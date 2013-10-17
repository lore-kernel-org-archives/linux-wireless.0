Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48766 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab3JQHmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:49 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 14/21] rt2x00: rt2800pci: use separate firmware callbacks for SoC devices
Date: Thu, 17 Oct 2013 09:42:28 +0200
Message-Id: <1381995755-16471-15-git-send-email-juhosg@openwrt.org> (sfid-20131017_094253_802044_5F6A6FC0)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use empty firmware callbacks for SoC devices because those
don't require firmware.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   38 +++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index afd422f..efc35b4 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -164,7 +164,6 @@ static inline int rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
 {
 	return rt2800_read_eeprom_efuse(rt2x00dev);
 }
-#endif /* CONFIG_PCI */
 
 /*
  * Firmware functions
@@ -206,6 +205,7 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
 
 	return 0;
 }
+#endif /* CONFIG_PCI */
 
 /*
  * Device state switch handlers.
@@ -493,6 +493,34 @@ static int rt2800soc_read_eeprom(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
+/* Firmware functions */
+static char *rt2800soc_get_firmware_name(struct rt2x00_dev *rt2x00dev)
+{
+	WARN_ON_ONCE(1);
+	return NULL;
+}
+
+static int rt2800soc_load_firmware(struct rt2x00_dev *rt2x00dev,
+				   const u8 *data, const size_t len)
+{
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+static int rt2800soc_check_firmware(struct rt2x00_dev *rt2x00dev,
+				    const u8 *data, const size_t len)
+{
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+static int rt2800soc_write_firmware(struct rt2x00_dev *rt2x00dev,
+				    const u8 *data, const size_t len)
+{
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
 static const struct ieee80211_ops rt2800soc_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
@@ -530,7 +558,7 @@ static const struct rt2800_ops rt2800soc_rt2800_ops = {
 	.regbusy_read		= rt2x00mmio_regbusy_read,
 	.read_eeprom		= rt2800soc_read_eeprom,
 	.hwcrypt_disabled	= rt2800pci_hwcrypt_disabled,
-	.drv_write_firmware	= rt2800pci_write_firmware,
+	.drv_write_firmware	= rt2800soc_write_firmware,
 	.drv_init_registers	= rt2800mmio_init_registers,
 	.drv_get_txwi		= rt2800mmio_get_txwi,
 };
@@ -543,9 +571,9 @@ static const struct rt2x00lib_ops rt2800soc_rt2x00_ops = {
 	.rxdone_tasklet		= rt2800mmio_rxdone_tasklet,
 	.autowake_tasklet	= rt2800mmio_autowake_tasklet,
 	.probe_hw		= rt2800_probe_hw,
-	.get_firmware_name	= rt2800pci_get_firmware_name,
-	.check_firmware		= rt2800_check_firmware,
-	.load_firmware		= rt2800_load_firmware,
+	.get_firmware_name	= rt2800soc_get_firmware_name,
+	.check_firmware		= rt2800soc_check_firmware,
+	.load_firmware		= rt2800soc_load_firmware,
 	.initialize		= rt2x00mmio_initialize,
 	.uninitialize		= rt2x00mmio_uninitialize,
 	.get_entry_state	= rt2800mmio_get_entry_state,
-- 
1.7.10
