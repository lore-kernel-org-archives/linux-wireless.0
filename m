Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:49324 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1CZCnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 22:43:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: use IEEE80211_HT_CAP_ macros for 11n cap_info
Date: Fri, 25 Mar 2011 19:47:02 -0700
Message-Id: <1301107622-31449-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1301107622-31449-1-git-send-email-bzhao@marvell.com>
References: <1301107622-31449-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

The hw_dot_11n_dev_cap reported by firmware hw_spec
has different format than the 11n capabilities.
Hence a lot of SET_ and RESET_ bit operation macros
were used to convert the dev_cap format to 11n
capability format. However the locally defined 11n
ht_cap macros are not necessary as we can use
IEEE80211_HT_CAP_ macros directly.

The 32-bit dev_cap bitmap is added as comment to
explain the mapping between firmware and 11n spec.

Some unused macros and unnecessary adapter variables
are also removed.

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c      |   85 ++++++++++++------------------
 drivers/net/wireless/mwifiex/cfg80211.c |    3 +-
 drivers/net/wireless/mwifiex/cmdevt.c   |    3 -
 drivers/net/wireless/mwifiex/fw.h       |   84 ++++++++-----------------------
 drivers/net/wireless/mwifiex/init.c     |    2 -
 drivers/net/wireless/mwifiex/join.c     |   13 +++--
 drivers/net/wireless/mwifiex/main.h     |    2 -
 7 files changed, 63 insertions(+), 129 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 7b7b86d..ce6421f 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -61,59 +61,42 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv,
 	uint16_t ht_cap_info = le16_to_cpu(ht_cap->ht_cap.cap_info);
 	uint16_t ht_ext_cap = le16_to_cpu(ht_cap->ht_cap.extended_ht_cap_info);
 
-	if (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap) &&
-	    ISSUPP_CHANWIDTH40(adapter->usr_dot_11n_dev_cap))
-		SETHT_SUPPCHANWIDTH(ht_cap_info);
+	/* Convert dev_cap to IEEE80211_HT_CAP */
+	if (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap))
+		ht_cap_info |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 	else
-		RESETHT_SUPPCHANWIDTH(ht_cap_info);
+		ht_cap_info &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 
-	if (ISSUPP_GREENFIELD(adapter->hw_dot_11n_dev_cap) &&
-	    ISSUPP_GREENFIELD(adapter->usr_dot_11n_dev_cap))
-		SETHT_GREENFIELD(ht_cap_info);
+	if (ISSUPP_SHORTGI20(adapter->hw_dot_11n_dev_cap))
+		ht_cap_info |= IEEE80211_HT_CAP_SGI_20;
 	else
-		RESETHT_GREENFIELD(ht_cap_info);
+		ht_cap_info &= ~IEEE80211_HT_CAP_SGI_20;
 
-	if (ISSUPP_SHORTGI20(adapter->hw_dot_11n_dev_cap) &&
-	    ISSUPP_SHORTGI20(adapter->usr_dot_11n_dev_cap))
-		SETHT_SHORTGI20(ht_cap_info);
+	if (ISSUPP_SHORTGI40(adapter->hw_dot_11n_dev_cap))
+		ht_cap_info |= IEEE80211_HT_CAP_SGI_40;
 	else
-		RESETHT_SHORTGI20(ht_cap_info);
+		ht_cap_info &= ~IEEE80211_HT_CAP_SGI_40;
 
-	if (ISSUPP_SHORTGI40(adapter->hw_dot_11n_dev_cap) &&
-	    ISSUPP_SHORTGI40(adapter->usr_dot_11n_dev_cap))
-		SETHT_SHORTGI40(ht_cap_info);
-	else
-		RESETHT_SHORTGI40(ht_cap_info);
-
-	/* No user config for RX STBC yet */
-	if (ISSUPP_RXSTBC(adapter->hw_dot_11n_dev_cap)
-	    && ISSUPP_RXSTBC(adapter->usr_dot_11n_dev_cap))
-		SETHT_RXSTBC(ht_cap_info, 1);
-	else
-		RESETHT_RXSTBC(ht_cap_info);
-
-	/* No user config for TX STBC yet */
 	if (ISSUPP_TXSTBC(adapter->hw_dot_11n_dev_cap))
-		SETHT_TXSTBC(ht_cap_info);
+		ht_cap_info |= IEEE80211_HT_CAP_TX_STBC;
 	else
-		RESETHT_TXSTBC(ht_cap_info);
+		ht_cap_info &= ~IEEE80211_HT_CAP_TX_STBC;
 
-	/* No user config for Delayed BACK yet */
-	if (GET_DELAYEDBACK(adapter->hw_dot_11n_dev_cap))
-		SETHT_DELAYEDBACK(ht_cap_info);
+	if (ISSUPP_RXSTBC(adapter->hw_dot_11n_dev_cap))
+		ht_cap_info |= 1 << IEEE80211_HT_CAP_RX_STBC_SHIFT;
 	else
-		RESETHT_DELAYEDBACK(ht_cap_info);
+		ht_cap_info &= ~(3 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
 
-	if (ISENABLED_40MHZ_INTOLARENT(adapter->usr_dot_11n_dev_cap))
-		SETHT_40MHZ_INTOLARANT(ht_cap_info);
+	if (ISSUPP_GREENFIELD(adapter->hw_dot_11n_dev_cap))
+		ht_cap_info |= IEEE80211_HT_CAP_GRN_FLD;
 	else
-		RESETHT_40MHZ_INTOLARANT(ht_cap_info);
+		ht_cap_info &= ~IEEE80211_HT_CAP_GRN_FLD;
 
-	SETAMPDU_SIZE(ht_cap->ht_cap.ampdu_params_info, AMPDU_FACTOR_64K);
-	SETAMPDU_SPACING(ht_cap->ht_cap.ampdu_params_info, 0);
+	ht_cap_info &= ~IEEE80211_HT_CAP_MAX_AMSDU;
+	ht_cap_info |= IEEE80211_HT_CAP_SM_PS;
 
-	/* Need change to support 8k AMSDU receive */
-	RESETHT_MAXAMSDU(ht_cap_info);
+	ht_cap->ht_cap.ampdu_params_info |= IEEE80211_HT_AMPDU_PARM_FACTOR;
+	ht_cap->ht_cap.ampdu_params_info &= ~IEEE80211_HT_AMPDU_PARM_DENSITY;
 
 	rx_mcs_supp = GET_RXMCSSUPP(adapter->hw_dev_mcs_support);
 
@@ -127,8 +110,7 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv,
 			sizeof(struct ieee80211_mcs_info) - rx_mcs_supp);
 
 	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA ||
-	    (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap) &&
-	     ISSUPP_CHANWIDTH40(adapter->usr_dot_11n_dev_cap)))
+			(ht_cap_info & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
 		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
 		SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
 
@@ -452,10 +434,10 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			       le16_to_cpu(ht_info->header.len));
 
 			if (!ISSUPP_CHANWIDTH40
-			    (priv->adapter->hw_dot_11n_dev_cap)
-			    || !ISSUPP_CHANWIDTH40(priv->adapter->
-						   usr_dot_11n_dev_cap))
-				RESET_CHANWIDTH40(ht_info->ht_info.ht_param);
+					(priv->adapter->hw_dot_11n_dev_cap))
+				ht_info->ht_info.ht_param &=
+					~(IEEE80211_HT_PARAM_CHAN_WIDTH_ANY |
+					IEEE80211_HT_PARAM_CHA_SEC_OFFSET);
 
 			*buffer += sizeof(struct mwifiex_ie_types_htinfo);
 			ret_len += sizeof(struct mwifiex_ie_types_htinfo);
@@ -474,13 +456,13 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		chan_list->chan_scan_param[0].radio_type =
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
-		if ((ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap) &&
-		     ISSUPP_CHANWIDTH40(priv->adapter->usr_dot_11n_dev_cap))
-		    && ISALLOWED_CHANWIDTH40(bss_desc->bcn_ht_info->ht_param))
+		if (ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap)
+			&& (bss_desc->bcn_ht_info->ht_param &
+				IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
 			SET_SECONDARYCHAN(chan_list->chan_scan_param[0].
 					  radio_type,
-					  GET_SECONDARYCHAN(bss_desc->
-					  bcn_ht_info->ht_param));
+					  (bss_desc->bcn_ht_info->ht_param &
+					  IEEE80211_HT_PARAM_CHA_SEC_OFFSET));
 
 		*buffer += sizeof(struct mwifiex_ie_types_chan_list_param_set);
 		ret_len += sizeof(struct mwifiex_ie_types_chan_list_param_set);
@@ -540,7 +522,8 @@ mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 	u16 curr_tx_buf_size = 0;
 
 	if (bss_desc->bcn_ht_cap) {
-		if (GETHT_MAXAMSDU(le16_to_cpu(bss_desc->bcn_ht_cap->cap_info)))
+		if (le16_to_cpu(bss_desc->bcn_ht_cap->cap_info) &
+				IEEE80211_HT_CAP_MAX_AMSDU)
 			max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_8K;
 		else
 			max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_4K;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 84e33f1..de86ef8 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1302,8 +1302,7 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	memset(&mcs[rx_mcs_supp], 0,
 			sizeof(struct ieee80211_mcs_info) - rx_mcs_supp);
 	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA ||
-			(ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap) &&
-			 ISSUPP_CHANWIDTH40(adapter->usr_dot_11n_dev_cap)))
+			ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap))
 		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
 		SETHT_MCS32(mcs_set.rx_mask);
 
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 24a3b6b..3865dd1 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1448,10 +1448,7 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	}
 
 	adapter->hw_dot_11n_dev_cap = le32_to_cpu(hw_spec->dot_11n_dev_cap);
-	adapter->usr_dot_11n_dev_cap = adapter->hw_dot_11n_dev_cap &
-		DEFAULT_11N_CAP_MASK;
 	adapter->hw_dev_mcs_support = hw_spec->dev_mcs_support;
-	adapter->usr_dev_mcs_support = adapter->hw_dev_mcs_support;
 
 	if (adapter->if_ops.update_mp_end_port)
 		adapter->if_ops.update_mp_end_port(adapter,
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 410be69..6593e07 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -182,76 +182,34 @@ enum MWIFIEX_802_11_WEP_STATUS {
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_4K        4096
 #define MWIFIEX_TX_DATA_BUF_SIZE_8K        8192
-#define MAX_RX_AMPDU_SIZE_64K   0x03
 #define NON_GREENFIELD_STAS     0x04
 
-#define HWSPEC_GREENFIELD_SUPP	 BIT(29)
-#define HWSPEC_RXSTBC_SUPP	 BIT(26)
-#define HWSPEC_SHORTGI40_SUPP	 BIT(24)
-#define HWSPEC_SHORTGI20_SUPP	 BIT(23)
-#define HWSPEC_CHANBW40_SUPP	 BIT(17)
-
-#define DEFAULT_11N_CAP_MASK	(HWSPEC_SHORTGI20_SUPP | HWSPEC_RXSTBC_SUPP)
 #define ISSUPP_11NENABLED(FwCapInfo) (FwCapInfo & BIT(11))
-#define ISSUPP_GREENFIELD(Dot11nDevCap) (Dot11nDevCap & BIT(29))
-#define ISSUPP_RXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(26))
-#define ISSUPP_TXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(25))
-#define ISSUPP_SHORTGI40(Dot11nDevCap) (Dot11nDevCap & BIT(24))
-#define ISSUPP_SHORTGI20(Dot11nDevCap) (Dot11nDevCap & BIT(23))
-#define GET_DELAYEDBACK(Dot11nDevCap) (((Dot11nDevCap >> 20) & 0x03))
+
+/* dev_cap bitmap
+ * BIT
+ * 0-16		reserved
+ * 17		IEEE80211_HT_CAP_SUP_WIDTH_20_40
+ * 18-22	reserved
+ * 23		IEEE80211_HT_CAP_SGI_20
+ * 24		IEEE80211_HT_CAP_SGI_40
+ * 25		IEEE80211_HT_CAP_TX_STBC
+ * 26		IEEE80211_HT_CAP_RX_STBC
+ * 27-28	reserved
+ * 29		IEEE80211_HT_CAP_GRN_FLD
+ * 30-31	reserved
+ */
 #define ISSUPP_CHANWIDTH40(Dot11nDevCap) (Dot11nDevCap & BIT(17))
-#define ISENABLED_40MHZ_INTOLARENT(Dot11nDevCap) (Dot11nDevCap & BIT(8))
-#define SETSUPP_CHANWIDTH40(Dot11nDevCap) (Dot11nDevCap |= BIT(17))
-#define RESETSUPP_CHANWIDTH40(Dot11nDevCap) (Dot11nDevCap &= ~BIT(17))
-#define GET_TXMCSSUPP(DevMCSSupported) (DevMCSSupported >> 4)
+#define ISSUPP_SHORTGI20(Dot11nDevCap) (Dot11nDevCap & BIT(23))
+#define ISSUPP_SHORTGI40(Dot11nDevCap) (Dot11nDevCap & BIT(24))
+#define ISSUPP_TXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(25))
+#define ISSUPP_RXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(26))
+#define ISSUPP_GREENFIELD(Dot11nDevCap) (Dot11nDevCap & BIT(29))
+
 #define GET_RXMCSSUPP(DevMCSSupported) (DevMCSSupported & 0x0f)
-#define GETHT_SUPPCHANWIDTH(HTCapInfo) (HTCapInfo & BIT(1))
-#define GETHT_GREENFIELD(HTCapInfo) (HTCapInfo & BIT(4))
-#define GETHT_SHORTGI20(HTCapInfo) (HTCapInfo & BIT(5))
-#define GETHT_SHORTGI40(HTCapInfo) (HTCapInfo & BIT(6))
-#define GETHT_TXSTBC(HTCapInfo) (HTCapInfo & BIT(7))
-#define GETHT_RXSTBC(HTCapInfo) ((HTCapInfo >> 8) & 0x03)
-#define GETHT_DELAYEDBACK(HTCapInfo) (HTCapInfo & BIT(10))
-#define GETHT_MAXAMSDU(HTCapInfo) (HTCapInfo & BIT(11))
-#define SETHT_SUPPCHANWIDTH(HTCapInfo) (HTCapInfo |= BIT(1))
-#define SETHT_GREENFIELD(HTCapInfo) (HTCapInfo |= BIT(4))
-#define SETHT_SHORTGI20(HTCapInfo) (HTCapInfo |= BIT(5))
-#define SETHT_SHORTGI40(HTCapInfo) (HTCapInfo |= BIT(6))
-#define SETHT_TXSTBC(HTCapInfo) (HTCapInfo |= BIT(7))
-#define SETHT_RXSTBC(HTCapInfo, value) (HTCapInfo |= (value << 8))
-#define SETHT_DELAYEDBACK(HTCapInfo) (HTCapInfo |= BIT(10))
-#define SETHT_MAXAMSDU(HTCapInfo) (HTCapInfo |= BIT(11))
-#define SETHT_DSSSCCK40(HTCapInfo) (HTCapInfo |= BIT(12))
-#define SETHT_40MHZ_INTOLARANT(HTCapInfo) (HTCapInfo |= BIT(14))
-#define RESETHT_SUPPCHANWIDTH(HTCapInfo) (HTCapInfo &= ~BIT(1))
-#define RESETHT_GREENFIELD(HTCapInfo) (HTCapInfo &= ~BIT(4))
-#define RESETHT_SHORTGI20(HTCapInfo) (HTCapInfo &= ~BIT(5))
-#define RESETHT_SHORTGI40(HTCapInfo) (HTCapInfo &= ~BIT(6))
-#define RESETHT_TXSTBC(HTCapInfo) (HTCapInfo &= ~BIT(7))
-#define RESETHT_RXSTBC(HTCapInfo) (HTCapInfo &= ~(0x03 << 8))
-#define RESETHT_DELAYEDBACK(HTCapInfo) (HTCapInfo &= ~BIT(10))
-#define RESETHT_MAXAMSDU(HTCapInfo) (HTCapInfo &= ~BIT(11))
-#define RESETHT_40MHZ_INTOLARANT(HTCapInfo) (HTCapInfo &= ~BIT(14))
 #define RESETHT_EXTCAP_RDG(HTExtCap) (HTExtCap &= ~BIT(11))
 #define SETHT_MCS32(x) (x[4] |= 1)
-#define SETHT_MCS_SET_DEFINED(x) (x[12] |= 1)
-#define SETHT_RX_HIGHEST_DT_SUPP(x, y) ((*(u16 *) (x + 10)) = y)
-#define AMPDU_FACTOR_64K	0x03
-#define SETAMPDU_SIZE(x, y) do { \
-	x = x & ~0x03; \
-	x |= y & 0x03; \
-} while (0) \
-
-#define SETAMPDU_SPACING(x, y) do { \
-	x = x & ~0x1c; \
-	x |= (y & 0x07) << 2; \
-} while (0) \
-
-#define ISSUPP_BANDA(FwCapInfo) (FwCapInfo & BIT(10))
-#define ISALLOWED_CHANWIDTH40(Field2) (Field2 & BIT(2))
-#define SET_CHANWIDTH40(Field2) (Field2 |= BIT(2))
-#define RESET_CHANWIDTH40(Field2) (Field2 &= ~(BIT(0) | BIT(1) | BIT(2)))
-#define GET_SECONDARYCHAN(Field2) (Field2 & (BIT(0) | BIT(1)))
+
 #define SET_SECONDARYCHAN(RadioType, SECCHAN) (RadioType |= (SECCHAN << 4))
 
 #define LLC_SNAP_LEN    8
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 07ebc97..1c9315d 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -267,8 +267,6 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	memset(adapter->event_body, 0, sizeof(adapter->event_body));
 	adapter->hw_dot_11n_dev_cap = 0;
 	adapter->hw_dev_mcs_support = 0;
-	adapter->usr_dot_11n_dev_cap = 0;
-	adapter->usr_dev_mcs_support = 0;
 	adapter->chan_offset = 0;
 	adapter->adhoc_11n_enabled = false;
 
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 8ffb6a8..08fa721 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -970,16 +970,16 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			       cpu_to_le16(sizeof(struct ieee80211_ht_cap));
 			ht_cap_info = le16_to_cpu(ht_cap->ht_cap.cap_info);
 
-			SETHT_SHORTGI20(ht_cap_info);
+			ht_cap_info |= IEEE80211_HT_CAP_SGI_20;
 			if (adapter->chan_offset) {
-				SETHT_SHORTGI40(ht_cap_info);
-				SETHT_DSSSCCK40(ht_cap_info);
-				SETHT_SUPPCHANWIDTH(ht_cap_info);
+				ht_cap_info |= IEEE80211_HT_CAP_SGI_40;
+				ht_cap_info |= IEEE80211_HT_CAP_DSSSCCK40;
+				ht_cap_info |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 				SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
 			}
 
 			ht_cap->ht_cap.ampdu_params_info
-					= MAX_RX_AMPDU_SIZE_64K;
+					= IEEE80211_HT_MAX_AMPDU_64K;
 			ht_cap->ht_cap.mcs.rx_mask[0] = 0xff;
 			pos += sizeof(struct mwifiex_ie_types_htcap);
 			cmd_append_size +=
@@ -999,7 +999,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			if (adapter->chan_offset) {
 				ht_info->ht_info.ht_param =
 					adapter->chan_offset;
-				SET_CHANWIDTH40(ht_info->ht_info.ht_param);
+				ht_info->ht_info.ht_param |=
+					IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
 			}
 			ht_info->ht_info.operation_mode =
 				cpu_to_le16(NON_GREENFIELD_STAS);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index f6fe105..7bcb2e9 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -687,8 +687,6 @@ struct mwifiex_adapter {
 	u8 event_body[MAX_EVENT_SIZE];
 	u32 hw_dot_11n_dev_cap;
 	u8 hw_dev_mcs_support;
-	u32 usr_dot_11n_dev_cap;
-	u8 usr_dev_mcs_support;
 	u8 adhoc_11n_enabled;
 	u8 chan_offset;
 	struct mwifiex_dbg dbg;
-- 
1.7.0.2

