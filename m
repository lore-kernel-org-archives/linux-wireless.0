Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:41533 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626Ab3C1CNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 22:13:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Sagar Bijwe <bsagar@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: use separate AMPDU tx/rx window sizes in 11ac networks
Date: Wed, 27 Mar 2013 19:10:32 -0700
Message-ID: <1364436632-24281-2-git-send-email-bzhao@marvell.com> (sfid-20130328_031353_215310_2D115079)
In-Reply-To: <1364436632-24281-1-git-send-email-bzhao@marvell.com>
References: <1364436632-24281-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Newer 11ac enabled chipsets have more TX and RX buffers in FW
and hardware; so they may support larger TX and RX window sizes
for BA. Reset BA settings during association, adhoc join/start
or start_ap() if we are joining/creating 11ac network.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Sagar Bijwe <bsagar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11ac.c     |   22 ++++++++++++++++++++++
 drivers/net/wireless/mwifiex/cfg80211.c |    5 +++++
 drivers/net/wireless/mwifiex/decl.h     |    4 ++++
 drivers/net/wireless/mwifiex/join.c     |   23 +++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h     |    1 +
 5 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11ac.c b/drivers/net/wireless/mwifiex/11ac.c
index de0a634..966a78f 100644
--- a/drivers/net/wireless/mwifiex/11ac.c
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -278,3 +278,25 @@ int mwifiex_cmd_11ac_cfg(struct mwifiex_private *priv,
 
 	return 0;
 }
+
+/* This function initializes the BlockACK setup information for given
+ * mwifiex_private structure for 11ac enabled networks.
+ */
+void mwifiex_set_11ac_ba_params(struct mwifiex_private *priv)
+{
+	priv->add_ba_param.timeout = MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT;
+
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
+		priv->add_ba_param.tx_win_size =
+					   MWIFIEX_11AC_UAP_AMPDU_DEF_TXWINSIZE;
+		priv->add_ba_param.rx_win_size =
+					   MWIFIEX_11AC_UAP_AMPDU_DEF_RXWINSIZE;
+	} else {
+		priv->add_ba_param.tx_win_size =
+					   MWIFIEX_11AC_STA_AMPDU_DEF_TXWINSIZE;
+		priv->add_ba_param.rx_win_size =
+					   MWIFIEX_11AC_STA_AMPDU_DEF_RXWINSIZE;
+	}
+
+	return;
+}
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 95f3306..8f161e1 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1381,6 +1381,11 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 				      priv->ap_11ac_enabled);
 	}
 
+	if (priv->ap_11ac_enabled)
+		mwifiex_set_11ac_ba_params(priv);
+	else
+		mwifiex_set_ba_params(priv);
+
 	mwifiex_set_wmm_params(priv, bss_cfg, params);
 
 	if (params->inactivity_timeout > 0) {
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 2af2c7c..94cc09d 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -45,6 +45,10 @@
 #define MWIFIEX_STA_AMPDU_DEF_RXWINSIZE        32
 #define MWIFIEX_UAP_AMPDU_DEF_TXWINSIZE        32
 #define MWIFIEX_UAP_AMPDU_DEF_RXWINSIZE        16
+#define MWIFIEX_11AC_STA_AMPDU_DEF_TXWINSIZE   32
+#define MWIFIEX_11AC_STA_AMPDU_DEF_RXWINSIZE   48
+#define MWIFIEX_11AC_UAP_AMPDU_DEF_TXWINSIZE   48
+#define MWIFIEX_11AC_UAP_AMPDU_DEF_RXWINSIZE   32
 
 #define MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT  0xffff
 
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 2fe0ceb..6bcb66e 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1295,6 +1295,14 @@ int mwifiex_associate(struct mwifiex_private *priv,
 	    (bss_desc->bss_mode != NL80211_IFTYPE_STATION))
 		return -1;
 
+	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info) &&
+	    !bss_desc->disable_11n && !bss_desc->disable_11ac &&
+	    (priv->adapter->config_bands & BAND_GAC ||
+	     priv->adapter->config_bands & BAND_AAC))
+		mwifiex_set_11ac_ba_params(priv);
+	else
+		mwifiex_set_ba_params(priv);
+
 	memcpy(&current_bssid,
 	       &priv->curr_bss_params.bss_descriptor.mac_address,
 	       sizeof(current_bssid));
@@ -1323,6 +1331,13 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %d\n",
 		priv->curr_bss_params.band);
 
+	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info) &&
+	    (priv->adapter->config_bands & BAND_GAC ||
+	     priv->adapter->config_bands & BAND_AAC))
+		mwifiex_set_11ac_ba_params(priv);
+	else
+		mwifiex_set_ba_params(priv);
+
 	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_AD_HOC_START,
 				    HostCmd_ACT_GEN_SET, 0, adhoc_ssid);
 }
@@ -1356,6 +1371,14 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 		return -1;
 	}
 
+	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info) &&
+	    !bss_desc->disable_11n && !bss_desc->disable_11ac &&
+	    (priv->adapter->config_bands & BAND_GAC ||
+	     priv->adapter->config_bands & BAND_AAC))
+		mwifiex_set_11ac_ba_params(priv);
+	else
+		mwifiex_set_ba_params(priv);
+
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.channel = %d\n",
 		priv->curr_bss_params.bss_descriptor.channel);
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %c\n",
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d032998..cab8a85 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -925,6 +925,7 @@ mwifiex_set_wmm_params(struct mwifiex_private *priv,
 		       struct mwifiex_uap_bss_param *bss_cfg,
 		       struct cfg80211_ap_settings *params);
 void mwifiex_set_ba_params(struct mwifiex_private *priv);
+void mwifiex_set_11ac_ba_params(struct mwifiex_private *priv);
 
 /*
  * This function checks if the queuing is RA based or not.
-- 
1.7.0.2

