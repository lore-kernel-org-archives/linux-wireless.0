Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36616 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761988AbcJaICv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 04:02:51 -0400
Received: by mail-pf0-f196.google.com with SMTP id n85so8104114pfi.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2016 01:02:51 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 07/12] mwifiex: resolve suspend() race with async FW init failure
Date: Mon, 31 Oct 2016 16:02:15 +0800
Message-Id: <1477900940-10549-7-git-send-email-huxinming820@marvell.com> (sfid-20161031_090300_995823_7B094890)
In-Reply-To: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
References: <1477900940-10549-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 11 +++++++++--
 drivers/net/wireless/marvell/mwifiex/sdio.c | 11 +++++++++--
 drivers/net/wireless/marvell/mwifiex/usb.c  | 12 ++++++++++--
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 32fbb91..b635563 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -102,12 +102,19 @@ static int mwifiex_pcie_suspend(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 
 	card = pci_get_drvdata(pdev);
-	if (!card || !card->adapter) {
-		pr_err("Card or adapter structure is not valid\n");
+	if (!card) {
+		dev_err(dev, "adapter structure is not valid\n");
 		return 0;
 	}
 
+	/* Might still be loading firmware */
+	wait_for_completion(&card->fw_done);
+
 	adapter = card->adapter;
+	if (!adapter) {
+		dev_err(dev, "card is not valid\n");
+		return 0;
+	}
 
 	/* Enable the Host Sleep */
 	if (!mwifiex_enable_hs(adapter)) {
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index a750edb..4d314c1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -331,8 +331,8 @@ static int mwifiex_sdio_suspend(struct device *dev)
 		}
 
 		card = sdio_get_drvdata(func);
-		if (!card || !card->adapter) {
-			pr_err("suspend: invalid card or adapter\n");
+		if (!card) {
+			dev_err(dev, "suspend: invalid card\n");
 			return 0;
 		}
 	} else {
@@ -340,7 +340,14 @@ static int mwifiex_sdio_suspend(struct device *dev)
 		return 0;
 	}
 
+	/* Might still be loading firmware */
+	wait_for_completion(&card->fw_done);
+
 	adapter = card->adapter;
+	if (!adapter) {
+		dev_err(dev, "card is not valid\n");
+		return 0;
+	}
 
 	/* Enable platform specific wakeup interrupt */
 	if (card->plt_wake_cfg && card->plt_wake_cfg->irq_wifi >= 0) {
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index a61455c..70126c3 100644
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
