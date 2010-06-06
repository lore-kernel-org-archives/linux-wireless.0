Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17575 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab0FFG4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/23] iwlwifi: kzalloc txb array
Date: Sat,  5 Jun 2010 23:56:31 -0700
Message-Id: <1275807398-18184-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we allocate queues, we currently don't
use kzalloc() right now. When we then free
those queues again without having used all
entries, we may end up trying to free random
pointers found in the txb array since it was
never initialised. This fixes it simply by
using kzalloc().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 769136f..a81989c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -272,7 +272,7 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 	/* Driver private data, only for Tx (not command) queues,
 	 * not shared with device. */
 	if (id != IWL_CMD_QUEUE_NUM) {
-		txq->txb = kmalloc(sizeof(txq->txb[0]) *
+		txq->txb = kzalloc(sizeof(txq->txb[0]) *
 				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
 		if (!txq->txb) {
 			IWL_ERR(priv, "kmalloc for auxiliary BD "
-- 
1.7.0.4

