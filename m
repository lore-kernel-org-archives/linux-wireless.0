Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57881 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2BBLMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 06:12:03 -0500
Received: by werb13 with SMTP id b13so1710580wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 03:12:02 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: declare support for hw scan while idle
Date: Thu,  2 Feb 2012 13:15:35 +0200
Message-Id: <1328181335-8155-1-git-send-email-eliad@wizery.com> (sfid-20120202_121209_149047_EF4B5DB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By allowing hw scan while idle, we no longer
need the redundant ROC/CROC that are done
on idle off/on, which helps simplifying the
state machine of the driver.

This way, we can also allow scanning while
there is an ongoing sched scan (otherwise,
we won't be able to ROC on idle-off)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
depends on "mac80211: support hw scan while idle"

 drivers/net/wireless/wl12xx/main.c |    7 ++-----
 drivers/net/wireless/wl12xx/scan.c |   13 -------------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 01ab633..ad7f1fe 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3042,10 +3042,6 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 		goto out_sleep;
 	}
 
-	/* cancel ROC before scanning */
-	if (wl12xx_dev_role_started(wlvif))
-		wl12xx_croc(wl, wlvif->dev_role_id);
-
 	ret = wl1271_scan(hw->priv, vif, ssid, len, req);
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
@@ -4913,7 +4909,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_AP_LINK_PS |
 		IEEE80211_HW_AMPDU_AGGREGATION |
-		IEEE80211_HW_TX_AMPDU_SETUP_IN_HW;
+		IEEE80211_HW_TX_AMPDU_SETUP_IN_HW |
+		IEEE80211_HW_SCAN_WHILE_IDLE;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 6adc733..848a165 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -38,7 +38,6 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	struct ieee80211_vif *vif;
 	struct wl12xx_vif *wlvif;
 	int ret;
-	bool is_sta, is_ibss;
 
 	dwork = container_of(work, struct delayed_work, work);
 	wl = container_of(dwork, struct wl1271, scan_complete_work);
@@ -70,18 +69,6 @@ void wl1271_scan_complete_work(struct work_struct *work)
 		wl1271_cmd_build_ap_probe_req(wl, wlvif, wlvif->probereq);
 	}
 
-	/* return to ROC if needed */
-	is_sta = (wlvif->bss_type == BSS_TYPE_STA_BSS);
-	is_ibss = (wlvif->bss_type == BSS_TYPE_IBSS);
-	if (((is_sta && !test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) ||
-	     (is_ibss && !test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags))) &&
-	    !test_bit(wlvif->dev_role_id, wl->roc_map)) {
-		/* restore remain on channel */
-		if (wlvif->dev_hlid == WL12XX_INVALID_LINK_ID)
-			wl12xx_start_dev(wl, wlvif);
-		else
-			wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
-	}
 	wl1271_ps_elp_sleep(wl);
 
 	if (wl->scan.failed) {
-- 
1.7.6.401.g6a319

