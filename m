Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50123 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1JJPQc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 33/34] iwlagn: remove uneeded include to iwl-dev.h
Date: Mon, 10 Oct 2011 07:27:18 -0700
Message-Id: <1318256839-31837-34-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171642_085236_3B47E34E)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl-core.c and iwl-trans-pcie-tx.c don't need to include iwl-dev.h

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c          |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    5 +----
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index abd0de4..b247a56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -34,7 +34,6 @@
 #include <net/mac80211.h>
 
 #include "iwl-eeprom.h"
-#include "iwl-dev.h" /* FIXME: remove */
 #include "iwl-debug.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 0d7803b..4a0c953 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -30,8 +30,6 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 
-/* TODO: remove include to iwl-dev.h */
-#include "iwl-dev.h"
 #include "iwl-debug.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
@@ -1020,9 +1018,8 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
 		if (test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status)) {
-			struct iwl_priv *priv = priv(trans);
 			struct iwl_tx_queue *txq =
-				&trans_pcie->txq[priv->shrd->cmd_queue];
+				&trans_pcie->txq[trans->shrd->cmd_queue];
 			struct iwl_queue *q = &txq->q;
 
 			IWL_ERR(trans,
-- 
1.7.0.4

