Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43591 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:20:07 -0500
Received: by mail-gx0-f174.google.com with SMTP id 8so301890gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:20:07 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52169.589133.277356@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:49:53 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 17/23] ath9k_htc: Configure beacon timers in AP mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Handle multi-interface situations by checking if
AP interfaces are already present.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   78 ++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   45 +++++++++++--
 drivers/net/wireless/ath/ath9k/wmi.c            |    4 -
 4 files changed, 115 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 5b0a21a..e9c51ca 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -352,10 +352,8 @@ struct ath_led {
 
 struct htc_beacon_config {
 	u16 beacon_interval;
-	u16 listen_interval;
 	u16 dtim_period;
 	u16 bmiss_timeout;
-	u8 dtim_count;
 };
 
 struct ath_btcoex {
@@ -380,6 +378,7 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
 #define OP_BT_PRIORITY_DETECTED    BIT(6)
 #define OP_BT_SCAN                 BIT(7)
 #define OP_ANI_RUNNING             BIT(8)
+#define OP_TSF_RESET               BIT(9)
 
 struct ath9k_htc_priv {
 	struct device *dev;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index bbbdd60..e897a56 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -138,6 +138,51 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
 }
 
+static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
+				       struct htc_beacon_config *bss_conf)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	enum ath9k_int imask = 0;
+	u32 nexttbtt, intval, tsftu;
+	__be32 htc_imask = 0;
+	int ret;
+	u8 cmd_rsp;
+	u64 tsf;
+
+	intval = bss_conf->beacon_interval & ATH9K_BEACON_PERIOD;
+	intval /= ATH9K_HTC_MAX_BCN_VIF;
+	nexttbtt = intval;
+
+	if (priv->op_flags & OP_TSF_RESET) {
+		intval |= ATH9K_BEACON_RESET_TSF;
+		priv->op_flags &= ~OP_TSF_RESET;
+	} else {
+		/*
+		 * Pull nexttbtt forward to reflect the current TSF.
+		 */
+		tsf = ath9k_hw_gettsf64(priv->ah);
+		tsftu = TSF_TO_TU(tsf >> 32, tsf) + FUDGE;
+		do {
+			nexttbtt += intval;
+		} while (nexttbtt < tsftu);
+	}
+
+	intval |= ATH9K_BEACON_ENA;
+
+	if (priv->op_flags & OP_ENABLE_BEACON)
+		imask |= ATH9K_INT_SWBA;
+
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"AP Beacon config, intval: %d, nexttbtt: %u imask: 0x%x\n",
+		bss_conf->beacon_interval, nexttbtt, imask);
+
+	WMI_CMD(WMI_DISABLE_INTR_CMDID);
+	ath9k_hw_beaconinit(priv->ah, nexttbtt, intval);
+	priv->bmiss_cnt = 0;
+	htc_imask = cpu_to_be32(imask);
+	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
+}
+
 static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 					  struct htc_beacon_config *bss_conf)
 {
@@ -260,13 +305,36 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 	struct htc_beacon_config *cur_conf = &priv->cur_beacon_conf;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 
+	/*
+	 * Changing the beacon interval when multiple AP interfaces
+	 * are configured will affect beacon transmission of all
+	 * of them.
+	 */
+	if ((priv->ah->opmode == NL80211_IFTYPE_AP) &&
+	    (priv->num_ap_vif > 1) &&
+	    (vif->type == NL80211_IFTYPE_AP) &&
+	    (cur_conf->beacon_interval != bss_conf->beacon_int)) {
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Changing beacon interval of multiple AP interfaces !\n");
+		return;
+	}
+
+	/*
+	 * If the HW is operating in AP mode, any new station interfaces that
+	 * are added cannot change the beacon parameters.
+	 */
+	if (priv->num_ap_vif &&
+	    (vif->type != NL80211_IFTYPE_AP)) {
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"HW in AP mode, cannot set STA beacon parameters\n");
+		return;
+	}
+
 	cur_conf->beacon_interval = bss_conf->beacon_int;
 	if (cur_conf->beacon_interval == 0)
 		cur_conf->beacon_interval = 100;
 
 	cur_conf->dtim_period = bss_conf->dtim_period;
-	cur_conf->listen_interval = 1;
-	cur_conf->dtim_count = 1;
 	cur_conf->bmiss_timeout =
 		ATH_DEFAULT_BMISS_LIMIT * cur_conf->beacon_interval;
 
@@ -277,6 +345,9 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 	case NL80211_IFTYPE_ADHOC:
 		ath9k_htc_beacon_config_adhoc(priv, cur_conf);
 		break;
+	case NL80211_IFTYPE_AP:
+		ath9k_htc_beacon_config_ap(priv, cur_conf);
+		break;
 	default:
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"Unsupported beaconing mode\n");
@@ -296,6 +367,9 @@ void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv)
 	case NL80211_IFTYPE_ADHOC:
 		ath9k_htc_beacon_config_adhoc(priv, cur_conf);
 		break;
+	case NL80211_IFTYPE_AP:
+		ath9k_htc_beacon_config_ap(priv, cur_conf);
+		break;
 	default:
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"Unsupported beaconing mode\n");
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 4779bb1..949af24 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -110,6 +110,9 @@ static void ath9k_htc_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	struct ath9k_htc_priv *priv = data;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 
+	if ((vif->type == NL80211_IFTYPE_AP) && bss_conf->enable_beacon)
+		priv->reconfig_beacon = true;
+
 	if (bss_conf->assoc) {
 		priv->rearm_ani = true;
 		priv->reconfig_beacon = true;
@@ -288,6 +291,11 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 		goto err;
 
 	htc_start(priv->htc);
+
+	if (!(priv->op_flags & OP_SCANNING) &&
+	    !(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
+		ath9k_htc_vif_reconfig(priv);
+
 err:
 	ath9k_htc_ps_restore(priv);
 	return ret;
@@ -1621,17 +1629,40 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 			common->curbssid, common->curaid);
 	}
 
-	if ((changed & BSS_CHANGED_BEACON_INT) ||
-	    (changed & BSS_CHANGED_BEACON) ||
-	    ((changed & BSS_CHANGED_BEACON_ENABLED) &&
-	    bss_conf->enable_beacon)) {
+	if ((changed & BSS_CHANGED_BEACON_ENABLED) && bss_conf->enable_beacon) {
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Beacon enabled for BSS: %pM\n", bss_conf->bssid);
 		priv->op_flags |= OP_ENABLE_BEACON;
 		ath9k_htc_beacon_config(priv, vif);
 	}
 
-	if ((changed & BSS_CHANGED_BEACON_ENABLED) &&
-	    !bss_conf->enable_beacon) {
-		priv->op_flags &= ~OP_ENABLE_BEACON;
+	if ((changed & BSS_CHANGED_BEACON_ENABLED) && !bss_conf->enable_beacon) {
+		/*
+		 * Disable SWBA interrupt only if there are no
+		 * AP/IBSS interfaces.
+		 */
+		if ((priv->num_ap_vif <= 1) || priv->num_ibss_vif) {
+			ath_dbg(common, ATH_DBG_CONFIG,
+				"Beacon disabled for BSS: %pM\n",
+				bss_conf->bssid);
+			priv->op_flags &= ~OP_ENABLE_BEACON;
+			ath9k_htc_beacon_config(priv, vif);
+		}
+	}
+
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		/*
+		 * Reset the HW TSF for the first AP interface.
+		 */
+		if ((priv->ah->opmode == NL80211_IFTYPE_AP) &&
+		    (priv->nvifs == 1) &&
+		    (priv->num_ap_vif == 1) &&
+		    (vif->type == NL80211_IFTYPE_AP)) {
+			priv->op_flags |= OP_TSF_RESET;
+		}
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Beacon interval changed for BSS: %pM\n",
+			bss_conf->bssid);
 		ath9k_htc_beacon_config(priv, vif);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index dc862f5..d3d2490 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -123,12 +123,8 @@ void ath9k_deinit_wmi(struct ath9k_htc_priv *priv)
 void ath9k_swba_tasklet(unsigned long data)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
-	struct ath_common *common = ath9k_hw_common(priv->ah);
-
-	ath_dbg(common, ATH_DBG_WMI, "SWBA Event received\n");
 
 	ath9k_htc_swba(priv, priv->wmi->beacon_pending);
-
 }
 
 void ath9k_fatal_work(struct work_struct *work)
-- 
1.7.4.1

