Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41005 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbYDOXCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 19:02:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/11] iwlwifi: fix unload warning and error
Date: Tue, 15 Apr 2008 16:01:46 -0700
Message-Id: <1208300507-25628-11-git-send-email-reinette.chatre@intel.com> (sfid-20080416_000232_490522_1B2052C9)
In-Reply-To: <1208300507-25628-10-git-send-email-reinette.chatre@intel.com>
References: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-2-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-3-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-4-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-5-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-6-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-7-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-8-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-9-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

This patch fix the error we get when unload the driver, No space for Tx.
The cause of this problem is related to receiving late SW rfkill from
rfkill subsystem during the driver teardown causing this error.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-rfkill.c   |    3 +++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index 8f38c24..5980a56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -47,6 +47,9 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 	if (!priv->rfkill_mngr.rfkill)
 		return 0;
 
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return 0;
+
 	IWL_DEBUG_RF_KILL("we recieved soft RFKILL set to state %d\n", state);
 	mutex_lock(&priv->mutex);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 0eb4220..dae881e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2427,7 +2427,8 @@ void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 				    CSR_UCODE_SW_BIT_RFKILL);
 			spin_unlock_irqrestore(&priv->lock, flags);
 			/* call the host command only if no hw rf-kill set */
-			if (!test_bit(STATUS_RF_KILL_HW, &priv->status))
+			if (!test_bit(STATUS_RF_KILL_HW, &priv->status) &&
+			    iwl_is_ready(priv))
 				iwl4965_send_card_state(priv,
 							CARD_STATE_CMD_DISABLE,
 							0);
-- 
1.5.3.4

