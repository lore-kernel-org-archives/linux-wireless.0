Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:45049 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbeFCSWL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Jun 2018 14:22:11 -0400
Received: by mail-lf0-f68.google.com with SMTP id 36-v6so19834385lfr.11
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2018 11:22:10 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v5 01/12] ath10k: add struct ath10k_bus_params
Date: Sun,  3 Jun 2018 20:20:18 +0200
Message-Id: <20180603182029.8914-2-erik.stromdahl@gmail.com> (sfid-20180603_202218_232732_6D4B775C)
In-Reply-To: <20180603182029.8914-1-erik.stromdahl@gmail.com>
References: <20180603182029.8914-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This struct is used as argument to ath10k_core_register in order to
make it easier to add more bus parameters in the future.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c  |  8 ++++----
 drivers/net/wireless/ath/ath10k/core.c |  5 +++--
 drivers/net/wireless/ath/ath10k/core.h |  7 ++++++-
 drivers/net/wireless/ath/ath10k/pci.c  | 12 ++++++------
 drivers/net/wireless/ath/ath10k/sdio.c |  7 ++++---
 drivers/net/wireless/ath/ath10k/snoc.c |  4 +++-
 drivers/net/wireless/ath/ath10k/usb.c  |  6 +++---
 7 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index fa39ffffd34d..5e272e940efd 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -755,7 +755,7 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 	enum ath10k_hw_rev hw_rev;
 	size_t size;
 	int ret;
-	u32 chip_id;
+	struct ath10k_bus_params bus_params;
 
 	of_id = of_match_device(ath10k_ahb_of_match, &pdev->dev);
 	if (!of_id) {
@@ -811,14 +811,14 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 
 	ath10k_pci_ce_deinit(ar);
 
-	chip_id = ath10k_ahb_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
-	if (chip_id == 0xffffffff) {
+	bus_params.chip_id = ath10k_ahb_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
+	if (bus_params.chip_id == 0xffffffff) {
 		ath10k_err(ar, "failed to get chip id\n");
 		ret = -ENODEV;
 		goto err_halt_device;
 	}
 
-	ret = ath10k_core_register(ar, chip_id);
+	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
 		ath10k_err(ar, "failed to register driver core: %d\n", ret);
 		goto err_halt_device;
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 4cf54a7ef09a..eee6e39e4e99 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2702,9 +2702,10 @@ static void ath10k_core_register_work(struct work_struct *work)
 	return;
 }
 
-int ath10k_core_register(struct ath10k *ar, u32 chip_id)
+int ath10k_core_register(struct ath10k *ar,
+			 const struct ath10k_bus_params *bus_params)
 {
-	ar->chip_id = chip_id;
+	ar->chip_id = bus_params->chip_id;
 	queue_work(ar->workqueue, &ar->register_work);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 951dbdd1c9eb..6dd68df104e4 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -874,6 +874,10 @@ struct ath10k_per_peer_tx_stats {
 	u32	reserved2;
 };
 
+struct ath10k_bus_params {
+	u32 chip_id;
+};
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -1161,7 +1165,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		      const struct ath10k_fw_components *fw_components);
 int ath10k_wait_for_suspend(struct ath10k *ar, u32 suspend_opt);
 void ath10k_core_stop(struct ath10k *ar);
-int ath10k_core_register(struct ath10k *ar, u32 chip_id);
+int ath10k_core_register(struct ath10k *ar,
+			 const struct ath10k_bus_params *bus_params);
 void ath10k_core_unregister(struct ath10k *ar);
 
 #endif /* _CORE_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index af2cf55c4c1e..7b5b93f48ba2 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3482,7 +3482,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	struct ath10k *ar;
 	struct ath10k_pci *ar_pci;
 	enum ath10k_hw_rev hw_rev;
-	u32 chip_id;
+	struct ath10k_bus_params bus_params;
 	bool pci_ps;
 	int (*pci_soft_reset)(struct ath10k *ar);
 	int (*pci_hard_reset)(struct ath10k *ar);
@@ -3618,19 +3618,19 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_free_irq;
 	}
 
-	chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
-	if (chip_id == 0xffffffff) {
+	bus_params.chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
+	if (bus_params.chip_id == 0xffffffff) {
 		ath10k_err(ar, "failed to get chip id\n");
 		goto err_free_irq;
 	}
 
-	if (!ath10k_pci_chip_is_supported(pdev->device, chip_id)) {
+	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id)) {
 		ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
-			   pdev->device, chip_id);
+			   pdev->device, bus_params.chip_id);
 		goto err_free_irq;
 	}
 
-	ret = ath10k_core_register(ar, chip_id);
+	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
 		ath10k_err(ar, "failed to register driver core: %d\n", ret);
 		goto err_free_irq;
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index d612ce8c9cff..be61d868edcf 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1931,7 +1931,8 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 	struct ath10k_sdio *ar_sdio;
 	struct ath10k *ar;
 	enum ath10k_hw_rev hw_rev;
-	u32 chip_id, dev_id_base;
+	u32 dev_id_base;
+	struct ath10k_bus_params bus_params;
 	int ret, i;
 
 	/* Assumption: All SDIO based chipsets (so far) are QCA6174 based.
@@ -2026,8 +2027,8 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 	}
 
 	/* TODO: don't know yet how to get chip_id with SDIO */
-	chip_id = 0;
-	ret = ath10k_core_register(ar, chip_id);
+	bus_params.chip_id = 0;
+	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
 		ath10k_err(ar, "failed to register driver core: %d\n", ret);
 		goto err_free_wq;
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index a3a7042fe13a..46d2a7a21efb 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1273,6 +1273,7 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	struct ath10k *ar;
 	int ret;
 	u32 i;
+	struct ath10k_bus_params bus_params;
 
 	of_id = of_match_device(ath10k_snoc_dt_match, &pdev->dev);
 	if (!of_id) {
@@ -1340,7 +1341,8 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 		goto err_free_irq;
 	}
 
-	ret = ath10k_core_register(ar, drv_data->hw_rev);
+	bus_params.chip_id = drv_data->hw_rev;
+	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
 		ath10k_err(ar, "failed to register driver core: %d\n", ret);
 		goto err_hw_power_off;
diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index d4803ff5a78a..275e00bafcb1 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -983,7 +983,7 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 	struct usb_device *dev = interface_to_usbdev(interface);
 	int ret, vendor_id, product_id;
 	enum ath10k_hw_rev hw_rev;
-	u32 chip_id;
+	struct ath10k_bus_params bus_params;
 
 	/* Assumption: All USB based chipsets (so far) are QCA9377 based.
 	 * If there will be newer chipsets that does not use the hw reg
@@ -1017,8 +1017,8 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 	ar->id.device = product_id;
 
 	/* TODO: don't know yet how to get chip_id with USB */
-	chip_id = 0;
-	ret = ath10k_core_register(ar, chip_id);
+	bus_params.chip_id = 0;
+	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
 		ath10k_warn(ar, "failed to register driver core: %d\n", ret);
 		goto err;
-- 
2.17.0
