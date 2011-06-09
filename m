Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4633 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab1FIOpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:19 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 02/21] staging: brcm80211: cleaned brcmu_utils.h
Date: Thu, 9 Jun 2011 16:44:42 +0200
Message-ID: <1307630701-9170-3-git-send-email-rvossen@broadcom.com> (sfid-20110609_164603_675223_44CB5FC5)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Moved softmac specific definitions into brcmsmac/types.h
Removed unused definitions.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/types.h      |    6 ++
 drivers/staging/brcm80211/include/brcmu_utils.h |  110 +++++------------------
 2 files changed, 29 insertions(+), 87 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 0de99d5..dd0bcf9 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -343,6 +343,12 @@ do {						\
 #define SET_REG(r, mask, val) \
 		W_REG((r), ((R_REG(r) & ~(mask)) | (val)))
 
+/* multi-bool data type: set of bools, mbool is true if any is set */
+typedef u32 mbool;
+#define mboolset(mb, bit)		((mb) |= (bit))	/* set one bool */
+#define mboolclr(mb, bit)		((mb) &= ~(bit))	/* clear one bool */
+#define mboolisset(mb, bit)		(((mb) & (bit)) != 0)	/* true if one bool is set */
+#define	mboolmaskset(mb, mask, val)	((mb) = (((mb) & ~(mask)) | (val)))
 
 /* forward declarations */
 struct sk_buff;
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index a4b52cf..e3308e8 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -22,16 +22,12 @@
 * Use brcmu_binit() to initialize before use
 */
 
-	struct brcmu_strbuf {
-		char *buf;	/* pointer to current position in origbuf */
-		unsigned int size;	/* current (residual) size in bytes */
-		char *origbuf;	/* unmodified pointer to orignal buffer */
-		unsigned int origsize;	/* unmodified orignal buffer size in bytes */
-	};
-
-/* ** driver-only section ** */
-
-#define GPIO_PIN_NOTDEFINED 	0x20	/* Pin not defined */
+struct brcmu_strbuf {
+	char *buf;	/* pointer to current position in origbuf */
+	unsigned int size;	/* current (residual) size in bytes */
+	char *origbuf;	/* unmodified pointer to orignal buffer */
+	unsigned int origsize;	/* unmodified orignal buffer size in bytes */
+};
 
 /*
  * Spin at most 'us' microseconds while 'exp' is true.
@@ -54,24 +50,25 @@
 #define PKTQ_MAX_PREC           16	/* Maximum precedence levels */
 #endif
 
-	struct pktq_prec {
-		struct sk_buff *head;	/* first packet to dequeue */
-		struct sk_buff *tail;	/* last packet to dequeue */
-		u16 len;		/* number of queued packets */
-		u16 max;		/* maximum number of queued packets */
-	};
+struct pktq_prec {
+	struct sk_buff *head;	/* first packet to dequeue */
+	struct sk_buff *tail;	/* last packet to dequeue */
+	u16 len;		/* number of queued packets */
+	u16 max;		/* maximum number of queued packets */
+};
 
 /* multi-priority pkt queue */
-	struct pktq {
-		u16 num_prec;	/* number of precedences in use */
-		u16 hi_prec;	/* rapid dequeue hint (>= highest non-empty prec) */
-		u16 max;	/* total max packets */
-		u16 len;	/* total number of packets */
-		/* q array must be last since # of elements can be either PKTQ_MAX_PREC or 1 */
-		struct pktq_prec q[PKTQ_MAX_PREC];
-	};
-
-#define PKTQ_PREC_ITER(pq, prec)        for (prec = (pq)->num_prec - 1; prec >= 0; prec--)
+struct pktq {
+	u16 num_prec;	/* number of precedences in use */
+	u16 hi_prec;	/* rapid dequeue hint (>= highest non-empty prec) */
+	u16 max;	/* total max packets */
+	u16 len;	/* total number of packets */
+	/*
+	 * q array must be last since # of elements can be either
+	 * PKTQ_MAX_PREC or 1
+	 */
+	struct pktq_prec q[PKTQ_MAX_PREC];
+};
 
 /* fn(pkt, arg).  return true if pkt belongs to if */
 typedef bool(*ifpkt_cb_t) (struct sk_buff *, void *);
@@ -194,28 +191,6 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 #define IOVT_BUFFER	8	/* buffer is size-checked as per minlen */
 #define BCM_IOVT_VALID(type) (((unsigned int)(type)) <= IOVT_BUFFER)
 
-/* Initializer for IOV type strings */
-#define BCM_IOV_TYPE_INIT { \
-	"void", \
-	"bool", \
-	"s8", \
-	"u8", \
-	"s16", \
-	"u16", \
-	"s32", \
-	"u32", \
-	"buffer", \
-	"" }
-
-#define BCM_IOVT_IS_INT(type) (\
-	(type == IOVT_BOOL) || \
-	(type == IOVT_INT8) || \
-	(type == IOVT_UINT8) || \
-	(type == IOVT_INT16) || \
-	(type == IOVT_UINT16) || \
-	(type == IOVT_INT32) || \
-	(type == IOVT_UINT32))
-
 /* ** driver/apps-shared section ** */
 
 #define BCME_STRLEN 		64	/* Max string length for BCM errors */
@@ -298,38 +273,6 @@ struct brcmu_tlv {
 
 #define ETHER_ADDR_STR_LEN	18	/* 18-bytes of Ethernet address buffer length */
 
-/* crypto utility function */
-/* 128-bit xor: *dst = *src1 xor *src2. dst1, src1 and src2 may have any alignment */
-	static inline void
-	 xor_128bit_block(const u8 *src1, const u8 *src2, u8 *dst) {
-		if (
-#ifdef __i386__
-			   1 ||
-#endif
-			   (((unsigned long) src1 | (unsigned long) src2 | (unsigned long) dst) &
-			    3) == 0) {
-			/* ARM CM3 rel time: 1229 (727 if alignment check could be omitted) */
-			/* x86 supports unaligned.  This version runs 6x-9x faster on x86. */
-			((u32 *) dst)[0] =
-			    ((const u32 *)src1)[0] ^ ((const u32 *)
-							 src2)[0];
-			((u32 *) dst)[1] =
-			    ((const u32 *)src1)[1] ^ ((const u32 *)
-							 src2)[1];
-			((u32 *) dst)[2] =
-			    ((const u32 *)src1)[2] ^ ((const u32 *)
-							 src2)[2];
-			((u32 *) dst)[3] =
-			    ((const u32 *)src1)[3] ^ ((const u32 *)
-							 src2)[3];
-		} else {
-			/* ARM CM3 rel time: 4668 (4191 if alignment check could be omitted) */
-			int k;
-			for (k = 0; k < 16; k++)
-				dst[k] = src1[k] ^ src2[k];
-		}
-	}
-
 /* externs */
 /* crc */
 extern u8 brcmu_crc8(u8 *p, uint nbytes, u8 crc);
@@ -346,13 +289,6 @@ extern char *brcmu_chipname(uint chipid, char *buf, uint len);
 extern struct brcmu_tlv *brcmu_parse_tlvs(void *buf, int buflen,
 					  uint key);
 
-/* multi-bool data type: set of bools, mbool is true if any is set */
-	typedef u32 mbool;
-#define mboolset(mb, bit)		((mb) |= (bit))	/* set one bool */
-#define mboolclr(mb, bit)		((mb) &= ~(bit))	/* clear one bool */
-#define mboolisset(mb, bit)		(((mb) & (bit)) != 0)	/* true if one bool is set */
-#define	mboolmaskset(mb, mask, val)	((mb) = (((mb) & ~(mask)) | (val)))
-
 /* power conversion */
 extern u16 brcmu_qdbm_to_mw(u8 qdbm);
 extern u8 brcmu_mw_to_qdbm(u16 mw);
-- 
1.7.4.1


