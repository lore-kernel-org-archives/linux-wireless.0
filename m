Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4455 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab1F2Xss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 045/119] staging: brcm80211: remove unnecessary
 abstraction for scheduler
Date: Wed, 29 Jun 2011 16:47:09 -0700
Message-ID: <1309391303-22741-46-git-send-email-frankyl@broadcom.com> (sfid-20110630_015043_167605_449ECC61)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The source dhd_linux_sched.c provided function setScheduler, but it
simply calls sched_setscheduler() linux function. The setScheduler()
function has been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile        |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd.h           |    2 -
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    4 +-
 .../staging/brcm80211/brcmfmac/dhd_linux_sched.c   |   25 --------------------
 4 files changed, 2 insertions(+), 30 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_linux_sched.c

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index d907cae..4963155 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -45,7 +45,6 @@ DHDOFILES = \
 	dhd_custom_gpio.o \
 	dhd_sdio.o	\
 	dhd_linux.o \
-	dhd_linux_sched.o \
 	bcmsdh.o \
 	bcmsdh_linux.o	\
 	bcmsdh_sdmmc.o \
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 46381bb..bccda7f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -938,8 +938,6 @@ extern int write_to_file(dhd_pub_t *dhd, u8 *buf, int size);
 extern int dhd_customer_oob_irq_map(unsigned long *irq_flags_ptr);
 #endif				/* defined(OOB_INTR_ONLY) */
 
-int setScheduler(struct task_struct *p, int policy, struct sched_param *param);
-
 extern void dhd_timeout_start(dhd_timeout_t *tmo, uint usec);
 extern int dhd_timeout_expired(dhd_timeout_t *tmo);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 2d4e2c7..bebdd4d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1244,7 +1244,7 @@ static int dhd_watchdog_thread(void *data)
 		struct sched_param param;
 		param.sched_priority = (dhd_watchdog_prio < MAX_RT_PRIO) ?
 		    dhd_watchdog_prio : (MAX_RT_PRIO - 1);
-		setScheduler(current, SCHED_FIFO, &param);
+		sched_setscheduler(current, SCHED_FIFO, &param);
 	}
 #endif				/* DHD_SCHED */
 
@@ -1305,7 +1305,7 @@ static int dhd_dpc_thread(void *data)
 		param.sched_priority =
 		    (dhd_dpc_prio <
 		     MAX_RT_PRIO) ? dhd_dpc_prio : (MAX_RT_PRIO - 1);
-		setScheduler(current, SCHED_FIFO, &param);
+		sched_setscheduler(current, SCHED_FIFO, &param);
 	}
 #endif				/* DHD_SCHED */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux_sched.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux_sched.c
deleted file mode 100644
index c66f1c2..0000000
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux_sched.c
+++ /dev/null
@@ -1,25 +0,0 @@
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
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-
-int setScheduler(struct task_struct *p, int policy, struct sched_param *param)
-{
-	int rc = 0;
-	rc = sched_setscheduler(p, policy, param);
-	return rc;
-}
-- 
1.7.1


