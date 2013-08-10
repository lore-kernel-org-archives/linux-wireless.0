Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40754 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3HJXDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 19:03:44 -0400
Date: Sun, 11 Aug 2013 02:03:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] iwlwifi: pcie: returning positive instead of negative
Message-ID: <20130810230321.GA19051@elgon.mountain> (sfid-20130811_010349_606599_4F723F94)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a missing '-' character here so we return positive 'ENOMEM'
instead of negative.  The caller doesn't care.  All non-zero returns
are translated to '-ENOMEM' in iwl_pcie_nic_init().

This is just a cleanup.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 134f7a1..a81d227 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -829,7 +829,7 @@ static int iwl_pcie_tx_alloc(struct iwl_trans *trans)
 				  sizeof(struct iwl_txq), GFP_KERNEL);
 	if (!trans_pcie->txq) {
 		IWL_ERR(trans, "Not enough memory for txq\n");
-		ret = ENOMEM;
+		ret = -ENOMEM;
 		goto error;
 	}
 
