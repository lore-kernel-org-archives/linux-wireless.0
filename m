Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46717 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab1KRTo1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 14:44:27 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: remove crc8 and cordic lib
Date: Fri, 18 Nov 2011 20:44:17 +0100
Message-Id: <1321645457-26438-1-git-send-email-hauke@hauke-m.de> (sfid-20111118_204429_790017_2104DD6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two libs are now fetched by compat-wireless directly form the kernel.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile        |    3 -
 compat/cordic.c        |  101 ------------------------------------------------
 compat/crc8.c          |   86 ----------------------------------------
 include/linux/cordic.h |   48 -----------------------
 include/linux/crc8.h   |  101 ------------------------------------------------
 5 files changed, 0 insertions(+), 339 deletions(-)
 delete mode 100644 compat/cordic.c
 delete mode 100644 compat/crc8.c
 delete mode 100644 include/linux/cordic.h
 delete mode 100644 include/linux/crc8.h

diff --git a/compat/Makefile b/compat/Makefile
index fc43ba1..31985f7 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -34,7 +34,4 @@ compat-$(CONFIG_COMPAT_KERNEL_2_6_39) += \
 	compat-2.6.39.o \
 	kstrtox.o
 compat-$(CONFIG_COMPAT_KERNEL_3_0) += compat-3.0.o
-compat-$(CONFIG_COMPAT_KERNEL_3_1) += \
-	cordic.o \
-	crc8.o
 
diff --git a/compat/cordic.c b/compat/cordic.c
deleted file mode 100644
index aa27a88..0000000
--- a/compat/cordic.c
+++ /dev/null
@@ -1,101 +0,0 @@
-/*
- * Copyright (c) 2011 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-#include <linux/module.h>
-#include <linux/cordic.h>
-
-#define CORDIC_ANGLE_GEN	39797
-#define CORDIC_PRECISION_SHIFT	16
-#define	CORDIC_NUM_ITER		(CORDIC_PRECISION_SHIFT + 2)
-
-#define	FIXED(X)	((s32)((X) << CORDIC_PRECISION_SHIFT))
-#define	FLOAT(X)	(((X) >= 0) \
-		? ((((X) >> (CORDIC_PRECISION_SHIFT - 1)) + 1) >> 1) \
-		: -((((-(X)) >> (CORDIC_PRECISION_SHIFT - 1)) + 1) >> 1))
-
-static const s32 arctan_table[] = {
-	2949120,
-	1740967,
-	919879,
-	466945,
-	234379,
-	117304,
-	58666,
-	29335,
-	14668,
-	7334,
-	3667,
-	1833,
-	917,
-	458,
-	229,
-	115,
-	57,
-	29
-};
-
-/*
- * cordic_calc_iq() - calculates the i/q coordinate for given angle
- *
- * theta: angle in degrees for which i/q coordinate is to be calculated
- * coord: function output parameter holding the i/q coordinate
- */
-struct cordic_iq cordic_calc_iq(s32 theta)
-{
-	struct cordic_iq coord;
-	s32 angle, valtmp;
-	unsigned iter;
-	int signx = 1;
-	int signtheta;
-
-	coord.i = CORDIC_ANGLE_GEN;
-	coord.q = 0;
-	angle = 0;
-
-	theta = FIXED(theta);
-	signtheta = (theta < 0) ? -1 : 1;
-	theta = ((theta + FIXED(180) * signtheta) % FIXED(360)) -
-		FIXED(180) * signtheta;
-
-	if (FLOAT(theta) > 90) {
-		theta -= FIXED(180);
-		signx = -1;
-	} else if (FLOAT(theta) < -90) {
-		theta += FIXED(180);
-		signx = -1;
-	}
-
-	for (iter = 0; iter < CORDIC_NUM_ITER; iter++) {
-		if (theta > angle) {
-			valtmp = coord.i - (coord.q >> iter);
-			coord.q += (coord.i >> iter);
-			angle += arctan_table[iter];
-		} else {
-			valtmp = coord.i + (coord.q >> iter);
-			coord.q -= (coord.i >> iter);
-			angle -= arctan_table[iter];
-		}
-		coord.i = valtmp;
-	}
-
-	coord.i *= signx;
-	coord.q *= signx;
-	return coord;
-}
-EXPORT_SYMBOL(cordic_calc_iq);
-
-MODULE_DESCRIPTION("Cordic functions");
-MODULE_AUTHOR("Broadcom Corporation");
-MODULE_LICENSE("Dual BSD/GPL");
diff --git a/compat/crc8.c b/compat/crc8.c
deleted file mode 100644
index 87b59ca..0000000
--- a/compat/crc8.c
+++ /dev/null
@@ -1,86 +0,0 @@
-/*
- * Copyright (c) 2011 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/crc8.h>
-#include <linux/printk.h>
-
-/*
- * crc8_populate_msb - fill crc table for given polynomial in reverse bit order.
- *
- * table:	table to be filled.
- * polynomial:	polynomial for which table is to be filled.
- */
-void crc8_populate_msb(u8 table[CRC8_TABLE_SIZE], u8 polynomial)
-{
-	int i, j;
-	const u8 msbit = 0x80;
-	u8 t = msbit;
-
-	table[0] = 0;
-
-	for (i = 1; i < CRC8_TABLE_SIZE; i *= 2) {
-		t = (t << 1) ^ (t & msbit ? polynomial : 0);
-		for (j = 0; j < i; j++)
-			table[i+j] = table[j] ^ t;
-	}
-}
-EXPORT_SYMBOL(crc8_populate_msb);
-
-/*
- * crc8_populate_lsb - fill crc table for given polynomial in regular bit order.
- *
- * table:	table to be filled.
- * polynomial:	polynomial for which table is to be filled.
- */
-void crc8_populate_lsb(u8 table[CRC8_TABLE_SIZE], u8 polynomial)
-{
-	int i, j;
-	u8 t = 1;
-
-	table[0] = 0;
-
-	for (i = (CRC8_TABLE_SIZE >> 1); i; i >>= 1) {
-		t = (t >> 1) ^ (t & 1 ? polynomial : 0);
-		for (j = 0; j < CRC8_TABLE_SIZE; j += 2*i)
-			table[i+j] = table[j] ^ t;
-	}
-}
-EXPORT_SYMBOL(crc8_populate_lsb);
-
-/*
- * crc8 - calculate a crc8 over the given input data.
- *
- * table: crc table used for calculation.
- * pdata: pointer to data buffer.
- * nbytes: number of bytes in data buffer.
- * crc:	previous returned crc8 value.
- */
-u8 crc8(const u8 table[CRC8_TABLE_SIZE], u8 *pdata, size_t nbytes, u8 crc)
-{
-	/* loop over the buffer data */
-	while (nbytes-- > 0)
-		crc = table[(crc ^ *pdata++) & 0xff];
-
-	return crc;
-}
-EXPORT_SYMBOL(crc8);
-
-MODULE_DESCRIPTION("CRC8 (by Williams, Ross N.) function");
-MODULE_AUTHOR("Broadcom Corporation");
-MODULE_LICENSE("Dual BSD/GPL");
diff --git a/include/linux/cordic.h b/include/linux/cordic.h
deleted file mode 100644
index f932093..0000000
--- a/include/linux/cordic.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
- * Copyright (c) 2011 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-#ifndef __CORDIC_H_
-#define __CORDIC_H_
-
-#include <linux/types.h>
-
-/**
- * struct cordic_iq - i/q coordinate.
- *
- * @i: real part of coordinate (in phase).
- * @q: imaginary part of coordinate (quadrature).
- */
-struct cordic_iq {
-	s32 i;
-	s32 q;
-};
-
-/**
- * cordic_calc_iq() - calculates the i/q coordinate for given angle.
- *
- * @theta: angle in degrees for which i/q coordinate is to be calculated.
- * @coord: function output parameter holding the i/q coordinate.
- *
- * The function calculates the i/q coordinate for a given angle using
- * cordic algorithm. The coordinate consists of a real (i) and an
- * imaginary (q) part. The real part is essentially the cosine of the
- * angle and the imaginary part is the sine of the angle. The returned
- * values are scaled by 2^16 for precision. The range for theta is
- * for -180 degrees to +180 degrees. Passed values outside this range are
- * converted before doing the actual calculation.
- */
-struct cordic_iq cordic_calc_iq(s32 theta);
-
-#endif /* __CORDIC_H_ */
diff --git a/include/linux/crc8.h b/include/linux/crc8.h
deleted file mode 100644
index 13c8dab..0000000
--- a/include/linux/crc8.h
+++ /dev/null
@@ -1,101 +0,0 @@
-/*
- * Copyright (c) 2011 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-#ifndef __CRC8_H_
-#define __CRC8_H_
-
-#include <linux/types.h>
-
-/* see usage of this value in crc8() description */
-#define CRC8_INIT_VALUE		0xFF
-
-/*
- * Return value of crc8() indicating valid message+crc. This is true
- * if a CRC is inverted before transmission. The CRC computed over the
- * whole received bitstream is _table[x], where x is the bit pattern
- * of the modification (almost always 0xff).
- */
-#define CRC8_GOOD_VALUE(_table)	(_table[0xFF])
-
-/* required table size for crc8 algorithm */
-#define CRC8_TABLE_SIZE			256
-
-/* helper macro assuring right table size is used */
-#define DECLARE_CRC8_TABLE(_table) \
-	static u8 _table[CRC8_TABLE_SIZE]
-
-/**
- * crc8_populate_lsb - fill crc table for given polynomial in regular bit order.
- *
- * @table:	table to be filled.
- * @polynomial:	polynomial for which table is to be filled.
- *
- * This function fills the provided table according the polynomial provided for
- * regular bit order (lsb first). Polynomials in CRC algorithms are typically
- * represented as shown below.
- *
- *	poly = x^8 + x^7 + x^6 + x^4 + x^2 + 1
- *
- * For lsb first direction x^7 maps to the lsb. So the polynomial is as below.
- *
- * - lsb first: poly = 10101011(1) = 0xAB
- */
-void crc8_populate_lsb(u8 table[CRC8_TABLE_SIZE], u8 polynomial);
-
-/**
- * crc8_populate_msb - fill crc table for given polynomial in reverse bit order.
- *
- * @table:	table to be filled.
- * @polynomial:	polynomial for which table is to be filled.
- *
- * This function fills the provided table according the polynomial provided for
- * reverse bit order (msb first). Polynomials in CRC algorithms are typically
- * represented as shown below.
- *
- *	poly = x^8 + x^7 + x^6 + x^4 + x^2 + 1
- *
- * For msb first direction x^7 maps to the msb. So the polynomial is as below.
- *
- * - msb first: poly = (1)11010101 = 0xD5
- */
-void crc8_populate_msb(u8 table[CRC8_TABLE_SIZE], u8 polynomial);
-
-/**
- * crc8() - calculate a crc8 over the given input data.
- *
- * @table:	crc table used for calculation.
- * @pdata:	pointer to data buffer.
- * @nbytes:	number of bytes in data buffer.
- * @crc:	previous returned crc8 value.
- *
- * The CRC8 is calculated using the polynomial given in crc8_populate_msb()
- * or crc8_populate_lsb().
- *
- * The caller provides the initial value (either %CRC8_INIT_VALUE
- * or the previous returned value) to allow for processing of
- * discontiguous blocks of data.  When generating the CRC the
- * caller is responsible for complementing the final return value
- * and inserting it into the byte stream.  When validating a byte
- * stream (including CRC8), a final return value of %CRC8_GOOD_VALUE
- * indicates the byte stream data can be considered valid.
- *
- * Reference:
- * "A Painless Guide to CRC Error Detection Algorithms", ver 3, Aug 1993
- * Williams, Ross N., ross<at>ross.net
- * (see URL http://www.ross.net/crc/download/crc_v3.txt).
- */
-u8 crc8(const u8 table[CRC8_TABLE_SIZE], u8 *pdata, size_t nbytes, u8 crc);
-
-#endif /* __CRC8_H_ */
-- 
1.7.4.1

