Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:60050 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756204Ab1DOPZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 11:25:50 -0400
To: netdev@vger.kernel.org
Subject: [PATCH 1/2] iwlegacy: use pci_dev->revision
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date: Fri, 15 Apr 2011 19:24:05 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201104151924.05645.sshtylyov@ru.mvista.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit be663ab67077fac8e23eb8e231a8c1c94cb32e54 (iwlwifi: split the drivers for
agn and legacy devices 3945/4965) added code to read the 4965's revision ID from
the PCI configuration register while it's already stored by PCI subsystem in the
'revision' field of 'struct pci_dev'...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.
Resending with proper patch numbering...

 drivers/net/wireless/iwlegacy/iwl4965-base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/net/wireless/iwlegacy/iwl4965-base.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ linux-2.6/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -3179,7 +3179,7 @@ static void iwl4965_hw_detect(struct iwl
 {
 	priv->hw_rev = _iwl_legacy_read32(priv, CSR_HW_REV);
 	priv->hw_wa_rev = _iwl_legacy_read32(priv, CSR_HW_REV_WA_REG);
-	pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &priv->rev_id);
+	priv->rev_id = priv->pci_dev->revision;
 	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", priv->rev_id);
 }
 
