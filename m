Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39787 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753852AbcKKLP5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 06:15:57 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>
Subject: [PATCH v2 2/3] mwifiex: Introduce mwifiex_probe_of() to parse common properties
Date: Fri, 11 Nov 2016 16:45:10 +0530
Message-ID: <1478862911-15498-2-git-send-email-akarwar@marvell.com> (sfid-20161111_121559_991321_E6569E21)
In-Reply-To: <1478862911-15498-1-git-send-email-akarwar@marvell.com>
References: <1478862911-15498-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajat Jain <rajatja@google.com>

Introduce function mwifiex_probe_of() to parse common properties.
Since the interface drivers get to decide whether or not the device
tree node was a valid one (depending on the compatible property),
let the interface drivers pass a flag to indicate whether the device
tree node was a valid one.

The function mwifiex_probe_of()nodetself is currently only a place
holder with the next patch adding content to it.

Signed-off-by: Rajat Jain <rajatja@google.com>
---
v2: Same as v1
---
 drivers/net/wireless/marvell/mwifiex/main.c    | 15 ++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/main.h    |  2 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c    |  4 +++-
 drivers/net/wireless/marvell/mwifiex/sdio.c    |  4 +++-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c |  5 +----
 drivers/net/wireless/marvell/mwifiex/usb.c     |  2 +-
 6 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index dcceab2..b2f3d96 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1552,6 +1552,16 @@ void mwifiex_do_flr(struct mwifiex_adapter *adapter, bool prepare)
 }
 EXPORT_SYMBOL_GPL(mwifiex_do_flr);
 
+static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
+{
+	struct device *dev = adapter->dev;
+
+	if (!dev->of_node)
+		return;
+
+	adapter->dt_node = dev->of_node;
+}
+
 /*
  * This function adds the card.
  *
@@ -1568,7 +1578,7 @@ void mwifiex_do_flr(struct mwifiex_adapter *adapter, bool prepare)
 int
 mwifiex_add_card(void *card, struct semaphore *sem,
 		 struct mwifiex_if_ops *if_ops, u8 iface_type,
-		 struct device *dev)
+		 struct device *dev, bool of_node_valid)
 {
 	struct mwifiex_adapter *adapter;
 
@@ -1581,6 +1591,9 @@ void mwifiex_do_flr(struct mwifiex_adapter *adapter, bool prepare)
 	}
 
 	adapter->dev = dev;
+	if (of_node_valid)
+		mwifiex_probe_of(adapter);
+
 	adapter->iface_type = iface_type;
 	adapter->card_sem = sem;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 2664513..0c07434 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1413,7 +1413,7 @@ static inline u8 mwifiex_is_tdls_link_setup(u8 status)
 int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 			     u32 func_init_shutdown);
 int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *, u8,
-		     struct device *);
+		     struct device *, bool);
 int mwifiex_remove_card(struct mwifiex_adapter *, struct semaphore *);
 
 void mwifiex_get_version(struct mwifiex_adapter *adapter, char *version,
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index de6939c..fe7f3b0 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -201,6 +201,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 					const struct pci_device_id *ent)
 {
 	struct pcie_service_card *card;
+	bool valid_of_node = false;
 	int ret;
 
 	pr_debug("info: vendor=0x%4.04X device=0x%4.04X rev=%d\n",
@@ -228,10 +229,11 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 		ret = mwifiex_pcie_probe_of(&pdev->dev);
 		if (ret)
 			goto err_free;
+		valid_of_node = true;
 	}
 
 	ret = mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
-			       MWIFIEX_PCIE, &pdev->dev);
+			       MWIFIEX_PCIE, &pdev->dev, valid_of_node);
 	if (ret) {
 		pr_err("%s failed\n", __func__);
 		goto err_free;
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index c95f41f..558743a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -156,6 +156,7 @@ static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
 {
 	int ret;
 	struct sdio_mmc_card *card = NULL;
+	bool valid_of_node = false;
 
 	pr_debug("info: vendor=0x%4.04X device=0x%4.04X class=%d function=%d\n",
 		 func->vendor, func->device, func->class, func->num);
@@ -203,10 +204,11 @@ static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
 			dev_err(&func->dev, "SDIO dt node parse failed\n");
 			goto err_disable;
 		}
+		valid_of_node = true;
 	}
 
 	ret = mwifiex_add_card(card, &add_remove_card_sem, &sdio_ops,
-			       MWIFIEX_SDIO, &func->dev);
+			       MWIFIEX_SDIO, &func->dev, valid_of_node);
 	if (ret) {
 		dev_err(&func->dev, "add card failed\n");
 		goto err_disable;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index b697b61..bcd6408 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -2235,10 +2235,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 		 * The cal-data can be read from device tree and/or
 		 * a configuration file and downloaded to firmware.
 		 */
-		if ((priv->adapter->iface_type == MWIFIEX_SDIO ||
-		    priv->adapter->iface_type == MWIFIEX_PCIE) &&
-		    adapter->dev->of_node) {
-			adapter->dt_node = adapter->dev->of_node;
+		if (adapter->dt_node) {
 			if (of_property_read_u32(adapter->dt_node,
 						 "marvell,wakeup-pin",
 						 &data) == 0) {
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index f847fff..11c9629 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -476,7 +476,7 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 	usb_set_intfdata(intf, card);
 
 	ret = mwifiex_add_card(card, &add_remove_card_sem, &usb_ops,
-			       MWIFIEX_USB, &card->udev->dev);
+			       MWIFIEX_USB, &card->udev->dev, false);
 	if (ret) {
 		pr_err("%s: mwifiex_add_card failed: %d\n", __func__, ret);
 		usb_reset_device(udev);
-- 
1.9.1
