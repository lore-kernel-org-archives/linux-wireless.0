Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2910 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758812Ab1EMKAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/32] staging: brcm80211: replaced IL_BIGENDIAN by
 __BIG_ENDIAN
Date: Fri, 13 May 2011 11:59:21 +0200
Message-ID: <1305280792-9475-1-git-send-email-arend@broadcom.com> (sfid-20110513_120051_177316_87BECBE4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. IL_BIGENDIAN was a Broadcom specific define.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    3 ---
 drivers/staging/brcm80211/include/aidmp.h     |    6 +++---
 drivers/staging/brcm80211/include/bcmutils.h  |    6 +++---
 drivers/staging/brcm80211/include/sbchipc.h   |    6 +++---
 4 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 4448845..b94f376 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -1623,9 +1623,6 @@ wlc_bmac_write_template_ram(struct wlc_hw_info *wlc_hw, int offset, int len,
 	d11regs_t *regs;
 	u32 word;
 	bool be_bit;
-#ifdef IL_BIGENDIAN
-	volatile u16 *dptr = NULL;
-#endif				/* IL_BIGENDIAN */
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	regs = wlc_hw->regs;
diff --git a/drivers/staging/brcm80211/include/aidmp.h b/drivers/staging/brcm80211/include/aidmp.h
index d33f020..7e0ce8f 100644
--- a/drivers/staging/brcm80211/include/aidmp.h
+++ b/drivers/staging/brcm80211/include/aidmp.h
@@ -292,7 +292,7 @@ typedef volatile struct _aidmp {
 #define	AI_OOBDINWIDTH		0x364
 #define	AI_OOBDOUTWIDTH		0x368
 
-#if	defined(IL_BIGENDIAN) && defined(BCMHND74K)
+#if	defined(__BIG_ENDIAN) && defined(BCMHND74K)
 /* Selective swapped defines for those registers we need in
  * big-endian code.
  */
@@ -303,7 +303,7 @@ typedef volatile struct _aidmp {
 #define	AI_RESETCTRL		0x804
 #define	AI_RESETSTATUS		0x800
 
-#else				/* !IL_BIGENDIAN || !BCMHND74K */
+#else				/* !__BIG_ENDIAN || !BCMHND74K */
 
 #define	AI_IOCTRLSET		0x400
 #define	AI_IOCTRLCLEAR		0x404
@@ -312,7 +312,7 @@ typedef volatile struct _aidmp {
 #define	AI_RESETCTRL		0x800
 #define	AI_RESETSTATUS		0x804
 
-#endif				/* IL_BIGENDIAN && BCMHND74K */
+#endif				/* __BIG_ENDIAN && BCMHND74K */
 
 #define	AI_IOCTRLWIDTH		0x700
 #define	AI_IOSTATUSWIDTH	0x704
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index aa00e83..224d4ce 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -277,7 +277,7 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
 #define	bcopy(src, dst, len)	memcpy((dst), (src), (len))
 
 /* register access macros */
-#ifndef IL_BIGENDIAN
+#ifndef __BIG_ENDIAN
 #ifndef __mips__
 #define R_REG(r) (\
 	SELECT_BUS_READ(sizeof(*(r)) == sizeof(u8) ? \
@@ -328,7 +328,7 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
 		}, \
 		(OSL_WRITE_REG(r, v))); \
 	} while (0)
-#else				/* IL_BIGENDIAN */
+#else				/* __BIG_ENDIAN */
 #define R_REG(r) (\
 	SELECT_BUS_READ( \
 		({ \
@@ -365,7 +365,7 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
 		}, \
 		(OSL_WRITE_REG(r, v))); \
 	} while (0)
-#endif				/* IL_BIGENDIAN */
+#endif				/* __BIG_ENDIAN */
 
 #define AND_REG(r, v)	W_REG((r), R_REG(r) & (v))
 #define OR_REG(r, v)	W_REG((r), R_REG(r) | (v))
diff --git a/drivers/staging/brcm80211/include/sbchipc.h b/drivers/staging/brcm80211/include/sbchipc.h
index f608894..8c01c63 100644
--- a/drivers/staging/brcm80211/include/sbchipc.h
+++ b/drivers/staging/brcm80211/include/sbchipc.h
@@ -225,7 +225,7 @@ typedef volatile struct {
 
 #endif				/* _LANGUAGE_ASSEMBLY */
 
-#if	defined(IL_BIGENDIAN) && defined(BCMHND74K)
+#if	defined(__BIG_ENDIAN) && defined(BCMHND74K)
 /* Selective swapped defines for those registers we need in
  * big-endian code.
  */
@@ -234,14 +234,14 @@ typedef volatile struct {
 #define	CC_CHIPST		0x28
 #define	CC_EROMPTR		0xf8
 
-#else				/* !IL_BIGENDIAN || !BCMHND74K */
+#else				/* !__BIG_ENDIAN || !BCMHND74K */
 
 #define	CC_CHIPID		0
 #define	CC_CAPABILITIES		4
 #define	CC_CHIPST		0x2c
 #define	CC_EROMPTR		0xfc
 
-#endif				/* IL_BIGENDIAN && BCMHND74K */
+#endif				/* __BIG_ENDIAN && BCMHND74K */
 
 #define CC_OTPST		0x10
 #define	CC_JTAGCMD		0x30
-- 
1.7.4.1


