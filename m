Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2234 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161163Ab1FALqY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 24/83] staging: brcm80211: merged two header files into
 dhd_sdio.c
Date: Wed, 1 Jun 2011 13:45:09 +0200
Message-ID: <1306928768-7501-24-git-send-email-rvossen@broadcom.com> (sfid-20110601_134630_135378_60F5A329)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Decreasing number of header files.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |  100 +++++++++++++++++++++-
 drivers/staging/brcm80211/brcmfmac/rte_armtrap.h |   75 ----------------
 drivers/staging/brcm80211/brcmfmac/rte_cons.h    |   61 -------------
 3 files changed, 98 insertions(+), 138 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/rte_armtrap.h
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/rte_cons.h

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 6882c9f..9c5cfa7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -31,8 +31,104 @@
 
 #include <bcmsoc.h>
 #ifdef DHD_DEBUG
-#include <rte_armtrap.h>
-#include <rte_cons.h>
+
+/* ARM trap handling */
+
+/* Trap types defined by ARM (see arminc.h) */
+
+/* Trap locations in lo memory */
+#define	TRAP_STRIDE	4
+#define FIRST_TRAP	TR_RST
+#define LAST_TRAP	(TR_FIQ * TRAP_STRIDE)
+
+#if defined(__ARM_ARCH_4T__)
+#define	MAX_TRAP_TYPE	(TR_FIQ + 1)
+#elif defined(__ARM_ARCH_7M__)
+#define	MAX_TRAP_TYPE	(TR_ISR + ARMCM3_NUMINTS)
+#endif				/* __ARM_ARCH_7M__ */
+
+/* The trap structure is defined here as offsets for assembly */
+#define	TR_TYPE		0x00
+#define	TR_EPC		0x04
+#define	TR_CPSR		0x08
+#define	TR_SPSR		0x0c
+#define	TR_REGS		0x10
+#define	TR_REG(n)	(TR_REGS + (n) * 4)
+#define	TR_SP		TR_REG(13)
+#define	TR_LR		TR_REG(14)
+#define	TR_PC		TR_REG(15)
+
+#define	TRAP_T_SIZE	80
+
+#ifndef	_LANGUAGE_ASSEMBLY
+
+typedef struct _trap_struct {
+	u32 type;
+	u32 epc;
+	u32 cpsr;
+	u32 spsr;
+	u32 r0;
+	u32 r1;
+	u32 r2;
+	u32 r3;
+	u32 r4;
+	u32 r5;
+	u32 r6;
+	u32 r7;
+	u32 r8;
+	u32 r9;
+	u32 r10;
+	u32 r11;
+	u32 r12;
+	u32 r13;
+	u32 r14;
+	u32 pc;
+} trap_t;
+
+#endif				/* !_LANGUAGE_ASSEMBLY */
+
+#define CBUF_LEN	(128)
+
+#define LOG_BUF_LEN	1024
+
+typedef struct {
+	u32 buf;		/* Can't be pointer on (64-bit) hosts */
+	uint buf_size;
+	uint idx;
+	char *_buf_compat;	/* Redundant pointer for backward compat. */
+} rte_log_t;
+
+typedef struct {
+	/* Virtual UART
+	 * When there is no UART (e.g. Quickturn),
+	 * the host should write a complete
+	 * input line directly into cbuf and then write
+	 * the length into vcons_in.
+	 * This may also be used when there is a real UART
+	 * (at risk of conflicting with
+	 * the real UART).  vcons_out is currently unused.
+	 */
+	volatile uint vcons_in;
+	volatile uint vcons_out;
+
+	/* Output (logging) buffer
+	 * Console output is written to a ring buffer log_buf at index log_idx.
+	 * The host may read the output when it sees log_idx advance.
+	 * Output will be lost if the output wraps around faster than the host
+	 * polls.
+	 */
+	rte_log_t log;
+
+	/* Console input line buffer
+	 * Characters are read one at a time into cbuf
+	 * until <CR> is received, then
+	 * the buffer is processed as a command line.
+	 * Also used for virtual UART.
+	 */
+	uint cbuf_idx;
+	char cbuf[CBUF_LEN];
+} rte_cons_t;
+
 #endif				/* DHD_DEBUG */
 #include <sbchipc.h>
 #include <sbdma.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/rte_armtrap.h b/drivers/staging/brcm80211/brcmfmac/rte_armtrap.h
deleted file mode 100644
index ebb2237..0000000
--- a/drivers/staging/brcm80211/brcmfmac/rte_armtrap.h
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
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
-#ifndef	_rte_armtrap_h
-#define	_rte_armtrap_h
-
-/* ARM trap handling */
-
-/* Trap types defined by ARM (see arminc.h) */
-
-/* Trap locations in lo memory */
-#define	TRAP_STRIDE	4
-#define FIRST_TRAP	TR_RST
-#define LAST_TRAP	(TR_FIQ * TRAP_STRIDE)
-
-#if defined(__ARM_ARCH_4T__)
-#define	MAX_TRAP_TYPE	(TR_FIQ + 1)
-#elif defined(__ARM_ARCH_7M__)
-#define	MAX_TRAP_TYPE	(TR_ISR + ARMCM3_NUMINTS)
-#endif				/* __ARM_ARCH_7M__ */
-
-/* The trap structure is defined here as offsets for assembly */
-#define	TR_TYPE		0x00
-#define	TR_EPC		0x04
-#define	TR_CPSR		0x08
-#define	TR_SPSR		0x0c
-#define	TR_REGS		0x10
-#define	TR_REG(n)	(TR_REGS + (n) * 4)
-#define	TR_SP		TR_REG(13)
-#define	TR_LR		TR_REG(14)
-#define	TR_PC		TR_REG(15)
-
-#define	TRAP_T_SIZE	80
-
-#ifndef	_LANGUAGE_ASSEMBLY
-
-typedef struct _trap_struct {
-	u32 type;
-	u32 epc;
-	u32 cpsr;
-	u32 spsr;
-	u32 r0;
-	u32 r1;
-	u32 r2;
-	u32 r3;
-	u32 r4;
-	u32 r5;
-	u32 r6;
-	u32 r7;
-	u32 r8;
-	u32 r9;
-	u32 r10;
-	u32 r11;
-	u32 r12;
-	u32 r13;
-	u32 r14;
-	u32 pc;
-} trap_t;
-
-#endif				/* !_LANGUAGE_ASSEMBLY */
-
-#endif				/* _rte_armtrap_h */
diff --git a/drivers/staging/brcm80211/brcmfmac/rte_cons.h b/drivers/staging/brcm80211/brcmfmac/rte_cons.h
deleted file mode 100644
index 7977e08..0000000
--- a/drivers/staging/brcm80211/brcmfmac/rte_cons.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
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
-#ifndef _rte_cons_h
-#define _rte_cons_h
-
-#define CBUF_LEN	(128)
-
-#define LOG_BUF_LEN	1024
-
-typedef struct {
-	u32 buf;		/* Can't be pointer on (64-bit) hosts */
-	uint buf_size;
-	uint idx;
-	char *_buf_compat;	/* Redundant pointer for backward compat. */
-} rte_log_t;
-
-typedef struct {
-	/* Virtual UART
-	 * When there is no UART (e.g. Quickturn),
-	 * the host should write a complete
-	 * input line directly into cbuf and then write
-	 * the length into vcons_in.
-	 * This may also be used when there is a real UART
-	 * (at risk of conflicting with
-	 * the real UART).  vcons_out is currently unused.
-	 */
-	volatile uint vcons_in;
-	volatile uint vcons_out;
-
-	/* Output (logging) buffer
-	 * Console output is written to a ring buffer log_buf at index log_idx.
-	 * The host may read the output when it sees log_idx advance.
-	 * Output will be lost if the output wraps around faster than the host
-	 * polls.
-	 */
-	rte_log_t log;
-
-	/* Console input line buffer
-	 * Characters are read one at a time into cbuf
-	 * until <CR> is received, then
-	 * the buffer is processed as a command line.
-	 * Also used for virtual UART.
-	 */
-	uint cbuf_idx;
-	char cbuf[CBUF_LEN];
-} rte_cons_t;
-
-#endif /* _rte_cons_h */
-- 
1.7.4.1


