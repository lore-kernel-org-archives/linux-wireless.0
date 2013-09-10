Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:15985 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3IJLQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 07:16:29 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00505PZ0TG50@mailout3.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 20:16:22 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Johannes Berg' <johannes.berg@intel.com>,
	'Emmanuel Grumbach' <emmanuel.grumbach@intel.com>,
	ilw@linux.intel.com
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
In-reply-to: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
Subject: [PATCH 01/12] wireless: iwlwifi: remove unnecessary pci_set_drvdata()
Date: Tue, 10 Sep 2013 20:16:22 +0900
Message-id: <00b201ceae17$2e5c3a00$8b14ae00$%han@samsung.com> (sfid-20130910_131632_934457_637390DC)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index dc02cb9..5c5c423 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -349,7 +349,6 @@ out_free_drv:
 	iwl_drv_stop(trans_pcie->drv);
 out_free_trans:
 	iwl_trans_pcie_free(iwl_trans);
-	pci_set_drvdata(pdev, NULL);
 	return ret;
 }
 
@@ -360,8 +359,6 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 
 	iwl_drv_stop(trans_pcie->drv);
 	iwl_trans_pcie_free(trans);
-
-	pci_set_drvdata(pdev, NULL);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
1.7.10.4


