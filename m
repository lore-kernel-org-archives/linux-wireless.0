Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4962 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563Ab2H3VEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 17:04:36 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 14/17] rt2x00: Fix rt73usb rfkill polling prior to interface start.
Date: Thu, 30 Aug 2012 23:04:26 +0200
Message-Id: <1346360670-6498-9-git-send-email-gwingerde@gmail.com> (sfid-20120830_230500_753057_52C19E4C)
In-Reply-To: <1346360670-6498-8-git-send-email-gwingerde@gmail.com>
References: <1346355248-5331-10-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-1-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-2-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-3-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-4-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-5-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-6-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-7-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-8-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to program the rfkill switch GPIO pin direction to input at
device initialization time, not only when the interface is brought up.
Doing this only when the interface is brought up could lead to rfkill
detecting the switch is turned on erroneously and inability to create
the interface and bringing it up.

Reported-and-tested-by: Andreas Messer <andi@bastelmap.de>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d5b6fb8..cfa9f37 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2177,6 +2177,7 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -2190,6 +2191,14 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00usb_register_read(rt2x00dev, MAC_CSR13, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR13_DIR7, 0);
+	rt2x00usb_register_write(rt2x00dev, MAC_CSR13, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt73usb_probe_hw_mode(rt2x00dev);
-- 
1.7.11.1

