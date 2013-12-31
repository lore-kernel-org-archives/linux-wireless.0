Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:55445 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab3LaRQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:36 -0500
Received: by mail-ea0-f179.google.com with SMTP id r15so5683625ead.10
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:35 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/28] iwlwifi: pcie: Fix CSR_RESET operation access type
Date: Tue, 31 Dec 2013 19:15:52 +0200
Message-Id: <1388510157-23345-23-git-send-email-egrumbach@gmail.com> (sfid-20131231_183436_702255_DB3E3B2E)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

The access to the CSR_RESET reg should be done as a complete
DWORD and not by setting a bit. This is the right way to reset
the device.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index bc584ef..2cb6332 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -779,7 +779,7 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 	}
 
 	/* Reset the entire device */
-	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
 	usleep_range(10, 15);
 
-- 
1.7.9.5

