Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4989 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab3DKL3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/15] brcmutil: add new d11 interface support
Date: Thu, 11 Apr 2013 13:28:49 +0200
Message-ID: <1365679740-25679-5-git-send-email-arend@broadcom.com> (sfid-20130411_132945_949017_AED9C01A)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

802.11 core interface is upgraded with 11ac support. Add channel spec support
code to brcmutil.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmutil/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmutil/d11.c      |  162 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/include/brcmu_d11.h |  145 ++++++++++++++++++
 3 files changed, 309 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmutil/d11.c
 create mode 100644 drivers/net/wireless/brcm80211/include/brcmu_d11.h

diff --git a/drivers/net/wireless/brcm80211/brcmutil/Makefile b/drivers/net/wireless/brcm80211/brcmutil/Makefile
index 6281c41..d7c4475 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmutil/Makefile
@@ -20,7 +20,8 @@ ccflags-y :=				\
 	-Idrivers/net/wireless/brcm80211/include
 
 BRCMUTIL_OFILES := \
-	utils.o
+	utils.o \
+	d11.o
 
 MODULEPFX := brcmutil
 
diff --git a/drivers/net/wireless/brcm80211/brcmutil/d11.c b/drivers/net/wireless/brcm80211/brcmutil/d11.c
new file mode 100644
index 0000000..30e54e2
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmutil/d11.c
@@ -0,0 +1,162 @@
+/*
+ * Copyright (c) 2013 Broadcom Corporation
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
+/*********************channel spec common functions*********************/
+
+#include <linux/module.h>
+
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
+#include <brcmu_d11.h>
+
+static void brcmu_d11n_encchspec(struct brcmu_chan *ch)
+{
+	ch->chspec = ch->chnum & BRCMU_CHSPEC_CH_MASK;
+
+	switch (ch->bw) {
+	case BRCMU_CHAN_BW_20:
+		ch->chspec |= BRCMU_CHSPEC_D11N_BW_20 | BRCMU_CHSPEC_D11N_SB_N;
+		break;
+	case BRCMU_CHAN_BW_40:
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	if (ch->chnum <= CH_MAX_2G_CHANNEL)
+		ch->chspec |= BRCMU_CHSPEC_D11N_BND_2G;
+	else
+		ch->chspec |= BRCMU_CHSPEC_D11N_BND_5G;
+}
+
+static void brcmu_d11ac_encchspec(struct brcmu_chan *ch)
+{
+	ch->chspec = ch->chnum & BRCMU_CHSPEC_CH_MASK;
+
+	switch (ch->bw) {
+	case BRCMU_CHAN_BW_20:
+		ch->chspec |= BRCMU_CHSPEC_D11AC_BW_20;
+		break;
+	case BRCMU_CHAN_BW_40:
+	case BRCMU_CHAN_BW_80:
+	case BRCMU_CHAN_BW_80P80:
+	case BRCMU_CHAN_BW_160:
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	if (ch->chnum <= CH_MAX_2G_CHANNEL)
+		ch->chspec |= BRCMU_CHSPEC_D11AC_BND_2G;
+	else
+		ch->chspec |= BRCMU_CHSPEC_D11AC_BND_5G;
+}
+
+static void brcmu_d11n_decchspec(struct brcmu_chan *ch)
+{
+	u16 val;
+
+	ch->chnum = (u8)(ch->chspec & BRCMU_CHSPEC_CH_MASK);
+
+	switch (ch->chspec & BRCMU_CHSPEC_D11N_BW_MASK) {
+	case BRCMU_CHSPEC_D11N_BW_20:
+		ch->bw = BRCMU_CHAN_BW_20;
+		break;
+	case BRCMU_CHSPEC_D11N_BW_40:
+		ch->bw = BRCMU_CHAN_BW_40;
+		val = ch->chspec & BRCMU_CHSPEC_D11N_SB_MASK;
+		if (val == BRCMU_CHSPEC_D11N_SB_L) {
+			ch->sb = BRCMU_CHAN_SB_L;
+			ch->chnum -= CH_10MHZ_APART;
+		} else {
+			ch->sb = BRCMU_CHAN_SB_U;
+			ch->chnum += CH_10MHZ_APART;
+		}
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	switch (ch->chspec & BRCMU_CHSPEC_D11N_BND_MASK) {
+	case BRCMU_CHSPEC_D11N_BND_5G:
+		ch->band = BRCMU_CHAN_BAND_5G;
+		break;
+	case BRCMU_CHSPEC_D11N_BND_2G:
+		ch->band = BRCMU_CHAN_BAND_2G;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+}
+
+static void brcmu_d11ac_decchspec(struct brcmu_chan *ch)
+{
+	u16 val;
+
+	ch->chnum = (u8)(ch->chspec & BRCMU_CHSPEC_CH_MASK);
+
+	switch (ch->chspec & BRCMU_CHSPEC_D11AC_BW_MASK) {
+	case BRCMU_CHSPEC_D11AC_BW_20:
+		ch->bw = BRCMU_CHAN_BW_20;
+		break;
+	case BRCMU_CHSPEC_D11AC_BW_40:
+		ch->bw = BRCMU_CHAN_BW_40;
+		val = ch->chspec & BRCMU_CHSPEC_D11AC_SB_MASK;
+		if (val == BRCMU_CHSPEC_D11AC_SB_L) {
+			ch->sb = BRCMU_CHAN_SB_L;
+			ch->chnum -= CH_10MHZ_APART;
+		} else if (val == BRCMU_CHSPEC_D11AC_SB_U) {
+			ch->sb = BRCMU_CHAN_SB_U;
+			ch->chnum += CH_10MHZ_APART;
+		} else {
+			WARN_ON_ONCE(1);
+		}
+		break;
+	case BRCMU_CHSPEC_D11AC_BW_80:
+		ch->bw = BRCMU_CHAN_BW_80;
+		break;
+	case BRCMU_CHSPEC_D11AC_BW_8080:
+	case BRCMU_CHSPEC_D11AC_BW_160:
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	switch (ch->chspec & BRCMU_CHSPEC_D11AC_BND_MASK) {
+	case BRCMU_CHSPEC_D11AC_BND_5G:
+		ch->band = BRCMU_CHAN_BAND_5G;
+		break;
+	case BRCMU_CHSPEC_D11AC_BND_2G:
+		ch->band = BRCMU_CHAN_BAND_2G;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+}
+
+void brcmu_d11_attach(struct brcmu_d11inf *d11inf)
+{
+	if (d11inf->io_type == BRCMU_D11N_IOTYPE) {
+		d11inf->encchspec = brcmu_d11n_encchspec;
+		d11inf->decchspec = brcmu_d11n_decchspec;
+	} else {
+		d11inf->encchspec = brcmu_d11ac_encchspec;
+		d11inf->decchspec = brcmu_d11ac_decchspec;
+	}
+}
+EXPORT_SYMBOL(brcmu_d11_attach);
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_d11.h b/drivers/net/wireless/brcm80211/include/brcmu_d11.h
new file mode 100644
index 0000000..92623f0
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/include/brcmu_d11.h
@@ -0,0 +1,145 @@
+/*
+ * Copyright (c) 2010 Broadcom Corporation
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
+#ifndef	_BRCMU_D11_H_
+#define	_BRCMU_D11_H_
+
+/* d11 io type */
+#define BRCMU_D11N_IOTYPE		1
+#define BRCMU_D11AC_IOTYPE		2
+
+/* A chanspec (channel specification) holds the channel number, band,
+ * bandwidth and control sideband
+ */
+
+/* chanspec binary format */
+
+#define BRCMU_CHSPEC_INVALID		255
+/* bit 0~7 channel number
+ * for 80+80 channels: bit 0~3 low channel id, bit 4~7 high channel id
+ */
+#define BRCMU_CHSPEC_CH_MASK		0x00ff
+#define BRCMU_CHSPEC_CH_SHIFT		0
+#define BRCMU_CHSPEC_CHL_MASK		0x000f
+#define BRCMU_CHSPEC_CHL_SHIFT		0
+#define BRCMU_CHSPEC_CHH_MASK		0x00f0
+#define BRCMU_CHSPEC_CHH_SHIFT		4
+
+/* bit 8~16 for dot 11n IO types
+ * bit 8~9 sideband
+ * bit 10~11 bandwidth
+ * bit 12~13 spectral band
+ * bit 14~15 not used
+ */
+#define BRCMU_CHSPEC_D11N_SB_MASK	0x0300
+#define BRCMU_CHSPEC_D11N_SB_SHIFT	8
+#define  BRCMU_CHSPEC_D11N_SB_L		0x0100	/* control lower */
+#define  BRCMU_CHSPEC_D11N_SB_U		0x0200	/* control upper */
+#define  BRCMU_CHSPEC_D11N_SB_N		0x0300	/* none */
+#define BRCMU_CHSPEC_D11N_BW_MASK	0x0c00
+#define BRCMU_CHSPEC_D11N_BW_SHIFT	10
+#define  BRCMU_CHSPEC_D11N_BW_10	0x0400
+#define  BRCMU_CHSPEC_D11N_BW_20	0x0800
+#define  BRCMU_CHSPEC_D11N_BW_40	0x0c00
+#define BRCMU_CHSPEC_D11N_BND_MASK	0x3000
+#define BRCMU_CHSPEC_D11N_BND_SHIFT	12
+#define  BRCMU_CHSPEC_D11N_BND_5G	0x1000
+#define  BRCMU_CHSPEC_D11N_BND_2G	0x2000
+
+/* bit 8~16 for dot 11ac IO types
+ * bit 8~10 sideband
+ * bit 11~13 bandwidth
+ * bit 14~15 spectral band
+ */
+#define BRCMU_CHSPEC_D11AC_SB_MASK	0x0700
+#define BRCMU_CHSPEC_D11AC_SB_SHIFT	8
+#define  BRCMU_CHSPEC_D11AC_SB_LLL	0x0000
+#define  BRCMU_CHSPEC_D11AC_SB_LLU	0x0100
+#define  BRCMU_CHSPEC_D11AC_SB_LUL	0x0200
+#define  BRCMU_CHSPEC_D11AC_SB_LUU	0x0300
+#define  BRCMU_CHSPEC_D11AC_SB_ULL	0x0400
+#define  BRCMU_CHSPEC_D11AC_SB_ULU	0x0500
+#define  BRCMU_CHSPEC_D11AC_SB_UUL	0x0600
+#define  BRCMU_CHSPEC_D11AC_SB_UUU	0x0700
+#define  BRCMU_CHSPEC_D11AC_SB_LL	BRCMU_CHSPEC_D11AC_SB_LLL
+#define  BRCMU_CHSPEC_D11AC_SB_LU	BRCMU_CHSPEC_D11AC_SB_LLU
+#define  BRCMU_CHSPEC_D11AC_SB_UL	BRCMU_CHSPEC_D11AC_SB_LUL
+#define  BRCMU_CHSPEC_D11AC_SB_UU	BRCMU_CHSPEC_D11AC_SB_LUU
+#define  BRCMU_CHSPEC_D11AC_SB_L	BRCMU_CHSPEC_D11AC_SB_LLL
+#define  BRCMU_CHSPEC_D11AC_SB_U	BRCMU_CHSPEC_D11AC_SB_LLU
+#define BRCMU_CHSPEC_D11AC_BW_MASK	0x3800
+#define BRCMU_CHSPEC_D11AC_BW_SHIFT	11
+#define  BRCMU_CHSPEC_D11AC_BW_5	0x0000
+#define  BRCMU_CHSPEC_D11AC_BW_10	0x0800
+#define  BRCMU_CHSPEC_D11AC_BW_20	0x1000
+#define  BRCMU_CHSPEC_D11AC_BW_40	0x1800
+#define  BRCMU_CHSPEC_D11AC_BW_80	0x2000
+#define  BRCMU_CHSPEC_D11AC_BW_160	0x2800
+#define  BRCMU_CHSPEC_D11AC_BW_8080	0x3000
+#define BRCMU_CHSPEC_D11AC_BND_MASK	0xc000
+#define BRCMU_CHSPEC_D11AC_BND_SHIFT	14
+#define  BRCMU_CHSPEC_D11AC_BND_2G	0x0000
+#define  BRCMU_CHSPEC_D11AC_BND_3G	0x4000
+#define  BRCMU_CHSPEC_D11AC_BND_4G	0x8000
+#define  BRCMU_CHSPEC_D11AC_BND_5G	0xc000
+
+#define BRCMU_CHAN_BAND_2G		0
+#define BRCMU_CHAN_BAND_5G		1
+
+enum brcmu_chan_bw {
+	BRCMU_CHAN_BW_20,
+	BRCMU_CHAN_BW_40,
+	BRCMU_CHAN_BW_80,
+	BRCMU_CHAN_BW_80P80,
+	BRCMU_CHAN_BW_160,
+};
+
+enum brcmu_chan_sb {
+	BRCMU_CHAN_SB_NONE = 0,
+	BRCMU_CHAN_SB_L,
+	BRCMU_CHAN_SB_U,
+	BRCMU_CHAN_SB_LL,
+	BRCMU_CHAN_SB_LU,
+	BRCMU_CHAN_SB_UL,
+	BRCMU_CHAN_SB_UU,
+	BRCMU_CHAN_SB_LLL,
+	BRCMU_CHAN_SB_LLU,
+	BRCMU_CHAN_SB_LUL,
+	BRCMU_CHAN_SB_LUU,
+	BRCMU_CHAN_SB_ULL,
+	BRCMU_CHAN_SB_ULU,
+	BRCMU_CHAN_SB_UUL,
+	BRCMU_CHAN_SB_UUU,
+};
+
+struct brcmu_chan {
+	u16 chspec;
+	u8 chnum;
+	u8 band;
+	enum brcmu_chan_bw bw;
+	enum brcmu_chan_sb sb;
+};
+
+struct brcmu_d11inf {
+	u8 io_type;
+
+	void (*encchspec)(struct brcmu_chan *ch);
+	void (*decchspec)(struct brcmu_chan *ch);
+};
+
+extern void brcmu_d11_attach(struct brcmu_d11inf *d11inf);
+
+#endif	/* _BRCMU_CHANNELS_H_ */
-- 
1.7.10.4


