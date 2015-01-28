Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6596 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965163AbbA1EzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 23:55:22 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0S4sPBj006239
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:55:22 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1s49ry0h6y-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:55:22 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <gaoqs@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 04/10] mwifiex: refactor start_ap handler
Date: Wed, 28 Jan 2015 15:54:19 +0530
Message-ID: <1422440665-3940-5-git-send-email-patila@marvell.com> (sfid-20150128_055530_590628_B05EB627)
In-Reply-To: <1422440665-3940-1-git-send-email-patila@marvell.com>
References: <1422440665-3940-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor mwifiex_cfg80211_start_ap by creating separate function
to set AP channel and another for configuring other AP parameters
and starting AP.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 68 ++++-----------------------------
 drivers/net/wireless/mwifiex/main.h     |  4 ++
 drivers/net/wireless/mwifiex/uap_cmd.c  | 65 +++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ceeaeac..2e0834c 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1677,7 +1677,6 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 {
 	struct mwifiex_uap_bss_param *bss_cfg;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	u8 config_bands = 0;
 
 	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_UAP)
 		return -1;
@@ -1697,6 +1696,11 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		memcpy(bss_cfg->ssid.ssid, params->ssid, params->ssid_len);
 		bss_cfg->ssid.ssid_len = params->ssid_len;
 	}
+	if (params->inactivity_timeout > 0) {
+		/* sta_ao_timer/ps_sta_ao_timer is in unit of 100ms */
+		bss_cfg->sta_ao_timer = 10 * params->inactivity_timeout;
+		bss_cfg->ps_sta_ao_timer = 10 * params->inactivity_timeout;
+	}
 
 	switch (params->hidden_ssid) {
 	case NL80211_HIDDEN_SSID_NOT_IN_USE:
@@ -1712,31 +1716,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
-	bss_cfg->channel = ieee80211_frequency_to_channel(
-				params->chandef.chan->center_freq);
-
-	/* Set appropriate bands */
-	if (params->chandef.chan->band == IEEE80211_BAND_2GHZ) {
-		bss_cfg->band_cfg = BAND_CONFIG_BG;
-		config_bands = BAND_B | BAND_G;
-
-		if (params->chandef.width > NL80211_CHAN_WIDTH_20_NOHT)
-			config_bands |= BAND_GN;
-	} else {
-		bss_cfg->band_cfg = BAND_CONFIG_A;
-		config_bands = BAND_A;
-
-		if (params->chandef.width > NL80211_CHAN_WIDTH_20_NOHT)
-			config_bands |= BAND_AN;
-
-		if (params->chandef.width > NL80211_CHAN_WIDTH_40)
-			config_bands |= BAND_AAC;
-	}
-
-	if (!((config_bands | priv->adapter->fw_bands) &
-	      ~priv->adapter->fw_bands))
-		priv->adapter->config_bands = config_bands;
-
+	mwifiex_uap_set_channel(bss_cfg, params->chandef);
 	mwifiex_set_uap_rates(bss_cfg, params);
 
 	if (mwifiex_set_secure_params(priv, bss_cfg, params)) {
@@ -1760,23 +1740,8 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 	mwifiex_set_wmm_params(priv, bss_cfg, params);
 
-	if (params->inactivity_timeout > 0) {
-		/* sta_ao_timer/ps_sta_ao_timer is in unit of 100ms */
-		bss_cfg->sta_ao_timer = 10 * params->inactivity_timeout;
-		bss_cfg->ps_sta_ao_timer = 10 * params->inactivity_timeout;
-	}
-
-	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
-			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
-		wiphy_err(wiphy, "Failed to stop the BSS\n");
-		kfree(bss_cfg);
-		return -1;
-	}
-
-	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
-			     HostCmd_ACT_GEN_SET,
-			     UAP_BSS_PARAMS_I, bss_cfg, false)) {
-		wiphy_err(wiphy, "Failed to set the SSID\n");
+	if (mwifiex_config_start_uap(priv, bss_cfg)) {
+		wiphy_err(wiphy, "Failed to start AP\n");
 		kfree(bss_cfg);
 		return -1;
 	}
@@ -1786,23 +1751,6 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 	memcpy(&priv->bss_cfg, bss_cfg, sizeof(priv->bss_cfg));
 	kfree(bss_cfg);
-
-	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_START,
-			     HostCmd_ACT_GEN_SET, 0, NULL, false)) {
-		wiphy_err(wiphy, "Failed to start the BSS\n");
-		return -1;
-	}
-
-	if (priv->sec_info.wep_enabled)
-		priv->curr_pkt_filter |= HostCmd_ACT_MAC_WEP_ENABLE;
-	else
-		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_WEP_ENABLE;
-
-	if (mwifiex_send_cmd(priv, HostCmd_CMD_MAC_CONTROL,
-			     HostCmd_ACT_GEN_SET, 0,
-			     &priv->curr_pkt_filter, true))
-		return -1;
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 673252a..0c75eff 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1321,6 +1321,10 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 			 struct cfg80211_beacon_data *data);
 int mwifiex_del_mgmt_ies(struct mwifiex_private *priv);
 u8 *mwifiex_11d_code_2_region(u8 code);
+void mwifiex_uap_set_channel(struct mwifiex_uap_bss_param *bss_cfg,
+			     struct cfg80211_chan_def chandef);
+int mwifiex_config_start_uap(struct mwifiex_private *priv,
+			     struct mwifiex_uap_bss_param *bss_cfg);
 void mwifiex_uap_del_sta_data(struct mwifiex_private *priv,
 			      struct mwifiex_sta_node *node);
 
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 0f347fd..baf5314 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -769,3 +769,68 @@ int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
 
 	return 0;
 }
+
+void mwifiex_uap_set_channel(struct mwifiex_uap_bss_param *bss_cfg,
+			     struct cfg80211_chan_def chandef)
+{
+	u8 config_bands = 0;
+
+	bss_cfg->channel = ieee80211_frequency_to_channel(
+						     chandef.chan->center_freq);
+
+	/* Set appropriate bands */
+	if (chandef.chan->band == IEEE80211_BAND_2GHZ) {
+		bss_cfg->band_cfg = BAND_CONFIG_BG;
+		config_bands = BAND_B | BAND_G;
+
+		if (chandef.width > NL80211_CHAN_WIDTH_20_NOHT)
+			config_bands |= BAND_GN;
+	} else {
+		bss_cfg->band_cfg = BAND_CONFIG_A;
+		config_bands = BAND_A;
+
+		if (chandef.width > NL80211_CHAN_WIDTH_20_NOHT)
+			config_bands |= BAND_AN;
+
+		if (chandef.width > NL80211_CHAN_WIDTH_40)
+			config_bands |= BAND_AAC;
+	}
+}
+
+int mwifiex_config_start_uap(struct mwifiex_private *priv,
+			     struct mwifiex_uap_bss_param *bss_cfg)
+{
+	if (mwifiex_del_mgmt_ies(priv))
+		dev_err(priv->adapter->dev, "Failed to delete mgmt IEs!\n");
+
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
+			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
+		dev_err(priv->adapter->dev, "Failed to stop the BSS\n");
+		return -1;
+	}
+
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
+			     HostCmd_ACT_GEN_SET,
+			     UAP_BSS_PARAMS_I, bss_cfg, false)) {
+		dev_err(priv->adapter->dev, "Failed to set the SSID\n");
+		return -1;
+	}
+
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_START,
+			     HostCmd_ACT_GEN_SET, 0, NULL, false)) {
+		dev_err(priv->adapter->dev, "Failed to start the BSS\n");
+		return -1;
+	}
+
+	if (priv->sec_info.wep_enabled)
+		priv->curr_pkt_filter |= HostCmd_ACT_MAC_WEP_ENABLE;
+	else
+		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_WEP_ENABLE;
+
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+			     HostCmd_ACT_GEN_SET, 0,
+			     &priv->curr_pkt_filter, true))
+		return -1;
+
+	return 0;
+}
-- 
1.8.1.4

