Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35602 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277AbbHJW01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 18:26:27 -0400
Received: by wicne3 with SMTP id ne3so38959344wic.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2015 15:26:26 -0700 (PDT)
From: Adrien Schildknecht <adrien+dev@schischi.me>
To: sgruszka@redhat.com, helmut.schaa@googlemail.com,
	kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Adrien Schildknecht <adrien+dev@schischi.me>
Subject: [PATCH] rt2x00: adjust EEPROM_SIZE for rt2500usb
Date: Tue, 11 Aug 2015 00:25:53 +0200
Message-Id: <1439245553-2840-1-git-send-email-adrien+dev@schischi.me> (sfid-20150811_002642_107864_3B7C3D96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2500usb_validate_eeprom() read data up to 0x6e (EEPROM_CALIBRATE_OFFSET)
but only 0x6a bytes has been allocated and read from the eeprom.

This lead to out-of-bound accesses and invalid values for
EEPROM_BBPTUNE_R17 and EEPROM_CALIBRATE_OFFSET.

Change the EEPROM_SIZE to 0x6e in order to retrieve all the fields.

Tested with a rt2570 device.

Signed-off-by: Adrien Schildknecht <adrien+dev@schischi.me>
---
 drivers/net/wireless/rt2x00/rt2500usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index afba073..78cc035 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -54,7 +54,7 @@
 #define CSR_REG_BASE			0x0400
 #define CSR_REG_SIZE			0x0100
 #define EEPROM_BASE			0x0000
-#define EEPROM_SIZE			0x006a
+#define EEPROM_SIZE			0x006e
 #define BBP_BASE			0x0000
 #define BBP_SIZE			0x0060
 #define RF_BASE				0x0004
-- 
2.5.0

