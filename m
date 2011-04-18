Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3587 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab1DRNcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:32:06 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/6] staging: brcm80211: implement flush driver callback
 for mac80211
Date: Mon, 18 Apr 2011 15:31:46 +0200
Message-ID: <1303133511-8300-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211 interface has a flush callback which is used by mac80211
to assure all pending transmit packets have been transmitted. This
is used before scanning off-channel.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
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
index 169d26b..6ea747f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -151,6 +151,7 @@ static int wl_ops_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
 			       u8 buf_size);
 static void wl_ops_rfkill_poll(struct ieee80211_hw *hw);
+static void wl_ops_flush(struct ieee80211_hw *hw, bool drop);
 
 static void wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
@@ -690,6 +691,18 @@ static void wl_ops_rfkill_poll(struct ieee80211_hw *hw)
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
@@ -711,6 +724,7 @@ static const struct ieee80211_ops wl_ops = {
 	.sta_remove = wl_ops_sta_remove,
 	.ampdu_action = wl_ops_ampdu_action,
 	.rfkill_poll = wl_ops_rfkill_poll,
+	.flush = wl_ops_flush,
 };
 
 /*
@@ -1981,3 +1995,13 @@ bool wl_rfkill_set_hw_state(struct wl_info *wl)
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
index 93e2f2c..3e5d884 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -8097,3 +8097,16 @@ int wlc_get_curband(struct wlc_info *wlc)
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
index eea9aa7..626d424 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -569,6 +569,7 @@ extern void wlc_scan_start(struct wlc_info *wlc);
 extern void wlc_scan_stop(struct wlc_info *wlc);
 extern void wlc_associate_upd(struct wlc_info *wlc, bool state);
 extern int wlc_get_curband(struct wlc_info *wlc);
+extern void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop);
 
 static inline int wlc_iovar_getuint(struct wlc_info *wlc, const char *name,
 				    uint *arg)
-- 
1.7.1


