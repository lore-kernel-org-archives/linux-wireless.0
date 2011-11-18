Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58303 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab1KRBA3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 20:00:29 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/5] iwlwifi: fix endianity issues in debug prints
Date: Thu, 17 Nov 2011 16:05:11 -0800
Message-Id: <1321574713-12076-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111118_020037_038328_2ADCB098)
In-Reply-To: <1321574713-12076-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1321574713-12076-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Use the CPUed version of the variables when printing data from the
BA notification.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 4ce64d7..a1a95d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -921,11 +921,9 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 			   ba_resp->sta_id);
 	IWL_DEBUG_TX_REPLY(priv, "TID = %d, SeqCtl = %d, bitmap = 0x%llx, "
 			   "scd_flow = %d, scd_ssn = %d\n",
-			   ba_resp->tid,
-			   ba_resp->seq_ctl,
+			   ba_resp->tid, ba_resp->seq_ctl,
 			   (unsigned long long)le64_to_cpu(ba_resp->bitmap),
-			   ba_resp->scd_flow,
-			   ba_resp->scd_ssn);
+			   scd_flow, ba_resp_scd_ssn);
 
 	/* Mark that the expected block-ack response arrived */
 	agg->wait_for_ba = false;
-- 
1.7.0.4

