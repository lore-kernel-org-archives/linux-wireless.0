Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:40776 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1ADDnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 22:43:21 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove struct ieee_htcap
Date: Mon,  3 Jan 2011 19:43:55 -0800
Message-Id: <1294112635-5235-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replace it with struct ieee80211_ht_cap

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c      |   28 ++++++++++++++++------------
 drivers/net/wireless/mwifiex/cfg80211.c |   13 +++++++------
 drivers/net/wireless/mwifiex/fw.h       |    2 +-
 drivers/net/wireless/mwifiex/ieee.h     |   11 +----------
 drivers/net/wireless/mwifiex/ioctl.h    |    2 --
 drivers/net/wireless/mwifiex/join.c     |   11 ++++++-----
 drivers/net/wireless/mwifiex/scan.c     |    3 ++-
 7 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 93de7ca..e4a0314 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -353,9 +353,10 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv,
 		      struct mwifiex_ie_types_htcap *ht_cap)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 *mcs;
 	int rx_mcs_supp;
-	uint16_t ht_cap_info = le16_to_cpu(ht_cap->ht_cap.ht_cap_info);
-	uint16_t ht_ext_cap = le16_to_cpu(ht_cap->ht_cap.ht_ext_cap);
+	uint16_t ht_cap_info = le16_to_cpu(ht_cap->ht_cap.cap_info);
+	uint16_t ht_ext_cap = le16_to_cpu(ht_cap->ht_cap.extended_ht_cap_info);
 
 	ENTER();
 
@@ -407,32 +408,34 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv,
 	else
 		RESETHT_40MHZ_INTOLARANT(ht_cap_info);
 
-	SETAMPDU_SIZE(ht_cap->ht_cap.ampdu_param, AMPDU_FACTOR_64K);
-	SETAMPDU_SPACING(ht_cap->ht_cap.ampdu_param, 0);
+	SETAMPDU_SIZE(ht_cap->ht_cap.ampdu_params_info, AMPDU_FACTOR_64K);
+	SETAMPDU_SPACING(ht_cap->ht_cap.ampdu_params_info, 0);
 
 	/* Need change to support 8k AMSDU receive */
 	RESETHT_MAXAMSDU(ht_cap_info);
 
 	rx_mcs_supp = GET_RXMCSSUPP(adapter->hw_dev_mcs_support);
 
+	mcs = (u8 *)&ht_cap->ht_cap.mcs;
+
 	/* Set MCS for 1x1 */
-	memset((u8 *) ht_cap->ht_cap.supported_mcs_set, 0xff, rx_mcs_supp);
+	memset(mcs, 0xff, rx_mcs_supp);
 
 	/* Clear all the other values */
-	memset((u8 *) &ht_cap->ht_cap.supported_mcs_set[rx_mcs_supp], 0,
-	       NUM_MCS_FIELD - rx_mcs_supp);
+	memset(&mcs[rx_mcs_supp], 0,
+			sizeof(struct ieee80211_mcs_info) - rx_mcs_supp);
 
 	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA ||
 	    (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap) &&
 	     ISSUPP_CHANWIDTH40(adapter->usr_dot_11n_dev_cap)))
 		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
-		SETHT_MCS32(ht_cap->ht_cap.supported_mcs_set);
+		SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
 
 	/* Clear RD responder bit */
 	RESETHT_EXTCAP_RDG(ht_ext_cap);
 
-	ht_cap->ht_cap.ht_cap_info = cpu_to_le16(ht_cap_info);
-	ht_cap->ht_cap.ht_ext_cap = cpu_to_le16(ht_ext_cap);
+	ht_cap->ht_cap.cap_info = cpu_to_le16(ht_cap_info);
+	ht_cap->ht_cap.extended_ht_cap_info = cpu_to_le16(ht_ext_cap);
 
 	LEAVE();
 }
@@ -830,7 +833,8 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		ht_cap = (struct mwifiex_ie_types_htcap *) *buffer;
 		memset(ht_cap, 0, sizeof(struct mwifiex_ie_types_htcap));
 		ht_cap->header.type = cpu_to_le16(WLAN_EID_HT_CAPABILITY);
-		ht_cap->header.len = cpu_to_le16(sizeof(struct ieee_htcap));
+		ht_cap->header.len =
+				cpu_to_le16(sizeof(struct ieee80211_ht_cap));
 		memcpy((u8 *) ht_cap + sizeof(struct mwifiex_ie_types_header),
 		       (u8 *) bss_desc->bcn_ht_cap +
 		       sizeof(struct ieee_types_header),
@@ -964,7 +968,7 @@ mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 
 	if (bss_desc->bcn_ht_cap) {
 		if (GETHT_MAXAMSDU(le16_to_cpu(bss_desc->bcn_ht_cap->ht_cap
-				.ht_cap_info)))
+				.cap_info)))
 			max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_8K;
 		else
 			max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_4K;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 8d74446..c961e0f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1416,7 +1416,8 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 		      struct mwifiex_private *priv)
 {
 	int rx_mcs_supp;
-	u8 mcs_set[NUM_MCS_FIELD];
+	struct ieee80211_mcs_info mcs_set;
+	u8 *mcs = (u8 *)&mcs_set;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	ENTER();
 
@@ -1429,17 +1430,17 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 
 	rx_mcs_supp = GET_RXMCSSUPP(priv->adapter->hw_dev_mcs_support);
 	/* Set MCS for 1x1 */
-	memset((u8 *) mcs_set, 0xff, rx_mcs_supp);
+	memset(mcs, 0xff, rx_mcs_supp);
 	/* Clear all the other values */
-	memset((u8 *) &mcs_set[rx_mcs_supp], 0,
-			NUM_MCS_FIELD - rx_mcs_supp);
+	memset(&mcs[rx_mcs_supp], 0,
+			sizeof(struct ieee80211_mcs_info) - rx_mcs_supp);
 	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA ||
 			(ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap) &&
 			 ISSUPP_CHANWIDTH40(adapter->usr_dot_11n_dev_cap)))
 		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
-		SETHT_MCS32(mcs_set);
+		SETHT_MCS32(mcs_set.rx_mask);
 
-	memcpy(&ht_info->mcs, mcs_set, NUM_MCS_FIELD);
+	memcpy((u8 *) &ht_info->mcs, mcs, sizeof(struct ieee80211_mcs_info));
 
 	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index f166991..d2c39c7 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1170,7 +1170,7 @@ struct mwifiex_wmm_ac_status {
 
 struct mwifiex_ie_types_htcap {
 	struct mwifiex_ie_types_header header;
-	struct ieee_htcap ht_cap;
+	struct ieee80211_ht_cap ht_cap;
 } __packed;
 
 struct mwifiex_ie_types_htinfo {
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index 8888106..70af50c 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -158,15 +158,6 @@ struct ieee_types_wmm_parameter {
 #define MWIFIEX_MAX_TRIPLET_802_11D		83
 #define COUNTRY_CODE_LEN			3
 
-struct ieee_htcap {
-	__le16 ht_cap_info;
-	u8 ampdu_param;
-	u8 supported_mcs_set[16];
-	__le16 ht_ext_cap;
-	u32 tx_bf_cap;
-	u8 asel;
-} __packed;
-
 struct ieee_bssco_2040 {
 	u8 bss_co_2040_value;
 } __packed;
@@ -187,7 +178,7 @@ struct ieee_obss_scan_param {
 
 struct ieee_types_htcap {
 	struct ieee_types_header ieee_hdr;
-	struct ieee_htcap ht_cap;
+	struct ieee80211_ht_cap ht_cap;
 } __packed;
 
 struct ieee_types_htinfo {
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index c5205cb..5ed613d 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -605,8 +605,6 @@ struct mwifiex_ds_wmm_cfg {
 	} param;
 };
 
-#define NUM_MCS_FIELD				16
-
 struct mwifiex_ds_11n_addba_param {
 	u32 timeout;
 	u32 tx_win_size;
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 8723c85..6ef516c 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1121,19 +1121,20 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			ht_cap->header.type =
 				cpu_to_le16(WLAN_EID_HT_CAPABILITY);
 			ht_cap->header.len =
-			       cpu_to_le16(sizeof(struct ieee_htcap));
-			ht_cap_info = le16_to_cpu(ht_cap->ht_cap.ht_cap_info);
+			       cpu_to_le16(sizeof(struct ieee80211_ht_cap));
+			ht_cap_info = le16_to_cpu(ht_cap->ht_cap.cap_info);
 
 			SETHT_SHORTGI20(ht_cap_info);
 			if (adapter->chan_offset) {
 				SETHT_SHORTGI40(ht_cap_info);
 				SETHT_DSSSCCK40(ht_cap_info);
 				SETHT_SUPPCHANWIDTH(ht_cap_info);
-				SETHT_MCS32(ht_cap->ht_cap.supported_mcs_set);
+				SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
 			}
 
-			ht_cap->ht_cap.ampdu_param = MAX_RX_AMPDU_SIZE_64K;
-			ht_cap->ht_cap.supported_mcs_set[0] = 0xff;
+			ht_cap->ht_cap.ampdu_params_info
+					= MAX_RX_AMPDU_SIZE_64K;
+			ht_cap->ht_cap.mcs.rx_mask[0] = 0xff;
 			HEXDUMP("ADHOC_START: HT_CAPABILITIES IE",
 				(u8 *) ht_cap,
 				sizeof(struct mwifiex_ie_types_htcap));
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 29d457a..104589e 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1132,7 +1132,8 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		ht_cap = (struct mwifiex_ie_types_htcap *) tlv_pos;
 		memset(ht_cap, 0, sizeof(struct mwifiex_ie_types_htcap));
 		ht_cap->header.type = cpu_to_le16(WLAN_EID_HT_CAPABILITY);
-		ht_cap->header.len = cpu_to_le16(sizeof(struct ieee_htcap));
+		ht_cap->header.len =
+				cpu_to_le16(sizeof(struct ieee80211_ht_cap));
 		mwifiex_fill_cap_info(priv, ht_cap);
 		HEXDUMP("SCAN: HT_CAPABILITIES IE", (u8 *) ht_cap,
 			sizeof(struct mwifiex_ie_types_htcap));
-- 
1.7.0.2

