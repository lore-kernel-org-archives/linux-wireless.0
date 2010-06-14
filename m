Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13219 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab0FNSY4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 14:24:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/6] iwlwifi: rename iwl4965_rx_mpdu_res_start
Date: Mon, 14 Jun 2010 11:24:51 -0700
Message-Id: <1276539892-12471-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
References: <1276539892-12471-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl4965_rx_mpdu_res_start is not 4695 specific, so rename it to more
general name iwl_rx_mpdu_res_start.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 90bd98c..0e7b066 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -904,7 +904,7 @@ void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_rx_phy_res *phy_res;
 	__le32 rx_pkt_status;
-	struct iwl4965_rx_mpdu_res_start *amsdu;
+	struct iwl_rx_mpdu_res_start *amsdu;
 	u32 len;
 	u32 ampdu_status;
 	u32 rate_n_flags;
@@ -933,7 +933,7 @@ void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 			return;
 		}
 		phy_res = &priv->_agn.last_phy_res;
-		amsdu = (struct iwl4965_rx_mpdu_res_start *)pkt->u.raw;
+		amsdu = (struct iwl_rx_mpdu_res_start *)pkt->u.raw;
 		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*amsdu));
 		len = le16_to_cpu(amsdu->byte_count);
 		rx_pkt_status = *(__le32 *)(pkt->u.raw + sizeof(*amsdu) + len);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index d5938e4..4984925 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1366,7 +1366,7 @@ struct iwl_rx_phy_res {
 	__le16 reserved3;
 } __attribute__ ((packed));
 
-struct iwl4965_rx_mpdu_res_start {
+struct iwl_rx_mpdu_res_start {
 	__le16 byte_count;
 	__le16 reserved;
 } __attribute__ ((packed));
-- 
1.7.0.4

