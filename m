Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:40838 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3LQUpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:12 -0500
Received: by mail-ee0-f47.google.com with SMTP id e51so2637943eek.20
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:10 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/36] iwlwifi: trans: prevent tx and cmds during FW error
Date: Tue, 17 Dec 2013 22:44:21 +0200
Message-Id: <1387313079-28123-18-git-send-email-egrumbach@gmail.com> (sfid-20131217_214520_774857_FC880103)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Stop Tx and commands from arriving to the transport layer when a FW
error has occurred. A HW recovery should take place before. Remove
transport specific checks of the same nature (note that not all
transports were protected).

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h |    6 ++++++
 drivers/net/wireless/iwlwifi/pcie/tx.c   |    3 ---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 6419603..c71519d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -620,6 +620,9 @@ static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 {
 	int ret;
 
+	if (unlikely(test_bit(STATUS_FW_ERROR, &trans->status)))
+		return -EIO;
+
 	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE)) {
 		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
 		return -EIO;
@@ -659,6 +662,9 @@ static inline void iwl_trans_free_tx_cmd(struct iwl_trans *trans,
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			       struct iwl_device_cmd *dev_cmd, int queue)
 {
+	if (unlikely(test_bit(STATUS_FW_ERROR, &trans->status)))
+		return -EIO;
+
 	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
 		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index a36884e..5b63948 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1606,9 +1606,6 @@ cancel:
 
 int iwl_trans_pcie_send_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
-	if (test_bit(STATUS_FW_ERROR, &trans->status))
-		return -EIO;
-
 	if (!(cmd->flags & CMD_SEND_IN_RFKILL) &&
 	    test_bit(STATUS_RFKILL, &trans->status)) {
 		IWL_DEBUG_RF_KILL(trans, "Dropping CMD 0x%x: RF KILL\n",
-- 
1.7.9.5

