Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:43967 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbZEVTTx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 15:19:53 -0400
Date: Fri, 22 May 2009 21:19:40 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-wireless@vger.kernel.org
Cc: andrey@cozybit.com, libertas-dev@lists.infradead.org
Subject: [PATCH] net/libertas: make SPI interface big endian aware
Message-ID: <20090522191940.GA3570@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The comment (which I remove) says that the translation is done SPI routines.
IMHO this can't work because the SPI driver does not know whether the incomming
bytes are part of the registers/bytes which need to be flipped or part of
packet data which has to remain untouched.
While adding le helpers I also removed spu_write_u32() which has no users.

Tested-by: Andrey Yurovsky <andrey@cozybit.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/libertas/if_spi.c |   34 +++++++++++++++----------------
 1 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 07311e7..8cf5d65 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -119,9 +119,6 @@ static struct chip_ident chip_id_to_device_name[] = {
  * First we have to put a SPU register name on the bus. Then we can
  * either read from or write to that register.
  *
- * For 16-bit transactions, byte order on the bus is big-endian.
- * We don't have to worry about that here, though.
- * The translation takes place in the SPI routines.
  */
 
 static void spu_transaction_init(struct if_spi_card *card)
@@ -147,7 +144,7 @@ static void spu_transaction_finish(struct if_spi_card *card)
 static int spu_write(struct if_spi_card *card, u16 reg, const u8 *buf, int len)
 {
 	int err = 0;
-	u16 reg_out = reg | IF_SPI_WRITE_OPERATION_MASK;
+	u16 reg_out = cpu_to_le16(reg | IF_SPI_WRITE_OPERATION_MASK);
 
 	/* You must give an even number of bytes to the SPU, even if it
 	 * doesn't care about the last one.  */
@@ -169,16 +166,10 @@ out:
 
 static inline int spu_write_u16(struct if_spi_card *card, u16 reg, u16 val)
 {
-	return spu_write(card, reg, (u8 *)&val, sizeof(u16));
-}
+	u16 buff;
 
-static inline int spu_write_u32(struct if_spi_card *card, u16 reg, u32 val)
-{
-	/* The lower 16 bits are written first. */
-	u16 out[2];
-	out[0] = val & 0xffff;
-	out[1] = (val & 0xffff0000) >> 16;
-	return spu_write(card, reg, (u8 *)&out, sizeof(u32));
+	buff = cpu_to_le16(val);
+	return spu_write(card, reg, (u8 *)&buff, sizeof(u16));
 }
 
 static inline int spu_reg_is_port_reg(u16 reg)
@@ -198,7 +189,7 @@ static int spu_read(struct if_spi_card *card, u16 reg, u8 *buf, int len)
 	unsigned int i, delay;
 	int err = 0;
 	u16 zero = 0;
-	u16 reg_out = reg | IF_SPI_READ_OPERATION_MASK;
+	u16 reg_out = cpu_to_le16(reg | IF_SPI_READ_OPERATION_MASK);
 
 	/* You must take an even number of bytes from the SPU, even if you
 	 * don't care about the last one.  */
@@ -236,18 +227,25 @@ out:
 /* Read 16 bits from an SPI register */
 static inline int spu_read_u16(struct if_spi_card *card, u16 reg, u16 *val)
 {
-	return spu_read(card, reg, (u8 *)val, sizeof(u16));
+	u16 buf;
+	int ret;
+
+	ret = spu_read(card, reg, (u8 *)&buf, sizeof(buf));
+	if (ret == 0)
+		*val = le16_to_cpup(&buf);
+	return ret;
 }
 
 /* Read 32 bits from an SPI register.
  * The low 16 bits are read first. */
 static int spu_read_u32(struct if_spi_card *card, u16 reg, u32 *val)
 {
-	u16 buf[2];
+	u32 buf;
 	int err;
-	err = spu_read(card, reg, (u8 *)buf, sizeof(u32));
+
+	err = spu_read(card, reg, (u8 *)&buf, sizeof(buf));
 	if (!err)
-		*val = buf[0] | (buf[1] << 16);
+		*val = le32_to_cpup(&buf);
 	return err;
 }
 
-- 
1.6.2.4

