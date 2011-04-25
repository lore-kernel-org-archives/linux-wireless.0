Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2562 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab1DYWpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 18:45:30 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	brudley@broadcom.com, henryp@broadcom.com, hharte@broadcom.com
Subject: [PATCH 1/7] staging: brcm80211: Add bcmchip.h
Date: Mon, 25 Apr 2011 15:45:07 -0700
Message-ID: <1303771513-18851-2-git-send-email-frankyl@broadcom.com> (sfid-20110426_004543_793374_5B6866AE)
In-Reply-To: <1303771513-18851-1-git-send-email-frankyl@broadcom.com>
References: <1303771513-18851-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcmchip.h contains chip specific core register base address and
address translation macro for core register access. This is
introduced for si/sb utils dependence removal in fullmac driver.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmchip.h |   34 ++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/brcm80211/brcmfmac/bcmchip.h

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmchip.h b/drivers/staging/brcm80211/brcmfmac/bcmchip.h
new file mode 100644
index 0000000..29eeee2
--- /dev/null
+++ b/drivers/staging/brcm80211/brcmfmac/bcmchip.h
@@ -0,0 +1,34 @@
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
+#ifndef _bcmchip_h_
+#define _bcmchip_h_
+
+/* Core reg address translation */
+#define CORE_CC_REG(base, field)	(base + offsetof(chipcregs_t, field))
+#define CORE_BUS_REG(base, field)	(base + offsetof(sdpcmd_regs_t, field))
+#define CORE_SB(base, field) \
+		(base + SBCONFIGOFF + offsetof(sbconfig_t, field))
+
+/* bcm4329 */
+/* SDIO device core, ID 0x829 */
+#define BCM4329_CORE_BUS_BASE		0x18011000
+/* internal memory core, ID 0x80e */
+#define BCM4329_CORE_SOCRAM_BASE	0x18003000
+/* ARM Cortex M3 core, ID 0x82a */
+#define BCM4329_CORE_ARM_BASE		0x18002000
+
+#endif				/* _bcmchip_h_ */
-- 
1.7.1


