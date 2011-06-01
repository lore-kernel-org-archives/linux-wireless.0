Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4928 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758830Ab1FALqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:32 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 63/83] staging: brcm80211: removed unused code from
 bcmotp.c
Date: Wed, 1 Jun 2011 13:45:48 +0200
Message-ID: <1306928768-7501-63-git-send-email-rvossen@broadcom.com> (sfid-20110601_134725_398670_7E9CBABE)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. The supported chips all contain an 'IPX' controller, the
older 'hnd' OTP controller is not used.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/bcmotp.c |  410 +--------------------------
 1 files changed, 2 insertions(+), 408 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/bcmotp.c b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
index 2b7f061..cca64e4 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmotp.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
@@ -36,7 +36,7 @@
 #define OTPS_GUP_CI		0x00000400	/* chipid/pkgopt subregion is programmed */
 #define OTPS_GUP_FUSE		0x00000800	/* fuse subregion is programmed */
 
-/* Fields in otpprog in rev >= 21 and HND OTP */
+/* Fields in otpprog in rev >= 21 */
 #define OTPP_COL_MASK		0x000000ff
 #define OTPP_COL_SHIFT		0
 #define OTPP_ROW_MASK		0x0000ff00
@@ -47,7 +47,7 @@
 #define OTPP_VALUE_MASK		0x20000000
 #define OTPP_VALUE_SHIFT	29
 #define OTPP_START_BUSY		0x80000000
-#define	OTPP_READ		0x40000000	/* HND OTP */
+#define	OTPP_READ		0x40000000
 
 /* Opcodes for OTPP_OC field */
 #define OTPPOC_READ		0
@@ -60,31 +60,11 @@
 #define OTPPOC_ROW_LOCK		8
 #define OTPPOC_PRESCN_TEST	9
 
-/*
- * There are two different OTP controllers so far:
- * 	1. new IPX OTP controller:	chipc 21, >=23
- * 	2. older HND OTP controller:	chipc 12, 17, 22
- *
- * Define BCMHNDOTP to include support for the HND OTP controller.
- * Define BCMIPXOTP to include support for the IPX OTP controller.
- *
- * NOTE 1: More than one may be defined
- * NOTE 2: If none are defined, the default is to include them all.
- */
-
-#if !defined(BCMHNDOTP) && !defined(BCMIPXOTP)
-#define BCMHNDOTP	1
-#define BCMIPXOTP	1
-#endif
-
-#define OTPTYPE_HND(ccrev)	((ccrev) < 21 || (ccrev) == 22)
 #define OTPTYPE_IPX(ccrev)	((ccrev) == 21 || (ccrev) >= 23)
 
 #define OTPP_TRIES	10000000	/* # of tries for OTPP */
 
-#ifdef BCMIPXOTP
 #define MAXNUMRDES		9	/* Maximum OTP redundancy entries */
-#endif
 
 /* OTP common function type */
 typedef int (*otp_status_t) (void *oh);
@@ -110,7 +90,6 @@ typedef struct {
 	otp_fn_t *fn;		/* OTP functions */
 	struct si_pub *sih;		/* Saved sb handle */
 
-#ifdef BCMIPXOTP
 	/* IPX OTP section */
 	u16 wsize;		/* Size of otp in words */
 	u16 rows;		/* Geometry */
@@ -125,15 +104,6 @@ typedef struct {
 	u16 fbase;		/* fuse subregion offset */
 	u16 flim;		/* fuse subregion boundary */
 	int otpgu_base;		/* offset to General Use Region */
-#endif				/* BCMIPXOTP */
-
-#ifdef BCMHNDOTP
-	/* HND OTP section */
-	uint size;		/* Size of otp in bytes */
-	uint hwprot;		/* Hardware protection bits */
-	uint signvalid;		/* Signature valid bits */
-	int boundary;		/* hw/sw boundary */
-#endif				/* BCMHNDOTP */
 } otpinfo_t;
 
 static otpinfo_t otpinfo;
@@ -151,8 +121,6 @@ static otpinfo_t otpinfo;
  *
  */
 
-#ifdef BCMIPXOTP
-
 #define HWSW_RGN(rgn)		(((rgn) == OTP_HW_RGN) ? "h/w" : "s/w")
 
 /* OTP layout */
@@ -497,374 +465,7 @@ static otp_fn_t ipxotp_fn = {
 	(otp_status_t) ipxotp_status
 };
 
-#endif				/* BCMIPXOTP */
-
-/*
- * HND OTP Code
- *
- *   Exported functions:
- *	hndotp_status()
- *	hndotp_size()
- *	hndotp_init()
- *	hndotp_read_bit()
- *	hndotp_read_region()
- *	hndotp_nvread()
- *
- */
-
-#ifdef BCMHNDOTP
-
-/* Fields in otpstatus */
-#define	OTPS_PROGFAIL		0x80000000
-#define	OTPS_PROTECT		0x00000007
-#define	OTPS_HW_PROTECT		0x00000001
-#define	OTPS_SW_PROTECT		0x00000002
-#define	OTPS_CID_PROTECT	0x00000004
-#define	OTPS_RCEV_MSK		0x00003f00
-#define	OTPS_RCEV_SHIFT		8
-
-/* Fields in the otpcontrol register */
-#define	OTPC_RECWAIT		0xff000000
-#define	OTPC_PROGWAIT		0x00ffff00
-#define	OTPC_PRW_SHIFT		8
-#define	OTPC_MAXFAIL		0x00000038
-#define	OTPC_VSEL		0x00000006
-#define	OTPC_SELVL		0x00000001
-
-/* OTP regions (Word offsets from otp size) */
-#define	OTP_SWLIM_OFF	(-4)
-#define	OTP_CIDBASE_OFF	0
-#define	OTP_CIDLIM_OFF	4
-
-/* Predefined OTP words (Word offset from otp size) */
-#define	OTP_BOUNDARY_OFF (-4)
-#define	OTP_HWSIGN_OFF	(-3)
-#define	OTP_SWSIGN_OFF	(-2)
-#define	OTP_CIDSIGN_OFF	(-1)
-#define	OTP_CID_OFF	0
-#define	OTP_PKG_OFF	1
-#define	OTP_FID_OFF	2
-#define	OTP_RSV_OFF	3
-#define	OTP_LIM_OFF	4
-#define	OTP_RD_OFF	4	/* Redundancy row starts here */
-#define	OTP_RC0_OFF	28	/* Redundancy control word 1 */
-#define	OTP_RC1_OFF	32	/* Redundancy control word 2 */
-#define	OTP_RC_LIM_OFF	36	/* Redundancy control word end */
-
-#define	OTP_HW_REGION	OTPS_HW_PROTECT
-#define	OTP_SW_REGION	OTPS_SW_PROTECT
-#define	OTP_CID_REGION	OTPS_CID_PROTECT
-
-#if OTP_HW_REGION != OTP_HW_RGN
-#error "incompatible OTP_HW_RGN"
-#endif
-#if OTP_SW_REGION != OTP_SW_RGN
-#error "incompatible OTP_SW_RGN"
-#endif
-#if OTP_CID_REGION != OTP_CI_RGN
-#error "incompatible OTP_CI_RGN"
-#endif
-
-/* Redundancy entry definitions */
-#define	OTP_RCE_ROW_SZ		6
-#define	OTP_RCE_SIGN_MASK	0x7fff
-#define	OTP_RCE_ROW_MASK	0x3f
-#define	OTP_RCE_BITS		21
-#define	OTP_RCE_SIGN_SZ		15
-#define	OTP_RCE_BIT0		1
-
-#define	OTP_WPR		4
-#define	OTP_SIGNATURE	0x578a
-#define	OTP_MAGIC	0x4e56
-
-static int hndotp_status(void *oh)
-{
-	otpinfo_t *oi = (otpinfo_t *) oh;
-	return (int)(oi->hwprot | oi->signvalid);
-}
-
-static int hndotp_size(void *oh)
-{
-	otpinfo_t *oi = (otpinfo_t *) oh;
-	return (int)(oi->size);
-}
-
-static u16 hndotp_otpr(void *oh, chipcregs_t *cc, uint wn)
-{
-	volatile u16 *ptr;
-
-	ptr = (volatile u16 *)((volatile char *)cc + CC_SROM_OTP);
-	return R_REG(&ptr[wn]);
-}
-
-static u16 hndotp_otproff(void *oh, chipcregs_t *cc, int woff)
-{
-	otpinfo_t *oi = (otpinfo_t *) oh;
-	volatile u16 *ptr;
-
-	ptr = (volatile u16 *)((volatile char *)cc + CC_SROM_OTP);
-
-	return R_REG(&ptr[(oi->size / 2) + woff]);
-}
-
-static u16 hndotp_read_bit(void *oh, chipcregs_t *cc, uint idx)
-{
-	uint k, row, col;
-	u32 otpp, st;
-
-	row = idx / 65;
-	col = idx % 65;
-
-	otpp = OTPP_START_BUSY | OTPP_READ |
-	    ((row << OTPP_ROW_SHIFT) & OTPP_ROW_MASK) | (col & OTPP_COL_MASK);
-
-	W_REG(&cc->otpprog, otpp);
-	st = R_REG(&cc->otpprog);
-	for (k = 0;
-	     ((st & OTPP_START_BUSY) == OTPP_START_BUSY) && (k < OTPP_TRIES);
-	     k++)
-		st = R_REG(&cc->otpprog);
-
-	if (k >= OTPP_TRIES) {
-		return 0xffff;
-	}
-	if (st & OTPP_READERR) {
-		return 0xffff;
-	}
-	st = (st & OTPP_VALUE_MASK) >> OTPP_VALUE_SHIFT;
-	return (u16) st;
-}
-
-static void *hndotp_init(struct si_pub *sih)
-{
-	uint idx;
-	chipcregs_t *cc;
-	otpinfo_t *oi;
-	u32 cap = 0, clkdiv, otpdiv = 0;
-	void *ret = NULL;
-
-	oi = &otpinfo;
-
-	idx = ai_coreidx(sih);
-
-	/* Check for otp */
-	cc = ai_setcoreidx(sih, SI_CC_IDX);
-	if (cc != NULL) {
-		cap = R_REG(&cc->capabilities);
-		if ((cap & CC_CAP_OTPSIZE) == 0) {
-			/* Nothing there */
-			goto out;
-		}
-
-		if (!((oi->ccrev == 12) || (oi->ccrev == 17)
-		     || (oi->ccrev == 22)))
-			return NULL;
-
-		/* Read the OTP byte size. chipcommon rev >= 18 has RCE so the size is
-		 * 8 row (64 bytes) smaller
-		 */
-		oi->size =
-		    1 << (((cap & CC_CAP_OTPSIZE) >> CC_CAP_OTPSIZE_SHIFT)
-			  + CC_CAP_OTPSIZE_BASE);
-		if (oi->ccrev >= 18)
-			oi->size -= ((OTP_RC0_OFF - OTP_BOUNDARY_OFF) * 2);
-
-		oi->hwprot = (int)(R_REG(&cc->otpstatus) & OTPS_PROTECT);
-		oi->boundary = -1;
-
-		/* Check the region signature */
-		if (hndotp_otproff(oi, cc, OTP_HWSIGN_OFF) == OTP_SIGNATURE) {
-			oi->signvalid |= OTP_HW_REGION;
-			oi->boundary = hndotp_otproff(oi, cc, OTP_BOUNDARY_OFF);
-		}
-
-		if (hndotp_otproff(oi, cc, OTP_SWSIGN_OFF) == OTP_SIGNATURE)
-			oi->signvalid |= OTP_SW_REGION;
-
-		if (hndotp_otproff(oi, cc, OTP_CIDSIGN_OFF) == OTP_SIGNATURE)
-			oi->signvalid |= OTP_CID_REGION;
-
-		/* Set OTP clkdiv for stability */
-		if (oi->ccrev == 22)
-			otpdiv = 12;
-
-		if (otpdiv) {
-			clkdiv = R_REG(&cc->clkdiv);
-			clkdiv =
-			    (clkdiv & ~CLKD_OTP) | (otpdiv << CLKD_OTP_SHIFT);
-			W_REG(&cc->clkdiv, clkdiv);
-		}
-		udelay(10);
-
-		ret = (void *)oi;
-	}
-
- out:				/* All done */
-	ai_setcoreidx(sih, idx);
-
-	return ret;
-}
-
-static int hndotp_read_region(void *oh, int region, u16 *data, uint *wlen)
-{
-	otpinfo_t *oi = (otpinfo_t *) oh;
-	u32 idx, st;
-	chipcregs_t *cc;
-	int i;
-
-
-	if (region != OTP_HW_REGION) {
-		/*
-		 * Only support HW region
-		 * (no active chips use HND OTP SW region)
-		 * */
-		return -ENOTSUPP;
-	}
-
-	/* Region empty? */
-	st = oi->hwprot | oi->signvalid;
-	if ((st & region) == 0)
-		return -ENODATA;
-
-	*wlen =
-	    ((int)*wlen < oi->boundary / 2) ? *wlen : (uint) oi->boundary / 2;
-
-	idx = ai_coreidx(oi->sih);
-	cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
-
-	for (i = 0; i < (int)*wlen; i++)
-		data[i] = hndotp_otpr(oh, cc, i);
-
-	ai_setcoreidx(oi->sih, idx);
-
-	return 0;
-}
-
-static int hndotp_nvread(void *oh, char *data, uint *len)
-{
-	int rc = 0;
-	otpinfo_t *oi = (otpinfo_t *) oh;
-	u32 base, bound, lim = 0, st;
-	int i, chunk, gchunks, tsz = 0;
-	u32 idx;
-	chipcregs_t *cc;
-	uint offset;
-	u16 *rawotp = NULL;
-
-	/* save the orig core */
-	idx = ai_coreidx(oi->sih);
-	cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
-
-	st = hndotp_status(oh);
-	if (!(st & (OTP_HW_REGION | OTP_SW_REGION))) {
-		rc = -1;
-		goto out;
-	}
-
-	/* Read the whole otp so we can easily manipulate it */
-	lim = hndotp_size(oh);
-	rawotp = kmalloc(lim, GFP_ATOMIC);
-	if (rawotp == NULL) {
-		rc = -2;
-		goto out;
-	}
-	for (i = 0; i < (int)(lim / 2); i++)
-		rawotp[i] = hndotp_otpr(oh, cc, i);
-
-	if ((st & OTP_HW_REGION) == 0) {
-		/* This could be a programming failure in the first
-		 * chunk followed by one or more good chunks
-		 */
-		for (i = 0; i < (int)(lim / 2); i++)
-			if (rawotp[i] == OTP_MAGIC)
-				break;
-
-		if (i < (int)(lim / 2)) {
-			base = i;
-			bound = (i * 2) + rawotp[i + 1];
-		} else {
-			rc = -3;
-			goto out;
-		}
-	} else {
-		bound = rawotp[(lim / 2) + OTP_BOUNDARY_OFF];
-
-		/* There are two cases: 1) The whole otp is used as nvram
-		 * and 2) There is a hardware header followed by nvram.
-		 */
-		if (rawotp[0] == OTP_MAGIC) {
-			base = 0;
-		} else
-			base = bound;
-	}
-
-	/* Find and copy the data */
-
-	chunk = 0;
-	gchunks = 0;
-	i = base / 2;
-	offset = 0;
-	while ((i < (int)(lim / 2)) && (rawotp[i] == OTP_MAGIC)) {
-		int dsz, rsz = rawotp[i + 1];
-
-		if (((i * 2) + rsz) >= (int)lim) {
-			/* Bad length, try to find another chunk anyway */
-			rsz = 6;
-		}
-		if (crc_ccitt(CRC16_INIT_VALUE, (u8 *) &rawotp[i], rsz) ==
-			CRC16_GOOD_VALUE) {
-			/* Good crc, copy the vars */
-			gchunks++;
-			dsz = rsz - 6;
-			tsz += dsz;
-			if (offset + dsz >= *len) {
-				goto out;
-			}
-			memcpy(&data[offset], &rawotp[i + 2], dsz);
-			offset += dsz;
-			/* Remove extra null characters at the end */
-			while (offset > 1 &&
-			       data[offset - 1] == 0 && data[offset - 2] == 0)
-				offset--;
-			i += rsz / 2;
-		} else {
-			/* bad length or crc didn't check, try to find the next set */
-			if (rawotp[i + (rsz / 2)] == OTP_MAGIC) {
-				/* Assume length is good */
-				i += rsz / 2;
-			} else {
-				while (++i < (int)(lim / 2))
-					if (rawotp[i] == OTP_MAGIC)
-						break;
-			}
-		}
-		chunk++;
-	}
-
-	*len = offset;
-
- out:
-	kfree(rawotp);
-	ai_setcoreidx(oi->sih, idx);
-
-	return rc;
-}
-
-static otp_fn_t otp_fn = {
-	(otp_size_t) hndotp_size,
-	(otp_read_bit_t) hndotp_read_bit,
-
-	(otp_init_t) hndotp_init,
-	(otp_read_region_t) hndotp_read_region,
-	(otp_nvread_t) hndotp_nvread,
-
-	(otp_status_t) hndotp_status
-};
-
-#endif				/* BCMHNDOTP */
-
 /*
- * Common Code: Compiled for IPX / HND / AUTO
  *	otp_status()
  *	otp_size()
  *	otp_read_bit()
@@ -907,15 +508,8 @@ void *otp_init(struct si_pub *sih)
 
 	oi->ccrev = sih->ccrev;
 
-#ifdef BCMIPXOTP
 	if (OTPTYPE_IPX(oi->ccrev))
 		oi->fn = &ipxotp_fn;
-#endif
-
-#ifdef BCMHNDOTP
-	if (OTPTYPE_HND(oi->ccrev))
-		oi->fn = &otp_fn;
-#endif
 
 	if (oi->fn == NULL) {
 		return NULL;
-- 
1.7.4.1


