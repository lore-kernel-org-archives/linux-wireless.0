Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:33891 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaINJnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 05:43:03 -0400
Subject: [PATCH 05/10] ath10k: fix space after a cast style errors
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 14 Sep 2014 12:50:23 +0300
Message-ID: <20140914095023.9063.66403.stgit@x230> (sfid-20140914_114306_612335_79BECDEE)
In-Reply-To: <20140914094728.9063.32593.stgit@x230>
References: <20140914094728.9063.32593.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warnings:

CHECK: No space is necessary after a cast

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 52f273b92fa3..08e88a3758c1 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -340,8 +340,8 @@ static void ath10k_pci_disable_and_clear_legacy_irq(struct ath10k *ar)
 
 	/* IMPORTANT: this extra read transaction is required to
 	 * flush the posted write buffer. */
-	(void) ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
-				 PCIE_INTR_ENABLE_ADDRESS);
+	(void)ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
+				PCIE_INTR_ENABLE_ADDRESS);
 }
 
 static void ath10k_pci_enable_legacy_irq(struct ath10k *ar)
@@ -352,8 +352,8 @@ static void ath10k_pci_enable_legacy_irq(struct ath10k *ar)
 
 	/* IMPORTANT: this extra read transaction is required to
 	 * flush the posted write buffer. */
-	(void) ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
-				 PCIE_INTR_ENABLE_ADDRESS);
+	(void)ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
+				PCIE_INTR_ENABLE_ADDRESS);
 }
 
 static inline const char *ath10k_pci_get_irq_method(struct ath10k *ar)
@@ -547,7 +547,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 			goto done;
 		}
 
-		if (buf != (u32) address) {
+		if (buf != (u32)address) {
 			ret = -EIO;
 			goto done;
 		}
@@ -695,7 +695,7 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		 * Request CE to send caller-supplied data that
 		 * was copied to bounce buffer to Target(!) address.
 		 */
-		ret = ath10k_ce_send(ce_diag, NULL, (u32) ce_data,
+		ret = ath10k_ce_send(ce_diag, NULL, (u32)ce_data,
 				     nbytes, 0, 0);
 		if (ret != 0)
 			goto done;
@@ -1624,7 +1624,7 @@ static int ath10k_pci_ce_init(struct ath10k *ar)
 			continue;
 		}
 
-		pipe_info->buf_sz = (size_t) (attr->src_sz_max);
+		pipe_info->buf_sz = (size_t)(attr->src_sz_max);
 	}
 
 	return 0;

