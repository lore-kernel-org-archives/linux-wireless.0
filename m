Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34915 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762003AbcJaIDF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 04:03:05 -0400
Received: by mail-pf0-f193.google.com with SMTP id s8so8098065pfj.2
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2016 01:03:04 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 11/12] mwifiex: stop checking for NULL drvata/intfdata
Date: Mon, 31 Oct 2016 16:02:19 +0800
Message-Id: <1477900940-10549-11-git-send-email-huxinming820@marvell.com> (sfid-20161031_092412_485157_E1898357)
In-Reply-To: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
References: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

These are never NULL, so stop making people think they might be.

I don't change this for SDIO because SDIO has a racy card-reset handler
that reallocates this struct. I'd rather not touch that mess right now.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 14 +++++---------
 drivers/net/wireless/marvell/mwifiex/usb.c  | 15 +++------------
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 04b9961..c061d00 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -102,10 +102,6 @@ static int mwifiex_pcie_suspend(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 
 	card = pci_get_drvdata(pdev);
-	if (!card) {
-		dev_err(dev, "adapter structure is not valid\n");
-		return 0;
-	}
 
 	/* Might still be loading firmware */
 	wait_for_completion(&card->fw_done);
@@ -148,8 +144,9 @@ static int mwifiex_pcie_resume(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 
 	card = pci_get_drvdata(pdev);
-	if (!card || !card->adapter) {
-		dev_err(dev, "Card or adapter structure is not valid\n");
+
+	if (!card->adapter) {
+		dev_err(dev, "adapter structure is not valid\n");
 		return 0;
 	}
 
@@ -222,8 +219,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	struct mwifiex_private *priv;
 
 	card = pci_get_drvdata(pdev);
-	if (!card)
-		return;
 
 	wait_for_completion(&card->fw_done);
 
@@ -2216,7 +2211,8 @@ static irqreturn_t mwifiex_pcie_interrupt(int irq, void *context)
 	}
 
 	card = pci_get_drvdata(pdev);
-	if (!card || !card->adapter) {
+
+	if (!card->adapter) {
 		pr_err("info: %s: card=%p adapter=%p\n", __func__, card,
 		       card ? card->adapter : NULL);
 		goto exit;
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index c26daf4..78b46fa 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -503,11 +503,6 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	struct usb_tx_data_port *port;
 	int i, j;
 
-	if (!card) {
-		dev_err(&intf->dev, "%s: card is NULL\n", __func__);
-		return 0;
-	}
-
 	/* Might still be loading firmware */
 	wait_for_completion(&card->fw_done);
 
@@ -574,8 +569,9 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 	struct mwifiex_adapter *adapter;
 	int i;
 
-	if (!card || !card->adapter) {
-		pr_err("%s: card or card->adapter is NULL\n", __func__);
+	if (!card->adapter) {
+		dev_err(&intf->dev, "%s: card->adapter is NULL\n",
+			__func__);
 		return 0;
 	}
 	adapter = card->adapter;
@@ -617,11 +613,6 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 	struct usb_card_rec *card = usb_get_intfdata(intf);
 	struct mwifiex_adapter *adapter;
 
-	if (!card) {
-		dev_err(&intf->dev, "%s: card is NULL\n", __func__);
-		return;
-	}
-
 	wait_for_completion(&card->fw_done);
 
 	adapter = card->adapter;
-- 
1.8.1.4
