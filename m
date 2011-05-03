Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2399 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 28/61] staging: brcm80211: implement flush driver
 callback for mac80211
Date: Tue, 3 May 2011 11:35:28 +0200
Message-ID: <1304415361-7813-29-git-send-email-arend@broadcom.com> (sfid-20110503_113835_176172_6F23A256)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211 interface has a flush callback which is used by mac80211
to assure all pending transmit packets have been transmitted. This
is used before scanning off-channel.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_export.h   |    1 +
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   24 ++++++++++++++++++++++
 drivers/staging/brcm80211/brcmsmac/wlc_main.c    |   13 +++++++++++
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h     |    1 +
 4 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_export.h b/drivers/staging/brcm80211/brcmsmac/wl_export.h
index 9ff760f..0fe0b24 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_export.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_export.h
@@ -42,5 +42,6 @@ extern void wl_free_timer(struct wl_info *wl, struct wl_timer *timer);
 extern void wl_add_timer(struct wl_info *wl, struct wl_timer *timer, uint ms,
 			 int periodic);
 extern bool wl_del_timer(struct wl_info *wl, struct wl_timer *timer);
+extern void wl_msleep(struct wl_info *wl, uint ms);
 
 #endif				/* _wl_export_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index dd46d2e..0a11e80 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -149,6 +149,7 @@ static int wl_ops_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
 			       u8 buf_size);
 static void wl_ops_rfkill_poll(struct ieee80211_hw *hw);
+static void wl_ops_flush(struct ieee80211_hw *hw, bool drop);
 
 static void wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
@@ -667,6 +668,18 @@ static void wl_ops_rfkill_poll(struct ieee80211_hw *hw)
 	wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, blocked);
 }
 
+static void wl_ops_flush(struct ieee80211_hw *hw, bool drop)
+{
+	struct wl_info *wl = HW_TO_WL(hw);
+
+	no_printk("%s: drop = %s\n", __func__, drop ? "true" : "false");
+
+	/* wait for packet queue and dma fifos to run empty */
+	WL_LOCK(wl);
+	wlc_wait_for_tx_completion(wl->wlc, drop);
+	WL_UNLOCK(wl);
+}
+
 static const struct ieee80211_ops wl_ops = {
 	.tx = wl_ops_tx,
 	.start = wl_ops_start,
@@ -688,6 +701,7 @@ static const struct ieee80211_ops wl_ops = {
 	.sta_remove = wl_ops_sta_remove,
 	.ampdu_action = wl_ops_ampdu_action,
 	.rfkill_poll = wl_ops_rfkill_poll,
+	.flush = wl_ops_flush,
 };
 
 /*
@@ -1947,3 +1961,13 @@ bool wl_rfkill_set_hw_state(struct wl_info *wl)
 	WL_LOCK(wl);
 	return blocked;
 }
+
+/*
+ * precondition: perimeter lock has been acquired
+ */
+void wl_msleep(struct wl_info *wl, uint ms)
+{
+	WL_UNLOCK(wl);
+	msleep(ms);
+	WL_LOCK(wl);
+}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index ea7d897..c4e7178 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -8104,3 +8104,16 @@ int wlc_get_curband(struct wlc_info *wlc)
 {
 	return wlc->band->bandunit;
 }
+
+void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop)
+{
+	/* flush packet queue when requested */
+	if (drop)
+		pktq_flush(&wlc->active_queue->q, false, NULL, 0);
+
+	/* wait for queue and DMA fifos to run dry */
+	while (!pktq_empty(&wlc->active_queue->q) ||
+	       TXPKTPENDTOT(wlc) > 0) {
+		wl_msleep(wlc->wl, 1);
+	}
+}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 08e5fb5..3dc5b1d 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -569,6 +569,7 @@ extern void wlc_associate_upd(struct wlc_info *wlc, bool state);
 extern void wlc_scan_start(struct wlc_info *wlc);
 extern void wlc_scan_stop(struct wlc_info *wlc);
 extern int wlc_get_curband(struct wlc_info *wlc);
+extern void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop);
 
 static inline int wlc_iovar_getuint(struct wlc_info *wlc, const char *name,
 				    uint *arg)
-- 
1.7.4.1


