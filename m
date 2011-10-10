Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31149 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab1JJPQa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/34] iwlagn: more info on warning for shutdown agg queue
Date: Mon, 10 Oct 2011 07:27:08 -0700
Message-Id: <1318256839-31837-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171714_234986_1F87A470)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When detect wrong state on shutdown aggregation queue, show more
information for debugging

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index fec7065..2e48979 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -634,8 +634,9 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
 	case IWL_AGG_ON:
 		break;
 	default:
-		IWL_WARN(trans, "Stopping AGG while state not ON"
-				"or starting\n");
+		IWL_WARN(trans, "Stopping AGG while state not ON "
+			 "or starting for %d on %d (%d)\n", sta_id, tid,
+			 trans->shrd->tid_data[sta_id][tid].agg.state);
 		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
 		return 0;
 	}
-- 
1.7.0.4

