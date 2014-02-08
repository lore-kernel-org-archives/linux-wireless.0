Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5431 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbaBHAVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:21:13 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 04/30] mwifiex: remove unsupported code in 11ac
Date: Fri, 7 Feb 2014 16:21:01 -0800
Message-ID: <1391818861-20926-4-git-send-email-bzhao@marvell.com> (sfid-20140208_012116_992867_0411D9B9)
In-Reply-To: <1391818861-20926-1-git-send-email-bzhao@marvell.com>
References: <1391818861-20926-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bit12 in fw_cap_info is for testing only.
Remove all related code.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |  3 ---
 drivers/net/wireless/mwifiex/cfp.c       |  5 -----
 drivers/net/wireless/mwifiex/fw.h        | 20 +++++++++++---------
 drivers/net/wireless/mwifiex/ioctl.h     |  3 +--
 drivers/net/wireless/mwifiex/join.c      | 12 ++++--------
 drivers/net/wireless/mwifiex/sta_ioctl.c |  2 +-
 6 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 8bfc07c..41e9aac 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1416,9 +1416,6 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 		if (params->chandef.width > NL80211_CHAN_WIDTH_20_NOHT)
 			config_bands |= BAND_GN;
-
-		if (params->chandef.width > NL80211_CHAN_WIDTH_40)
-			config_bands |= BAND_GAC;
 	} else {
 		bss_cfg->band_cfg = BAND_CONFIG_A;
 		config_bands = BAND_A;
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index dfb068b..2c3226b 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -438,7 +438,6 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 			break;
 		case BAND_G:
 		case BAND_G | BAND_GN:
-		case BAND_G | BAND_GN | BAND_GAC:
 			dev_dbg(adapter->dev, "info: infra band=%d "
 				"supported_rates_g\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_g,
@@ -449,10 +448,7 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 		case BAND_A | BAND_B:
 		case BAND_A | BAND_B | BAND_G | BAND_GN | BAND_AN:
 		case BAND_A | BAND_B | BAND_G | BAND_GN | BAND_AN | BAND_AAC:
-		case BAND_A | BAND_B | BAND_G | BAND_GN | BAND_AN |
-		     BAND_AAC | BAND_GAC:
 		case BAND_B | BAND_G | BAND_GN:
-		case BAND_B | BAND_G | BAND_GN | BAND_GAC:
 			dev_dbg(adapter->dev, "info: infra band=%d "
 				"supported_rates_bg\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_bg,
@@ -476,7 +472,6 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 					       sizeof(supported_rates_a));
 			break;
 		case BAND_GN:
-		case BAND_GN | BAND_GAC:
 			dev_dbg(adapter->dev, "info: infra band=%d "
 				"supported_rates_n\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_n,
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 059bc16..d8014c8 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -50,21 +50,23 @@ struct tx_packet_hdr {
 #define HOSTCMD_SUPPORTED_RATES         14
 #define N_SUPPORTED_RATES               3
 #define ALL_802_11_BANDS           (BAND_A | BAND_B | BAND_G | BAND_GN | \
-				    BAND_AN | BAND_GAC | BAND_AAC)
+				    BAND_AN | BAND_AAC)
 
 #define FW_MULTI_BANDS_SUPPORT  (BIT(8) | BIT(9) | BIT(10) | BIT(11) | \
-				 BIT(12) | BIT(13))
+				 BIT(13))
 #define IS_SUPPORT_MULTI_BANDS(adapter)        \
 	(adapter->fw_cap_info & FW_MULTI_BANDS_SUPPORT)
 
-/* shift bit 12 and bit 13 in fw_cap_info from the firmware to bit 13 and 14
- * for 11ac so that bit 11 is for GN, bit 12 for AN, bit 13 for GAC, and bit
- * bit 14 for AAC, in order to be compatible with the band capability
- * defined in the driver after right shift of 8 bits.
+/* bit 13: 11ac BAND_AAC
+ * bit 12: reserved for lab testing, will be reused for BAND_AN
+ * bit 11: 11n  BAND_GN
+ * bit 10: 11a  BAND_A
+ * bit 9: 11g   BAND_G
+ * bit 8: 11b   BAND_B
+ * Map these bits to band capability by right shifting 8 bits.
  */
 #define GET_FW_DEFAULT_BANDS(adapter)  \
-	    (((((adapter->fw_cap_info & 0x3000) << 1) | \
-	       (adapter->fw_cap_info & ~0xF000)) >> 8) & \
+	    (((adapter->fw_cap_info & 0x2f00) >> 8) & \
 	     ALL_802_11_BANDS)
 
 #define HostCmd_WEP_KEY_INDEX_MASK              0x3fff
@@ -226,7 +228,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 /* HW_SPEC fw_cap_info */
 
-#define ISSUPP_11ACENABLED(fw_cap_info) (fw_cap_info & (BIT(12)|BIT(13)))
+#define ISSUPP_11ACENABLED(fw_cap_info) (fw_cap_info & BIT(13))
 
 #define GET_VHTCAP_CHWDSET(vht_cap_info)    ((vht_cap_info >> 2) & 0x3)
 #define GET_VHTNSSMCS(mcs_mapset, nss) ((mcs_mapset >> (2 * (nss - 1))) & 0x3)
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 00a95f4..48f1590 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -60,8 +60,7 @@ enum {
 	BAND_A = 4,
 	BAND_GN = 8,
 	BAND_AN = 16,
-	BAND_GAC = 32,
-	BAND_AAC = 64,
+	BAND_AAC = 32,
 };
 
 #define MWIFIEX_WPA_PASSHPHRASE_LEN 64
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 4e4686e..d3934c6 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -515,8 +515,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 
 	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info) &&
 	    !bss_desc->disable_11n && !bss_desc->disable_11ac &&
-	    (priv->adapter->config_bands & BAND_GAC ||
-	     priv->adapter->config_bands & BAND_AAC))
+	    priv->adapter->config_bands & BAND_AAC)
 		mwifiex_cmd_append_11ac_tlv(priv, bss_desc, &pos);
 
 	/* Append vendor specific IE TLV */
@@ -1300,8 +1299,7 @@ int mwifiex_associate(struct mwifiex_private *priv,
 
 	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info) &&
 	    !bss_desc->disable_11n && !bss_desc->disable_11ac &&
-	    (priv->adapter->config_bands & BAND_GAC ||
-	     priv->adapter->config_bands & BAND_AAC))
+	    priv->adapter->config_bands & BAND_AAC)
 		mwifiex_set_11ac_ba_params(priv);
 	else
 		mwifiex_set_ba_params(priv);
@@ -1335,8 +1333,7 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 		priv->curr_bss_params.band);
 
 	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info) &&
-	    (priv->adapter->config_bands & BAND_GAC ||
-	     priv->adapter->config_bands & BAND_AAC))
+	    priv->adapter->config_bands & BAND_AAC)
 		mwifiex_set_11ac_ba_params(priv);
 	else
 		mwifiex_set_ba_params(priv);
@@ -1376,8 +1373,7 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 
 	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info) &&
 	    !bss_desc->disable_11n && !bss_desc->disable_11ac &&
-	    (priv->adapter->config_bands & BAND_GAC ||
-	     priv->adapter->config_bands & BAND_AAC))
+	    priv->adapter->config_bands & BAND_AAC)
 		mwifiex_set_11ac_ba_params(priv);
 	else
 		mwifiex_set_ba_params(priv);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index c5cb2ed..9e55a48 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -290,7 +290,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 
 		if (mwifiex_band_to_radio_type(bss_desc->bss_band) ==
 						HostCmd_SCAN_RADIO_TYPE_BG)
-			config_bands = BAND_B | BAND_G | BAND_GN | BAND_GAC;
+			config_bands = BAND_B | BAND_G | BAND_GN;
 		else
 			config_bands = BAND_A | BAND_AN | BAND_AAC;
 
-- 
1.8.2.3

