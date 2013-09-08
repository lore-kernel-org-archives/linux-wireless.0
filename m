Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:33695 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3IHOzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 10:55:52 -0400
Subject: [PATCH 4/8] ath10k: add boot debug messages to pci.c and ce.c
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Sep 2013 17:55:50 +0300
Message-ID: <20130908145550.3136.92297.stgit@localhost6.localdomain6> (sfid-20130908_165554_539077_9DAD0698)
In-Reply-To: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
References: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To unify all boot related debug messages into one debug
level.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |    8 ++++++++
 drivers/net/wireless/ath/ath10k/pci.c |    6 ++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index afe5df4..38c2571 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1010,6 +1010,10 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 	ath10k_ce_src_ring_lowmark_set(ar, ctrl_addr, 0);
 	ath10k_ce_src_ring_highmark_set(ar, ctrl_addr, nentries);
 
+	ath10k_dbg(ATH10K_DBG_BOOT,
+		   "boot ce src ring id %d entries %d base_addr %p\n",
+		   ce_id, nentries, src_ring->base_addr_owner_space);
+
 	return 0;
 }
 
@@ -1091,6 +1095,10 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 	ath10k_ce_dest_ring_lowmark_set(ar, ctrl_addr, 0);
 	ath10k_ce_dest_ring_highmark_set(ar, ctrl_addr, nentries);
 
+	ath10k_dbg(ATH10K_DBG_BOOT,
+		   "boot ce dest ring id %d entries %d base_addr %p\n",
+		   ce_id, nentries, dest_ring->base_addr_owner_space);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 880fcd0d..503a8c170 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2375,10 +2375,10 @@ static void ath10k_pci_dump_features(struct ath10k_pci *ar_pci)
 
 		switch (i) {
 		case ATH10K_PCI_FEATURE_MSI_X:
-			ath10k_dbg(ATH10K_DBG_PCI, "device supports MSI-X\n");
+			ath10k_dbg(ATH10K_DBG_BOOT, "device supports MSI-X\n");
 			break;
 		case ATH10K_PCI_FEATURE_SOC_POWER_SAVE:
-			ath10k_dbg(ATH10K_DBG_PCI, "QCA98XX SoC power save enabled\n");
+			ath10k_dbg(ATH10K_DBG_BOOT, "QCA98XX SoC power save enabled\n");
 			break;
 		}
 	}
@@ -2504,6 +2504,8 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	ath10k_do_pci_sleep(ar);
 
+	ath10k_dbg(ATH10K_DBG_BOOT, "boot pci_mem 0x%p\n", ar_pci->mem);
+
 	ret = ath10k_core_register(ar, chip_id);
 	if (ret) {
 		ath10k_err("could not register driver core (%d)\n", ret);

