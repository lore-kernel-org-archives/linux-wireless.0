Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab3IMIr1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 04:47:27 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: do not dump stack whet triggering firmware restart
Date: Fri, 13 Sep 2013 10:45:30 +0200
Message-Id: <1379061930-2007-1-git-send-email-sgruszka@redhat.com> (sfid-20130913_104731_749582_6F802F06)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We send REPLY_ERROR command to the device to force microcode error
and restart firmware. This is not a problem, so do not dump stack
on such situation.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index f45eb29..ec49033 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1546,7 +1546,8 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 	if (test_bit(STATUS_FW_ERROR, &trans_pcie->status)) {
 		IWL_ERR(trans, "FW error in SYNC CMD %s\n",
 			get_cmd_string(trans_pcie, cmd->id));
-		dump_stack();
+		if (cmd->id != REPLY_ERROR)
+			dump_stack();
 		ret = -EIO;
 		goto cancel;
 	}
-- 
1.8.3.1

