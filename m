Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbXHSSbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:31:05 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446949ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:31:03 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/30] rt2x00: Cleanup set_state for rt61 and rt73
Date: Sun, 19 Aug 2007 20:27:15 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192027.15945.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 252c0576e50c72fed7a52777b5a4abf962b8ae43 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 13:08:09 +0200
Subject: [PATCH 16/30] rt2x00: Cleanup set_state for rt61 and rt73

The set_state was doing too much work for rt61 and rt73,
the additional registers that were set should be used
for Power Saving management and _not_ suspend/resume.
Since at the moment we don't support power management
we should remove the additional calls.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt61pci.c |   12 ------------
 drivers/net/wireless/rt73usb.c |    8 --------
 2 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index d0c2323..1a4957b 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -1423,18 +1423,6 @@ static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 	rt2x00_set_field32(&reg, MAC_CSR12_PUT_TO_SLEEP, put_to_sleep);
 	rt2x00pci_register_write(rt2x00dev, MAC_CSR12, reg);
 
-	if (put_to_sleep) {
-		rt2x00pci_register_write(rt2x00dev, SOFT_RESET_CSR, 0x00000005);
-		rt2x00pci_register_write(rt2x00dev, IO_CNTL_CSR, 0x0000001c);
-		rt2x00pci_register_write(rt2x00dev, PCI_USEC_CSR, 0x00000060);
-		rt61pci_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0x00, 0x00);
-	} else {
-		rt2x00pci_register_write(rt2x00dev, SOFT_RESET_CSR, 0x00000007);
-		rt2x00pci_register_write(rt2x00dev, IO_CNTL_CSR, 0x00000018);
-		rt2x00pci_register_write(rt2x00dev, PCI_USEC_CSR, 0x00000020);
-		rt61pci_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0x00, 0x00);
-	}
-
 	/*
 	 * Device is not guaranteed to be in the requested state yet.
 	 * We must wait until the register indicates that the
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 0d9c1b9..85dfc58 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -1156,19 +1156,11 @@ static int rt73usb_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 
 	put_to_sleep = (state != STATE_AWAKE);
 
-	if (!put_to_sleep)
-		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0x0000,
-					    USB_MODE_WAKEUP, REGISTER_TIMEOUT);
-
 	rt73usb_register_read(rt2x00dev, MAC_CSR12, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR12_FORCE_WAKEUP, !put_to_sleep);
 	rt2x00_set_field32(&reg, MAC_CSR12_PUT_TO_SLEEP, put_to_sleep);
 	rt73usb_register_write(rt2x00dev, MAC_CSR12, reg);
 
-	if (put_to_sleep)
-		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0x0000,
-					    USB_MODE_SLEEP, REGISTER_TIMEOUT);
-
 	/*
 	 * Device is not guaranteed to be in the requested state yet.
 	 * We must wait until the register indicates that the
-- 
1.5.3.rc5

