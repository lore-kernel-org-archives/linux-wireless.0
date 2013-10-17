Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48762 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab3JQHmu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:50 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 16/21] rt2x00: rt2800pci: rename rt2800pci_disable_radio function
Date: Thu, 17 Oct 2013 09:42:30 +0200
Message-Id: <1381995755-16471-17-git-send-email-juhosg@openwrt.org> (sfid-20131017_100807_088714_19038E1A)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function contain code for SoC devices only.
Rename the function to 'rt2800soc_disable_radio'
and move it to the SoC specific section. Use
the renamed function in the SoC specific code
only and remove the 'if rt2x00_is_soc(rt2x00dev)'
condition from the function body.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index e424b7a..4cfd8f7 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -237,15 +237,6 @@ static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	return retval;
 }
 
-static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
-{
-	if (rt2x00_is_soc(rt2x00dev)) {
-		rt2800_disable_radio(rt2x00dev);
-		rt2x00mmio_register_write(rt2x00dev, PWR_PIN_CFG, 0);
-		rt2x00mmio_register_write(rt2x00dev, TX_PIN_CFG, 0);
-	}
-}
-
 #ifdef CONFIG_PCI
 static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
 			       enum dev_state state)
@@ -280,7 +271,6 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		 * After the radio has been disabled, the device should
 		 * be put to sleep for powersaving.
 		 */
-		rt2800pci_disable_radio(rt2x00dev);
 		rt2800pci_set_state(rt2x00dev, STATE_SLEEP);
 		break;
 	case STATE_RADIO_IRQ_ON:
@@ -480,6 +470,13 @@ MODULE_DEVICE_TABLE(pci, rt2800pci_device_table);
 MODULE_LICENSE("GPL");
 
 #if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
+static void rt2800soc_disable_radio(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_disable_radio(rt2x00dev);
+	rt2x00mmio_register_write(rt2x00dev, PWR_PIN_CFG, 0);
+	rt2x00mmio_register_write(rt2x00dev, TX_PIN_CFG, 0);
+}
+
 static int rt2800soc_set_device_state(struct rt2x00_dev *rt2x00dev,
 				      enum dev_state state)
 {
@@ -491,7 +488,7 @@ static int rt2800soc_set_device_state(struct rt2x00_dev *rt2x00dev,
 		break;
 
 	case STATE_RADIO_OFF:
-		rt2800pci_disable_radio(rt2x00dev);
+		rt2800soc_disable_radio(rt2x00dev);
 		break;
 
 	case STATE_RADIO_IRQ_ON:
-- 
1.7.10
