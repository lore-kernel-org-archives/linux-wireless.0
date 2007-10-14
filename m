Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24399 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbXJNUWT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 16:22:19 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ian Schram <ischram@telenet.be>
Subject: [PATCH 3/5] iwlwifi: Beautify by removing superfluous newlines and code
Date: Sun, 14 Oct 2007 22:20:32 +0200
Message-Id: <11923932401165-git-send-email-tomas.winkler@intel.com> (sfid-20071014_212226_837460_82587C5F)
In-Reply-To: <11923932403473-git-send-email-tomas.winkler@intel.com>
References: <11923932343888-git-send-email-tomas.winkler@intel.com>
 <11923932403473-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Schram <ischram@telenet.be>

Moving code around, lindent, and whatnot created several places where
there appeared to be an 75 column "rule" instead of 80. This patch removes
those that I can spot, hopefully increasing readability.

Signed-off-by: Ian Schram <ischram@telenet.be>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   44 +++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   19 ++++--------
 2 files changed, 21 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7cbfa93..724a569 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1352,7 +1352,6 @@ static int iwl_update_sta_key_info(struct iwl_priv *priv,
 		break;
 	case ALG_TKIP:
 	case ALG_WEP:
-		return -EINVAL;
 	default:
 		return -EINVAL;
 	}
@@ -2637,11 +2636,9 @@ static void iwl_build_tx_cmd_basic(struct iwl_priv *priv,
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
 
@@ -3140,24 +3137,21 @@ int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
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
@@ -3304,9 +3298,8 @@ static int iwl_get_measurement(struct iwl_priv *priv,
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
@@ -5504,8 +5497,7 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 * image, u32 len)
 	iwl_release_restricted_access(priv);
 
 	if (!errcnt)
-		IWL_DEBUG_INFO
-		    ("ucode image in INSTRUCTION memory is good\n");
+		IWL_DEBUG_INFO("ucode image in INSTRUCTION memory is good\n");
 
 	return rc;
 }
@@ -5804,16 +5796,11 @@ static int iwl_read_ucode(struct iwl_priv *priv)
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
@@ -6788,7 +6775,7 @@ static void iwl_bg_post_associate(struct work_struct *data)
 
 	default:
 		 IWL_ERROR("%s Should not be called in %d mode\n",
-				__FUNCTION__, priv->iw_mode);
+			   __FUNCTION__, priv->iw_mode);
 		break;
 	}
 
@@ -6802,8 +6789,7 @@ static void iwl_bg_post_associate(struct work_struct *data)
 
 static void iwl_bg_abort_scan(struct work_struct *work)
 {
-	struct iwl_priv *priv = container_of(work, struct iwl_priv,
-					     abort_scan);
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
 	if (!iwl_is_ready(priv))
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7cf7d09..cb3a368 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1384,7 +1384,6 @@ static int iwl_update_sta_key_info(struct iwl_priv *priv,
 		break;
 	case ALG_TKIP:
 	case ALG_WEP:
-		return -EINVAL;
 	default:
 		return -EINVAL;
 	}
@@ -2719,11 +2718,9 @@ static void iwl_build_tx_cmd_basic(struct iwl_priv *priv,
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
 
@@ -3227,24 +3224,21 @@ int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
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
@@ -7190,8 +7184,7 @@ static void iwl_bg_post_associate(struct work_struct *data)
 
 static void iwl_bg_abort_scan(struct work_struct *work)
 {
-	struct iwl_priv *priv = container_of(work, struct iwl_priv,
-					     abort_scan);
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
 	if (!iwl_is_ready(priv))
 		return;
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
