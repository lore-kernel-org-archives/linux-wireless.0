Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:48073 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757522Ab2FOTcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 15:32:43 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 1/5] mwifiex: set channel via start_ap handler for AP interface
Date: Fri, 15 Jun 2012 12:21:51 -0700
Message-Id: <1339788115-20596-2-git-send-email-bzhao@marvell.com> (sfid-20120615_213248_589419_CAD49A78)
In-Reply-To: <1339788115-20596-1-git-send-email-bzhao@marvell.com>
References: <1339788115-20596-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds functionality to set channel info received from
cfg80211_ap_settings in start_ap handler.

Since set_channel cfg80211 handler has been removed and we need
not explicitely call mwifiex_uap_set_channel(); hence this
function definition is also removed.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v3: resending as 1/5, no change since v1
v2: resending as 1/4, no change since v1

 drivers/net/wireless/mwifiex/cfg80211.c |   23 +++++++++++++++++------
 drivers/net/wireless/mwifiex/main.h     |    1 -
 drivers/net/wireless/mwifiex/uap_cmd.c  |   30 ------------------------------
 3 files changed, 17 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 015fec3..7b4eaf4 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -384,13 +384,13 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 	cfp.freq = chan->center_freq;
 	cfp.channel = ieee80211_frequency_to_channel(chan->center_freq);
 
-	if (mwifiex_bss_set_channel(priv, &cfp))
-		return -EFAULT;
-
-	if (priv->bss_type == MWIFIEX_BSS_TYPE_STA)
+	if (priv->bss_type == MWIFIEX_BSS_TYPE_STA) {
+		if (mwifiex_bss_set_channel(priv, &cfp))
+			return -EFAULT;
 		return mwifiex_drv_change_adhoc_chan(priv, cfp.channel);
-	else
-		return mwifiex_uap_set_channel(priv, cfp.channel);
+	}
+
+	return 0;
 }
 
 /*
@@ -961,6 +961,17 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
+	bss_cfg->channel =
+	    (u8)ieee80211_frequency_to_channel(params->channel->center_freq);
+	bss_cfg->band_cfg = BAND_CONFIG_MANUAL;
+
+	if (mwifiex_set_rf_channel(priv, params->channel,
+				   params->channel_type)) {
+		kfree(bss_cfg);
+		wiphy_err(wiphy, "Failed to set band config information!\n");
+		return -1;
+	}
+
 	if (mwifiex_set_secure_params(priv, bss_cfg, params)) {
 		kfree(bss_cfg);
 		wiphy_err(wiphy, "Failed to parse secuirty parameters!\n");
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 5b32221..512481e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -990,7 +990,6 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 
 int mwifiex_main_process(struct mwifiex_adapter *);
 
-int mwifiex_uap_set_channel(struct mwifiex_private *priv, int channel);
 int mwifiex_bss_set_channel(struct mwifiex_private *,
 			    struct mwifiex_chan_freq_power *cfp);
 int mwifiex_get_bss_info(struct mwifiex_private *,
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 89f9a2a..fb0c6cb 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -421,33 +421,3 @@ int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
 
 	return 0;
 }
-
-/* This function sets the RF channel for AP.
- *
- * This function populates channel information in AP config structure
- * and sends command to configure channel information in AP.
- */
-int mwifiex_uap_set_channel(struct mwifiex_private *priv, int channel)
-{
-	struct mwifiex_uap_bss_param *bss_cfg;
-	struct wiphy *wiphy = priv->wdev->wiphy;
-
-	bss_cfg = kzalloc(sizeof(struct mwifiex_uap_bss_param), GFP_KERNEL);
-	if (!bss_cfg)
-		return -ENOMEM;
-
-	mwifiex_set_sys_config_invalid_data(bss_cfg);
-	bss_cfg->band_cfg = BAND_CONFIG_MANUAL;
-	bss_cfg->channel = channel;
-
-	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_UAP_SYS_CONFIG,
-				   HostCmd_ACT_GEN_SET,
-				   UAP_BSS_PARAMS_I, bss_cfg)) {
-		wiphy_err(wiphy, "Failed to set the uAP channel\n");
-		kfree(bss_cfg);
-		return -1;
-	}
-
-	kfree(bss_cfg);
-	return 0;
-}
-- 
1.7.0.2

