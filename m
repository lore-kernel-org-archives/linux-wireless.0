Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39724 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab1HXLUx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 07:20:53 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: add crc8 lib
Date: Wed, 24 Aug 2011 13:20:39 +0200
Message-Id: <1314184839-13279-3-git-send-email-hauke@hauke-m.de> (sfid-20110824_132112_847646_BB72B0AD)
In-Reply-To: <1314184839-13279-1-git-send-email-hauke@hauke-m.de>
References: <1314184839-13279-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat/crc8.c was copied from lib/crc8.c and include/linux/crc8.h was
copied from include/linux/crc8.h

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile      |    3 +-
 compat/crc8.c        |   86 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/crc8.h |  101 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 189 insertions(+), 1 deletions(-)
 create mode 100644 compat/crc8.c
 create mode 100644 include/linux/crc8.h

diff --git a/compat/Makefile b/compat/Makefile
index 31e4459..2fb1893 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -35,5 +35,6 @@ compat-$(CONFIG_COMPAT_KERNEL_2_6_39) += \
 	kstrtox.o
 compat-$(CONFIG_COMPAT_KERNEL_3_0) += compat-3.0.o
 compat-$(CONFIG_COMPAT_KERNEL_3_1) += \
-	cordic.o
+	cordic.o \
+	crc8.o
 
diff --git a/compat/crc8.c b/compat/crc8.c
new file mode 100644
index 0000000..87b59ca
--- /dev/null
+++ b/compat/crc8.c
@@ -0,0 +1,86 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/crc8.h>
+#include <linux/printk.h>
+
+/*
+ * crc8_populate_msb - fill crc table for given polynomial in reverse bit order.
+ *
+ * table:	table to be filled.
+ * polynomial:	polynomial for which table is to be filled.
+ */
+void crc8_populate_msb(u8 table[CRC8_TABLE_SIZE], u8 polynomial)
+{
+	int i, j;
+	const u8 msbit = 0x80;
+	u8 t = msbit;
+
+	table[0] = 0;
+
+	for (i = 1; i < CRC8_TABLE_SIZE; i *= 2) {
+		t = (t << 1) ^ (t & msbit ? polynomial : 0);
+		for (j = 0; j < i; j++)
+			table[i+j] = table[j] ^ t;
+	}
+}
+EXPORT_SYMBOL(crc8_populate_msb);
+
+/*
+ * crc8_populate_lsb - fill crc table for given polynomial in regular bit order.
+ *
+ * table:	table to be filled.
+ * polynomial:	polynomial for which table is to be filled.
+ */
+void crc8_populate_lsb(u8 table[CRC8_TABLE_SIZE], u8 polynomial)
+{
+	int i, j;
+	u8 t = 1;
+
+	table[0] = 0;
+
+	for (i = (CRC8_TABLE_SIZE >> 1); i; i >>= 1) {
+		t = (t >> 1) ^ (t & 1 ? polynomial : 0);
+		for (j = 0; j < CRC8_TABLE_SIZE; j += 2*i)
+			table[i+j] = table[j] ^ t;
+	}
+}
+EXPORT_SYMBOL(crc8_populate_lsb);
+
+/*
+ * crc8 - calculate a crc8 over the given input data.
+ *
+ * table: crc table used for calculation.
+ * pdata: pointer to data buffer.
+ * nbytes: number of bytes in data buffer.
+ * crc:	previous returned crc8 value.
+ */
+u8 crc8(const u8 table[CRC8_TABLE_SIZE], u8 *pdata, size_t nbytes, u8 crc)
+{
+	/* loop over the buffer data */
+	while (nbytes-- > 0)
+		crc = table[(crc ^ *pdata++) & 0xff];
+
+	return crc;
+}
+EXPORT_SYMBOL(crc8);
+
+MODULE_DESCRIPTION("CRC8 (by Williams, Ross N.) function");
+MODULE_AUTHOR("Broadcom Corporation");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/include/linux/crc8.h b/include/linux/crc8.h
new file mode 100644
index 0000000..13c8dab
--- /dev/null
+++ b/include/linux/crc8.h
@@ -0,0 +1,101 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef __CRC8_H_
+#define __CRC8_H_
+
+#include <linux/types.h>
+
+/* see usage of this value in crc8() description */
+#define CRC8_INIT_VALUE		0xFF
+
+/*
+ * Return value of crc8() indicating valid message+crc. This is true
+ * if a CRC is inverted before transmission. The CRC computed over the
+ * whole received bitstream is _table[x], where x is the bit pattern
+ * of the modification (almost always 0xff).
+ */
+#define CRC8_GOOD_VALUE(_table)	(_table[0xFF])
+
+/* required table size for crc8 algorithm */
+#define CRC8_TABLE_SIZE			256
+
+/* helper macro assuring right table size is used */
+#define DECLARE_CRC8_TABLE(_table) \
+	static u8 _table[CRC8_TABLE_SIZE]
+
+/**
+ * crc8_populate_lsb - fill crc table for given polynomial in regular bit order.
+ *
+ * @table:	table to be filled.
+ * @polynomial:	polynomial for which table is to be filled.
+ *
+ * This function fills the provided table according the polynomial provided for
+ * regular bit order (lsb first). Polynomials in CRC algorithms are typically
+ * represented as shown below.
+ *
+ *	poly = x^8 + x^7 + x^6 + x^4 + x^2 + 1
+ *
+ * For lsb first direction x^7 maps to the lsb. So the polynomial is as below.
+ *
+ * - lsb first: poly = 10101011(1) = 0xAB
+ */
+void crc8_populate_lsb(u8 table[CRC8_TABLE_SIZE], u8 polynomial);
+
+/**
+ * crc8_populate_msb - fill crc table for given polynomial in reverse bit order.
+ *
+ * @table:	table to be filled.
+ * @polynomial:	polynomial for which table is to be filled.
+ *
+ * This function fills the provided table according the polynomial provided for
+ * reverse bit order (msb first). Polynomials in CRC algorithms are typically
+ * represented as shown below.
+ *
+ *	poly = x^8 + x^7 + x^6 + x^4 + x^2 + 1
+ *
+ * For msb first direction x^7 maps to the msb. So the polynomial is as below.
+ *
+ * - msb first: poly = (1)11010101 = 0xD5
+ */
+void crc8_populate_msb(u8 table[CRC8_TABLE_SIZE], u8 polynomial);
+
+/**
+ * crc8() - calculate a crc8 over the given input data.
+ *
+ * @table:	crc table used for calculation.
+ * @pdata:	pointer to data buffer.
+ * @nbytes:	number of bytes in data buffer.
+ * @crc:	previous returned crc8 value.
+ *
+ * The CRC8 is calculated using the polynomial given in crc8_populate_msb()
+ * or crc8_populate_lsb().
+ *
+ * The caller provides the initial value (either %CRC8_INIT_VALUE
+ * or the previous returned value) to allow for processing of
+ * discontiguous blocks of data.  When generating the CRC the
+ * caller is responsible for complementing the final return value
+ * and inserting it into the byte stream.  When validating a byte
+ * stream (including CRC8), a final return value of %CRC8_GOOD_VALUE
+ * indicates the byte stream data can be considered valid.
+ *
+ * Reference:
+ * "A Painless Guide to CRC Error Detection Algorithms", ver 3, Aug 1993
+ * Williams, Ross N., ross<at>ross.net
+ * (see URL http://www.ross.net/crc/download/crc_v3.txt).
+ */
+u8 crc8(const u8 table[CRC8_TABLE_SIZE], u8 *pdata, size_t nbytes, u8 crc);
+
+#endif /* __CRC8_H_ */
-- 
1.7.4.1

