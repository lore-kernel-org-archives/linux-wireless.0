Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbbAVUee (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:34 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/38] iwlwifi: pcie: init ref_lock
Date: Thu, 22 Jan 2015 22:33:20 +0200
Message-Id: <1421958809-3371-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214447_223695_5BC75052)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ref_lock that was recently added is missing initialization
which makes lockdep unhappy and is generally a bad idea.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 9ee4ca0..95c2ab1 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2348,6 +2348,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	trans_pcie->trans = trans;
 	spin_lock_init(&trans_pcie->irq_lock);
 	spin_lock_init(&trans_pcie->reg_lock);
+	spin_lock_init(&trans_pcie->ref_lock);
 	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 
 	err = pci_enable_device(pdev);
-- 
1.9.1

