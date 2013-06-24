Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46883 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab3FXVDd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 17:03:33 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 1/3] rt2x00: rt2800: increase EEPROM_SIZE to 512 bytes
Date: Mon, 24 Jun 2013 23:03:22 +0200
Message-Id: <1372107804-19679-2-git-send-email-juhosg@openwrt.org> (sfid-20130624_230339_027008_65D944FE)
In-Reply-To: <1372107804-19679-1-git-send-email-juhosg@openwrt.org>
References: <1372107804-19679-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ralink 3T chipsets are using a different EEPROM
layout than the others. The EEPROM on these devices
contain more data than the others which does not fit
into 272 byte which the rt2800 driver actually uses.

The Ralink reference driver defines EEPROM_SIZE to
512/1024 bytes for PCI/USB devices respectively.

Increase the EEPROM_SIZE constant to 512 bytes, in
order to make room for EEPROM data of 3T devices.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
Changes in v3: ---
Changes in v2: add Acked-by tags
---
 drivers/net/wireless/rt2x00/rt2800.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index fe43d01..d78c495 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -100,7 +100,7 @@
 #define CSR_REG_BASE			0x1000
 #define CSR_REG_SIZE			0x0800
 #define EEPROM_BASE			0x0000
-#define EEPROM_SIZE			0x0110
+#define EEPROM_SIZE			0x0200
 #define BBP_BASE			0x0000
 #define BBP_SIZE			0x00ff
 #define RF_BASE				0x0004
-- 
1.7.10

