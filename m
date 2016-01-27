Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32401 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbcA0J4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:56:48 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 02/12] ath10k: make ath10k_pci_read32/write32() ops more generic
Date: Wed, 27 Jan 2016 15:24:23 +0530
Message-ID: <1453888473-2879-3-git-send-email-rmani@qti.qualcomm.com> (sfid-20160127_105726_039639_82334364)
In-Reply-To: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
References: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_pci_read32/write32() does work more specific to
PCI by ensuring pci wake/sleep for every read and write.
There is a plan to use most of stuff available in pci.c
(irq stuff, copy engine, etc) for AHB case. Such kind
of pci wake/sleep for every read/write is not required
in AHB case (qca4019). All those reusable areas in pci.c
and ce.c calls ath10k_pci_read32/write32() for low level
read and write.

In fact, ath10k_pci_read32/write32() should do what it does
today for PCI case. But for AHB, it has to do differently.
To make ath10k_pci_read32/write32() more generic, new function
pointers are added in ar_pci for the function which does
operation more close to the bus. Later, corresponding bus
specific read and write function will be mapped to that.

ath10k_pci_read32/write32() are changed to call directly
those function pointers without worrying which bus underlying
to it. Also, the function to get number of bank is changed
in the same way.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 34 +++++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/pci.h |  8 ++++++++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 956e548..c5f6604 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -619,7 +619,7 @@ static void ath10k_pci_sleep_sync(struct ath10k *ar)
 	spin_unlock_irqrestore(&ar_pci->ps_lock, flags);
 }
 
-void ath10k_pci_write32(struct ath10k *ar, u32 offset, u32 value)
+static void ath10k_bus_pci_write32(struct ath10k *ar, u32 offset, u32 value)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
@@ -641,7 +641,7 @@ void ath10k_pci_write32(struct ath10k *ar, u32 offset, u32 value)
 	ath10k_pci_sleep(ar);
 }
 
-u32 ath10k_pci_read32(struct ath10k *ar, u32 offset)
+static u32 ath10k_bus_pci_read32(struct ath10k *ar, u32 offset)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	u32 val;
@@ -666,6 +666,20 @@ u32 ath10k_pci_read32(struct ath10k *ar, u32 offset)
 	return val;
 }
 
+inline void ath10k_pci_write32(struct ath10k *ar, u32 offset, u32 value)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	ar_pci->bus_ops->write32(ar, offset, value);
+}
+
+inline u32 ath10k_pci_read32(struct ath10k *ar, u32 offset)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	return ar_pci->bus_ops->read32(ar, offset);
+}
+
 u32 ath10k_pci_soc_read32(struct ath10k *ar, u32 addr)
 {
 	return ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS + addr);
@@ -1906,6 +1920,13 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
 	return 1;
 }
 
+static int ath10k_bus_get_num_banks(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	return ar_pci->bus_ops->get_num_banks(ar);
+}
+
 int ath10k_pci_init_config(struct ath10k *ar)
 {
 	u32 interconnect_targ_addr;
@@ -2017,7 +2038,7 @@ int ath10k_pci_init_config(struct ath10k *ar)
 	/* first bank is switched to IRAM */
 	ealloc_value |= ((HI_EARLY_ALLOC_MAGIC << HI_EARLY_ALLOC_MAGIC_SHIFT) &
 			 HI_EARLY_ALLOC_MAGIC_MASK);
-	ealloc_value |= ((ath10k_pci_get_num_banks(ar) <<
+	ealloc_value |= ((ath10k_bus_get_num_banks(ar) <<
 			  HI_EARLY_ALLOC_IRAM_BANKS_SHIFT) &
 			 HI_EARLY_ALLOC_IRAM_BANKS_MASK);
 
@@ -2988,6 +3009,12 @@ static bool ath10k_pci_chip_is_supported(u32 dev_id, u32 chip_id)
 	return false;
 }
 
+static const struct ath10k_bus_ops ath10k_pci_bus_ops = {
+	.read32		= ath10k_bus_pci_read32,
+	.write32	= ath10k_bus_pci_write32,
+	.get_num_banks	= ath10k_pci_get_num_banks,
+};
+
 static int ath10k_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *pci_dev)
 {
@@ -3038,6 +3065,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ar_pci->ar = ar;
 	ar->dev_id = pci_dev->device;
 	ar_pci->pci_ps = pci_ps;
+	ar_pci->bus_ops = &ath10k_pci_bus_ops;
 
 	ar->id.vendor = pdev->vendor;
 	ar->id.device = pdev->device;
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index ae76131..41f3fac 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -157,6 +157,12 @@ struct ath10k_pci_supp_chip {
 	u32 rev_id;
 };
 
+struct ath10k_bus_ops {
+	u32 (*read32)(struct ath10k *ar, u32 offset);
+	void (*write32)(struct ath10k *ar, u32 offset, u32 value);
+	int (*get_num_banks)(struct ath10k *ar);
+};
+
 struct ath10k_pci {
 	struct pci_dev *pdev;
 	struct device *dev;
@@ -225,6 +231,8 @@ struct ath10k_pci {
 	 * on MMIO read/write.
 	 */
 	bool pci_ps;
+
+	const struct ath10k_bus_ops *bus_ops;
 };
 
 static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
-- 
1.8.1.2

