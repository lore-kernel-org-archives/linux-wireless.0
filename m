Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24858 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbbKZLzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 06:55:38 -0500
Date: Thu, 26 Nov 2015 14:55:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] rt2x00: type bug in _rt2500usb_register_read()
Message-ID: <20151126115523.GD10556@mwanda> (sfid-20151126_125602_648789_FE200A98)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code causes a static checker bug.

drivers/net/wireless/ralink/rt2x00/rt2500usb.c:232 _rt2500usb_register_read()
warn: passing casted pointer 'value' to 'rt2500usb_register_read()' 32 vs 16.

If the low 16 bits were initialized to zero then this code would only be
a problem on big endian systems.  But in this case this is case the low
16 bits are never initialized.  This is called from a function which is
created using a macro:

RT2X00DEBUGFS_OPS(csr, "0x%.8x\n", u32);

We end up copying uninitialized data to the user which is bogus and an
information leak.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Not tested.  Perhaps we should just remove this code since it has never
worked.

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
index b50d873..d26018f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
@@ -229,7 +229,10 @@ static void _rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
 				     const unsigned int offset,
 				     u32 *value)
 {
-	rt2500usb_register_read(rt2x00dev, offset, (u16 *)value);
+	u16 tmp;
+
+	rt2500usb_register_read(rt2x00dev, offset, &tmp);
+	*value = tmp;
 }
 
 static void _rt2500usb_register_write(struct rt2x00_dev *rt2x00dev,
