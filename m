Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:41695 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbeFCSWL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Jun 2018 14:22:11 -0400
Received: by mail-lf0-f65.google.com with SMTP id d24-v6so21803716lfa.8
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2018 11:22:11 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v5 02/12] ath10k: add device type enum to ath10k_bus_params
Date: Sun,  3 Jun 2018 20:20:19 +0200
Message-Id: <20180603182029.8914-3-erik.stromdahl@gmail.com> (sfid-20180603_202217_030550_5FF26ED5)
In-Reply-To: <20180603182029.8914-1-erik.stromdahl@gmail.com>
References: <20180603182029.8914-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add dev_type parameter to struct ath10k_bus_params.

The dev type specifies if the device is a high latency device (usb and
sdio) or low latency device (pci, ahb and snoc)

The setup of high latency chips is sometimes different than
for chips using low latency interfaces.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c  | 1 +
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 drivers/net/wireless/ath/ath10k/core.h | 7 +++++++
 drivers/net/wireless/ath/ath10k/pci.c  | 1 +
 drivers/net/wireless/ath/ath10k/sdio.c | 1 +
 drivers/net/wireless/ath/ath10k/snoc.c | 1 +
 drivers/net/wireless/ath/ath10k/usb.c  | 1 +
 7 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 5e272e940efd..bb3928003b72 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -811,6 +811,7 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 
 	ath10k_pci_ce_deinit(ar);
 
+	bus_params.dev_type = ATH10K_DEV_TYPE_LL;
 	bus_params.chip_id = ath10k_ahb_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
 	if (bus_params.chip_id == 0xffffffff) {
 		ath10k_err(ar, "failed to get chip id\n");
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index eee6e39e4e99..ebc8ea7cfd40 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2706,6 +2706,7 @@ int ath10k_core_register(struct ath10k *ar,
 			 const struct ath10k_bus_params *bus_params)
 {
 	ar->chip_id = bus_params->chip_id;
+	ar->dev_type = bus_params->dev_type;
 	queue_work(ar->workqueue, &ar->register_work);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 6dd68df104e4..f3e94531bbee 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -874,8 +874,14 @@ struct ath10k_per_peer_tx_stats {
 	u32	reserved2;
 };
 
+enum ath10k_dev_type {
+	ATH10K_DEV_TYPE_LL,
+	ATH10K_DEV_TYPE_HL,
+};
+
 struct ath10k_bus_params {
 	u32 chip_id;
+	enum ath10k_dev_type dev_type;
 };
 
 struct ath10k {
@@ -888,6 +894,7 @@ struct ath10k {
 	enum ath10k_hw_rev hw_rev;
 	u16 dev_id;
 	u32 chip_id;
+	enum ath10k_dev_type dev_type;
 	u32 target_version;
 	u8 fw_version_major;
 	u32 fw_version_minor;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 7b5b93f48ba2..05674e6d439a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3618,6 +3618,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_free_irq;
 	}
 
+	bus_params.dev_type = ATH10K_DEV_TYPE_LL;
 	bus_params.chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
 	if (bus_params.chip_id == 0xffffffff) {
 		ath10k_err(ar, "failed to get chip id\n");
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index be61d868edcf..4b4fd0e3b009 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2026,6 +2026,7 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 		goto err_free_wq;
 	}
 
+	bus_params.dev_type = ATH10K_DEV_TYPE_HL;
 	/* TODO: don't know yet how to get chip_id with SDIO */
 	bus_params.chip_id = 0;
 	ret = ath10k_core_register(ar, &bus_params);
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 46d2a7a21efb..01a5f075f349 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1341,6 +1341,7 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 		goto err_free_irq;
 	}
 
+	bus_params.dev_type = ATH10K_DEV_TYPE_LL;
 	bus_params.chip_id = drv_data->hw_rev;
 	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index 275e00bafcb1..f731d35ee76d 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -1016,6 +1016,7 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 	ar->id.vendor = vendor_id;
 	ar->id.device = product_id;
 
+	bus_params.dev_type = ATH10K_DEV_TYPE_HL;
 	/* TODO: don't know yet how to get chip_id with USB */
 	bus_params.chip_id = 0;
 	ret = ath10k_core_register(ar, &bus_params);
-- 
2.17.0
