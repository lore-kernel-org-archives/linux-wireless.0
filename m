Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1778 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab1AYKv5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 05:51:57 -0500
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH] staging: brcm80211: bugfix for softmac crash on multi
 cpu configurations
Date: Tue, 25 Jan 2011 11:51:56 +0100
Message-ID: <1295952716-16161-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Solved a locking issue that resulted in driver crashes with the 43224 and 43225
chips. The problem has been reported on several fora. Root cause was two fold:
hardware was being manipulated by two unsynchronized threads, and a scan
operation could interfere with an ongoing dynamic calibration process. Fix was
to invoke a lock on wl_ops_config() operation and to set internal flags when a
scan operation is started and stopped.

Please add this to the staging-linus branch.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/sys/wl_mac80211.c  |   12 ++++++++++--
 drivers/staging/brcm80211/sys/wlc_mac80211.c |   13 +++++++++++++
 drivers/staging/brcm80211/sys/wlc_pub.h      |    2 ++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index f123588..cd8392b 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -263,9 +263,7 @@ ieee_set_channel(struct ieee80211_hw *hw, struct ieee80211_channel *chan,
 	switch (type) {
 	case NL80211_CHAN_HT20:
 	case NL80211_CHAN_NO_HT:
-		WL_LOCK(wl);
 		err = wlc_set(wl->wlc, WLC_SET_CHANNEL, chan->hw_value);
-		WL_UNLOCK(wl);
 		break;
 	case NL80211_CHAN_HT40MINUS:
 	case NL80211_CHAN_HT40PLUS:
@@ -285,6 +283,7 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 	int err = 0;
 	int new_int;
 
+	WL_LOCK(wl);
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {
 		WL_NONE("%s: Setting listen interval to %d\n",
 			__func__, conf->listen_interval);
@@ -341,6 +340,7 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
  config_out:
+	WL_UNLOCK(wl);
 	return err;
 }
 
@@ -459,13 +459,21 @@ wl_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
 
 static void wl_ops_sw_scan_start(struct ieee80211_hw *hw)
 {
+	struct wl_info *wl = hw->priv;
 	WL_NONE("Scan Start\n");
+	WL_LOCK(wl);
+	wlc_scan_start(wl->wlc);
+	WL_UNLOCK(wl);
 	return;
 }
 
 static void wl_ops_sw_scan_complete(struct ieee80211_hw *hw)
 {
+	struct wl_info *wl = hw->priv;
 	WL_NONE("Scan Complete\n");
+	WL_LOCK(wl);
+	wlc_scan_stop(wl->wlc);
+	WL_UNLOCK(wl);
 	return;
 }
 
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index a130386..e37e805 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -8461,3 +8461,16 @@ static void wlc_txq_free(struct wlc_info *wlc, struct osl_info *osh,
 
 	kfree(qi);
 }
+
+/*
+ * Flag 'scan in progress' to withold dynamic phy calibration
+ */
+void wlc_scan_start(struct wlc_info *wlc)
+{
+	wlc_phy_hold_upd(wlc->band->pi, PHY_HOLD_FOR_SCAN, true);
+}
+
+void wlc_scan_stop(struct wlc_info *wlc)
+{
+	wlc_phy_hold_upd(wlc->band->pi, PHY_HOLD_FOR_SCAN, false);
+}
diff --git a/drivers/staging/brcm80211/sys/wlc_pub.h b/drivers/staging/brcm80211/sys/wlc_pub.h
index 146a690..aff4130 100644
--- a/drivers/staging/brcm80211/sys/wlc_pub.h
+++ b/drivers/staging/brcm80211/sys/wlc_pub.h
@@ -570,6 +570,8 @@ extern void wlc_enable_mac(struct wlc_info *wlc);
 extern u16 wlc_rate_shm_offset(struct wlc_info *wlc, u8 rate);
 extern u32 wlc_get_rspec_history(struct wlc_bsscfg *cfg);
 extern u32 wlc_get_current_highest_rate(struct wlc_bsscfg *cfg);
+extern void wlc_scan_start(struct wlc_info *wlc);
+extern void wlc_scan_stop(struct wlc_info *wlc);
 
 static inline int wlc_iovar_getuint(struct wlc_info *wlc, const char *name,
 				    uint *arg)
-- 
1.7.1


