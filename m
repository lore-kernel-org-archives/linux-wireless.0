Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1JJIM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:56 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:56 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/29] wl12xx: make WL1271_FLAG_STA_ASSOCIATED flag per-vif
Date: Mon, 10 Oct 2011 10:13:00 +0200
Message-Id: <1318234397-21081-13-git-send-email-eliad@wizery.com> (sfid-20111010_101259_584034_B1824241)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag should be set per-vif, rather than globally.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c  |    2 +-
 drivers/net/wireless/wl12xx/main.c   |   52 +++++++++++++++++----------------
 drivers/net/wireless/wl12xx/scan.c   |    4 +-
 drivers/net/wireless/wl12xx/tx.c     |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    6 +++-
 5 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index be9e112..cfb2835 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -52,7 +52,7 @@ void wl1271_pspoll_work(struct work_struct *work)
 	if (!test_and_clear_bit(WL1271_FLAG_PSPOLL_FAILURE, &wl->flags))
 		goto out;
 
-	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 		goto out;
 
 	/*
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index e242c50..6e67cbf 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -400,10 +400,9 @@ static struct platform_device wl1271_device = {
 static DEFINE_MUTEX(wl_list_mutex);
 static LIST_HEAD(wl_list);
 
-static int wl1271_check_operstate(struct wl1271 *wl, unsigned char operstate)
+static int wl1271_check_operstate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				  unsigned char operstate)
 {
-	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret;
 
 	if (operstate != IF_OPER_UP)
@@ -430,6 +429,7 @@ static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
 	struct wl1271 *wl_temp;
+	struct wl12xx_vif *wlvif;
 	int ret = 0;
 
 	/* Check that this notification is for us. */
@@ -463,17 +463,18 @@ static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 	if (wl->state == WL1271_STATE_OFF)
 		goto out;
 
-	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
-		goto out;
-
-	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+			continue;
 
-	wl1271_check_operstate(wl, dev->operstate);
+		ret = wl1271_ps_elp_wakeup(wl);
+		if (ret < 0)
+			goto out;
 
-	wl1271_ps_elp_sleep(wl);
+		wl1271_check_operstate(wl, wlvif, dev->operstate);
 
+		wl1271_ps_elp_sleep(wl);
+	}
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -535,7 +536,7 @@ int wl1271_recalc_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	/* reconfigure/disable according to new streaming_period */
 	if (period &&
-	    test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) &&
+	    test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) &&
 	    (wl->conf.rx_streaming.always ||
 	     test_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags)))
 		ret = wl1271_set_rx_streaming(wl, wlvif, true);
@@ -558,7 +559,7 @@ static void wl1271_rx_streaming_enable_work(struct work_struct *work)
 	mutex_lock(&wl->mutex);
 
 	if (test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags) ||
-	    !test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) ||
+	    !test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
 	    (!wl->conf.rx_streaming.always &&
 	     !test_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags)))
 		goto out;
@@ -1233,7 +1234,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 	 * not encrypted.
 	 */
 	wl12xx_for_each_wlvif(wl, wlvif) {
-		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) ||
+		if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
 		    test_bit(WL1271_FLAG_AP_STARTED, &wl->flags))
 			wlvif->tx_security_seq +=
 				WL1271_TX_SQN_POST_RECOVERY_PADDING;
@@ -1609,7 +1610,7 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 
 	mutex_lock(&wl->mutex);
 
-	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 		goto out_unlock;
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -2243,11 +2244,11 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	 * Keep the below message for now, unless it starts bothering
 	 * users who really like to roam a lot :)
 	 */
-	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+	if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 		wl1271_info("JOIN while associated.");
 
 	if (set_assoc)
-		set_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
+		set_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags);
 
 	if (is_ibss)
 		ret = wl12xx_cmd_role_start_ibss(wl, wlvif);
@@ -2256,7 +2257,7 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (ret < 0)
 		goto out;
 
-	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 		goto out;
 
 	/*
@@ -2439,7 +2440,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			 * possible rate for the band as a fixed rate for
 			 * association frames and other control messages.
 			 */
-			if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+			if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 				wl1271_set_band_rate(wl, wlvif);
 
 			wlvif->basic_rate =
@@ -2450,7 +2451,8 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 				wl1271_warning("rate policy for channel "
 					       "failed %d", ret);
 
-			if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
+			if (test_bit(WLVIF_FLAG_STA_ASSOCIATED,
+				     &wlvif->flags)) {
 				if (wl12xx_is_roc(wl)) {
 					/* roaming */
 					ret = wl12xx_croc(wl,
@@ -2508,7 +2510,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		 * If we're not, we'll enter it when joining an SSID,
 		 * through the bss_info_changed() hook.
 		 */
-		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
+		if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
 			wl1271_debug(DEBUG_PSM, "psm enabled");
 			ret = wl1271_ps_set_mode(wl, wlvif,
 						 STATION_POWER_SAVE_MODE,
@@ -2971,7 +2973,7 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 
 	/* cancel ROC before scanning */
 	if (wl12xx_is_roc(wl)) {
-		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
+		if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
 			/* don't allow scanning right now */
 			ret = -EBUSY;
 			goto out_sleep;
@@ -3609,8 +3611,8 @@ sta_not_found:
 		} else {
 			/* use defaults when not associated */
 			bool was_assoc =
-			    !!test_and_clear_bit(WL1271_FLAG_STA_ASSOCIATED,
-						 &wl->flags);
+			    !!test_and_clear_bit(WLVIF_FLAG_STA_ASSOCIATED,
+						 &wlvif->flags);
 			bool was_ifup =
 			    !!test_and_clear_bit(WL1271_FLAG_STA_STATE_SENT,
 						 &wl->flags);
@@ -3739,7 +3741,7 @@ sta_not_found:
 			if (ret < 0)
 				goto out;
 
-			wl1271_check_operstate(wl,
+			wl1271_check_operstate(wl, wlvif,
 					       ieee80211_get_operstate(vif));
 		}
 		/*
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index e1a8ce0..687f59b 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -64,7 +64,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
+	if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
 		/* restore hardware connection monitoring template */
 		wl1271_cmd_build_ap_probe_req(wl, wlvif, wlvif->probereq);
 	}
@@ -72,7 +72,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	/* return to ROC if needed */
 	is_sta = (wlvif->bss_type == BSS_TYPE_STA_BSS);
 	is_ibss = (wlvif->bss_type == BSS_TYPE_IBSS);
-	if (((is_sta && !test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) ||
+	if (((is_sta && !test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) ||
 	     (is_ibss && !test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags))) &&
 	    !test_bit(wlvif->dev_role_id, wl->roc_map)) {
 		/* restore remain on channel */
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 91689d0..f37444c 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -192,7 +192,7 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	wl1271_tx_update_filters(wl, wlvif, skb);
 
-	if ((test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) ||
+	if ((test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
 	     test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags)) &&
 	    !ieee80211_is_auth(hdr->frame_control) &&
 	    !ieee80211_is_assoc_req(hdr->frame_control))
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 9e44430..400dd17 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -313,7 +313,6 @@ struct wl1271_ap_key {
 };
 
 enum wl12xx_flags {
-	WL1271_FLAG_STA_ASSOCIATED,
 	WL1271_FLAG_IBSS_JOINED,
 	WL1271_FLAG_GPIO_POWER,
 	WL1271_FLAG_TX_QUEUE_STOPPED,
@@ -338,6 +337,10 @@ enum wl12xx_flags {
 	WL1271_FLAG_CS_PROGRESS,
 };
 
+enum wl12xx_vif_flags {
+	WLVIF_FLAG_STA_ASSOCIATED,
+};
+
 struct wl1271_link {
 	/* AP-mode - TX queue per AC in link */
 	struct sk_buff_head tx_queue[NUM_TX_QUEUES];
@@ -551,6 +554,7 @@ struct wl1271_station {
 struct wl12xx_vif {
 	struct wl1271 *wl;
 	struct list_head list;
+	unsigned long flags;
 	u8 bss_type;
 	u8 p2p; /* we are using p2p role */
 	u8 role_id;
-- 
1.7.6.401.g6a319

