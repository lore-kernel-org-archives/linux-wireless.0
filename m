Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34229 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755660AbcKJL5y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 06:57:54 -0500
Received: by mail-pf0-f193.google.com with SMTP id y68so3976393pfb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2016 03:57:54 -0800 (PST)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH RESEND v2 06/11] mwifiex: resolve suspend() race with async FW init failure
Date: Thu, 10 Nov 2016 19:57:07 +0800
Message-Id: <1478779032-5165-6-git-send-email-huxinming820@marvell.com> (sfid-20161110_125848_360860_C3E37DE5)
In-Reply-To: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
References: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: Same as v1
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 12 ++++++++++--
 drivers/net/wireless/marvell/mwifiex/sdio.c | 12 ++++++++++--
 drivers/net/wireless/marvell/mwifiex/usb.c  | 12 ++++++++++--
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a2353f9..4d96683 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -118,12 +118,20 @@ static int mwifiex_pcie_suspend(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 
 	card = pci_get_drvdata(pdev);
-	if (!card || !card->adapter) {
-		pr_err("Card or adapter structure is not valid\n");
+	if (!card) {
+		dev_err(dev, "card structure is not valid\n");
 		return 0;
 	}
 
+	/* Might still be loading firmware */
+	wait_for_completion(&card->fw_done);
+
 	adapter = card->adapter;
+	if (!adapter) {
+		dev_err(dev, "adapter is not valid\n");
+		return 0;
+	}
+
 	mwifiex_enable_wake(adapter);
 
 	/* Enable the Host Sleep */
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index a2257a4..39ffe7d 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -285,8 +285,8 @@ static int mwifiex_sdio_suspend(struct device *dev)
 		}
 
 		card = sdio_get_drvdata(func);
-		if (!card || !card->adapter) {
-			pr_err("suspend: invalid card or adapter\n");
+		if (!card) {
+			dev_err(dev, "suspend: invalid card\n");
 			return 0;
 		}
 	} else {
@@ -294,7 +294,15 @@ static int mwifiex_sdio_suspend(struct device *dev)
 		return 0;
 	}
 
+	/* Might still be loading firmware */
+	wait_for_completion(&card->fw_done);
+
 	adapter = card->adapter;
+	if (!adapter) {
+		dev_err(dev, "adapter is not valid\n");
+		return 0;
+	}
+
 	mwifiex_enable_wake(adapter);
 
 	/* Enable the Host Sleep */
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 558a7f1..671702c 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -503,11 +503,19 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	struct usb_tx_data_port *port;
 	int i, j;
 
-	if (!card || !card->adapter) {
-		pr_err("%s: card or card->adapter is NULL\n", __func__);
+	if (!card) {
+		dev_err(&intf->dev, "%s: card is NULL\n", __func__);
 		return 0;
 	}
+
+	/* Might still be loading firmware */
+	wait_for_completion(&card->fw_done);
+
 	adapter = card->adapter;
+	if (!adapter) {
+		dev_err(&intf->dev, "card is not valid\n");
+		return 0;
+	}
 
 	if (unlikely(adapter->is_suspended))
 		mwifiex_dbg(adapter, WARN,
-- 
1.8.1.4
