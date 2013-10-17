Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48763 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab3JQHmu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:50 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 15/21] rt2x00: rt2800pci: use separate set_state callback for SoC devices
Date: Thu, 17 Oct 2013 09:42:29 +0200
Message-Id: <1381995755-16471-16-git-send-email-juhosg@openwrt.org> (sfid-20131017_100807_198239_699E0011)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'rt2800pci_set_state' function uses MCU commands
to set the device state, however these have no effect
on SoC devices. Use a different set_state callback
which does not use the MCU fcuntions.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   43 +++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index efc35b4..e424b7a 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -246,6 +246,7 @@ static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
+#ifdef CONFIG_PCI
 static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
 			       enum dev_state state)
 {
@@ -304,7 +305,6 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 	return retval;
 }
 
-#ifdef CONFIG_PCI
 /*
  * Device probe functions.
  */
@@ -480,6 +480,45 @@ MODULE_DEVICE_TABLE(pci, rt2800pci_device_table);
 MODULE_LICENSE("GPL");
 
 #if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
+static int rt2800soc_set_device_state(struct rt2x00_dev *rt2x00dev,
+				      enum dev_state state)
+{
+	int retval = 0;
+
+	switch (state) {
+	case STATE_RADIO_ON:
+		retval = rt2800pci_enable_radio(rt2x00dev);
+		break;
+
+	case STATE_RADIO_OFF:
+		rt2800pci_disable_radio(rt2x00dev);
+		break;
+
+	case STATE_RADIO_IRQ_ON:
+	case STATE_RADIO_IRQ_OFF:
+		rt2800mmio_toggle_irq(rt2x00dev, state);
+		break;
+
+	case STATE_DEEP_SLEEP:
+	case STATE_SLEEP:
+	case STATE_STANDBY:
+	case STATE_AWAKE:
+		/* These states are not supported, but don't report an error */
+		retval = 0;
+		break;
+
+	default:
+		retval = -ENOTSUPP;
+		break;
+	}
+
+	if (unlikely(retval))
+		rt2x00_err(rt2x00dev, "Device failed to enter state %d (%d)\n",
+			   state, retval);
+
+	return retval;
+}
+
 static int rt2800soc_read_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	void __iomem *base_addr = ioremap(0x1F040000, EEPROM_SIZE);
@@ -578,7 +617,7 @@ static const struct rt2x00lib_ops rt2800soc_rt2x00_ops = {
 	.uninitialize		= rt2x00mmio_uninitialize,
 	.get_entry_state	= rt2800mmio_get_entry_state,
 	.clear_entry		= rt2800mmio_clear_entry,
-	.set_device_state	= rt2800pci_set_device_state,
+	.set_device_state	= rt2800soc_set_device_state,
 	.rfkill_poll		= rt2800_rfkill_poll,
 	.link_stats		= rt2800_link_stats,
 	.reset_tuner		= rt2800_reset_tuner,
-- 
1.7.10
