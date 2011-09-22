Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57207 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab1IVXBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:17 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/12] iwlagn: set the sequence control from the transport layer
Date: Thu, 22 Sep 2011 15:14:50 -0700
Message-Id: <1316729700-1770-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_010144_739025_68E742D7)
In-Reply-To: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since all the queue logic has been moved to the transport layer,
the sequence number is set in the transport layer.
While doing that I forgot that the mac header is copied to the
TB of the TX cmd in the upper layer before the call to the transport
layer. So basically we used the sequence number from mac80211...
This was fine for the first assocation but after the second, mac80211
resets its counters while we don't hence a shift that led to terrible
impact on performance.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |    3 ---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 8c0f07f..12a9808 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -327,9 +327,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	memset(dev_cmd, 0, sizeof(*dev_cmd));
 	tx_cmd = (struct iwl_tx_cmd *) dev_cmd->payload;
 
-	/* Copy MAC header from skb into command buffer */
-	memcpy(tx_cmd->hdr, hdr, hdr_len);
-
 	/* Total # bytes to be transmitted */
 	len = (u16)skb->len;
 	tx_cmd->len = cpu_to_le16(len);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index b78ac65..781f6aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1101,6 +1101,9 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		}
 	}
 
+	/* Copy MAC header from skb into command buffer */
+	memcpy(tx_cmd->hdr, hdr, hdr_len);
+
 	txq = &trans_pcie->txq[txq_id];
 	q = &txq->q;
 
-- 
1.7.0.4

