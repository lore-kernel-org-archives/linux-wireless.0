Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48766 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab3JQHmv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:51 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 17/21] rt2x00: rt2800pci: split rt2800pci_enable_radio function
Date: Thu, 17 Oct 2013 09:42:31 +0200
Message-Id: <1381995755-16471-18-git-send-email-juhosg@openwrt.org> (sfid-20131017_100807_874722_B9B1945A)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function is called for PCI and SoC devices
however the MCU related part of the function
has no effect on SoC devices. Move the common
part of the function into a separate helper and
use that for the SoC devices.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 4cfd8f7..88dd242 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -61,6 +61,7 @@ static bool rt2800pci_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
 	return modparam_nohwcrypt;
 }
 
+#ifdef CONFIG_PCI
 static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 {
 	unsigned int i;
@@ -91,7 +92,6 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 }
 
-#ifdef CONFIG_PCI
 static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
 {
 	struct rt2x00_dev *rt2x00dev = eeprom->data;
@@ -210,17 +210,23 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
 /*
  * Device state switch handlers.
  */
-static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
+static int rt2800mmio_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
-	int retval;
-
 	/* Wait for DMA, ignore error until we initialize queues. */
 	rt2800_wait_wpdma_ready(rt2x00dev);
 
 	if (unlikely(rt2800mmio_init_queues(rt2x00dev)))
 		return -EIO;
 
-	retval = rt2800_enable_radio(rt2x00dev);
+	return rt2800_enable_radio(rt2x00dev);
+}
+
+#ifdef CONFIG_PCI
+static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
+{
+	int retval;
+
+	retval = rt2800mmio_enable_radio(rt2x00dev);
 	if (retval)
 		return retval;
 
@@ -237,7 +243,6 @@ static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	return retval;
 }
 
-#ifdef CONFIG_PCI
 static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
 			       enum dev_state state)
 {
@@ -484,7 +489,7 @@ static int rt2800soc_set_device_state(struct rt2x00_dev *rt2x00dev,
 
 	switch (state) {
 	case STATE_RADIO_ON:
-		retval = rt2800pci_enable_radio(rt2x00dev);
+		retval = rt2800mmio_enable_radio(rt2x00dev);
 		break;
 
 	case STATE_RADIO_OFF:
-- 
1.7.10
