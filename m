Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbXJYJWi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:38 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ian Schram <ischram@telenet.be>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 08/30] iwlwifi: Beautify by removing superfluous newlines and code
Date: Thu, 25 Oct 2007 17:15:29 +0800
Message-Id: <1193303762680-git-send-email-yi.zhu@intel.com> (sfid-20071025_102256_009998_DAD739AB)
In-Reply-To: <11933037613709-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Schram <ischram@telenet.be>

Moving code around, lindent, and whatnot created several places where
there appeared to be an 75 column "rule" instead of 80. This patch removes
those that I can spot, hopefully increasing readability.

Signed-off-by: Ian Schram <ischram@telenet.be>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   44 +++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   19 ++++--------
 2 files changed, 21 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a435977..cd2ed1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1350,7 +1350,6 @@ static int iwl_update_sta_key_info(struct iwl_priv *priv,
 		break;
 	case ALG_TKIP:
 	case ALG_WEP:
-		return -EINVAL;
 	default:
 		return -EINVAL;
 	}
@@ -2645,11 +2644,9 @@ static void iwl_build_tx_cmd_basic(struct iwl_priv *priv,
 	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
 		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ ||
 		    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_REQ)
-			cmd->cmd.tx.timeout.pm_frame_timeout =
-				cpu_to_le16(3);
+			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(3);
 		else
-			cmd->cmd.tx.timeout.pm_frame_timeout =
-				cpu_to_le16(2);
+			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(2);
 	} else
 		cmd->cmd.tx.timeout.pm_frame_timeout = 0;
 
@@ -3148,24 +3145,21 @@ int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
 		int index = mac[5] & (IWL_IBSS_MAC_HASH_SIZE - 1);
 
 		__list_for_each(p, &priv->ibss_mac_hash[index]) {
-			entry =
-				list_entry(p, struct iwl_ibss_seq, list);
+			entry = list_entry(p, struct iwl_ibss_seq, list);
 			if (!compare_ether_addr(entry->mac, mac))
 				break;
 		}
 		if (p == &priv->ibss_mac_hash[index]) {
 			entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 			if (!entry) {
-				IWL_ERROR
-					("Cannot malloc new mac entry\n");
+				IWL_ERROR("Cannot malloc new mac entry\n");
 				return 0;
 			}
 			memcpy(entry->mac, mac, ETH_ALEN);
 			entry->seq_num = seq;
 			entry->frag_num = frag;
 			entry->packet_time = jiffies;
-			list_add(&entry->list,
-				 &priv->ibss_mac_hash[index]);
+			list_add(&entry->list, &priv->ibss_mac_hash[index]);
 			return 0;
 		}
 		last_seq = &entry->seq_num;
@@ -3312,9 +3306,8 @@ static int iwl_get_measurement(struct iwl_priv *priv,
 	switch (spectrum_resp_status) {
 	case 0:		/* Command will be handled */
 		if (res->u.spectrum.id != 0xff) {
-			IWL_DEBUG_INFO
-			    ("Replaced existing measurement: %d\n",
-			     res->u.spectrum.id);
+			IWL_DEBUG_INFO("Replaced existing measurement: %d\n",
+						res->u.spectrum.id);
 			priv->measurement_status &= ~MEASUREMENT_READY;
 		}
 		priv->measurement_status |= MEASUREMENT_ACTIVE;
@@ -5512,8 +5505,7 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 * image, u32 len)
 	iwl_release_restricted_access(priv);
 
 	if (!errcnt)
-		IWL_DEBUG_INFO
-		    ("ucode image in INSTRUCTION memory is good\n");
+		IWL_DEBUG_INFO("ucode image in INSTRUCTION memory is good\n");
 
 	return rc;
 }
@@ -5812,16 +5804,11 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	boot_size = le32_to_cpu(ucode->boot_size);
 
 	IWL_DEBUG_INFO("f/w package hdr ucode version = 0x%x\n", ver);
-	IWL_DEBUG_INFO("f/w package hdr runtime inst size = %u\n",
-		       inst_size);
-	IWL_DEBUG_INFO("f/w package hdr runtime data size = %u\n",
-		       data_size);
-	IWL_DEBUG_INFO("f/w package hdr init inst size = %u\n",
-		       init_size);
-	IWL_DEBUG_INFO("f/w package hdr init data size = %u\n",
-		       init_data_size);
-	IWL_DEBUG_INFO("f/w package hdr boot inst size = %u\n",
-		       boot_size);
+	IWL_DEBUG_INFO("f/w package hdr runtime inst size = %u\n", inst_size);
+	IWL_DEBUG_INFO("f/w package hdr runtime data size = %u\n", data_size);
+	IWL_DEBUG_INFO("f/w package hdr init inst size = %u\n", init_size);
+	IWL_DEBUG_INFO("f/w package hdr init data size = %u\n", init_data_size);
+	IWL_DEBUG_INFO("f/w package hdr boot inst size = %u\n", boot_size);
 
 	/* Verify size of file vs. image size info in file's header */
 	if (ucode_raw->size < sizeof(*ucode) +
@@ -6796,7 +6783,7 @@ static void iwl_bg_post_associate(struct work_struct *data)
 
 	default:
 		 IWL_ERROR("%s Should not be called in %d mode\n",
-				__FUNCTION__, priv->iw_mode);
+			   __FUNCTION__, priv->iw_mode);
 		break;
 	}
 
@@ -6810,8 +6797,7 @@ static void iwl_bg_post_associate(struct work_struct *data)
 
 static void iwl_bg_abort_scan(struct work_struct *work)
 {
-	struct iwl_priv *priv = container_of(work, struct iwl_priv,
-					     abort_scan);
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
 	if (!iwl_is_ready(priv))
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 2a86f0e..976171c 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1382,7 +1382,6 @@ static int iwl_update_sta_key_info(struct iwl_priv *priv,
 		break;
 	case ALG_TKIP:
 	case ALG_WEP:
-		return -EINVAL;
 	default:
 		return -EINVAL;
 	}
@@ -2732,11 +2731,9 @@ static void iwl_build_tx_cmd_basic(struct iwl_priv *priv,
 	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
 		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ ||
 		    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_REQ)
-			cmd->cmd.tx.timeout.pm_frame_timeout =
-				cpu_to_le16(3);
+			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(3);
 		else
-			cmd->cmd.tx.timeout.pm_frame_timeout =
-				cpu_to_le16(2);
+			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(2);
 	} else
 		cmd->cmd.tx.timeout.pm_frame_timeout = 0;
 
@@ -3240,24 +3237,21 @@ int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
 		int index = mac[5] & (IWL_IBSS_MAC_HASH_SIZE - 1);
 
 		__list_for_each(p, &priv->ibss_mac_hash[index]) {
-			entry =
-				list_entry(p, struct iwl_ibss_seq, list);
+			entry = list_entry(p, struct iwl_ibss_seq, list);
 			if (!compare_ether_addr(entry->mac, mac))
 				break;
 		}
 		if (p == &priv->ibss_mac_hash[index]) {
 			entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 			if (!entry) {
-				IWL_ERROR
-					("Cannot malloc new mac entry\n");
+				IWL_ERROR("Cannot malloc new mac entry\n");
 				return 0;
 			}
 			memcpy(entry->mac, mac, ETH_ALEN);
 			entry->seq_num = seq;
 			entry->frag_num = frag;
 			entry->packet_time = jiffies;
-			list_add(&entry->list,
-				 &priv->ibss_mac_hash[index]);
+			list_add(&entry->list, &priv->ibss_mac_hash[index]);
 			return 0;
 		}
 		last_seq = &entry->seq_num;
@@ -7203,8 +7197,7 @@ static void iwl_bg_post_associate(struct work_struct *data)
 
 static void iwl_bg_abort_scan(struct work_struct *work)
 {
-	struct iwl_priv *priv = container_of(work, struct iwl_priv,
-					     abort_scan);
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
 	if (!iwl_is_ready(priv))
 		return;
-- 
1.5.2
