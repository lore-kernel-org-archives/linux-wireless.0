Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63862 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaBWT5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:30 -0500
Received: by mail-wi0-f170.google.com with SMTP id hi5so2351583wib.5
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:29 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/17] iwlwifi: pcie: stop the firmware when we restart it
Date: Sun, 23 Feb 2014 21:57:02 +0200
Message-Id: <1393185428-8524-11-git-send-email-egrumbach@gmail.com> (sfid-20140223_211709_127522_3ABA9B54)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In case the firmware didn't assert but we want to restart
it, e.g. we didn't get the reply for a host command, or the
Tx queues are stuck, we should stop the firmware by
provoking an interrupt. This allows to better debug the
firmware in these bad scenarios.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index e476d9e..3b0c72c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -207,7 +207,7 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 		IWL_ERR(trans, "scratch %d = 0x%08x\n", i,
 			le32_to_cpu(txq->scratchbufs[i].scratch));
 
-	iwl_trans_fw_error(trans);
+	iwl_write_prph(trans, DEVICE_SET_NMI_REG, 1);
 }
 
 /*
@@ -1024,7 +1024,7 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 		if (nfreed++ > 0) {
 			IWL_ERR(trans, "HCMD skipped: index (%d) %d %d\n",
 				idx, q->write_ptr, q->read_ptr);
-			iwl_trans_fw_error(trans);
+			iwl_write_prph(trans, DEVICE_SET_NMI_REG, 1);
 		}
 	}
 
@@ -1583,6 +1583,7 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 			       get_cmd_string(trans_pcie, cmd->id));
 		ret = -ETIMEDOUT;
 
+		iwl_write_prph(trans, DEVICE_SET_NMI_REG, 1);
 		iwl_trans_fw_error(trans);
 
 		goto cancel;
-- 
1.7.9.5

