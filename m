Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40518 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab1AUDCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:02:11 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so1249489iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:02:10 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63236.977078.2280@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:31:24 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 15/33] ath9k_htc: Add ANI for AP mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The time granularity for the ANI task is different for AP and
station mode.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 378aba3..83deb94 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -32,6 +32,7 @@
 #include "wmi.h"
 
 #define ATH_STA_SHORT_CALINTERVAL 1000    /* 1 second */
+#define ATH_AP_SHORT_CALINTERVAL  100     /* 100 ms */
 #define ATH_ANI_POLLINTERVAL      100     /* 100 ms */
 #define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
 #define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index ce11b96..f986d93 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -952,7 +952,8 @@ void ath9k_ani_work(struct work_struct *work)
 	unsigned int timestamp = jiffies_to_msecs(jiffies);
 	u32 cal_interval, short_cal_interval;
 
-	short_cal_interval = ATH_STA_SHORT_CALINTERVAL;
+	short_cal_interval = (ah->opmode == NL80211_IFTYPE_AP) ?
+		ATH_AP_SHORT_CALINTERVAL : ATH_STA_SHORT_CALINTERVAL;
 
 	/* Only calibrate if awake */
 	if (ah->power_mode != ATH9K_PM_AWAKE)
@@ -1269,6 +1270,9 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	INC_VIF(priv, vif->type);
 	ath9k_htc_set_opmode(priv);
 
+	if (priv->ah->opmode == NL80211_IFTYPE_AP)
+		ath_start_ani(priv);
+
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"Attach a VIF of type: %d at idx: %d\n", vif->type, avp->index);
 
@@ -1302,6 +1306,9 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	ath9k_htc_remove_station(priv, vif, NULL);
 	priv->vif = NULL;
 
+	if (priv->ah->opmode == NL80211_IFTYPE_AP)
+		cancel_delayed_work_sync(&priv->ath9k_ani_work);
+
 	DEC_VIF(priv, vif->type);
 	ath9k_htc_set_opmode(priv);
 
-- 
1.7.3.5

