Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:56113 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752130Ab1FWOnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 10:43:24 -0400
To: netdev@vger.kernel.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] iwlwifi: use pci_dev->revision, again
Cc: wey-yi.w.guy@intel.com, ilw@linux.intel.com
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date: Thu, 23 Jun 2011 18:41:40 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201106231841.40691.sshtylyov@ru.mvista.com> (sfid-20110623_164328_660191_9EBE3E2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit ff938e43d39e926de74b32a3656c190f979ab642 (net: use pci_dev->revision,
again) already converted this driver to using the 'revision' field of 'struct
pci_dev' but commit c2974a1d18832a9fffb2eb389c3878f5c4ed92f1 (iwlagn: remove
rev_id) later reverted that change for no reason. Now restore the change...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.

 drivers/net/wireless/iwlwifi/iwl-agn.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-agn.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3275,10 +3275,9 @@ struct ieee80211_ops iwlagn_hw_ops = {
 
 static u32 iwl_hw_detect(struct iwl_priv *priv)
 {
-	u8 rev_id;
+	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n",
+		       priv->pci_dev->revision);
 
-	pci_read_config_byte(priv->pci_dev, PCI_REVISION_ID, &rev_id);
-	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", rev_id);
 	return iwl_read32(priv, CSR_HW_REV);
 }
 
