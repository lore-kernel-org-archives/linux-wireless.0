Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22575 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842AbYCUU6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2008 16:58:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	Toralf Forster <toralf.foerster@gmx.de>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/5] iwlwifi: fix __devexit_p points to __devexit functions
Date: Fri, 21 Mar 2008 13:53:41 -0700
Message-Id: <1206132824-20558-3-git-send-email-reinette.chatre@intel.com> (sfid-20080321_205959_724959_E7CA82EF)
In-Reply-To: <1206132824-20558-2-git-send-email-reinette.chatre@intel.com>
References: <1206132824-20558-1-git-send-email-reinette.chatre@intel.com>
 <1206132824-20558-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iwlxxxx_pci_remove functions are not needed when drivers are not
compiled as modules - they can thus be discarded at kernel link time.
This is already captured by having them as __devexit_p in the pci_driver
struct - these are supposed to be pointers to __devexit functions, but was not.
This is now fixed.

This problem was reported by Toralf Forster when testing the compilation of
2.6.25-rc6.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: Toralf Forster <toralf.foerster@gmx.de>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7b6517f..5bc5f6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8159,7 +8159,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	return err;
 }
 
-static void iwl3945_pci_remove(struct pci_dev *pdev)
+static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
 	struct list_head *p, *q;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 29448d5..3562449 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8370,7 +8370,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	return err;
 }
 
-static void iwl4965_pci_remove(struct pci_dev *pdev)
+static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 	struct list_head *p, *q;
-- 
1.5.3.4

