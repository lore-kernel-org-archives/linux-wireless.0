Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:3418 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222Ab2H3Tkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 15:40:39 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 07/14] rt2x00: Fix rt2500usb rfkill polling prior to interface start.
Date: Thu, 30 Aug 2012 21:34:06 +0200
Message-Id: <1346355248-5331-8-git-send-email-gwingerde@gmail.com> (sfid-20120830_214055_317287_7AD2E222)
In-Reply-To: <1346355248-5331-7-git-send-email-gwingerde@gmail.com>
References: <1346355248-5331-1-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-2-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-3-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-4-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-5-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-6-git-send-email-gwingerde@gmail.com>
 <1346355248-5331-7-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to program the rfkill switch GPIO pin direction to input at
device initialization time, not only when the interface is brought up.
Doing this only when the interface is brought up could lead to rfkill
detecting the switch is turned on erroneously and inability to create
the interface and bringing it up.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 5742ce9..f95b551 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1768,6 +1768,7 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u16 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -1781,6 +1782,14 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
+	rt2x00_set_field16(&reg, MAC_CSR19_DIR0, 0);
+	rt2500usb_register_write(rt2x00dev, MAC_CSR19, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2500usb_probe_hw_mode(rt2x00dev);
-- 
1.7.11.1

