Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48762 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab3JQHmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:49 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 13/21] rt2x00: rt2800pci: use separate read_eeprom callback for SoC devices
Date: Thu, 17 Oct 2013 09:42:27 +0200
Message-Id: <1381995755-16471-14-git-send-email-juhosg@openwrt.org> (sfid-20131017_100807_299972_BBF07CED)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename the 'rt2800pci_read_eeprom_soc function' to
'rt2800soc_read_eeprom' and use that directly in the
SoC specific 'rt2800_ops' structure. Also move the
'rt2800pci_eeprom_read' function into an 'ifdef PCI'
section and remove the 'rt2800pci_read_eeprom_soc'
call from that.

Additionally, remove the dummy inline eeprom functions.
Those are not used anymore.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   56 +++++++++----------------------
 1 file changed, 16 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 344a73d..afd422f 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -91,26 +91,6 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 }
 
-#if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
-static int rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
-{
-	void __iomem *base_addr = ioremap(0x1F040000, EEPROM_SIZE);
-
-	if (!base_addr)
-		return -ENOMEM;
-
-	memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
-
-	iounmap(base_addr);
-	return 0;
-}
-#else
-static inline int rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
-{
-	return -ENOMEM;
-}
-#endif /* CONFIG_SOC_RT288X || CONFIG_SOC_RT305X */
-
 #ifdef CONFIG_PCI
 static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
 {
@@ -184,21 +164,6 @@ static inline int rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
 {
 	return rt2800_read_eeprom_efuse(rt2x00dev);
 }
-#else
-static inline int rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
-{
-	return 0;
-}
-
-static inline int rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
-{
-	return -EOPNOTSUPP;
-}
 #endif /* CONFIG_PCI */
 
 /*
@@ -339,6 +304,7 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 	return retval;
 }
 
+#ifdef CONFIG_PCI
 /*
  * Device probe functions.
  */
@@ -346,9 +312,7 @@ static int rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
-	if (rt2x00_is_soc(rt2x00dev))
-		retval = rt2800pci_read_eeprom_soc(rt2x00dev);
-	else if (rt2800pci_efuse_detect(rt2x00dev))
+	if (rt2800pci_efuse_detect(rt2x00dev))
 		retval = rt2800pci_read_eeprom_efuse(rt2x00dev);
 	else
 		retval = rt2800pci_read_eeprom_pci(rt2x00dev);
@@ -356,7 +320,6 @@ static int rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
 	return retval;
 }
 
-#ifdef CONFIG_PCI
 static const struct ieee80211_ops rt2800pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
@@ -517,6 +480,19 @@ MODULE_DEVICE_TABLE(pci, rt2800pci_device_table);
 MODULE_LICENSE("GPL");
 
 #if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
+static int rt2800soc_read_eeprom(struct rt2x00_dev *rt2x00dev)
+{
+	void __iomem *base_addr = ioremap(0x1F040000, EEPROM_SIZE);
+
+	if (!base_addr)
+		return -ENOMEM;
+
+	memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
+
+	iounmap(base_addr);
+	return 0;
+}
+
 static const struct ieee80211_ops rt2800soc_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
@@ -552,7 +528,7 @@ static const struct rt2800_ops rt2800soc_rt2800_ops = {
 	.register_multiread	= rt2x00mmio_register_multiread,
 	.register_multiwrite	= rt2x00mmio_register_multiwrite,
 	.regbusy_read		= rt2x00mmio_regbusy_read,
-	.read_eeprom		= rt2800pci_read_eeprom,
+	.read_eeprom		= rt2800soc_read_eeprom,
 	.hwcrypt_disabled	= rt2800pci_hwcrypt_disabled,
 	.drv_write_firmware	= rt2800pci_write_firmware,
 	.drv_init_registers	= rt2800mmio_init_registers,
-- 
1.7.10
