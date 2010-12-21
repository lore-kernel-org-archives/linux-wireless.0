Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:39785 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab0LUXls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 18:41:48 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: replace struct ieee_htinfo with ieee80211_ht_info
Date: Tue, 21 Dec 2010 15:41:54 -0800
Message-Id: <1292974914-12306-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct ieee80211_ht_info is defined in include/linux/ieee80211.h

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c  |   10 +++++-----
 drivers/net/wireless/mwifiex/fw.h   |    2 +-
 drivers/net/wireless/mwifiex/ieee.h |   10 +---------
 drivers/net/wireless/mwifiex/join.c |   13 +++++++------
 4 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 73d2fb7..93de7ca 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -852,7 +852,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			ht_info->header.type =
 					cpu_to_le16(WLAN_EID_HT_INFORMATION);
 			ht_info->header.len =
-				cpu_to_le16(sizeof(struct ieee_htinfo));
+				cpu_to_le16(sizeof(struct ieee80211_ht_info));
 
 			memcpy((u8 *) ht_info +
 			       sizeof(struct mwifiex_ie_types_header),
@@ -864,7 +864,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			    (priv->adapter->hw_dot_11n_dev_cap)
 			    || !ISSUPP_CHANWIDTH40(priv->adapter->
 						   usr_dot_11n_dev_cap)) {
-				RESET_CHANWIDTH40(ht_info->ht_info.field2);
+				RESET_CHANWIDTH40(ht_info->ht_info.ht_param);
 			}
 
 			*buffer += sizeof(struct mwifiex_ie_types_htinfo);
@@ -880,18 +880,18 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			sizeof(struct mwifiex_ie_types_chan_list_param_set) -
 			sizeof(struct mwifiex_ie_types_header));
 		chan_list->chan_scan_param[0].chan_number =
-			bss_desc->bcn_ht_info->ht_info.pri_chan;
+			bss_desc->bcn_ht_info->ht_info.control_chan;
 		chan_list->chan_scan_param[0].radio_type =
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
 		if ((ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap) &&
 		     ISSUPP_CHANWIDTH40(priv->adapter->usr_dot_11n_dev_cap))
 		    && ISALLOWED_CHANWIDTH40(bss_desc->bcn_ht_info->ht_info.
-					     field2))
+					     ht_param))
 			SET_SECONDARYCHAN(chan_list->chan_scan_param[0].
 					  radio_type,
 					  GET_SECONDARYCHAN(bss_desc->
-					  bcn_ht_info->ht_info.field2));
+					  bcn_ht_info->ht_info.ht_param));
 
 		HEXDUMP("ChanList", (u8 *) chan_list,
 			sizeof(struct mwifiex_ie_types_chan_list_param_set));
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 834122c..f166991 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1175,7 +1175,7 @@ struct mwifiex_ie_types_htcap {
 
 struct mwifiex_ie_types_htinfo {
 	struct mwifiex_ie_types_header header;
-	struct ieee_htinfo ht_info;
+	struct ieee80211_ht_info ht_info;
 } __packed;
 
 struct mwifiex_ie_types_2040bssco {
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index 263380c..8888106 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -167,14 +167,6 @@ struct ieee_htcap {
 	u8 asel;
 } __packed;
 
-struct ieee_htinfo {
-	u8 pri_chan;
-	u8 field2;
-	u16 field3;
-	u16 field4;
-	u8 basic_mcs_set[16];
-} __packed;
-
 struct ieee_bssco_2040 {
 	u8 bss_co_2040_value;
 } __packed;
@@ -200,7 +192,7 @@ struct ieee_types_htcap {
 
 struct ieee_types_htinfo {
 	struct ieee_types_header ieee_hdr;
-	struct ieee_htinfo ht_info;
+	struct ieee80211_ht_info ht_info;
 } __packed;
 
 struct ieee_types_2040bssco {
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 9ac0c2f..9504107 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1154,17 +1154,18 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			ht_info->header.type =
 				cpu_to_le16(WLAN_EID_HT_INFORMATION);
 			ht_info->header.len =
-				cpu_to_le16(sizeof(struct ieee_htinfo));
-			ht_info->ht_info.pri_chan =
+				cpu_to_le16(sizeof(struct ieee80211_ht_info));
+			ht_info->ht_info.control_chan =
 				(u8) priv->curr_bss_params.bss_descriptor.
 				channel;
 			if (adapter->chan_offset) {
-				ht_info->ht_info.field2 =
+				ht_info->ht_info.ht_param =
 					adapter->chan_offset;
-				SET_CHANWIDTH40(ht_info->ht_info.field2);
+				SET_CHANWIDTH40(ht_info->ht_info.ht_param);
 			}
-			ht_info->ht_info.field3 = NON_GREENFIELD_STAS;
-			ht_info->ht_info.basic_mcs_set[0] = 0xff;
+			ht_info->ht_info.operation_mode =
+				cpu_to_le16(NON_GREENFIELD_STAS);
+			ht_info->ht_info.basic_set[0] = 0xff;
 			HEXDUMP("ADHOC_START: HT_INFORMATION IE",
 				(u8 *) ht_info,
 				sizeof(struct mwifiex_ie_types_htinfo));
-- 
1.7.0.2

