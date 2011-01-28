Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46720 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab1A1CLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 21:11:33 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: remove struct ieee_extcap and ieee_types_extcap
Date: Thu, 27 Jan 2011 18:13:02 -0800
Message-Id: <1296180782-28951-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1296180782-28951-1-git-send-email-bzhao@marvell.com>
References: <1296180782-28951-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These structures are redundant.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c  |    2 +-
 drivers/net/wireless/mwifiex/fw.h   |    2 +-
 drivers/net/wireless/mwifiex/ieee.h |   11 +----------
 drivers/net/wireless/mwifiex/scan.c |   25 +++++++++++--------------
 4 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index afb3395..eab270c 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -928,7 +928,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		ext_cap = (struct mwifiex_ie_types_extcap *) *buffer;
 		memset(ext_cap, 0, sizeof(struct mwifiex_ie_types_extcap));
 		ext_cap->header.type = cpu_to_le16(WLAN_EID_EXT_CAPABILITY);
-		ext_cap->header.len = cpu_to_le16(sizeof(struct ieee_extcap));
+		ext_cap->header.len = cpu_to_le16(sizeof(ext_cap->ext_cap));
 
 		memcpy((u8 *) ext_cap +
 		       sizeof(struct mwifiex_ie_types_header),
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 32652a2..551dbbe 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1182,7 +1182,7 @@ struct mwifiex_ie_types_2040bssco {
 
 struct mwifiex_ie_types_extcap {
 	struct mwifiex_ie_types_header header;
-	struct ieee_extcap ext_cap;
+	u8 ext_cap;
 } __packed;
 
 struct mwifiex_ie_types_pmk {
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index 618d457..755b518 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -156,10 +156,6 @@ struct ieee_bssco_2040 {
 	u8 bss_co_2040_value;
 } __packed;
 
-struct ieee_extcap {
-	u8 ext_cap_value;
-} __packed;
-
 struct ieee_obss_scan_param {
 	u16 obss_scan_passive_dwell;
 	u16 obss_scan_active_dwell;
@@ -175,11 +171,6 @@ struct ieee_types_2040bssco {
 	struct ieee_bssco_2040 bss_co_2040;
 } __packed;
 
-struct ieee_types_extcap {
-	struct ieee_types_header ieee_hdr;
-	struct ieee_extcap ext_cap;
-} __packed;
-
 struct ieee_types_obss_scan_param {
 	struct ieee_types_header ieee_hdr;
 	struct ieee_obss_scan_param obss_scan;
@@ -217,7 +208,7 @@ struct mwifiex_bssdescriptor {
 	u16 ht_info_offset;
 	struct ieee_types_2040bssco *bcn_bss_co_2040;
 	u16 bss_co_2040_offset;
-	struct ieee_types_extcap *bcn_ext_cap;
+	u8 *bcn_ext_cap;
 	u16 ext_cap_offset;
 	struct ieee_types_obss_scan_param *bcn_obss_scan;
 	u16 overlap_bss_offset;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 35e8762..bd623cf 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1660,15 +1660,14 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				sizeof(struct ieee_types_header));
 			break;
 		case WLAN_EID_EXT_CAPABILITY:
-			bss_entry->bcn_ext_cap =
-				(struct ieee_types_extcap *) current_ptr;
-			bss_entry->ext_cap_offset =
-				(u16) (current_ptr -
-					 bss_entry->beacon_buf);
+			bss_entry->bcn_ext_cap = (u8 *) (current_ptr +
+					sizeof(struct ieee_types_header));
+			bss_entry->ext_cap_offset = (u16) (current_ptr +
+					sizeof(struct ieee_types_header) -
+					bss_entry->beacon_buf);
 			HEXDUMP("InterpretIE: Resp EXTCAP_IE",
 				(u8 *) bss_entry->bcn_ext_cap,
-				(*(bss_entry->bcn_ext_cap)).ieee_hdr.len +
-				sizeof(struct ieee_types_header));
+				element_len + sizeof(struct ieee_types_header));
 			break;
 		case WLAN_EID_OVERLAP_BSS_SCAN_PARAM:
 			bss_entry->bcn_obss_scan =
@@ -1787,7 +1786,7 @@ mwifiex_adjust_beacon_buffer_ptrs(struct mwifiex_private *priv,
 			}
 			if (adapter->scan_table[adj_idx].bcn_ext_cap) {
 				adapter->scan_table[adj_idx].bcn_ext_cap =
-				(struct ieee_types_extcap *)
+				(u8 *)
 				(adapter->scan_table[adj_idx].beacon_buf +
 				 adapter->scan_table[adj_idx].ext_cap_offset);
 			}
@@ -2059,7 +2058,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 				 new_beacon->bss_co_2040_offset);
 		}
 		if (new_beacon->bcn_ext_cap) {
-			new_beacon->bcn_ext_cap = (struct ieee_types_extcap *)
+			new_beacon->bcn_ext_cap = (u8 *)
 				(new_beacon->beacon_buf +
 				 new_beacon->ext_cap_offset);
 		}
@@ -2134,8 +2133,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 			}
 			if (new_beacon->bcn_ext_cap) {
 				new_beacon->bcn_ext_cap =
-					(struct ieee_types_extcap *)
-					(new_beacon->beacon_buf +
+					(u8 *) (new_beacon->beacon_buf +
 					 new_beacon->ext_cap_offset);
 			}
 			if (new_beacon->bcn_obss_scan) {
@@ -2448,7 +2446,7 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
 			}
 			if (adapter->scan_table[del_idx].bcn_ext_cap) {
 				adapter->scan_table[del_idx].bcn_ext_cap =
-					(struct ieee_types_extcap *)
+					(u8 *)
 					(adapter->scan_table[del_idx].beacon_buf
 					 + adapter->scan_table[del_idx].
 					     ext_cap_offset);
@@ -3412,8 +3410,7 @@ mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
 		}
 
 		if (curr_bss->bcn_ext_cap) {
-			curr_bss->bcn_ext_cap = (struct ieee_types_extcap *)
-				(curr_bss->beacon_buf +
+			curr_bss->bcn_ext_cap = (u8 *) (curr_bss->beacon_buf +
 				 curr_bss->ext_cap_offset);
 		}
 
-- 
1.7.0.2

