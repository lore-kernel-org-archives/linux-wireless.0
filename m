Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:65402 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbaFXTwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:44 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so905590wes.28
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:43 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/27] iwlwifi: pcie: log when waking the NIC for hcmd submission fails
Date: Tue, 24 Jun 2014 22:52:05 +0300
Message-Id: <1403639541-4621-11-git-send-email-egrumbach@gmail.com> (sfid-20140624_215251_884048_D693BCEB)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Lutomirski <luto@amacapital.net>

I've never seen this happen, but it's useful to rule it out.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 038940a..6acccb1 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1438,6 +1438,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 				   CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 			spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
 			trans_pcie->cmd_in_flight = false;
+			IWL_ERR(trans, "Failed to wake NIC for hcmd\n");
 			idx = -EIO;
 			goto out;
 		}
-- 
1.8.3.2

