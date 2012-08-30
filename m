Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:1728 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab2H3VEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 17:04:39 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 13/14] rt2x00: Fix rt2800 rfkill polling prior to interface start.
Date: Thu, 30 Aug 2012 23:04:25 +0200
Message-Id: <1346360670-6498-8-git-send-email-gwingerde@gmail.com> (sfid-20120830_230451_299492_F86F31D0)
In-Reply-To: <1346360670-6498-7-git-send-email-gwingerde@gmail.com>
References: <1346355248-5331-10-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-1-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-2-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-3-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-4-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-5-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-6-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-7-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to program the rfkill switch GPIO pin direction to input at
device initialization time, not only when the interface is brought up.
Doing this only when the interface is brought up could lead to rfkill
detecting the switch is turned on erroneously and inability to create
the interface and bringing it up.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 98aa426..0965540 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -983,6 +983,7 @@ static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -996,6 +997,14 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, GPIO_CTRL, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_DIR2, 1);
+	rt2x00pci_register_write(rt2x00dev, GPIO_CTRL, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2800_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6681bfc..5390632 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -736,6 +736,7 @@ static int rt2800usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -749,6 +750,14 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00usb_register_read(rt2x00dev, GPIO_CTRL, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_DIR2, 1);
+	rt2x00usb_register_write(rt2x00dev, GPIO_CTRL, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2800_probe_hw_mode(rt2x00dev);
-- 
1.7.11.1

