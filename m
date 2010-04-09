Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17566 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813Ab0DIUJl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/12] iwlwifi: clean up last_phy_res
Date: Fri,  9 Apr 2010 13:09:23 -0700
Message-Id: <1270843769-30017-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
References: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The last_phy_res[100] variable is used in an odd
way. The first byte of it is used as a flag, and
the rest as the data. Thus, the array need only
be 61 bytes, since it is just the flag and a
struct iwl_rx_phy_res (which is 60 bytes).

Clean this up by splitting the variable into two:
last_phy_res and last_phy_res_valid, using correct
types for both (struct and bool). While doing all
this also move the variables to the _agn part of
the hw-specific union since they only apply to
A-MPDUs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    4 +++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 49e20f1..7f27a94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1001,11 +1001,11 @@ void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 				phy_res->cfg_phy_cnt + len);
 		ampdu_status = le32_to_cpu(rx_pkt_status);
 	} else {
-		if (!priv->last_phy_res[0]) {
+		if (!priv->_agn.last_phy_res_valid) {
 			IWL_ERR(priv, "MPDU frame without cached PHY data\n");
 			return;
 		}
-		phy_res = (struct iwl_rx_phy_res *)&priv->last_phy_res[1];
+		phy_res = &priv->_agn.last_phy_res;
 		amsdu = (struct iwl4965_rx_mpdu_res_start *)pkt->u.raw;
 		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*amsdu));
 		len = le16_to_cpu(amsdu->byte_count);
@@ -1094,10 +1094,10 @@ void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 /* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
  * This will be used later in iwl_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
 void iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
+			    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	priv->last_phy_res[0] = 1;
-	memcpy(&priv->last_phy_res[1], &(pkt->u.raw[0]),
+	priv->_agn.last_phy_res_valid = true;
+	memcpy(&priv->_agn.last_phy_res, pkt->u.raw,
 	       sizeof(struct iwl_rx_phy_res));
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 95c2bc3..9466e90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1120,7 +1120,6 @@ struct iwl_priv {
 	__le16 sensitivity_tbl[HD_TABLE_SIZE];
 
 	struct iwl_ht_config current_ht_config;
-	u8 last_phy_res[100];
 
 	/* Rate scaling data */
 	u8 retry_rate;
@@ -1237,6 +1236,9 @@ struct iwl_priv {
 			 * no AGGREGATION
 			 */
 			u8 agg_tids_count;
+
+			struct iwl_rx_phy_res last_phy_res;
+			bool last_phy_res_valid;
 		} _agn;
 #endif
 	};
-- 
1.6.3.3

