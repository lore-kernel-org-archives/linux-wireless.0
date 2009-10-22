Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:44931 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbZJVNe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:34:27 -0400
Message-Id: <20091022133403.169617620@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
Date: Thu, 22 Oct 2009 15:30:44 +0200
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 01/19] libertas spi: fix sparse errors
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the following sparse warnings:

$ make modules SUBDIRS=drivers/net/wireless/libertas C=1 CF=-D__CHECK_ENDIAN__
make: Entering directory `/usr/src/linux-wl'
  CHECK   drivers/net/wireless/libertas/if_spi.c
drivers/net/wireless/libertas/if_spi.c:137:16: warning: incorrect type in initializer (different base types)
drivers/net/wireless/libertas/if_spi.c:137:16:    expected unsigned short [unsigned] [usertype] reg_out
drivers/net/wireless/libertas/if_spi.c:137:16:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:191:16: warning: incorrect type in initializer (different base types)
drivers/net/wireless/libertas/if_spi.c:191:16:    expected unsigned short [unsigned] [usertype] reg_out
drivers/net/wireless/libertas/if_spi.c:191:16:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:256:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:256:24:    expected restricted __le32 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:256:24:    got unsigned int *<noident>
drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:171:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/if_spi.c:171:7:    expected unsigned short [unsigned] [usertype] buff
drivers/net/wireless/libertas/if_spi.c:171:7:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/libertas/if_spi.c:243:24: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/libertas/if_spi.c:243:24:    expected restricted __le16 const [usertype] *p
drivers/net/wireless/libertas/if_spi.c:243:24:    got unsigned short *<noident>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/if_spi.c
+++ linux-wl/drivers/net/wireless/libertas/if_spi.c
@@ -134,7 +134,7 @@
 static int spu_write(struct if_spi_card *card, u16 reg, const u8 *buf, int len)
 {
 	int err = 0;
-	u16 reg_out = cpu_to_le16(reg | IF_SPI_WRITE_OPERATION_MASK);
+	__le16 reg_out = cpu_to_le16(reg | IF_SPI_WRITE_OPERATION_MASK);
 	struct spi_message m;
 	struct spi_transfer reg_trans;
 	struct spi_transfer data_trans;
@@ -166,7 +166,7 @@
 
 static inline int spu_write_u16(struct if_spi_card *card, u16 reg, u16 val)
 {
-	u16 buff;
+	__le16 buff;
 
 	buff = cpu_to_le16(val);
 	return spu_write(card, reg, (u8 *)&buff, sizeof(u16));
@@ -188,7 +188,7 @@
 {
 	unsigned int delay;
 	int err = 0;
-	u16 reg_out = cpu_to_le16(reg | IF_SPI_READ_OPERATION_MASK);
+	__le16 reg_out = cpu_to_le16(reg | IF_SPI_READ_OPERATION_MASK);
 	struct spi_message m;
 	struct spi_transfer reg_trans;
 	struct spi_transfer dummy_trans;
@@ -235,7 +235,7 @@
 /* Read 16 bits from an SPI register */
 static inline int spu_read_u16(struct if_spi_card *card, u16 reg, u16 *val)
 {
-	u16 buf;
+	__le16 buf;
 	int ret;
 
 	ret = spu_read(card, reg, (u8 *)&buf, sizeof(buf));
@@ -248,7 +248,7 @@
  * The low 16 bits are read first. */
 static int spu_read_u32(struct if_spi_card *card, u16 reg, u32 *val)
 {
-	u32 buf;
+	__le32 buf;
 	int err;
 
 	err = spu_read(card, reg, (u8 *)&buf, sizeof(buf));

-- 
