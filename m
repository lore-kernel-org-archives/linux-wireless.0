Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:54323 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab1D1CIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 22:08:51 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: HT capability information handling
Date: Wed, 27 Apr 2011 19:13:12 -0700
Message-Id: <1303956793-17982-2-git-send-email-bzhao@marvell.com> (sfid-20110428_040858_184941_6B95F348)
In-Reply-To: <1303956793-17982-1-git-send-email-bzhao@marvell.com>
References: <1303956793-17982-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

1) Initialise HT capabilities in cfg80211 properly.
2) Cfg80211 stack may modify "sband->ht_cap" to disable
40Mhz operation in 2.4GHz band (after recent patch
"cfg80211: module_param to disable HT40 in 2.4GHz band")
Therefore read "sband->ht_cap" instead of an adapter variable
"hw_dot_11n_dev_cap" to get HT capabilities.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c      |  102 ++++++++-----------------------
 drivers/net/wireless/mwifiex/11n.h      |    2 +-
 drivers/net/wireless/mwifiex/cfg80211.c |   42 +++++++++++--
 drivers/net/wireless/mwifiex/scan.c     |    4 +-
 4 files changed, 64 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index e22d761..1d294cf 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -29,95 +29,38 @@
  * Fills HT capability information field, AMPDU Parameters field, HT extended
  * capability field, and supported MCS set fields.
  *
- * Only the following HT capability information fields are used, all other
- * fields are always turned off.
+ * HT capability information field, AMPDU Parameters field, supported MCS set
+ * fields are retrieved from cfg80211 stack
  *
- *  Bit 1 : Supported channel width (0: 20MHz, 1: Both 20 and 40 MHz)
- *  Bit 4 : Greenfield support (0: Not supported, 1: Supported)
- *  Bit 5 : Short GI for 20 MHz support (0: Not supported, 1: Supported)
- *  Bit 6 : Short GI for 40 MHz support (0: Not supported, 1: Supported)
- *  Bit 7 : Tx STBC (0: Not supported, 1: Supported)
- *  Bit 8-9 : Rx STBC (0: Not supported, X: Support for up to X spatial streams)
- *  Bit 10 : Delayed BA support (0: Not supported, 1: Supported)
- *  Bit 11 : Maximum AMSDU length (0: 3839 octets, 1: 7935 octets)
- *  Bit 14 : 40-Mhz intolerant support (0: Not supported, 1: Supported)
- *
- *  In addition, the following AMPDU Parameters are set -
- *      - Maximum AMPDU length exponent (set to 3)
- *      - Minimum AMPDU start spacing (set to 0 - No restrictions)
- *
- *  MCS is set for 1x1, with MSC32 for infra mode or ad-hoc mode with 40 MHz
- *  support.
- *
- *  RD responder bit to set to clear in the extended capability header.
+ * RD responder bit to set to clear in the extended capability header.
  */
 void
-mwifiex_fill_cap_info(struct mwifiex_private *priv,
+mwifiex_fill_cap_info(struct mwifiex_private *priv, u8 radio_type,
 		      struct mwifiex_ie_types_htcap *ht_cap)
 {
-	struct mwifiex_adapter *adapter = priv->adapter;
-	u8 *mcs;
-	int rx_mcs_supp;
-	uint16_t ht_cap_info = le16_to_cpu(ht_cap->ht_cap.cap_info);
 	uint16_t ht_ext_cap = le16_to_cpu(ht_cap->ht_cap.extended_ht_cap_info);
+	struct ieee80211_supported_band *sband =
+					priv->wdev->wiphy->bands[radio_type];
 
-	/* Convert dev_cap to IEEE80211_HT_CAP */
-	if (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap))
-		ht_cap_info |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-	else
-		ht_cap_info &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-
-	if (ISSUPP_SHORTGI20(adapter->hw_dot_11n_dev_cap))
-		ht_cap_info |= IEEE80211_HT_CAP_SGI_20;
-	else
-		ht_cap_info &= ~IEEE80211_HT_CAP_SGI_20;
-
-	if (ISSUPP_SHORTGI40(adapter->hw_dot_11n_dev_cap))
-		ht_cap_info |= IEEE80211_HT_CAP_SGI_40;
-	else
-		ht_cap_info &= ~IEEE80211_HT_CAP_SGI_40;
-
-	if (ISSUPP_TXSTBC(adapter->hw_dot_11n_dev_cap))
-		ht_cap_info |= IEEE80211_HT_CAP_TX_STBC;
-	else
-		ht_cap_info &= ~IEEE80211_HT_CAP_TX_STBC;
-
-	if (ISSUPP_RXSTBC(adapter->hw_dot_11n_dev_cap))
-		ht_cap_info |= 1 << IEEE80211_HT_CAP_RX_STBC_SHIFT;
-	else
-		ht_cap_info &= ~(3 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
-
-	if (ISSUPP_GREENFIELD(adapter->hw_dot_11n_dev_cap))
-		ht_cap_info |= IEEE80211_HT_CAP_GRN_FLD;
-	else
-		ht_cap_info &= ~IEEE80211_HT_CAP_GRN_FLD;
-
-	ht_cap_info &= ~IEEE80211_HT_CAP_MAX_AMSDU;
-	ht_cap_info |= IEEE80211_HT_CAP_SM_PS;
+	ht_cap->ht_cap.ampdu_params_info =
+		(sband->ht_cap.ampdu_factor &
+		 IEEE80211_HT_AMPDU_PARM_FACTOR)|
+		((sband->ht_cap.ampdu_density <<
+		 IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT) &
+		 IEEE80211_HT_AMPDU_PARM_DENSITY);
 
-	ht_cap->ht_cap.ampdu_params_info |= IEEE80211_HT_AMPDU_PARM_FACTOR;
-	ht_cap->ht_cap.ampdu_params_info &= ~IEEE80211_HT_AMPDU_PARM_DENSITY;
-
-	rx_mcs_supp = GET_RXMCSSUPP(adapter->hw_dev_mcs_support);
-
-	mcs = (u8 *)&ht_cap->ht_cap.mcs;
-
-	/* Set MCS for 1x1 */
-	memset(mcs, 0xff, rx_mcs_supp);
-
-	/* Clear all the other values */
-	memset(&mcs[rx_mcs_supp], 0,
-			sizeof(struct ieee80211_mcs_info) - rx_mcs_supp);
+	memcpy((u8 *) &ht_cap->ht_cap.mcs, &sband->ht_cap.mcs,
+						sizeof(sband->ht_cap.mcs));
 
 	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
-			(ht_cap_info & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
+			(sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
 		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
 		SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
 
 	/* Clear RD responder bit */
 	ht_ext_cap &= ~IEEE80211_HT_EXT_CAP_RD_RESPONDER;
 
-	ht_cap->ht_cap.cap_info = cpu_to_le16(ht_cap_info);
+	ht_cap->ht_cap.cap_info = cpu_to_le16(sband->ht_cap.cap);
 	ht_cap->ht_cap.extended_ht_cap_info = cpu_to_le16(ht_ext_cap);
 }
 
@@ -391,10 +334,15 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_2040bssco *bss_co_2040;
 	struct mwifiex_ie_types_extcap *ext_cap;
 	int ret_len = 0;
+	struct ieee80211_supported_band *sband;
+	u8 radio_type;
 
 	if (!buffer || !*buffer)
 		return ret_len;
 
+	radio_type = mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
+	sband = priv->wdev->wiphy->bands[radio_type];
+
 	if (bss_desc->bcn_ht_cap) {
 		ht_cap = (struct mwifiex_ie_types_htcap *) *buffer;
 		memset(ht_cap, 0, sizeof(struct mwifiex_ie_types_htcap));
@@ -406,7 +354,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		       sizeof(struct ieee_types_header),
 		       le16_to_cpu(ht_cap->header.len));
 
-		mwifiex_fill_cap_info(priv, ht_cap);
+		mwifiex_fill_cap_info(priv, radio_type, ht_cap);
 
 		*buffer += sizeof(struct mwifiex_ie_types_htcap);
 		ret_len += sizeof(struct mwifiex_ie_types_htcap);
@@ -428,8 +376,8 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			       sizeof(struct ieee_types_header),
 			       le16_to_cpu(ht_info->header.len));
 
-			if (!ISSUPP_CHANWIDTH40
-					(priv->adapter->hw_dot_11n_dev_cap))
+			if (!(sband->ht_cap.cap &
+					IEEE80211_HT_CAP_SUP_WIDTH_20_40))
 				ht_info->ht_info.ht_param &=
 					~(IEEE80211_HT_PARAM_CHAN_WIDTH_ANY |
 					IEEE80211_HT_PARAM_CHA_SEC_OFFSET);
@@ -451,7 +399,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		chan_list->chan_scan_param[0].radio_type =
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
-		if (ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap)
+		if ((sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 			&& (bss_desc->bcn_ht_info->ht_param &
 				IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
 			SET_SECONDARYCHAN(chan_list->chan_scan_param[0].
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 02602ff..a4390a1 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -38,7 +38,7 @@ int mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			       u8 **buffer);
 void mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 			struct mwifiex_bssdescriptor *bss_desc);
-void mwifiex_fill_cap_info(struct mwifiex_private *,
+void mwifiex_fill_cap_info(struct mwifiex_private *, u8 radio_type,
 			   struct mwifiex_ie_types_htcap *);
 int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv,
 				  u16 action, int *htcap_cfg);
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 5855755..98009e2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1150,9 +1150,9 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
  *
  * The following default values are set -
  *      - HT Supported = True
- *      - Maximum AMPDU length factor = 0x3
- *      - Minimum AMPDU spacing = 0x6
- *      - HT Capabilities map = IEEE80211_HT_CAP_SUP_WIDTH_20_40 (0x0002)
+ *      - Maximum AMPDU length factor = IEEE80211_HT_MAX_AMPDU_64K
+ *      - Minimum AMPDU spacing = IEEE80211_HT_MPDU_DENSITY_NONE
+ *      - HT Capabilities supported by firmware
  *      - MCS information, Rx mask = 0xff
  *      - MCD information, Tx parameters = IEEE80211_HT_MCS_TX_DEFINED (0x01)
  */
@@ -1166,13 +1166,41 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	ht_info->ht_supported = true;
-	ht_info->ampdu_factor = 0x3;
-	ht_info->ampdu_density = 0x6;
+	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
 
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
-	ht_info->cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 
-	rx_mcs_supp = GET_RXMCSSUPP(priv->adapter->hw_dev_mcs_support);
+	/* Fill HT capability information */
+	if (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap))
+		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	else
+		ht_info->cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+
+	if (ISSUPP_SHORTGI20(adapter->hw_dot_11n_dev_cap))
+		ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
+	else
+		ht_info->cap &= ~IEEE80211_HT_CAP_SGI_20;
+
+	if (ISSUPP_SHORTGI40(adapter->hw_dot_11n_dev_cap))
+		ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
+	else
+		ht_info->cap &= ~IEEE80211_HT_CAP_SGI_40;
+
+	if (ISSUPP_RXSTBC(adapter->hw_dot_11n_dev_cap))
+		ht_info->cap |= 1 << IEEE80211_HT_CAP_RX_STBC_SHIFT;
+	else
+		ht_info->cap &= ~(3 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
+
+	if (ISSUPP_TXSTBC(adapter->hw_dot_11n_dev_cap))
+		ht_info->cap |= IEEE80211_HT_CAP_TX_STBC;
+	else
+		ht_info->cap &= ~IEEE80211_HT_CAP_TX_STBC;
+
+	ht_info->cap &= ~IEEE80211_HT_CAP_MAX_AMSDU;
+	ht_info->cap |= IEEE80211_HT_CAP_SM_PS;
+
+	rx_mcs_supp = GET_RXMCSSUPP(adapter->hw_dev_mcs_support);
 	/* Set MCS for 1x1 */
 	memset(mcs, 0xff, rx_mcs_supp);
 	/* Clear all the other values */
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 68d905d..be708ad 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1007,7 +1007,9 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		ht_cap->header.type = cpu_to_le16(WLAN_EID_HT_CAPABILITY);
 		ht_cap->header.len =
 				cpu_to_le16(sizeof(struct ieee80211_ht_cap));
-		mwifiex_fill_cap_info(priv, ht_cap);
+		radio_type =
+			mwifiex_band_to_radio_type(priv->adapter->config_bands);
+		mwifiex_fill_cap_info(priv, radio_type, ht_cap);
 		tlv_pos += sizeof(struct mwifiex_ie_types_htcap);
 	}
 
-- 
1.7.0.2

