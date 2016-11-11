Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44718 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756679AbcKKNLt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 08:11:49 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 10/11] mwifiex: stop checking for NULL drvata/intfdata
Date: Fri, 11 Nov 2016 18:40:17 +0530
Message-ID: <1478869818-4340-10-git-send-email-akarwar@marvell.com> (sfid-20161111_141155_682000_E9807C0F)
In-Reply-To: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
References: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

These are never NULL, so stop making people think they might be.

I don't change this for SDIO because SDIO has a racy card-reset handler
that reallocates this struct. I'd rather not touch that mess right now.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Tested-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v3: Same as v1 and v2
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 14 +++++---------
 drivers/net/wireless/marvell/mwifiex/usb.c  | 15 +++------------
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 1ab366c..3b6d908 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -118,10 +118,6 @@ static int mwifiex_pcie_suspend(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 
 	card = pci_get_drvdata(pdev);
-	if (!card) {
-		dev_err(dev, "card structure is not valid\n");
-		return 0;
-	}
 
 	/* Might still be loading firmware */
 	wait_for_completion(&card->fw_done);
@@ -166,8 +162,9 @@ static int mwifiex_pcie_resume(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 
 	card = pci_get_drvdata(pdev);
-	if (!card || !card->adapter) {
-		dev_err(dev, "Card or adapter structure is not valid\n");
+
+	if (!card->adapter) {
+		dev_err(dev, "adapter structure is not valid\n");
 		return 0;
 	}
 
@@ -255,8 +252,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	struct mwifiex_private *priv;
 
 	card = pci_get_drvdata(pdev);
-	if (!card)
-		return;
 
 	wait_for_completion(&card->fw_done);
 
@@ -2249,7 +2244,8 @@ static irqreturn_t mwifiex_pcie_interrupt(int irq, void *context)
 	}
 
 	card = pci_get_drvdata(pdev);
-	if (!card || !card->adapter) {
+
+	if (!card->adapter) {
 		pr_err("info: %s: card=%p adapter=%p\n", __func__, card,
 		       card ? card->adapter : NULL);
 		goto exit;
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 8bcfd92..806ded6 100644
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
1.9.1
