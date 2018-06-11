Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50000 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753873AbeFKRPr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 13:15:47 -0400
From: Colin King <colin.king@canonical.com>
To: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: pcie: make array prop static, shrinks object size
Date: Mon, 11 Jun 2018 18:15:37 +0100
Message-Id: <20180611171537.14597-1-colin.king@canonical.com> (sfid-20180611_191606_778694_EE267F77)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate the read-only array 'prop' on the stack but
instead make it static. Makes the object code smaller by 20 bytes:

Before:
   text    data     bss     dec     hex filename
  71659   14614     576   86849   15341 trans.o

After:
   text    data     bss     dec     hex filename
  71479   14774     576   86829   1532d trans.o

(gcc version 7.3.0 x86_64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 7229991ae70d..c4626ebe5da1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1946,7 +1946,7 @@ static void iwl_trans_pcie_removal_wk(struct work_struct *wk)
 	struct iwl_trans_pcie_removal *removal =
 		container_of(wk, struct iwl_trans_pcie_removal, work);
 	struct pci_dev *pdev = removal->pdev;
-	char *prop[] = {"EVENT=INACCESSIBLE", NULL};
+	static char *prop[] = {"EVENT=INACCESSIBLE", NULL};
 
 	dev_err(&pdev->dev, "Device gone - attempting removal\n");
 	kobject_uevent_env(&pdev->dev.kobj, KOBJ_CHANGE, prop);
-- 
2.17.0
