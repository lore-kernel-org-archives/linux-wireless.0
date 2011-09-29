Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2064 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246Ab1I2Wex (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 18:34:53 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 17/25] staging: brcm80211: removed global variable in
 softmac otp
Date: Thu, 29 Sep 2011 15:34:28 -0700
Message-ID: <1317335676-3424-18-git-send-email-frankyl@broadcom.com> (sfid-20110930_003531_083616_CDC0D31C)
In-Reply-To: <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
 <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Placed variable on the stack instead and deleted unused functions.
Softmac was tested to function properly with multiple adapters in one
system.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/otp.c |  143 ++++--------------------------
 drivers/staging/brcm80211/brcmsmac/otp.h |    8 --
 2 files changed, 18 insertions(+), 133 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index 06cb575..f15e8be 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -67,15 +67,13 @@
 /* Fixed size subregions sizes in words */
 #define OTPGU_CI_SZ		2
 
+struct otpinfo;
+
 /* OTP function struct */
 struct otp_fn_s {
-	int (*size)(struct otpinfo *oi);
-	u16 (*read_bit)(struct otpinfo *oi, struct chipcregs *cc, uint off);
-	struct otpinfo *(*init)(struct si_pub *sih);
+	int (*init)(struct si_pub *sih, struct otpinfo *oi);
 	int (*read_region)(struct otpinfo *oi, int region, u16 *data,
 			   uint *wlen);
-	int (*nvread)(struct otpinfo *oi, char *data, uint *len);
-	int (*status)(struct otpinfo *oi);
 };
 
 struct otpinfo {
@@ -99,21 +97,6 @@ struct otpinfo {
 	int otpgu_base;		/* offset to General Use Region */
 };
 
-static struct otpinfo otpinfo;
-
-/*
- * IPX OTP Code
- *
- *   Exported functions:
- *	ipxotp_status()
- *	ipxotp_size()
- *	ipxotp_init()
- *	ipxotp_read_bit()
- *	ipxotp_read_region()
- *	ipxotp_nvread()
- *
- */
-
 /* OTP layout */
 /* CC revs 21, 24 and 27 OTP General Use Region word offset */
 #define REVA4_OTPGU_BASE	12
@@ -149,51 +132,11 @@ static struct otpinfo otpinfo;
 #define OTP4315_SWREG_SZ	178	/* 178 bytes */
 #define OTP_SZ_FU_144		(144/8)	/* 144 bits */
 
-static int ipxotp_status(struct otpinfo *oi)
-{
-	return (int)(oi->status);
-}
-
-/* Return size in bytes */
-static int ipxotp_size(struct otpinfo *oi)
-{
-	return (int)oi->wsize * 2;
-}
-
 static u16 ipxotp_otpr(struct otpinfo *oi, struct chipcregs *cc, uint wn)
 {
 	return R_REG(&cc->sromotp[wn]);
 }
 
-static u16 ipxotp_read_bit(struct otpinfo *oi, struct chipcregs *cc, uint off)
-{
-	uint k, row, col;
-	u32 otpp, st;
-
-	row = off / oi->cols;
-	col = off % oi->cols;
-
-	otpp = OTPP_START_BUSY |
-	    ((OTPPOC_READ << OTPP_OC_SHIFT) & OTPP_OC_MASK) |
-	    ((row << OTPP_ROW_SHIFT) & OTPP_ROW_MASK) |
-	    ((col << OTPP_COL_SHIFT) & OTPP_COL_MASK);
-	W_REG(&cc->otpprog, otpp);
-
-	for (k = 0;
-	     ((st = R_REG(&cc->otpprog)) & OTPP_START_BUSY)
-	     && (k < OTPP_TRIES); k++)
-		;
-	if (k >= OTPP_TRIES)
-		return 0xffff;
-
-	if (st & OTPP_READERR)
-		return 0xffff;
-
-	st = (st & OTPP_VALUE_MASK) >> OTPP_VALUE_SHIFT;
-
-	return (int)st;
-}
-
 /*
  * Calculate max HW/SW region byte size by subtracting fuse region
  * and checksum size, osizew is oi->wsize (OTP size - GU size) in words
@@ -294,28 +237,24 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs *cc)
 	oi->flim = oi->wsize;
 }
 
-static struct otpinfo *ipxotp_init(struct si_pub *sih)
+static int ipxotp_init(struct si_pub *sih, struct otpinfo *oi)
 {
 	uint idx;
 	struct chipcregs *cc;
-	struct otpinfo *oi;
 
 	/* Make sure we're running IPX OTP */
 	if (!OTPTYPE_IPX(sih->ccrev))
-		return NULL;
+		return -EBADE;
 
 	/* Make sure OTP is not disabled */
 	if (ai_is_otp_disabled(sih))
-		return NULL;
-
-	/* OTP is always powered */
-	oi = &otpinfo;
+		return -EBADE;
 
 	/* Check for otp size */
 	switch ((sih->cccaps & CC_CAP_OTPSIZE) >> CC_CAP_OTPSIZE_SHIFT) {
 	case 0:
 		/* Nothing there */
-		return NULL;
+		return -EBADE;
 	case 1:		/* 32x64 */
 		oi->rows = 32;
 		oi->cols = 64;
@@ -338,7 +277,7 @@ static struct otpinfo *ipxotp_init(struct si_pub *sih)
 		break;
 	default:
 		/* Don't know the geometry */
-		return NULL;
+		return -EBADE;
 	}
 
 	/* Retrieve OTP region info */
@@ -349,7 +288,7 @@ static struct otpinfo *ipxotp_init(struct si_pub *sih)
 
 	ai_setcoreidx(sih, idx);
 
-	return oi;
+	return 0;
 }
 
 static int
@@ -437,56 +376,16 @@ ipxotp_read_region(struct otpinfo *oi, int region, u16 *data, uint *wlen)
 	return 0;
 }
 
-static int ipxotp_nvread(struct otpinfo *oi, char *data, uint *len)
-{
-	return -ENOTSUPP;
-}
-
 static const struct otp_fn_s ipxotp_fn = {
-	(int (*)(struct otpinfo *)) ipxotp_size,
-	(u16 (*)(struct otpinfo *, struct chipcregs *, uint)) ipxotp_read_bit,
-
-	(struct otpinfo *(*)(struct si_pub *)) ipxotp_init,
+	(int (*)(struct si_pub *, struct otpinfo *)) ipxotp_init,
 	(int (*)(struct otpinfo *, int, u16 *, uint *)) ipxotp_read_region,
-	(int (*)(struct otpinfo *, char *, uint *)) ipxotp_nvread,
-
-	(int (*)(struct otpinfo *)) ipxotp_status
 };
 
-/*
- *	otp_status()
- *	otp_size()
- *	otp_read_bit()
- *	otp_init()
- *	otp_read_region()
- *	otp_nvread()
- */
-
-int otp_status(struct otpinfo *oi)
+static int otp_init(struct si_pub *sih, struct otpinfo *oi)
 {
-	return oi->fn->status(oi);
-}
-
-int otp_size(struct otpinfo *oi)
-{
-	return oi->fn->size(oi);
-}
 
-u16 otp_read_bit(struct otpinfo *oi, uint offset)
-{
-	uint idx = ai_coreidx(oi->sih);
-	struct chipcregs *cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
-	u16 readBit = (u16) oi->fn->read_bit(oi, cc, offset);
-	ai_setcoreidx(oi->sih, idx);
-	return readBit;
-}
+	int ret;
 
-struct otpinfo *otp_init(struct si_pub *sih)
-{
-	struct otpinfo *oi;
-	struct otpinfo *ret = NULL;
-
-	oi = &otpinfo;
 	memset(oi, 0, sizeof(struct otpinfo));
 
 	oi->ccrev = sih->ccrev;
@@ -495,18 +394,19 @@ struct otpinfo *otp_init(struct si_pub *sih)
 		oi->fn = &ipxotp_fn;
 
 	if (oi->fn == NULL)
-		return NULL;
+		return -EBADE;
 
 	oi->sih = sih;
 
-	ret = (oi->fn->init) (sih);
+	ret = (oi->fn->init) (sih, oi);
 
 	return ret;
 }
 
 int
 otp_read_region(struct si_pub *sih, int region, u16 *data, uint *wlen) {
-	struct otpinfo *oi;
+	struct otpinfo otpinfo;
+	struct otpinfo *oi = &otpinfo;
 	int err = 0;
 
 	if (ai_is_otp_disabled(sih)) {
@@ -514,19 +414,12 @@ otp_read_region(struct si_pub *sih, int region, u16 *data, uint *wlen) {
 		goto out;
 	}
 
-	oi = otp_init(sih);
-	if (oi == NULL) {
-		err = -EBADE;
+	err = otp_init(sih, oi);
+	if (err)
 		goto out;
-	}
 
 	err = ((oi)->fn->read_region)(oi, region, data, wlen);
 
  out:
 	return err;
 }
-
-int otp_nvread(struct otpinfo *oi, char *data, uint *len)
-{
-	return oi->fn->nvread(oi, data, len);
-}
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.h b/drivers/staging/brcm80211/brcmsmac/otp.h
index bf2f76f..6b6d31c 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.h
+++ b/drivers/staging/brcm80211/brcmsmac/otp.h
@@ -30,15 +30,7 @@
 /* OTP Size */
 #define OTP_SZ_MAX		(6144/8)	/* maximum bytes in one CIS */
 
-struct otpinfo;
-
-/* Exported functions */
-extern int otp_status(struct otpinfo *oi);
-extern int otp_size(struct otpinfo *oi);
-extern u16 otp_read_bit(struct otpinfo *oi, uint offset);
-extern struct otpinfo *otp_init(struct si_pub *sih);
 extern int otp_read_region(struct si_pub *sih, int region, u16 *data,
 			   uint *wlen);
-extern int otp_nvread(struct otpinfo *oi, char *data, uint *len);
 
 #endif				/* _BRCM_OTP_H_ */
-- 
1.7.1


