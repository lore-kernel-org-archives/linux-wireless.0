Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:3993 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887Ab0ESP0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 11:26:14 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/7] rt2x00: Introduce separate interface type for PCI-express.
Date: Wed, 19 May 2010 17:26:05 +0200
Message-Id: <1274282769-19244-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
References: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed later for PCI-express specific code in rt2800pci.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    9 ++++++++-
 drivers/net/wireless/rt2x00/rt2x00pci.c |    5 ++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 9fc3612..e7acc6a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -160,6 +160,7 @@ struct avg_val {
 
 enum rt2x00_chip_intf {
 	RT2X00_CHIP_INTF_PCI,
+	RT2X00_CHIP_INTF_PCIE,
 	RT2X00_CHIP_INTF_USB,
 	RT2X00_CHIP_INTF_SOC,
 };
@@ -980,7 +981,13 @@ static inline bool rt2x00_intf(struct rt2x00_dev *rt2x00dev,
 
 static inline bool rt2x00_is_pci(struct rt2x00_dev *rt2x00dev)
 {
-	return rt2x00_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
+	return rt2x00_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI) ||
+	       rt2x00_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);
+}
+
+static inline bool rt2x00_is_pcie(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);
 }
 
 static inline bool rt2x00_is_usb(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 19b8683..fe4b00b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -350,7 +350,10 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	rt2x00dev->irq = pci_dev->irq;
 	rt2x00dev->name = pci_name(pci_dev);
 
-	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
+	if (pci_dev->is_pcie)
+		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);
+	else
+		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
 
 	retval = rt2x00pci_alloc_reg(rt2x00dev);
 	if (retval)
-- 
1.7.1

