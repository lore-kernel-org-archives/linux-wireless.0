Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45877 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756458AbcKKNL2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 08:11:28 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 06/11] mwifiex: resolve suspend() race with async FW init failure
Date: Fri, 11 Nov 2016 18:40:13 +0530
Message-ID: <1478869818-4340-6-git-send-email-akarwar@marvell.com> (sfid-20161111_141142_255690_5CBBEB62)
In-Reply-To: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
References: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

Signed-off-by: Brian Norris <briannorris@chromium.org>
Tested-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v3: Same as v1 and v2
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
1.9.1
