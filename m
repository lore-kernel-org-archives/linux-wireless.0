Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1211 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163Ab1JDVTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:36 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/26] staging: brcm80211: remove brcmu_bprintf and
 related functions
Date: Tue, 4 Oct 2011 23:18:50 +0200
Message-ID: <1317763152-17607-5-git-send-email-arend@broadcom.com> (sfid-20111004_232038_366220_20474CEF)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions brcmu_bprintf and brcmu_binit could be replaced by
snprintf kernel function. These are no longer used in both brcm80211
drivers so they have been removed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/types.h      |    1 -
 drivers/staging/brcm80211/brcmutil/utils.c      |   34 -----------------------
 drivers/staging/brcm80211/include/brcmu_utils.h |   15 ----------
 3 files changed, 0 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 23969fe..27a814b 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -329,7 +329,6 @@ struct ieee80211_tx_queue_params;
 struct brcms_info;
 struct brcms_c_info;
 struct brcms_hardware;
-struct brcmu_strbuf;
 struct brcms_txq_info;
 struct brcms_band;
 struct dma_pub;
diff --git a/drivers/staging/brcm80211/brcmutil/utils.c b/drivers/staging/brcm80211/brcmutil/utils.c
index 1fe47fe..62bcc71 100644
--- a/drivers/staging/brcm80211/brcmutil/utils.c
+++ b/drivers/staging/brcm80211/brcmutil/utils.c
@@ -598,37 +598,3 @@ uint brcmu_bitcount(u8 *bitmap, uint length)
 	return bitcount;
 }
 EXPORT_SYMBOL(brcmu_bitcount);
-
-/* Initialization of brcmu_strbuf structure */
-void brcmu_binit(struct brcmu_strbuf *b, char *buf, uint size)
-{
-	b->origsize = b->size = size;
-	b->origbuf = b->buf = buf;
-}
-EXPORT_SYMBOL(brcmu_binit);
-
-/* Buffer sprintf wrapper to guard against buffer overflow */
-int brcmu_bprintf(struct brcmu_strbuf *b, const char *fmt, ...)
-{
-	va_list ap;
-	int r;
-
-	va_start(ap, fmt);
-	r = vsnprintf(b->buf, b->size, fmt, ap);
-
-	/* Non Ansi C99 compliant returns -1,
-	 * Ansi compliant return r >= b->size,
-	 * stdlib returns 0, handle all
-	 */
-	if ((r == -1) || (r >= (int)b->size) || (r == 0)) {
-		b->size = 0;
-	} else {
-		b->size -= r;
-		b->buf += r;
-	}
-
-	va_end(ap);
-
-	return r;
-}
-EXPORT_SYMBOL(brcmu_bprintf);
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index cf34bd3..a7d3df2 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -19,18 +19,6 @@
 
 #include <linux/skbuff.h>
 
-/* Buffer structure for collecting string-formatted data
-* using brcmu_bprintf() API.
-* Use brcmu_binit() to initialize before use
-*/
-
-struct brcmu_strbuf {
-	char *buf;	/* pointer to current position in origbuf */
-	unsigned int size;	/* current (residual) size in bytes */
-	char *origbuf;	/* unmodified pointer to orignal buffer */
-	unsigned int origsize;	/* unmodified orignal buffer size in bytes */
-};
-
 /*
  * Spin at most 'us' microseconds while 'exp' is true.
  * Caller should explicitly test 'exp' when this completes
@@ -228,9 +216,6 @@ extern struct brcmu_tlv *brcmu_parse_tlvs(void *buf, int buflen,
 extern u16 brcmu_qdbm_to_mw(u8 qdbm);
 extern u8 brcmu_mw_to_qdbm(u16 mw);
 
-extern void brcmu_binit(struct brcmu_strbuf *b, char *buf, uint size);
-extern int brcmu_bprintf(struct brcmu_strbuf *b, const char *fmt, ...);
-
 extern uint brcmu_mkiovar(char *name, char *data, uint datalen,
 			  char *buf, uint len);
 extern uint brcmu_bitcount(u8 *bitmap, uint bytelength);
-- 
1.7.4.1


