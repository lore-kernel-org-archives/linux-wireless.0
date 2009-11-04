Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:57630 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbZKDRga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 12:36:30 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:36:10 +0100
Message-Id: <20091104173610.28463.4270.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 34/41] rt2x00: add support for different chipset interfaces
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2x00: add support for different chipset interfaces

Enhance rt2x00 infrastructure by adding explicit information
about used chipset interface to struct rt2x00_chip.

The new field will be used by rt2800 drivers for rt2800 library.

Also add commonly used rt2x00_intf_is_pci() and rt2x00_intf_is_usb()
helpers to make code easier to read (noticed by Ivo van Doorn).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

Index: b/drivers/net/wireless/rt2x00/rt2x00.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -144,6 +144,11 @@ struct avg_val {
 	int avg_weight;
 };
 
+enum rt2x00_chip_intf {
+	RT2X00_CHIP_INTF_PCI,
+	RT2X00_CHIP_INTF_USB,
+};
+
 /*
  * Chipset identification
  * The chipset on the device is composed of a RT and RF chip.
@@ -169,6 +174,8 @@ struct rt2x00_chip {
 
 	u16 rf;
 	u32 rev;
+
+	enum rt2x00_chip_intf intf;
 };
 
 /*
@@ -937,6 +944,28 @@ static inline bool rt2x00_check_rev(cons
 	return ((chipset->rev & mask) == rev);
 }
 
+static inline void rt2x00_set_chip_intf(struct rt2x00_dev *rt2x00dev,
+					enum rt2x00_chip_intf intf)
+{
+	rt2x00dev->chip.intf = intf;
+}
+
+static inline bool rt2x00_intf(const struct rt2x00_chip *chipset,
+			       enum rt2x00_chip_intf intf)
+{
+	return (chipset->intf == intf);
+}
+
+static inline bool rt2x00_intf_is_pci(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_intf(&rt2x00dev->chip, RT2X00_CHIP_INTF_PCI);
+}
+
+static inline bool rt2x00_intf_is_usb(struct rt2x00_dev *rt2x00dev)
+{
+	return rt2x00_intf(&rt2x00dev->chip, RT2X00_CHIP_INTF_USB);
+}
+
 /**
  * rt2x00queue_map_txskb - Map a skb into DMA for TX purposes.
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
