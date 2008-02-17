Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:31670 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbYBQQhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 11:37:14 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1391939fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2008 08:37:12 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 10/11] rt2x00: Fix MAC address defines in rt61pci
Date: Sun, 17 Feb 2008 17:36:33 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802171730.44353.IvDoorn@gmail.com>
In-Reply-To: <200802171730.44353.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802171736.33183.IvDoorn@gmail.com> (sfid-20080217_164719_746912_0EBC499D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MAC address offset defines were incorrect because
the byte offset was used instead of word index. This
bug had no affect on normal operations since these
defines weren't used. (EEPROM_MAC_ADDR_0 was used
to read 6 bytes from).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 4ef7ef3..3511bba 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -1130,10 +1130,10 @@ struct hw_pairwise_ta_entry {
 #define EEPROM_MAC_ADDR_0		0x0002
 #define EEPROM_MAC_ADDR_BYTE0		FIELD16(0x00ff)
 #define EEPROM_MAC_ADDR_BYTE1		FIELD16(0xff00)
-#define EEPROM_MAC_ADDR1		0x0004
+#define EEPROM_MAC_ADDR1		0x0003
 #define EEPROM_MAC_ADDR_BYTE2		FIELD16(0x00ff)
 #define EEPROM_MAC_ADDR_BYTE3		FIELD16(0xff00)
-#define EEPROM_MAC_ADDR_2		0x0006
+#define EEPROM_MAC_ADDR_2		0x0004
 #define EEPROM_MAC_ADDR_BYTE4		FIELD16(0x00ff)
 #define EEPROM_MAC_ADDR_BYTE5		FIELD16(0xff00)
 
-- 
1.5.4

