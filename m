Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46314 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab1CEFTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 00:19:32 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: remove struct ieee_types_2040bssco
Date: Fri,  4 Mar 2011 21:22:23 -0800
Message-Id: <1299302545-9672-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1299302545-9672-1-git-send-email-bzhao@marvell.com>
References: <1299302545-9672-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This struct is not necessary.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/ieee.h |    7 +------
 drivers/net/wireless/mwifiex/scan.c |   23 ++++++++++-------------
 2 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index 877a9f8..1c95780 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -162,11 +162,6 @@ struct ieee_obss_scan_param {
 	u16 obss_scan_active_threshold;
 } __packed;
 
-struct ieee_types_2040bssco {
-	struct ieee_types_header ieee_hdr;
-	u8 bss_co_2040;
-} __packed;
-
 struct ieee_types_obss_scan_param {
 	struct ieee_types_header ieee_hdr;
 	struct ieee_obss_scan_param obss_scan;
@@ -202,7 +197,7 @@ struct mwifiex_bssdescriptor {
 	u16 ht_cap_offset;
 	struct ieee80211_ht_info *bcn_ht_info;
 	u16 ht_info_offset;
-	struct ieee_types_2040bssco *bcn_bss_co_2040;
+	u8 *bcn_bss_co_2040;
 	u16 bss_co_2040_offset;
 	u8 *bcn_ext_cap;
 	u16 ext_cap_offset;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 19a9494..2e33588 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1540,11 +1540,11 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 					bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_BSS_COEX_2040:
-			bss_entry->bcn_bss_co_2040 =
-				(struct ieee_types_2040bssco *) current_ptr;
-			bss_entry->bss_co_2040_offset =
-				(u16) (current_ptr -
-					 bss_entry->beacon_buf);
+			bss_entry->bcn_bss_co_2040 = (u8 *) (current_ptr +
+					sizeof(struct ieee_types_header));
+			bss_entry->bss_co_2040_offset = (u16) (current_ptr +
+					sizeof(struct ieee_types_header) -
+						bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_EXT_CAPABILITY:
 			bss_entry->bcn_ext_cap = (u8 *) (current_ptr +
@@ -1655,7 +1655,7 @@ mwifiex_adjust_beacon_buffer_ptrs(struct mwifiex_private *priv,
 			}
 			if (adapter->scan_table[adj_idx].bcn_bss_co_2040) {
 				adapter->scan_table[adj_idx].bcn_bss_co_2040 =
-				(struct ieee_types_2040bssco *)
+				(u8 *)
 				(adapter->scan_table[adj_idx].beacon_buf +
 			       adapter->scan_table[adj_idx].bss_co_2040_offset);
 			}
@@ -1920,8 +1920,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 				 new_beacon->ht_info_offset);
 		}
 		if (new_beacon->bcn_bss_co_2040) {
-			new_beacon->bcn_bss_co_2040 =
-				(struct ieee_types_2040bssco *)
+			new_beacon->bcn_bss_co_2040 = (u8 *)
 				(new_beacon->beacon_buf +
 				 new_beacon->bss_co_2040_offset);
 		}
@@ -1995,8 +1994,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 			}
 			if (new_beacon->bcn_bss_co_2040) {
 				new_beacon->bcn_bss_co_2040 =
-					(struct ieee_types_2040bssco *)
-					(new_beacon->beacon_buf +
+					(u8 *) (new_beacon->beacon_buf +
 					 new_beacon->bss_co_2040_offset);
 			}
 			if (new_beacon->bcn_ext_cap) {
@@ -2282,7 +2280,7 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
 			}
 			if (adapter->scan_table[del_idx].bcn_bss_co_2040) {
 				adapter->scan_table[del_idx].bcn_bss_co_2040 =
-					(struct ieee_types_2040bssco *)
+					(u8 *)
 					(adapter->scan_table[del_idx].beacon_buf
 					 + adapter->scan_table[del_idx].
 					   bss_co_2040_offset);
@@ -3218,8 +3216,7 @@ mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
 
 		if (curr_bss->bcn_bss_co_2040) {
 			curr_bss->bcn_bss_co_2040 =
-				(struct ieee_types_2040bssco *)
-				(curr_bss->beacon_buf +
+				(u8 *) (curr_bss->beacon_buf +
 				 curr_bss->bss_co_2040_offset);
 		}
 
-- 
1.7.0.2

