Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35880 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750923AbdLaRbi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Dec 2017 12:31:38 -0500
Received: by mail-lf0-f67.google.com with SMTP id c19so32383589lfg.3
        for <linux-wireless@vger.kernel.org>; Sun, 31 Dec 2017 09:31:37 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 03/18] ath10k: add struct ath10k_bus_params
Date: Sun, 31 Dec 2017 18:29:10 +0100
Message-Id: <20171231172925.24014-4-erik.stromdahl@gmail.com> (sfid-20171231_183149_777996_ACB91743)
In-Reply-To: <20171231172925.24014-1-erik.stromdahl@gmail.com>
References: <20171231172925.24014-1-erik.stromdahl@gmail.com>
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
 drivers/net/wireless/ath/ath10k/usb.c  |  6 +++---
 6 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 35d10490f6c3..6f902f355fca 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -758,7 +758,7 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 	enum ath10k_hw_rev hw_rev;
 	size_t size;
 	int ret;
-	u32 chip_id;
+	struct ath10k_bus_params bus_params;
 
 	of_id = of_match_device(ath10k_ahb_of_match, &pdev->dev);
 	if (!of_id) {
@@ -814,14 +814,14 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 
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
index fe9341c97f31..3440ccc45d60 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2609,9 +2609,10 @@ static void ath10k_core_register_work(struct work_struct *work)
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
index fe6b30356d3b..f2e851d91170 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -769,6 +769,10 @@ struct ath10k_per_peer_tx_stats {
 	u32	reserved2;
 };
 
+struct ath10k_bus_params {
+	u32 chip_id;
+};
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -1049,7 +1053,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		      const struct ath10k_fw_components *fw_components);
 int ath10k_wait_for_suspend(struct ath10k *ar, u32 suspend_opt);
 void ath10k_core_stop(struct ath10k *ar);
-int ath10k_core_register(struct ath10k *ar, u32 chip_id);
+int ath10k_core_register(struct ath10k *ar,
+			 const struct ath10k_bus_params *bus_params);
 void ath10k_core_unregister(struct ath10k *ar);
 
 #endif /* _CORE_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8abaccc25227..124443d45873 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3420,7 +3420,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	struct ath10k *ar;
 	struct ath10k_pci *ar_pci;
 	enum ath10k_hw_rev hw_rev;
-	u32 chip_id;
+	struct ath10k_bus_params bus_params;
 	bool pci_ps;
 	int (*pci_soft_reset)(struct ath10k *ar);
 	int (*pci_hard_reset)(struct ath10k *ar);
@@ -3555,19 +3555,19 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
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
index 03a69e5b1116..03dc748317f8 100644
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
2.15.1
