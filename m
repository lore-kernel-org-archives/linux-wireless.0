Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50954 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab1J3HHk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Oct 2011 03:07:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.2] iwlwifi: don't perform "echo test" when cmd queue stuck
Date: Sat, 29 Oct 2011 23:15:15 -0700
Message-Id: <1319955315-29983-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111030_080753_689463_04426BCA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Perform "echo test" when cmd queue stuck detected, somethime it will cause
calltrace. I am not sure how to fix it yet, just remove the action now until
find a better way to handle it.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a779024..8efa10f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1450,16 +1450,6 @@ static inline int iwl_check_stuck_queue(struct iwl_priv *priv, int txq)
 {
 	if (iwl_trans_check_stuck_queue(trans(priv), txq)) {
 		int ret;
-		if (txq == priv->shrd->cmd_queue) {
-			/*
-			 * validate command queue still working
-			 * by sending "ECHO" command
-			 */
-			if (!iwl_cmd_echo_test(priv))
-				return 0;
-			else
-				IWL_DEBUG_HC(priv, "echo testing fail\n");
-		}
 		ret = iwl_force_reset(priv, IWL_FW_RESET, false);
 		return (ret == -EAGAIN) ? 0 : 1;
 	}
-- 
1.7.0.4

