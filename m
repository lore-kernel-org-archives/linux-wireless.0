Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33458 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdLaRbi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Dec 2017 12:31:38 -0500
Received: by mail-lf0-f66.google.com with SMTP id j143so7015137lfg.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 Dec 2017 09:31:38 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 04/18] ath10k: high_latency detection
Date: Sun, 31 Dec 2017 18:29:11 +0100
Message-Id: <20171231172925.24014-5-erik.stromdahl@gmail.com> (sfid-20171231_183216_405694_EB6DA58C)
In-Reply-To: <20171231172925.24014-1-erik.stromdahl@gmail.com>
References: <20171231172925.24014-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add is_high_latency parameter to struct ath10k_bus_params.

The setup of high latency chips is sometimes different than
for chips using low latency interfaces.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c  | 1 +
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 drivers/net/wireless/ath/ath10k/core.h | 2 ++
 drivers/net/wireless/ath/ath10k/pci.c  | 1 +
 drivers/net/wireless/ath/ath10k/sdio.c | 1 +
 drivers/net/wireless/ath/ath10k/usb.c  | 1 +
 6 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 6f902f355fca..b342f3393e2c 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -814,6 +814,7 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 
 	ath10k_pci_ce_deinit(ar);
 
+	bus_params.is_high_latency = false;
 	bus_params.chip_id = ath10k_ahb_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
 	if (bus_params.chip_id == 0xffffffff) {
 		ath10k_err(ar, "failed to get chip id\n");
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 3440ccc45d60..09b6ad481414 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2613,6 +2613,7 @@ int ath10k_core_register(struct ath10k *ar,
 			 const struct ath10k_bus_params *bus_params)
 {
 	ar->chip_id = bus_params->chip_id;
+	ar->is_high_latency = bus_params->is_high_latency;
 	queue_work(ar->workqueue, &ar->register_work);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f2e851d91170..17827ce3752d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -771,6 +771,7 @@ struct ath10k_per_peer_tx_stats {
 
 struct ath10k_bus_params {
 	u32 chip_id;
+	bool is_high_latency;
 };
 
 struct ath10k {
@@ -783,6 +784,7 @@ struct ath10k {
 	enum ath10k_hw_rev hw_rev;
 	u16 dev_id;
 	u32 chip_id;
+	bool is_high_latency;
 	u32 target_version;
 	u8 fw_version_major;
 	u32 fw_version_minor;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 124443d45873..9fd8f1576f0c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3555,6 +3555,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_free_irq;
 	}
 
+	bus_params.is_high_latency = false;
 	bus_params.chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
 	if (bus_params.chip_id == 0xffffffff) {
 		ath10k_err(ar, "failed to get chip id\n");
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 03dc748317f8..f0f1b2b8c7a7 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2026,6 +2026,7 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 		goto err_free_wq;
 	}
 
+	bus_params.is_high_latency = true;
 	/* TODO: don't know yet how to get chip_id with SDIO */
 	bus_params.chip_id = 0;
 	ret = ath10k_core_register(ar, &bus_params);
diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index 275e00bafcb1..3b330e9607aa 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -1016,6 +1016,7 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 	ar->id.vendor = vendor_id;
 	ar->id.device = product_id;
 
+	bus_params.is_high_latency = true;
 	/* TODO: don't know yet how to get chip_id with USB */
 	bus_params.chip_id = 0;
 	ret = ath10k_core_register(ar, &bus_params);
-- 
2.15.1
