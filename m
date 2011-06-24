Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:39369 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754347Ab1FXPlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 11:41:21 -0400
To: netdev@vger.kernel.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2] iwlwifi: use pci_dev->revision, again
Cc: wey-yi.w.guy@intel.com, ilw@linux.intel.com
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date: Fri, 24 Jun 2011 19:39:37 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201106241939.37388.sshtylyov@ru.mvista.com> (sfid-20110624_174126_632184_3290036A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit ff938e43d39e926de74b32a3656c190f979ab642 (net: use pci_dev->revision,
again) already converted this driver to using the 'revision' field of 'struct
pci_dev' but commit 084dd79172cb3aad11d2b7ee5628d57badca7c6e (iwlagn: move PCI
related operations from probe and remove to PCI layer) has again added the code
to read the PCI revision ID register...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the iwlwifi-2.6.git...

 drivers/net/wireless/iwlwifi/iwl-pci.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: iwlwifi-2.6/drivers/net/wireless/iwlwifi/iwl-pci.c
===================================================================
--- iwlwifi-2.6.orig/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ iwlwifi-2.6/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -383,7 +383,6 @@ static int iwl_pci_probe(struct pci_dev 
 {
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	struct iwl_pci_bus *bus;
-	u8 rev_id;
 	u16 pci_cmd;
 	int err;
 
@@ -440,8 +439,7 @@ static int iwl_pci_probe(struct pci_dev 
 		(unsigned long long) pci_resource_len(pdev, 0));
 	pr_info("pci_resource_base = %p\n", bus->hw_base);
 
-	pci_read_config_byte(pdev, PCI_REVISION_ID, &rev_id);
-	pr_info("HW Revision ID = 0x%X\n", rev_id);
+	pr_info("HW Revision ID = 0x%X\n", pdev->revision);
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
 	 * PCI Tx retries from interfering with C3 CPU state */
