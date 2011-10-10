Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53588 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1JJINC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:02 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so8169287bkb.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:01 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 15/29] wl12xx: make WL1271_FLAG_PSM flag per-vif
Date: Mon, 10 Oct 2011 10:13:03 +0200
Message-Id: <1318234397-21081-16-git-send-email-eliad@wizery.com> (sfid-20111010_101307_962200_541AFFE3)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move WL1271_FLAG_PSM and WL1271_FLAG_PSM_REQUESTED into
per-vif flags.
These flags should be set per-vif, rather than globally.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c  |    4 ++--
 drivers/net/wireless/wl12xx/main.c   |   18 +++++++++---------
 drivers/net/wireless/wl12xx/ps.c     |   25 +++++++++++++++++--------
 drivers/net/wireless/wl12xx/wl12xx.h |    4 ++--
 4 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index cfb2835..d8b183b 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -84,7 +84,7 @@ static void wl1271_event_pspoll_delivery_fail(struct wl1271 *wl,
 			    "trying to work around it.");
 
 	/* force active mode receive data from the AP */
-	if (test_bit(WL1271_FLAG_PSM, &wl->flags)) {
+	if (test_bit(WLVIF_FLAG_PSM, &wlvif->flags)) {
 		ret = wl1271_ps_set_mode(wl, wlvif, STATION_ACTIVE_MODE,
 					 wlvif->basic_rate, true);
 		if (ret < 0)
@@ -116,7 +116,7 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 	case EVENT_ENTER_POWER_SAVE_FAIL:
 		wl1271_debug(DEBUG_PSM, "PSM entry failed");
 
-		if (!test_bit(WL1271_FLAG_PSM, &wl->flags)) {
+		if (!test_bit(WLVIF_FLAG_PSM, &wlvif->flags)) {
 			/* remain in active mode */
 			wlvif->psm_entry_retry = 0;
 			break;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 4c4b34d..9c0a1ac 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1618,7 +1618,7 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 		goto out_unlock;
 
 	/* enter psm if needed*/
-	if (!test_bit(WL1271_FLAG_PSM, &wl->flags)) {
+	if (!test_bit(WLVIF_FLAG_PSM, &wlvif->flags)) {
 		DECLARE_COMPLETION_ONSTACK(compl);
 
 		wlvif->ps_compl = &compl;
@@ -1705,7 +1705,7 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 
 	if (is_sta) {
 		/* exit psm if it wasn't configured */
-		if (!test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags))
+		if (!test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags))
 			wl1271_ps_set_mode(wl, wlvif, STATION_ACTIVE_MODE,
 					   wlvif->basic_rate, true);
 	} else if (is_ap) {
@@ -2502,8 +2502,8 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		clear_bit(WL1271_FLAG_PSPOLL_FAILURE, &wl->flags);
 
 	if (conf->flags & IEEE80211_CONF_PS &&
-	    !test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags)) {
-		set_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags);
+	    !test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags)) {
+		set_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags);
 
 		/*
 		 * We enter PSM only if we're already associated.
@@ -2517,12 +2517,12 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 						 wlvif->basic_rate, true);
 		}
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
-		   test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags)) {
+		   test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags)) {
 		wl1271_debug(DEBUG_PSM, "psm disabled");
 
-		clear_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags);
+		clear_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags);
 
-		if (test_bit(WL1271_FLAG_PSM, &wl->flags))
+		if (test_bit(WLVIF_FLAG_PSM, &wlvif->flags))
 			ret = wl1271_ps_set_mode(wl, wlvif,
 						 STATION_ACTIVE_MODE,
 						 wlvif->basic_rate, true);
@@ -3759,8 +3759,8 @@ sta_not_found:
 		}
 
 		/* If we want to go in PSM but we're not there yet */
-		if (test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags) &&
-		    !test_bit(WL1271_FLAG_PSM, &wl->flags)) {
+		if (test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags) &&
+		    !test_bit(WLVIF_FLAG_PSM, &wlvif->flags)) {
 			enum wl1271_cmd_ps_mode mode;
 
 			mode = STATION_POWER_SAVE_MODE;
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index ac3f207..8cd81ce 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -32,6 +32,7 @@ void wl1271_elp_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
 	struct wl1271 *wl;
+	struct wl12xx_vif *wlvif;
 
 	dwork = container_of(work, struct delayed_work, work);
 	wl = container_of(dwork, struct wl1271, elp_work);
@@ -47,11 +48,15 @@ void wl1271_elp_work(struct work_struct *work)
 	if (unlikely(!test_bit(WL1271_FLAG_ELP_REQUESTED, &wl->flags)))
 		goto out;
 
-	if (test_bit(WL1271_FLAG_IN_ELP, &wl->flags) ||
-	    (!test_bit(WL1271_FLAG_PSM, &wl->flags) &&
-	     !test_bit(WL1271_FLAG_IDLE, &wl->flags)))
+	if (test_bit(WL1271_FLAG_IN_ELP, &wl->flags))
 		goto out;
 
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		if (!test_bit(WLVIF_FLAG_PSM, &wlvif->flags) &&
+		    !test_bit(WL1271_FLAG_IDLE, &wl->flags))
+			goto out;
+	}
+
 	wl1271_debug(DEBUG_PSM, "chip to elp");
 	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
 	set_bit(WL1271_FLAG_IN_ELP, &wl->flags);
@@ -65,13 +70,17 @@ out:
 /* Routines to toggle sleep mode while in ELP */
 void wl1271_ps_elp_sleep(struct wl1271 *wl)
 {
+	struct wl12xx_vif *wlvif;
+
 	/* we shouldn't get consecutive sleep requests */
 	if (WARN_ON(test_and_set_bit(WL1271_FLAG_ELP_REQUESTED, &wl->flags)))
 		return;
 
-	if (!test_bit(WL1271_FLAG_PSM, &wl->flags) &&
-	    !test_bit(WL1271_FLAG_IDLE, &wl->flags))
-		return;
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		if (!test_bit(WLVIF_FLAG_PSM, &wlvif->flags) &&
+		    !test_bit(WL1271_FLAG_IDLE, &wl->flags))
+			return;
+	}
 
 	ieee80211_queue_delayed_work(wl->hw, &wl->elp_work,
 				     msecs_to_jiffies(ELP_ENTRY_DELAY));
@@ -162,7 +171,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (ret < 0)
 			return ret;
 
-		set_bit(WL1271_FLAG_PSM, &wl->flags);
+		set_bit(WLVIF_FLAG_PSM, &wlvif->flags);
 		break;
 	case STATION_ACTIVE_MODE:
 	default:
@@ -184,7 +193,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (ret < 0)
 			return ret;
 
-		clear_bit(WL1271_FLAG_PSM, &wl->flags);
+		clear_bit(WLVIF_FLAG_PSM, &wlvif->flags);
 		break;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 042ab07..37498f2 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -318,8 +318,6 @@ enum wl12xx_flags {
 	WL1271_FLAG_TX_PENDING,
 	WL1271_FLAG_IN_ELP,
 	WL1271_FLAG_ELP_REQUESTED,
-	WL1271_FLAG_PSM,
-	WL1271_FLAG_PSM_REQUESTED,
 	WL1271_FLAG_IRQ_RUNNING,
 	WL1271_FLAG_IDLE,
 	WL1271_FLAG_PSPOLL_FAILURE,
@@ -339,6 +337,8 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_STA_ASSOCIATED,
 	WLVIF_FLAG_IBSS_JOINED,
 	WLVIF_FLAG_AP_STARTED,
+	WLVIF_FLAG_PSM,
+	WLVIF_FLAG_PSM_REQUESTED,
 };
 
 struct wl1271_link {
-- 
1.7.6.401.g6a319

