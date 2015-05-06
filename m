Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33111 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063AbbEFBGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 21:06:19 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v1 09/12] p54: use sysdata_file_request() and sysdata_file_request_async()
Date: Tue,  5 May 2015 17:44:27 -0700
Message-Id: <1430873070-7290-10-git-send-email-mcgrof@do-not-panic.com> (sfid-20150506_030639_218582_CD655412)
In-Reply-To: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This is an example conversion of the p54 driver firmware calls
over to sysdata_file_request() and sysdata_file_request_async().

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/net/wireless/p54/eeprom.c |  1 -
 drivers/net/wireless/p54/fwio.c   |  4 ++--
 drivers/net/wireless/p54/led.c    |  1 -
 drivers/net/wireless/p54/main.c   |  1 -
 drivers/net/wireless/p54/p54.h    |  4 +++-
 drivers/net/wireless/p54/p54pci.c | 19 +++++++++++++------
 drivers/net/wireless/p54/p54pci.h |  2 +-
 drivers/net/wireless/p54/p54spi.c | 25 ++++++-------------------
 drivers/net/wireless/p54/p54spi.h |  2 +-
 drivers/net/wireless/p54/p54usb.c | 14 ++++++++------
 drivers/net/wireless/p54/p54usb.h |  2 +-
 drivers/net/wireless/p54/txrx.c   |  1 -
 12 files changed, 35 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index 2fe713e..0ad3434 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -16,7 +16,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 5367d51..2bfe34d 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/slab.h>
-#include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/export.h>
 
@@ -27,8 +26,9 @@
 #include "eeprom.h"
 #include "lmac.h"
 
-int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
+int p54_parse_firmware(void *context, const struct sysdata_file *fw)
 {
+	struct ieee80211_hw *dev = context;
 	struct p54_common *priv = dev->priv;
 	struct exp_if *exp_if;
 	struct bootrec *bootrec;
diff --git a/drivers/net/wireless/p54/led.c b/drivers/net/wireless/p54/led.c
index 1f6fd5f..96aaefb 100644
--- a/drivers/net/wireless/p54/led.c
+++ b/drivers/net/wireless/p54/led.c
@@ -16,7 +16,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/firmware.h>
 #include <linux/etherdevice.h>
 
 #include <net/mac80211.h>
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index b9250d7..a6ade6e 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/slab.h>
-#include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/module.h>
 
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 40b401e..239b649 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -14,6 +14,8 @@
 #ifndef P54_H
 #define P54_H
 
+#include <linux/sysdata.h>
+
 #ifdef CONFIG_P54_LEDS
 #include <linux/leds.h>
 #endif /* CONFIG_P54_LEDS */
@@ -268,7 +270,7 @@ struct p54_common {
 /* interfaces for the drivers */
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
 void p54_free_skb(struct ieee80211_hw *dev, struct sk_buff *skb);
-int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw);
+int p54_parse_firmware(void *, const struct sysdata_file *);
 int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len);
 int p54_read_eeprom(struct ieee80211_hw *dev);
 
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 27a4906..b5deb09 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -15,7 +15,6 @@
 
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
 #include <linux/completion.h>
@@ -490,7 +489,7 @@ static int p54p_open(struct ieee80211_hw *dev)
 	return 0;
 }
 
-static void p54p_firmware_step2(const struct firmware *fw,
+static void p54p_firmware_step2(const struct sysdata_file *fw,
 				void *context)
 {
 	struct p54p_priv *priv = context;
@@ -542,6 +541,16 @@ out:
 	pci_dev_put(pdev);
 }
 
+static int p54p_request_fw_step2(struct p54p_priv *priv)
+{
+	const struct sysdata_file_desc p54p_fw_step2_desc = {
+		SYSDATA_DEFAULT_ASYNC(p54p_firmware_step2, priv),
+	};
+	return sysdata_file_request_async("isl3886pci",
+					  &p54p_fw_step2_desc,
+					  &priv->pdev->dev);
+}
+
 static int p54p_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id)
 {
@@ -620,9 +629,7 @@ static int p54p_probe(struct pci_dev *pdev,
 	spin_lock_init(&priv->lock);
 	tasklet_init(&priv->tasklet, p54p_tasklet, (unsigned long)dev);
 
-	err = request_firmware_nowait(THIS_MODULE, 1, "isl3886pci",
-				      &priv->pdev->dev, GFP_KERNEL,
-				      priv, p54p_firmware_step2);
+	err = p54p_request_fw_step2(priv);
 	if (!err)
 		return 0;
 
@@ -654,7 +661,7 @@ static void p54p_remove(struct pci_dev *pdev)
 	priv = dev->priv;
 	wait_for_completion(&priv->fw_loaded);
 	p54_unregister_common(dev);
-	release_firmware(priv->firmware);
+	release_sysdata_file(priv->firmware);
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
 	iounmap(priv->map);
diff --git a/drivers/net/wireless/p54/p54pci.h b/drivers/net/wireless/p54/p54pci.h
index 68405c1..55870bf 100644
--- a/drivers/net/wireless/p54/p54pci.h
+++ b/drivers/net/wireless/p54/p54pci.h
@@ -94,7 +94,7 @@ struct p54p_priv {
 	struct pci_dev *pdev;
 	struct p54p_csr __iomem *map;
 	struct tasklet_struct tasklet;
-	const struct firmware *firmware;
+	const struct sysdata_file *firmware;
 	spinlock_t lock;
 	struct p54p_ring_control *ring_control;
 	dma_addr_t ring_control_dma;
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 0950ed6..24155d2 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -23,8 +23,6 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-#include <linux/firmware.h>
-#include <linux/sysdata.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/spi/spi.h>
@@ -166,22 +164,11 @@ static int p54spi_spi_write_dma(struct p54s_priv *priv, __le32 base,
 static int p54spi_request_firmware(struct ieee80211_hw *dev)
 {
 	struct p54s_priv *priv = dev->priv;
-	int ret;
-
-	/* FIXME: should driver use it's own struct device? */
-	ret = request_firmware(&priv->firmware, "3826.arm", &priv->spi->dev);
-
-	if (ret < 0) {
-		dev_err(&priv->spi->dev, "request_firmware() failed: %d", ret);
-		return ret;
-	}
-
-	ret = p54_parse_firmware(dev, priv->firmware);
-	if (ret) {
-		release_firmware(priv->firmware);
-		return ret;
-	}
-
+	const struct sysdata_file_desc p54_spi_fw = {
+		SYSDATA_DEFAULT_SYNC(p54_parse_firmware, priv),
+	};
+	return sysdata_file_request("3826.arm", &p54_spi_fw,
+				    &priv->spi->dev);
 	return 0;
 }
 
@@ -701,7 +688,7 @@ static int p54spi_remove(struct spi_device *spi)
 
 	gpio_free(p54spi_gpio_power);
 	gpio_free(p54spi_gpio_irq);
-	release_firmware(priv->firmware);
+	release_sysdata_file(priv->firmware);
 
 	mutex_destroy(&priv->mutex);
 
diff --git a/drivers/net/wireless/p54/p54spi.h b/drivers/net/wireless/p54/p54spi.h
index dfaa62a..f4f20ff 100644
--- a/drivers/net/wireless/p54/p54spi.h
+++ b/drivers/net/wireless/p54/p54spi.h
@@ -119,7 +119,7 @@ struct p54s_priv {
 	struct list_head tx_pending;
 
 	enum fw_state fw_state;
-	const struct firmware *firmware;
+	const struct sysdata_file *firmware;
 };
 
 #endif /* P54SPI_H */
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 043bd1c..5eb1b53 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -15,7 +15,6 @@
 #include <linux/usb.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
 #include <linux/crc32.h>
@@ -916,7 +915,7 @@ err_out:
 	return ret;
 }
 
-static void p54u_load_firmware_cb(const struct firmware *firmware,
+static void p54u_load_firmware_cb(const struct sysdata_file *firmware,
 				  void *context)
 {
 	struct p54u_priv *priv = context;
@@ -960,6 +959,9 @@ static int p54u_load_firmware(struct ieee80211_hw *dev,
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct p54u_priv *priv = dev->priv;
 	struct device *device = &udev->dev;
+	const struct sysdata_file_desc p54u_fw_desc = {
+		SYSDATA_DEFAULT_ASYNC(p54u_load_firmware_cb, priv),
+	};
 	int err, i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(p54u_fwlist) != __NUM_P54U_HWTYPES);
@@ -973,9 +975,9 @@ static int p54u_load_firmware(struct ieee80211_hw *dev,
 	       p54u_fwlist[i].fw);
 
 	usb_get_dev(udev);
-	err = request_firmware_nowait(THIS_MODULE, 1, p54u_fwlist[i].fw,
-				      device, GFP_KERNEL, priv,
-				      p54u_load_firmware_cb);
+	err = sysdata_file_request_async(p54u_fwlist[i].fw,
+					 &p54u_fw_desc,
+					 device);
 	if (err) {
 		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
 					  "(%d)!\n", p54u_fwlist[i].fw, err);
@@ -1073,7 +1075,7 @@ static void p54u_disconnect(struct usb_interface *intf)
 	p54_unregister_common(dev);
 
 	usb_put_dev(interface_to_usbdev(intf));
-	release_firmware(priv->fw);
+	release_sysdata_file(priv->fw);
 	p54_free_common(dev);
 }
 
diff --git a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p54/p54usb.h
index a5f5f0f..9da200b 100644
--- a/drivers/net/wireless/p54/p54usb.h
+++ b/drivers/net/wireless/p54/p54usb.h
@@ -153,7 +153,7 @@ struct p54u_priv {
 	spinlock_t lock;
 	struct sk_buff_head rx_queue;
 	struct usb_anchor submitted;
-	const struct firmware *fw;
+	const struct sysdata_file *fw;
 
 	/* asynchronous firmware callback */
 	struct completion fw_wait_load;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 24e5ff9..2d9dee0 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/export.h>
-#include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <asm/div64.h>
 
-- 
2.3.2.209.gd67f9d5.dirty

