Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3870 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758851Ab1FALqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:35 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 53/83] staging: brcm80211: absorb msgtrace.h in fullmac
Date: Wed, 1 Jun 2011 13:45:38 +0200
Message-ID: <1306928768-7501-53-git-send-email-rvossen@broadcom.com> (sfid-20110601_134901_362708_3C524FCD)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Absorb msgtrace.h into dhd_common.c

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |   28 +++++++++--
 drivers/staging/brcm80211/brcmfmac/msgtrace.h   |   61 -----------------------
 2 files changed, 23 insertions(+), 66 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/msgtrace.h

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 79df125..22e5efd 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -26,7 +26,6 @@
 #include <dhd_bus.h>
 #include <dhd_proto.h>
 #include <dhd_dbg.h>
-#include <msgtrace.h>
 
 #define BRCM_OUI		"\x00\x10\x18"
 #define DOT11_OUI_LEN			3
@@ -57,6 +56,8 @@ void dhd_iscan_unlock(void);
 #endif
 
 #define EPI_VERSION_STR         "4.218.248.5"
+#define MSGTRACE_VERSION	1
+
 #ifdef DHD_DEBUG
 const char dhd_version[] =
 "Dongle Host Driver, version " EPI_VERSION_STR "\nCompiled on " __DATE__
@@ -118,6 +119,22 @@ const bcm_iovar_t dhd_iovars[] = {
 	{NULL, 0, 0, 0, 0}
 };
 
+/* Message trace header */
+struct msgtrace_hdr {
+	u8 version;
+	u8 spare;
+	u16 len;		/* Len of the trace */
+	u32 seqnum;		/* Sequence number of message. Useful
+				 * if the messsage has been lost
+				 * because of DMA error or a bus reset
+				 * (ex: SDIO Func2)
+				 */
+	u32 discarded_bytes;	/* Number of discarded bytes because of
+				 trace overflow  */
+	u32 discarded_printf;	/* Number of discarded printf
+				 because of trace overflow */
+} __packed;
+
 void dhd_common_init(void)
 {
 	/* Init global variables at run-time, not as part of the declaration.
@@ -732,12 +749,12 @@ static void wl_show_host_event(wl_event_msg_t *event, void *event_data)
 	case WLC_E_TRACE:
 		{
 			static u32 seqnum_prev;
-			msgtrace_hdr_t hdr;
+			struct msgtrace_hdr hdr;
 			u32 nblost;
 			char *s, *p;
 
 			buf = (unsigned char *) event_data;
-			memcpy(&hdr, buf, MSGTRACE_HDRLEN);
+			memcpy(&hdr, buf, sizeof(struct msgtrace_hdr));
 
 			if (hdr.version != MSGTRACE_VERSION) {
 				DHD_ERROR(
@@ -751,7 +768,8 @@ static void wl_show_host_event(wl_event_msg_t *event, void *event_data)
 			}
 
 			/* There are 2 bytes available at the end of data */
-			buf[MSGTRACE_HDRLEN + be16_to_cpu(hdr.len)] = '\0';
+			*(buf + sizeof(struct msgtrace_hdr)
+				 + be16_to_cpu(hdr.len)) = '\0';
 
 			if (be32_to_cpu(hdr.discarded_bytes)
 			    || be32_to_cpu(hdr.discarded_printf)) {
@@ -774,7 +792,7 @@ static void wl_show_host_event(wl_event_msg_t *event, void *event_data)
 			 * avoid display big
 			 * printf (issue with Linux printk )
 			 */
-			p = (char *)&buf[MSGTRACE_HDRLEN];
+			p = (char *)&buf[sizeof(struct msgtrace_hdr)];
 			while ((s = strstr(p, "\n")) != NULL) {
 				*s = '\0';
 				printk(KERN_DEBUG"%s\n", p);
diff --git a/drivers/staging/brcm80211/brcmfmac/msgtrace.h b/drivers/staging/brcm80211/brcmfmac/msgtrace.h
deleted file mode 100644
index d654671..0000000
--- a/drivers/staging/brcm80211/brcmfmac/msgtrace.h
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
-
-#ifndef	_MSGTRACE_H
-#define	_MSGTRACE_H
-
-#define MSGTRACE_VERSION 1
-
-/* Message trace header */
-typedef struct msgtrace_hdr {
-	u8 version;
-	u8 spare;
-	u16 len;		/* Len of the trace */
-	u32 seqnum;		/* Sequence number of message. Useful
-				 * if the messsage has been lost
-				 * because of DMA error or a bus reset
-				 * (ex: SDIO Func2)
-				 */
-	u32 discarded_bytes;	/* Number of discarded bytes because of
-				 trace overflow  */
-	u32 discarded_printf;	/* Number of discarded printf
-				 because of trace overflow */
-} __attribute__((packed)) msgtrace_hdr_t;
-
-#define MSGTRACE_HDRLEN		sizeof(msgtrace_hdr_t)
-
-/* The hbus driver generates traces when sending a trace message.
- * This causes endless traces.
- * This flag must be set to true in any hbus traces.
- * The flag is reset in the function msgtrace_put.
- * This prevents endless traces but generates hasardous
- * lost of traces only in bus device code.
- * It is recommendat to set this flag in macro SD_TRACE
- * but not in SD_ERROR for avoiding missing
- * hbus error traces. hbus error trace should not generates endless traces.
- */
-extern bool msgtrace_hbus_trace;
-
-typedef void (*msgtrace_func_send_t) (void *hdl1, void *hdl2, u8 *hdr,
-				      u16 hdrlen, u8 *buf,
-				      u16 buflen);
-
-extern void msgtrace_sent(void);
-extern void msgtrace_put(char *buf, int count);
-extern void msgtrace_init(void *hdl1, void *hdl2,
-			  msgtrace_func_send_t func_send);
-
-#endif				/* _MSGTRACE_H */
-- 
1.7.4.1


