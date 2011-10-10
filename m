Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31149 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab1JJPQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/34] iwlagn: do nothing when disable agg in wrong state
Date: Mon, 10 Oct 2011 07:27:05 -0700
Message-Id: <1318256839-31837-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171653_200100_441EC7BB)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When disable aggregation request come in on wrong agg state. ignore it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index fa2ce39..fec7065 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -636,6 +636,8 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
 	default:
 		IWL_WARN(trans, "Stopping AGG while state not ON"
 				"or starting\n");
+		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
+		return 0;
 	}
 
 	write_ptr = trans_pcie->txq[txq_id].q.write_ptr;
-- 
1.7.0.4

