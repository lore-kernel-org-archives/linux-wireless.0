Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48815 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab3JQHmw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:52 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 19/21] rt2x00: rt2800pci: use separate hwcrypt_disabled callback for SoC devices
Date: Thu, 17 Oct 2013 09:42:33 +0200
Message-Id: <1381995755-16471-20-git-send-email-juhosg@openwrt.org> (sfid-20131017_094257_301344_1BD6BDF5)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'rt2800pci_hwcrypt_disabled' function is the
only PCI specific callback which is used by the
SoC driver. Create a clone of that to get rid of
the dependency.

Even though the two functions are using the same
variable, but the SoC specific code will be moved
into a separate module which will have its own
'modparam_nohwcrypt' variable.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 77ddd1a..488d1c4 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -56,12 +56,12 @@ static bool modparam_nohwcrypt = false;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
+#ifdef CONFIG_PCI
 static bool rt2800pci_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
 {
 	return modparam_nohwcrypt;
 }
 
-#ifdef CONFIG_PCI
 static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 {
 	unsigned int i;
@@ -462,6 +462,11 @@ MODULE_DEVICE_TABLE(pci, rt2800pci_device_table);
 MODULE_LICENSE("GPL");
 
 #if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
+static bool rt2800soc_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
+{
+	return modparam_nohwcrypt;
+}
+
 static void rt2800soc_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_disable_radio(rt2x00dev);
@@ -585,7 +590,7 @@ static const struct rt2800_ops rt2800soc_rt2800_ops = {
 	.register_multiwrite	= rt2x00mmio_register_multiwrite,
 	.regbusy_read		= rt2x00mmio_regbusy_read,
 	.read_eeprom		= rt2800soc_read_eeprom,
-	.hwcrypt_disabled	= rt2800pci_hwcrypt_disabled,
+	.hwcrypt_disabled	= rt2800soc_hwcrypt_disabled,
 	.drv_write_firmware	= rt2800soc_write_firmware,
 	.drv_init_registers	= rt2800mmio_init_registers,
 	.drv_get_txwi		= rt2800mmio_get_txwi,
-- 
1.7.10
