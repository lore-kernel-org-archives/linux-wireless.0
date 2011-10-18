Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2290 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/15] brcm80211: util: remove function
 brcmu_format_hex() from brcmutil
Date: Tue, 18 Oct 2011 14:03:10 +0200
Message-ID: <1318939391-19495-15-git-send-email-arend@broadcom.com> (sfid-20111018_140351_525821_728F9B18)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmu_format_hex() filled a string buffer with byte
values from a data buffer. The calling function used this string
buffer in a printk. Now the calling function uses the kernel
function print_hex_dump_bytes().

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   24 +++++++++----------
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   20 ----------------
 .../net/wireless/brcm80211/include/brcmu_utils.h   |    9 ++-----
 3 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index abb49fc..4f1d6e4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -6044,7 +6044,6 @@ void brcms_c_print_txdesc(struct d11txh *txh)
 
 	u8 *rtsph = txh->RTSPhyHeader;
 	struct ieee80211_rts rts = txh->rts_frame;
-	char hexbuf[256];
 
 	/* add plcp header along with txh descriptor */
 	printk(KERN_DEBUG "Raw TxDesc + plcp header:\n");
@@ -6065,17 +6064,16 @@ void brcms_c_print_txdesc(struct d11txh *txh)
 	printk(KERN_DEBUG "XtraFrameTypes: %04x ", xtraft);
 	printk(KERN_DEBUG "\n");
 
-	brcmu_format_hex(hexbuf, iv, sizeof(txh->IV));
-	printk(KERN_DEBUG "SecIV:       %s\n", hexbuf);
-	brcmu_format_hex(hexbuf, ra, sizeof(txh->TxFrameRA));
-	printk(KERN_DEBUG "RA:          %s\n", hexbuf);
+	print_hex_dump_bytes("SecIV:", DUMP_PREFIX_OFFSET, iv, sizeof(txh->IV));
+	print_hex_dump_bytes("RA:", DUMP_PREFIX_OFFSET,
+			     ra, sizeof(txh->TxFrameRA));
 
 	printk(KERN_DEBUG "Fb FES Time: %04x ", tfestfb);
-	brcmu_format_hex(hexbuf, rtspfb, sizeof(txh->RTSPLCPFallback));
-	printk(KERN_DEBUG "RTS PLCP: %s ", hexbuf);
+	print_hex_dump_bytes("Fb RTS PLCP:", DUMP_PREFIX_OFFSET,
+			     rtspfb, sizeof(txh->RTSPLCPFallback));
 	printk(KERN_DEBUG "RTS DUR: %04x ", rtsdfb);
-	brcmu_format_hex(hexbuf, fragpfb, sizeof(txh->FragPLCPFallback));
-	printk(KERN_DEBUG "PLCP: %s ", hexbuf);
+	print_hex_dump_bytes("PLCP:", DUMP_PREFIX_OFFSET,
+			     fragpfb, sizeof(txh->FragPLCPFallback));
 	printk(KERN_DEBUG "DUR: %04x", fragdfb);
 	printk(KERN_DEBUG "\n");
 
@@ -6090,10 +6088,10 @@ void brcms_c_print_txdesc(struct d11txh *txh)
 	printk(KERN_DEBUG "MaxAggbyte_fb:  %04x\n", mabyte_f);
 	printk(KERN_DEBUG "MinByte:     %04x\n", mmbyte);
 
-	brcmu_format_hex(hexbuf, rtsph, sizeof(txh->RTSPhyHeader));
-	printk(KERN_DEBUG "RTS PLCP: %s ", hexbuf);
-	brcmu_format_hex(hexbuf, (u8 *) &rts, sizeof(txh->rts_frame));
-	printk(KERN_DEBUG "RTS Frame: %s", hexbuf);
+	print_hex_dump_bytes("RTS PLCP:", DUMP_PREFIX_OFFSET,
+			     rtsph, sizeof(txh->RTSPhyHeader));
+	print_hex_dump_bytes("RTS Frame:", DUMP_PREFIX_OFFSET,
+			     (u8 *)&rts, sizeof(txh->rts_frame));
 	printk(KERN_DEBUG "\n");
 }
 #endif				/* defined(BCMDBG) */
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index 11cfbde..12b795f 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -335,23 +335,3 @@ void brcmu_prpkt(const char *msg, struct sk_buff *p0)
 }
 EXPORT_SYMBOL(brcmu_prpkt);
 #endif				/* defined(BCMDBG) */
-
-#if defined(BCMDBG)
-/*
- * print bytes formatted as hex to a string. return the resulting
- * string length
- */
-int brcmu_format_hex(char *str, const void *bytes, int len)
-{
-	int i;
-	char *p = str;
-	const u8 *src = (const u8 *)bytes;
-
-	for (i = 0; i < len; i++) {
-		p += snprintf(p, 3, "%02X", *src);
-		src++;
-	}
-	return (int)(p - str);
-}
-EXPORT_SYMBOL(brcmu_format_hex);
-#endif				/* defined(BCMDBG) */
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index e5eac87..ccf6015 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -178,16 +178,13 @@ extern uint brcmu_pkttotlen(struct sk_buff *p);
 /* ip address */
 struct ipv4_addr;
 
+
+/* externs */
+/* format/print */
 #ifdef BCMDBG
 extern void brcmu_prpkt(const char *msg, struct sk_buff *p0);
 #else
 #define brcmu_prpkt(a, b)
 #endif				/* BCMDBG */
 
-/* externs */
-/* format/print */
-#if defined(BCMDBG)
-extern int brcmu_format_hex(char *str, const void *bytes, int len);
-#endif
-
 #endif				/* _BRCMU_UTILS_H_ */
-- 
1.7.4.1


