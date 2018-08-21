Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38933 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbeHUNku (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 09:40:50 -0400
From: Colin King <colin.king@canonical.com>
To: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: pcie: make array 'prop' static, shrinks object size
Date: Tue, 21 Aug 2018 11:21:09 +0100
Message-Id: <20180821102109.1630-1-colin.king@canonical.com> (sfid-20180821_122127_411002_C2EE42E5)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array prop on the stack but instead make it static.
Makes the object code smaller by 30 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  80138	  15382	    576	  96096	  17760	drivers/net/wireless/intel/iwlwifi/pcie/trans.o

After:
   text	   data	    bss	    dec	    hex	filename
  79948	  15542	    576	  96066	  17742	drivers/net/wireless/intel/iwlwifi/pcie/trans.o

(gcc version 8.2.0 x86_64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 7d319b6863fe..c7daf666ee21 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1947,7 +1947,7 @@ static void iwl_trans_pcie_removal_wk(struct work_struct *wk)
 	struct iwl_trans_pcie_removal *removal =
 		container_of(wk, struct iwl_trans_pcie_removal, work);
 	struct pci_dev *pdev = removal->pdev;
-	char *prop[] = {"EVENT=INACCESSIBLE", NULL};
+	static char *prop[] = {"EVENT=INACCESSIBLE", NULL};
 
 	dev_err(&pdev->dev, "Device gone - attempting removal\n");
 	kobject_uevent_env(&pdev->dev.kobj, KOBJ_CHANGE, prop);
-- 
2.17.1
