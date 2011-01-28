Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46724 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab1A1CLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 21:11:33 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: remove struct ieee_types_htcap
Date: Thu, 27 Jan 2011 18:13:01 -0800
Message-Id: <1296180782-28951-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1296180782-28951-1-git-send-email-bzhao@marvell.com>
References: <1296180782-28951-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use "struct ieee80211_ht_cap" directly

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c  |    3 +--
 drivers/net/wireless/mwifiex/ieee.h |    7 +------
 drivers/net/wireless/mwifiex/join.c |    7 ++-----
 drivers/net/wireless/mwifiex/scan.c |   24 ++++++++++++------------
 drivers/net/wireless/mwifiex/wmm.c  |    6 ++----
 drivers/net/wireless/mwifiex/wmm.h  |    2 +-
 6 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 8a0414e..afb3395 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -966,8 +966,7 @@ mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 	ENTER();
 
 	if (bss_desc->bcn_ht_cap) {
-		if (GETHT_MAXAMSDU(le16_to_cpu(bss_desc->bcn_ht_cap->ht_cap
-				.cap_info)))
+		if (GETHT_MAXAMSDU(le16_to_cpu(bss_desc->bcn_ht_cap->cap_info)))
 			max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_8K;
 		else
 			max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_4K;
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index 04b88f6..618d457 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -170,11 +170,6 @@ struct ieee_obss_scan_param {
 	u16 obss_scan_active_threshold;
 } __packed;
 
-struct ieee_types_htcap {
-	struct ieee_types_header ieee_hdr;
-	struct ieee80211_ht_cap ht_cap;
-} __packed;
-
 struct ieee_types_2040bssco {
 	struct ieee_types_header ieee_hdr;
 	struct ieee_bssco_2040 bss_co_2040;
@@ -216,7 +211,7 @@ struct mwifiex_bssdescriptor {
 	u16 cap_info_bitmap;
 	struct ieee_types_wmm_parameter wmm_ie;
 	u8  disable_11n;
-	struct ieee_types_htcap *bcn_ht_cap;
+	struct ieee80211_ht_cap *bcn_ht_cap;
 	u16 ht_cap_offset;
 	struct ieee80211_ht_info *bcn_ht_info;
 	u16 ht_info_offset;
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 6ef516c..873e9ff 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -750,11 +750,8 @@ mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	else
 		priv->curr_bss_params.wmm_enabled = false;
 
-	if ((priv->wmm_required
-	     || (bss_desc->bcn_ht_cap &&
-		 (bss_desc->bcn_ht_cap->ieee_hdr.element_id ==
-			WLAN_EID_HT_CAPABILITY))
-	    ) && priv->curr_bss_params.wmm_enabled)
+	if ((priv->wmm_required || bss_desc->bcn_ht_cap)
+			&& priv->curr_bss_params.wmm_enabled)
 		priv->wmm_enabled = true;
 	else
 		priv->wmm_enabled = false;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 371c048..35e8762 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1627,15 +1627,15 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				sizeof(struct ieee_types_header));
 			break;
 		case WLAN_EID_HT_CAPABILITY:
-			bss_entry->bcn_ht_cap =
-				(struct ieee_types_htcap *) current_ptr;
-			bss_entry->ht_cap_offset =
-				(u16) (current_ptr -
-					 bss_entry->beacon_buf);
+			bss_entry->bcn_ht_cap = (struct ieee80211_ht_cap *)
+					(current_ptr +
+					sizeof(struct ieee_types_header));
+			bss_entry->ht_cap_offset = (u16) (current_ptr +
+					sizeof(struct ieee_types_header) -
+					bss_entry->beacon_buf);
 			HEXDUMP("InterpretIE: Resp HTCAP_IE",
 				(u8 *) bss_entry->bcn_ht_cap,
-				(*(bss_entry->bcn_ht_cap)).ieee_hdr.len +
-				sizeof(struct ieee_types_header));
+				element_len + sizeof(struct ieee_types_header));
 			break;
 		case WLAN_EID_HT_INFORMATION:
 			bss_entry->bcn_ht_info = (struct ieee80211_ht_info *)
@@ -1768,7 +1768,7 @@ mwifiex_adjust_beacon_buffer_ptrs(struct mwifiex_private *priv,
 			}
 			if (adapter->scan_table[adj_idx].bcn_ht_cap) {
 				adapter->scan_table[adj_idx].bcn_ht_cap =
-				(struct ieee_types_htcap *)
+				(struct ieee80211_ht_cap *)
 				(adapter->scan_table[adj_idx].beacon_buf +
 				 adapter->scan_table[adj_idx].ht_cap_offset);
 			}
@@ -2042,7 +2042,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 				 new_beacon->wapi_offset);
 		}
 		if (new_beacon->bcn_ht_cap) {
-			new_beacon->bcn_ht_cap = (struct ieee_types_htcap *)
+			new_beacon->bcn_ht_cap = (struct ieee80211_ht_cap *)
 				(new_beacon->beacon_buf +
 				 new_beacon->ht_cap_offset);
 		}
@@ -2115,7 +2115,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 			}
 			if (new_beacon->bcn_ht_cap) {
 				new_beacon->bcn_ht_cap =
-					(struct ieee_types_htcap *)
+					(struct ieee80211_ht_cap *)
 					(new_beacon->beacon_buf +
 					 new_beacon->ht_cap_offset);
 			}
@@ -2426,7 +2426,7 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
 			}
 			if (adapter->scan_table[del_idx].bcn_ht_cap) {
 				adapter->scan_table[del_idx].bcn_ht_cap =
-					(struct ieee_types_htcap *)
+					(struct ieee80211_ht_cap *)
 					(adapter->scan_table[del_idx].beacon_buf
 					 + adapter->scan_table[del_idx].
 					  ht_cap_offset);
@@ -3393,7 +3393,7 @@ mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
 		}
 
 		if (curr_bss->bcn_ht_cap) {
-			curr_bss->bcn_ht_cap = (struct ieee_types_htcap *)
+			curr_bss->bcn_ht_cap = (struct ieee80211_ht_cap *)
 				(curr_bss->beacon_buf +
 				 curr_bss->ht_cap_offset);
 		}
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index a0c29b4..95126ad 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -877,7 +877,7 @@ u32
 mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 				    u8 **assoc_buf,
 				    struct ieee_types_wmm_parameter *wmm_ie,
-				    struct ieee_types_htcap *ht_cap)
+				    struct ieee80211_ht_cap *ht_cap)
 {
 	struct mwifiex_ie_types_wmm_param_set *wmm_tlv;
 	u32 ret_len = 0;
@@ -903,9 +903,7 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 	       wmm_ie->vend_hdr.element_id);
 
 	if ((priv->wmm_required
-	     || (ht_cap && (ht_cap->ieee_hdr.element_id ==
-		WLAN_EID_HT_CAPABILITY)
-		 && (priv->adapter->config_bands & BAND_GN
+	     || (ht_cap && (priv->adapter->config_bands & BAND_GN
 		     || priv->adapter->config_bands & BAND_AN))
 	    )
 	    && wmm_ie->vend_hdr.element_id == WLAN_EID_VENDOR_SPECIFIC) {
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 1dce042..4d76b85 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -108,7 +108,7 @@ extern u32 mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 						 u8 **assoc_buf,
 						 struct ieee_types_wmm_parameter
 						 *wmmie,
-						 struct ieee_types_htcap
+						 struct ieee80211_ht_cap
 						 *htcap);
 
 void mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
-- 
1.7.0.2

