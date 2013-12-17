Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:51436 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3LQUpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:18 -0500
Received: by mail-ee0-f41.google.com with SMTP id t10so3148173eei.14
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:17 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/36] iwlwifi: trans: clear FW_ERROR status in common code
Date: Tue, 17 Dec 2013 22:44:26 +0200
Message-Id: <1387313079-28123-23-git-send-email-egrumbach@gmail.com> (sfid-20131217_215150_154531_8D5F6B1E)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Clear the FW_ERROR status before the common start_fw transport code.
Remove the transport specific clears.

After these patches the FW_ERROR flag is only set and cleared by common
transport code.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h  |    1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index fa495ba..8aaabdb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -590,6 +590,7 @@ static inline int iwl_trans_start_fw(struct iwl_trans *trans,
 
 	WARN_ON_ONCE(!trans->rx_mpdu_cmd);
 
+	clear_bit(STATUS_FW_ERROR, &trans->status);
 	return trans->ops->start_fw(trans, fw, run_in_rfkill);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 28c62a5..eecd38e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -589,8 +589,6 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 		return -EIO;
 	}
 
-	clear_bit(STATUS_FW_ERROR, &trans->status);
-
 	iwl_enable_rfkill_int(trans);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-- 
1.7.9.5

