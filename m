Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab1LPQhj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:39 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/24] iwlwifi: fix endianity issue in debug prints
Date: Fri, 16 Dec 2011 07:37:08 -0800
Message-Id: <1324049849-831-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173746_062446_117B9B36)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

ba_resp->seq_ctl is __le16, need to translate to cpu endianity.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index b484578..1cac701 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -925,7 +925,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 			   ba_resp->sta_id);
 	IWL_DEBUG_TX_REPLY(priv, "TID = %d, SeqCtl = %d, bitmap = 0x%llx, "
 			   "scd_flow = %d, scd_ssn = %d\n",
-			   ba_resp->tid, ba_resp->seq_ctl,
+			   ba_resp->tid, le16_to_cpu(ba_resp->seq_ctl),
 			   (unsigned long long)le64_to_cpu(ba_resp->bitmap),
 			   scd_flow, ba_resp_scd_ssn);
 
-- 
1.7.0.4

