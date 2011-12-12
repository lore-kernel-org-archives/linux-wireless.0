Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3055 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab1LLXPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:46 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/15] brcm80211: smac: use bcma core access functions
 in otp.c
Date: Mon, 12 Dec 2011 15:15:00 -0800
Message-ID: <1323731713-14942-3-git-send-email-frankyl@broadcom.com> (sfid-20111213_001553_642926_93497C93)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The code in otp.c now uses the bcma core access functions to
read the OTP information from the device.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/otp.c      |   68 ++++++++------------
 .../net/wireless/brcm80211/include/chipcommon.h    |    2 +
 2 files changed, 28 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/otp.c b/drivers/net/wireless/brcm80211/brcmsmac/otp.c
index 612434e..f1ca126 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/otp.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/otp.c
@@ -77,7 +77,7 @@ struct otp_fn_s {
 };
 
 struct otpinfo {
-	uint ccrev;		/* chipc revision */
+	struct bcma_device *core; /* chipc core */
 	const struct otp_fn_s *fn;	/* OTP functions */
 	struct si_pub *sih;		/* Saved sb handle */
 
@@ -133,9 +133,10 @@ struct otpinfo {
 #define OTP_SZ_FU_144		(144/8)	/* 144 bits */
 
 static u16
-ipxotp_otpr(struct otpinfo *oi, struct chipcregs __iomem *cc, uint wn)
+ipxotp_otpr(struct otpinfo *oi, uint wn)
 {
-	return R_REG(&cc->sromotp[wn]);
+	return bcma_read16(oi->core,
+			   CHIPCREGOFFS(sromotp[wn]));
 }
 
 /*
@@ -161,19 +162,21 @@ static int ipxotp_max_rgnsz(struct si_pub *sih, int osizew)
 	return ret;
 }
 
-static void _ipxotp_init(struct otpinfo *oi, struct chipcregs __iomem *cc)
+static void _ipxotp_init(struct otpinfo *oi)
 {
 	uint k;
 	u32 otpp, st;
+	int ccrev = ai_get_ccrev(oi->sih);
+
 
 	/*
 	 * record word offset of General Use Region
 	 * for various chipcommon revs
 	 */
-	if (oi->ccrev == 21 || oi->ccrev == 24
-	    || oi->ccrev == 27) {
+	if (ccrev == 21 || ccrev == 24
+	    || ccrev == 27) {
 		oi->otpgu_base = REVA4_OTPGU_BASE;
-	} else if (oi->ccrev == 36) {
+	} else if (ccrev == 36) {
 		/*
 		 * OTP size greater than equal to 2KB (128 words),
 		 * otpgu_base is similar to rev23
@@ -182,7 +185,7 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs __iomem *cc)
 			oi->otpgu_base = REVB8_OTPGU_BASE;
 		else
 			oi->otpgu_base = REV36_OTPGU_BASE;
-	} else if (oi->ccrev == 23 || oi->ccrev >= 25) {
+	} else if (ccrev == 23 || ccrev >= 25) {
 		oi->otpgu_base = REVB8_OTPGU_BASE;
 	}
 
@@ -190,24 +193,21 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs __iomem *cc)
 	otpp =
 	    OTPP_START_BUSY | ((OTPPOC_INIT << OTPP_OC_SHIFT) & OTPP_OC_MASK);
 
-	W_REG(&cc->otpprog, otpp);
-	for (k = 0;
-	     ((st = R_REG(&cc->otpprog)) & OTPP_START_BUSY)
-	     && (k < OTPP_TRIES); k++)
-		;
+	bcma_write32(oi->core, CHIPCREGOFFS(otpprog), otpp);
+	st = bcma_read32(oi->core, CHIPCREGOFFS(otpprog));
+	for (k = 0; (st & OTPP_START_BUSY) && (k < OTPP_TRIES); k++)
+		st = bcma_read32(oi->core, CHIPCREGOFFS(otpprog));
 	if (k >= OTPP_TRIES)
 		return;
 
 	/* Read OTP lock bits and subregion programmed indication bits */
-	oi->status = R_REG(&cc->otpstatus);
+	oi->status = bcma_read32(oi->core, CHIPCREGOFFS(otpstatus));
 
 	if ((ai_get_chip_id(oi->sih) == BCM43224_CHIP_ID)
 	    || (ai_get_chip_id(oi->sih) == BCM43225_CHIP_ID)) {
 		u32 p_bits;
-		p_bits =
-		    (ipxotp_otpr(oi, cc, oi->otpgu_base + OTPGU_P_OFF) &
-		     OTPGU_P_MSK)
-		    >> OTPGU_P_SHIFT;
+		p_bits = (ipxotp_otpr(oi, oi->otpgu_base + OTPGU_P_OFF) &
+			  OTPGU_P_MSK) >> OTPGU_P_SHIFT;
 		oi->status |= (p_bits << OTPS_GUP_SHIFT);
 	}
 
@@ -220,7 +220,7 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs __iomem *cc)
 	oi->hwlim = oi->wsize;
 	if (oi->status & OTPS_GUP_HW) {
 		oi->hwlim =
-		    ipxotp_otpr(oi, cc, oi->otpgu_base + OTPGU_HSB_OFF) / 16;
+		    ipxotp_otpr(oi, oi->otpgu_base + OTPGU_HSB_OFF) / 16;
 		oi->swbase = oi->hwlim;
 	} else
 		oi->swbase = oi->hwbase;
@@ -230,7 +230,7 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs __iomem *cc)
 
 	if (oi->status & OTPS_GUP_SW) {
 		oi->swlim =
-		    ipxotp_otpr(oi, cc, oi->otpgu_base + OTPGU_SFB_OFF) / 16;
+		    ipxotp_otpr(oi, oi->otpgu_base + OTPGU_SFB_OFF) / 16;
 		oi->fbase = oi->swlim;
 	} else
 		oi->fbase = oi->swbase;
@@ -240,11 +240,8 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs __iomem *cc)
 
 static int ipxotp_init(struct si_pub *sih, struct otpinfo *oi)
 {
-	uint idx;
-	struct chipcregs __iomem *cc;
-
 	/* Make sure we're running IPX OTP */
-	if (!OTPTYPE_IPX(oi->ccrev))
+	if (!OTPTYPE_IPX(ai_get_ccrev(sih)))
 		return -EBADE;
 
 	/* Make sure OTP is not disabled */
@@ -282,21 +279,13 @@ static int ipxotp_init(struct si_pub *sih, struct otpinfo *oi)
 	}
 
 	/* Retrieve OTP region info */
-	idx = ai_coreidx(sih);
-	cc = ai_setcoreidx(sih, SI_CC_IDX);
-
-	_ipxotp_init(oi, cc);
-
-	ai_setcoreidx(sih, idx);
-
+	_ipxotp_init(oi);
 	return 0;
 }
 
 static int
 ipxotp_read_region(struct otpinfo *oi, int region, u16 *data, uint *wlen)
 {
-	uint idx;
-	struct chipcregs __iomem *cc;
 	uint base, i, sz;
 
 	/* Validate region selection */
@@ -365,14 +354,10 @@ ipxotp_read_region(struct otpinfo *oi, int region, u16 *data, uint *wlen)
 		return -EINVAL;
 	}
 
-	idx = ai_coreidx(oi->sih);
-	cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
-
 	/* Read the data */
 	for (i = 0; i < sz; i++)
-		data[i] = ipxotp_otpr(oi, cc, base + i);
+		data[i] = ipxotp_otpr(oi, base + i);
 
-	ai_setcoreidx(oi->sih, idx);
 	*wlen = sz;
 	return 0;
 }
@@ -384,14 +369,13 @@ static const struct otp_fn_s ipxotp_fn = {
 
 static int otp_init(struct si_pub *sih, struct otpinfo *oi)
 {
-
 	int ret;
 
 	memset(oi, 0, sizeof(struct otpinfo));
 
-	oi->ccrev = ai_get_ccrev(sih);
+	oi->core = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
 
-	if (OTPTYPE_IPX(oi->ccrev))
+	if (OTPTYPE_IPX(ai_get_ccrev(sih)))
 		oi->fn = &ipxotp_fn;
 
 	if (oi->fn == NULL)
@@ -399,7 +383,7 @@ static int otp_init(struct si_pub *sih, struct otpinfo *oi)
 
 	oi->sih = sih;
 
-	ret = (oi->fn->init) (sih, oi);
+	ret = (oi->fn->init)(sih, oi);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/brcm80211/include/chipcommon.h b/drivers/net/wireless/brcm80211/include/chipcommon.h
index fefabc3..f96834a 100644
--- a/drivers/net/wireless/brcm80211/include/chipcommon.h
+++ b/drivers/net/wireless/brcm80211/include/chipcommon.h
@@ -19,6 +19,8 @@
 
 #include "defs.h"		/* for PAD macro */
 
+#define CHIPCREGOFFS(field)	offsetof(struct chipcregs, field)
+
 struct chipcregs {
 	u32 chipid;		/* 0x0 */
 	u32 capabilities;
-- 
1.7.5.4


