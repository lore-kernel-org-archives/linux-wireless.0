Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3HPLHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:07:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 09/20] iwlwifi: pcie: returning positive instead of negative
Date: Fri, 16 Aug 2013 13:06:59 +0200
Message-Id: <1376651230-1060-9-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130736_483733_E5BDF76C)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

There is a missing '-' character here so we return positive 'ENOMEM'
instead of negative.  The caller doesn't care.  All non-zero returns
are translated to '-ENOMEM' in iwl_pcie_nic_init().

This is just a cleanup.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 12c9c00..f45eb29 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -838,7 +838,7 @@ static int iwl_pcie_tx_alloc(struct iwl_trans *trans)
 				  sizeof(struct iwl_txq), GFP_KERNEL);
 	if (!trans_pcie->txq) {
 		IWL_ERR(trans, "Not enough memory for txq\n");
-		ret = ENOMEM;
+		ret = -ENOMEM;
 		goto error;
 	}
 
-- 
1.8.4.rc2

