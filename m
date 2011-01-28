Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46719 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1A1CLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 21:11:33 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: remove struct ieee_types_htinfo
Date: Thu, 27 Jan 2011 18:13:00 -0800
Message-Id: <1296180782-28951-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use "struct ieee80211_ht_info" directly

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c  |    7 +++----
 drivers/net/wireless/mwifiex/ieee.h |    7 +------
 drivers/net/wireless/mwifiex/scan.c |   24 ++++++++++++------------
 3 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 2922528..8a0414e 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -884,18 +884,17 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			sizeof(struct mwifiex_ie_types_chan_list_param_set) -
 			sizeof(struct mwifiex_ie_types_header));
 		chan_list->chan_scan_param[0].chan_number =
-			bss_desc->bcn_ht_info->ht_info.control_chan;
+			bss_desc->bcn_ht_info->control_chan;
 		chan_list->chan_scan_param[0].radio_type =
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
 		if ((ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap) &&
 		     ISSUPP_CHANWIDTH40(priv->adapter->usr_dot_11n_dev_cap))
-		    && ISALLOWED_CHANWIDTH40(bss_desc->bcn_ht_info->ht_info.
-					     ht_param))
+		    && ISALLOWED_CHANWIDTH40(bss_desc->bcn_ht_info->ht_param))
 			SET_SECONDARYCHAN(chan_list->chan_scan_param[0].
 					  radio_type,
 					  GET_SECONDARYCHAN(bss_desc->
-					  bcn_ht_info->ht_info.ht_param));
+					  bcn_ht_info->ht_param));
 
 		HEXDUMP("ChanList", (u8 *) chan_list,
 			sizeof(struct mwifiex_ie_types_chan_list_param_set));
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index 2282c0c..04b88f6 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -175,11 +175,6 @@ struct ieee_types_htcap {
 	struct ieee80211_ht_cap ht_cap;
 } __packed;
 
-struct ieee_types_htinfo {
-	struct ieee_types_header ieee_hdr;
-	struct ieee80211_ht_info ht_info;
-} __packed;
-
 struct ieee_types_2040bssco {
 	struct ieee_types_header ieee_hdr;
 	struct ieee_bssco_2040 bss_co_2040;
@@ -223,7 +218,7 @@ struct mwifiex_bssdescriptor {
 	u8  disable_11n;
 	struct ieee_types_htcap *bcn_ht_cap;
 	u16 ht_cap_offset;
-	struct ieee_types_htinfo *bcn_ht_info;
+	struct ieee80211_ht_info *bcn_ht_info;
 	u16 ht_info_offset;
 	struct ieee_types_2040bssco *bcn_bss_co_2040;
 	u16 bss_co_2040_offset;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 6da0612..371c048 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1638,15 +1638,15 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				sizeof(struct ieee_types_header));
 			break;
 		case WLAN_EID_HT_INFORMATION:
-			bss_entry->bcn_ht_info =
-				(struct ieee_types_htinfo *) current_ptr;
-			bss_entry->ht_info_offset =
-				(u16) (current_ptr -
-					 bss_entry->beacon_buf);
+			bss_entry->bcn_ht_info = (struct ieee80211_ht_info *)
+					(current_ptr +
+					sizeof(struct ieee_types_header));
+			bss_entry->ht_info_offset = (u16) (current_ptr +
+					sizeof(struct ieee_types_header) -
+					bss_entry->beacon_buf);
 			HEXDUMP("InterpretIE: Resp HTINFO_IE",
 				(u8 *) bss_entry->bcn_ht_info,
-				(*(bss_entry->bcn_ht_info)).ieee_hdr.len +
-				sizeof(struct ieee_types_header));
+				element_len + sizeof(struct ieee_types_header));
 			break;
 		case WLAN_EID_BSS_COEX_2040:
 			bss_entry->bcn_bss_co_2040 =
@@ -1775,7 +1775,7 @@ mwifiex_adjust_beacon_buffer_ptrs(struct mwifiex_private *priv,
 
 			if (adapter->scan_table[adj_idx].bcn_ht_info) {
 				adapter->scan_table[adj_idx].bcn_ht_info =
-				(struct ieee_types_htinfo *)
+				(struct ieee80211_ht_info *)
 				(adapter->scan_table[adj_idx].beacon_buf +
 				 adapter->scan_table[adj_idx].ht_info_offset);
 			}
@@ -2048,7 +2048,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 		}
 
 		if (new_beacon->bcn_ht_info) {
-			new_beacon->bcn_ht_info = (struct ieee_types_htinfo *)
+			new_beacon->bcn_ht_info = (struct ieee80211_ht_info *)
 				(new_beacon->beacon_buf +
 				 new_beacon->ht_info_offset);
 		}
@@ -2122,7 +2122,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 
 			if (new_beacon->bcn_ht_info) {
 				new_beacon->bcn_ht_info =
-					(struct ieee_types_htinfo *)
+					(struct ieee80211_ht_info *)
 					(new_beacon->beacon_buf +
 					 new_beacon->ht_info_offset);
 			}
@@ -2434,7 +2434,7 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
 
 			if (adapter->scan_table[del_idx].bcn_ht_info) {
 				adapter->scan_table[del_idx].bcn_ht_info =
-					(struct ieee_types_htinfo *)
+					(struct ieee80211_ht_info *)
 					(adapter->scan_table[del_idx].beacon_buf
 					 + adapter->scan_table[del_idx].
 					  ht_info_offset);
@@ -3399,7 +3399,7 @@ mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
 		}
 
 		if (curr_bss->bcn_ht_info) {
-			curr_bss->bcn_ht_info = (struct ieee_types_htinfo *)
+			curr_bss->bcn_ht_info = (struct ieee80211_ht_info *)
 				(curr_bss->beacon_buf +
 				 curr_bss->ht_info_offset);
 		}
-- 
1.7.0.2

