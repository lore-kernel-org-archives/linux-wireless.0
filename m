Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39712 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab1HXLUt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 07:20:49 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat: add cordic lib
Date: Wed, 24 Aug 2011 13:20:38 +0200
Message-Id: <1314184839-13279-2-git-send-email-hauke@hauke-m.de> (sfid-20110824_132053_238998_321A9439)
In-Reply-To: <1314184839-13279-1-git-send-email-hauke@hauke-m.de>
References: <1314184839-13279-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat/cordic.c was copied from lib/cordic.c and include/linux/cordic.h was
copied from include/linux/cordic.h

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile        |    2 +
 compat/cordic.c        |  101 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cordic.h |   48 +++++++++++++++++++++++
 3 files changed, 151 insertions(+), 0 deletions(-)
 create mode 100644 compat/cordic.c
 create mode 100644 include/linux/cordic.h

diff --git a/compat/Makefile b/compat/Makefile
index 8e3739c..31e4459 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -34,4 +34,6 @@ compat-$(CONFIG_COMPAT_KERNEL_2_6_39) += \
 	compat-2.6.39.o \
 	kstrtox.o
 compat-$(CONFIG_COMPAT_KERNEL_3_0) += compat-3.0.o
+compat-$(CONFIG_COMPAT_KERNEL_3_1) += \
+	cordic.o
 
diff --git a/compat/cordic.c b/compat/cordic.c
new file mode 100644
index 0000000..aa27a88
--- /dev/null
+++ b/compat/cordic.c
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
+#include <linux/module.h>
+#include <linux/cordic.h>
+
+#define CORDIC_ANGLE_GEN	39797
+#define CORDIC_PRECISION_SHIFT	16
+#define	CORDIC_NUM_ITER		(CORDIC_PRECISION_SHIFT + 2)
+
+#define	FIXED(X)	((s32)((X) << CORDIC_PRECISION_SHIFT))
+#define	FLOAT(X)	(((X) >= 0) \
+		? ((((X) >> (CORDIC_PRECISION_SHIFT - 1)) + 1) >> 1) \
+		: -((((-(X)) >> (CORDIC_PRECISION_SHIFT - 1)) + 1) >> 1))
+
+static const s32 arctan_table[] = {
+	2949120,
+	1740967,
+	919879,
+	466945,
+	234379,
+	117304,
+	58666,
+	29335,
+	14668,
+	7334,
+	3667,
+	1833,
+	917,
+	458,
+	229,
+	115,
+	57,
+	29
+};
+
+/*
+ * cordic_calc_iq() - calculates the i/q coordinate for given angle
+ *
+ * theta: angle in degrees for which i/q coordinate is to be calculated
+ * coord: function output parameter holding the i/q coordinate
+ */
+struct cordic_iq cordic_calc_iq(s32 theta)
+{
+	struct cordic_iq coord;
+	s32 angle, valtmp;
+	unsigned iter;
+	int signx = 1;
+	int signtheta;
+
+	coord.i = CORDIC_ANGLE_GEN;
+	coord.q = 0;
+	angle = 0;
+
+	theta = FIXED(theta);
+	signtheta = (theta < 0) ? -1 : 1;
+	theta = ((theta + FIXED(180) * signtheta) % FIXED(360)) -
+		FIXED(180) * signtheta;
+
+	if (FLOAT(theta) > 90) {
+		theta -= FIXED(180);
+		signx = -1;
+	} else if (FLOAT(theta) < -90) {
+		theta += FIXED(180);
+		signx = -1;
+	}
+
+	for (iter = 0; iter < CORDIC_NUM_ITER; iter++) {
+		if (theta > angle) {
+			valtmp = coord.i - (coord.q >> iter);
+			coord.q += (coord.i >> iter);
+			angle += arctan_table[iter];
+		} else {
+			valtmp = coord.i + (coord.q >> iter);
+			coord.q -= (coord.i >> iter);
+			angle -= arctan_table[iter];
+		}
+		coord.i = valtmp;
+	}
+
+	coord.i *= signx;
+	coord.q *= signx;
+	return coord;
+}
+EXPORT_SYMBOL(cordic_calc_iq);
+
+MODULE_DESCRIPTION("Cordic functions");
+MODULE_AUTHOR("Broadcom Corporation");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/include/linux/cordic.h b/include/linux/cordic.h
new file mode 100644
index 0000000..f932093
--- /dev/null
+++ b/include/linux/cordic.h
@@ -0,0 +1,48 @@
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
+#ifndef __CORDIC_H_
+#define __CORDIC_H_
+
+#include <linux/types.h>
+
+/**
+ * struct cordic_iq - i/q coordinate.
+ *
+ * @i: real part of coordinate (in phase).
+ * @q: imaginary part of coordinate (quadrature).
+ */
+struct cordic_iq {
+	s32 i;
+	s32 q;
+};
+
+/**
+ * cordic_calc_iq() - calculates the i/q coordinate for given angle.
+ *
+ * @theta: angle in degrees for which i/q coordinate is to be calculated.
+ * @coord: function output parameter holding the i/q coordinate.
+ *
+ * The function calculates the i/q coordinate for a given angle using
+ * cordic algorithm. The coordinate consists of a real (i) and an
+ * imaginary (q) part. The real part is essentially the cosine of the
+ * angle and the imaginary part is the sine of the angle. The returned
+ * values are scaled by 2^16 for precision. The range for theta is
+ * for -180 degrees to +180 degrees. Passed values outside this range are
+ * converted before doing the actual calculation.
+ */
+struct cordic_iq cordic_calc_iq(s32 theta);
+
+#endif /* __CORDIC_H_ */
-- 
1.7.4.1

