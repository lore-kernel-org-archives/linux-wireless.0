Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645Ab0DPNt2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 09:49:28 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	<wey-yi.w.guy@intel.com>, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlwifi: initialize iwl_wimax_coex_cmd.flags
Date: Fri, 16 Apr 2010 15:47:56 +0200
Message-Id: <1271425676-32552-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl_wimax_coex_cmd.flags can be really uninitialized, so fix
that.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f09bff8..2e489cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2382,11 +2382,11 @@ EXPORT_SYMBOL(iwl_free_txq_mem);
 
 int iwl_send_wimax_coex(struct iwl_priv *priv)
 {
-	struct iwl_wimax_coex_cmd uninitialized_var(coex_cmd);
+	struct iwl_wimax_coex_cmd coex_cmd;
 
 	if (priv->cfg->support_wimax_coexist) {
 		/* UnMask wake up src at associated sleep */
-		coex_cmd.flags |= COEX_FLAGS_ASSOC_WA_UNMASK_MSK;
+		coex_cmd.flags = COEX_FLAGS_ASSOC_WA_UNMASK_MSK;
 
 		/* UnMask wake up src at unassociated sleep */
 		coex_cmd.flags |= COEX_FLAGS_UNASSOC_WA_UNMASK_MSK;
-- 
1.6.2.5

