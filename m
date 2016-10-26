Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35248 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754619AbcJZXaF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 19:30:05 -0400
Received: by mail-pf0-f181.google.com with SMTP id s8so4865348pfj.2
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2016 16:29:56 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Rajat Jain <rajatja@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] mwifiex: don't do unbalanced free()'ing in cleanup_if()
Date: Wed, 26 Oct 2016 16:29:20 -0700
Message-Id: <1477524560-49226-1-git-send-email-briannorris@chromium.org> (sfid-20161027_013027_374096_AD07498D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cleanup_if() callback is the inverse of init_if(). We allocate our
'card' interface structure in the probe() function, but we free it in
cleanup_if(). That gives a few problems:
(a) we leak this memory if probe() fails before we reach init_if()
(b) we can't safely utilize 'card' after cleanup_if() -- namely, in
    remove() or suspend(), both of which might race with the cleanup
    paths in our asynchronous FW initialization path

Solution: just use devm_kzalloc(), which will free this structure
properly when the device is removed -- and drop the set_drvdata(...,
NULL), since the driver core does this for us. This also removes the
temptation to use drvdata == NULL as a hack for checking if the device
has been "cleaned up."

I *do* leave the set_drvdata(..., NULL) for the hacky SDIO
mwifiex_recreate_adapter(), since the device core won't be able to clear
that one for us.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c |  5 +----
 drivers/net/wireless/marvell/mwifiex/sdio.c | 16 ++++++++++------
 drivers/net/wireless/marvell/mwifiex/usb.c  |  7 +------
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 063c707844d3..3047c1ab944a 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -189,7 +189,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 	pr_debug("info: vendor=0x%4.04X device=0x%4.04X rev=%d\n",
 		 pdev->vendor, pdev->device, pdev->revision);
 
-	card = kzalloc(sizeof(struct pcie_service_card), GFP_KERNEL);
+	card = devm_kzalloc(&pdev->dev, sizeof(*card), GFP_KERNEL);
 	if (!card)
 		return -ENOMEM;
 
@@ -2815,7 +2815,6 @@ static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
 err_set_dma_mask:
 	pci_disable_device(pdev);
 err_enable_dev:
-	pci_set_drvdata(pdev, NULL);
 	return ret;
 }
 
@@ -2849,9 +2848,7 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 		pci_disable_device(pdev);
 		pci_release_region(pdev, 2);
 		pci_release_region(pdev, 0);
-		pci_set_drvdata(pdev, NULL);
 	}
-	kfree(card);
 }
 
 static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 8718950004f3..f04cf5a551b3 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -152,7 +152,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 	pr_debug("info: vendor=0x%4.04X device=0x%4.04X class=%d function=%d\n",
 		 func->vendor, func->device, func->class, func->num);
 
-	card = kzalloc(sizeof(struct sdio_mmc_card), GFP_KERNEL);
+	card = devm_kzalloc(&func->dev, sizeof(*card), GFP_KERNEL);
 	if (!card)
 		return -ENOMEM;
 
@@ -185,7 +185,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 
 	if (ret) {
 		dev_err(&func->dev, "failed to enable function\n");
-		goto err_free;
+		return ret;
 	}
 
 	/* device tree node parsing and platform specific configuration*/
@@ -210,8 +210,6 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 	sdio_claim_host(func);
 	sdio_disable_func(func);
 	sdio_release_host(func);
-err_free:
-	kfree(card);
 
 	return ret;
 }
@@ -2240,8 +2238,6 @@ static void mwifiex_cleanup_sdio(struct mwifiex_adapter *adapter)
 	kfree(card->mpa_rx.len_arr);
 	kfree(card->mpa_tx.buf);
 	kfree(card->mpa_rx.buf);
-	sdio_set_drvdata(card->func, NULL);
-	kfree(card);
 }
 
 /*
@@ -2291,6 +2287,14 @@ static void mwifiex_recreate_adapter(struct sdio_mmc_card *card)
 
 	mwifiex_sdio_remove(func);
 
+	/*
+	 * Normally, we would let the driver core take care of releasing these.
+	 * But we're not letting the driver core handle this one. See above
+	 * TODO.
+	 */
+	sdio_set_drvdata(func, NULL);
+	devm_kfree(&func->dev, card);
+
 	/* power cycle the adapter */
 	sdio_claim_host(func);
 	mmc_hw_reset(func->card->host);
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 73eb0846db21..57ed834ba296 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -382,7 +382,7 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 	struct usb_card_rec *card;
 	u16 id_vendor, id_product, bcd_device, bcd_usb;
 
-	card = kzalloc(sizeof(struct usb_card_rec), GFP_KERNEL);
+	card = devm_kzalloc(&intf->dev, sizeof(*card), GFP_KERNEL);
 	if (!card)
 		return -ENOMEM;
 
@@ -480,7 +480,6 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 	if (ret) {
 		pr_err("%s: mwifiex_add_card failed: %d\n", __func__, ret);
 		usb_reset_device(udev);
-		kfree(card);
 		return ret;
 	}
 
@@ -630,11 +629,7 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 		    "%s: removing card\n", __func__);
 	mwifiex_remove_card(adapter, &add_remove_card_sem);
 
-	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
-	kfree(card);
-
-	return;
 }
 
 static struct usb_driver mwifiex_usb_driver = {
-- 
2.8.0.rc3.226.g39d4020
