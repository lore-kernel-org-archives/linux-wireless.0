Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2727 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460Ab1HONem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:42 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/15] staging: brcm80211: replaced void pointers in otp
 functions
Date: Mon, 15 Aug 2011 15:34:15 +0200
Message-ID: <1313415267-5264-4-git-send-email-arend@broadcom.com> (sfid-20110815_154257_175135_F33B9092)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Otp is 'One Time Programmable' functionality. Replaced void
pointers by less generic pointer types.

Reported-by: Julian Calaby <julian.calaby@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/otp.c |   90 ++++++++++++-----------------
 drivers/staging/brcm80211/brcmsmac/otp.h |   12 ++--
 2 files changed, 44 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index b6ff767..1e0093c 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -66,13 +66,13 @@
 
 /* OTP function struct */
 struct otp_fn_s {
-	int (*size)(void *oh);
-	u16 (*read_bit)(void *oh, struct chipcregs *cc, uint off);
-	void *(*init)(struct si_pub *sih);
-	int (*read_region)(struct si_pub *sih, int region, u16 *data,
+	int (*size)(struct otpinfo *oi);
+	u16 (*read_bit)(struct otpinfo *oi, struct chipcregs *cc, uint off);
+	struct otpinfo *(*init)(struct si_pub *sih);
+	int (*read_region)(struct otpinfo *oi, int region, u16 *data,
 			   uint *wlen);
-	int (*nvread)(void *oh, char *data, uint *len);
-	int (*status)(void *oh);
+	int (*nvread)(struct otpinfo *oi, char *data, uint *len);
+	int (*status)(struct otpinfo *oi);
 };
 
 struct otpinfo {
@@ -148,31 +148,24 @@ static struct otpinfo otpinfo;
 #define OTP4315_SWREG_SZ	178	/* 178 bytes */
 #define OTP_SZ_FU_144		(144/8)	/* 144 bits */
 
-static int ipxotp_status(void *oh)
+static int ipxotp_status(struct otpinfo *oi)
 {
-	struct otpinfo *oi = (struct otpinfo *) oh;
 	return (int)(oi->status);
 }
 
 /* Return size in bytes */
-static int ipxotp_size(void *oh)
+static int ipxotp_size(struct otpinfo *oi)
 {
-	struct otpinfo *oi = (struct otpinfo *) oh;
 	return (int)oi->wsize * 2;
 }
 
-static u16 ipxotp_otpr(void *oh, struct chipcregs *cc, uint wn)
+static u16 ipxotp_otpr(struct otpinfo *oi, struct chipcregs *cc, uint wn)
 {
-	struct otpinfo *oi;
-
-	oi = (struct otpinfo *) oh;
-
 	return R_REG(&cc->sromotp[wn]);
 }
 
-static u16 ipxotp_read_bit(void *oh, struct chipcregs *cc, uint off)
+static u16 ipxotp_read_bit(struct otpinfo *oi, struct chipcregs *cc, uint off)
 {
-	struct otpinfo *oi = (struct otpinfo *) oh;
 	uint k, row, col;
 	u32 otpp, st;
 
@@ -300,7 +293,7 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs *cc)
 	oi->flim = oi->wsize;
 }
 
-static void *ipxotp_init(struct si_pub *sih)
+static struct otpinfo *ipxotp_init(struct si_pub *sih)
 {
 	uint idx;
 	struct chipcregs *cc;
@@ -355,12 +348,12 @@ static void *ipxotp_init(struct si_pub *sih)
 
 	ai_setcoreidx(sih, idx);
 
-	return (void *)oi;
+	return oi;
 }
 
-static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
+static int
+ipxotp_read_region(struct otpinfo *oi, int region, u16 *data, uint *wlen)
 {
-	struct otpinfo *oi = (struct otpinfo *) oh;
 	uint idx;
 	struct chipcregs *cc;
 	uint base, i, sz;
@@ -436,27 +429,27 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 
 	/* Read the data */
 	for (i = 0; i < sz; i++)
-		data[i] = ipxotp_otpr(oh, cc, base + i);
+		data[i] = ipxotp_otpr(oi, cc, base + i);
 
 	ai_setcoreidx(oi->sih, idx);
 	*wlen = sz;
 	return 0;
 }
 
-static int ipxotp_nvread(void *oh, char *data, uint *len)
+static int ipxotp_nvread(struct otpinfo *oi, char *data, uint *len)
 {
 	return -ENOTSUPP;
 }
 
 static struct otp_fn_s ipxotp_fn = {
-	(int (*)(void *)) ipxotp_size,
-	(u16 (*)(void *, struct chipcregs *, uint)) ipxotp_read_bit,
+	(int (*)(struct otpinfo *)) ipxotp_size,
+	(u16 (*)(struct otpinfo *, struct chipcregs *, uint)) ipxotp_read_bit,
 
-	(void *(*)(struct si_pub *)) ipxotp_init,
-	(int (*)(struct si_pub *, int, u16 *, uint *)) ipxotp_read_region,
-	(int (*)(void *, char *, uint *)) ipxotp_nvread,
+	(struct otpinfo *(*)(struct si_pub *)) ipxotp_init,
+	(int (*)(struct otpinfo *, int, u16 *, uint *)) ipxotp_read_region,
+	(int (*)(struct otpinfo *, char *, uint *)) ipxotp_nvread,
 
-	(int (*)(void *)) ipxotp_status
+	(int (*)(struct otpinfo *)) ipxotp_status
 };
 
 /*
@@ -468,34 +461,29 @@ static struct otp_fn_s ipxotp_fn = {
  *	otp_nvread()
  */
 
-int otp_status(void *oh)
+int otp_status(struct otpinfo *oi)
 {
-	struct otpinfo *oi = (struct otpinfo *) oh;
-
-	return oi->fn->status(oh);
+	return oi->fn->status(oi);
 }
 
-int otp_size(void *oh)
+int otp_size(struct otpinfo *oi)
 {
-	struct otpinfo *oi = (struct otpinfo *) oh;
-
-	return oi->fn->size(oh);
+	return oi->fn->size(oi);
 }
 
-u16 otp_read_bit(void *oh, uint offset)
+u16 otp_read_bit(struct otpinfo *oi, uint offset)
 {
-	struct otpinfo *oi = (struct otpinfo *) oh;
 	uint idx = ai_coreidx(oi->sih);
 	struct chipcregs *cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
-	u16 readBit = (u16) oi->fn->read_bit(oh, cc, offset);
+	u16 readBit = (u16) oi->fn->read_bit(oi, cc, offset);
 	ai_setcoreidx(oi->sih, idx);
 	return readBit;
 }
 
-void *otp_init(struct si_pub *sih)
+struct otpinfo *otp_init(struct si_pub *sih)
 {
 	struct otpinfo *oi;
-	void *ret = NULL;
+	struct otpinfo *ret = NULL;
 
 	oi = &otpinfo;
 	memset(oi, 0, sizeof(struct otpinfo));
@@ -516,9 +504,8 @@ void *otp_init(struct si_pub *sih)
 }
 
 int
-otp_read_region(struct si_pub *sih, int region, u16 *data,
-				 uint *wlen) {
-	void *oh;
+otp_read_region(struct si_pub *sih, int region, u16 *data, uint *wlen) {
+	struct otpinfo *oi;
 	int err = 0;
 
 	if (ai_is_otp_disabled(sih)) {
@@ -526,22 +513,19 @@ otp_read_region(struct si_pub *sih, int region, u16 *data,
 		goto out;
 	}
 
-	oh = otp_init(sih);
-	if (oh == NULL) {
+	oi = otp_init(sih);
+	if (oi == NULL) {
 		err = -EBADE;
 		goto out;
 	}
 
-	err = (((struct otpinfo *) oh)->fn->read_region)
-						(oh, region, data, wlen);
+	err = ((oi)->fn->read_region)(oi, region, data, wlen);
 
  out:
 	return err;
 }
 
-int otp_nvread(void *oh, char *data, uint *len)
+int otp_nvread(struct otpinfo *oi, char *data, uint *len)
 {
-	struct otpinfo *oi = (struct otpinfo *) oh;
-
-	return oi->fn->nvread(oh, data, len);
+	return oi->fn->nvread(oi, data, len);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.h b/drivers/staging/brcm80211/brcmsmac/otp.h
index 4d79246..938100e 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.h
+++ b/drivers/staging/brcm80211/brcmsmac/otp.h
@@ -36,13 +36,15 @@
 /* OTP usage */
 #define OTP4325_FM_DISABLED_OFFSET	188
 
+struct otpinfo;
+
 /* Exported functions */
-extern int otp_status(void *oh);
-extern int otp_size(void *oh);
-extern u16 otp_read_bit(void *oh, uint offset);
-extern void *otp_init(struct si_pub *sih);
+extern int otp_status(struct otpinfo *oi);
+extern int otp_size(struct otpinfo *oi);
+extern u16 otp_read_bit(struct otpinfo *oi, uint offset);
+extern struct otpinfo *otp_init(struct si_pub *sih);
 extern int otp_read_region(struct si_pub *sih, int region, u16 *data,
 			   uint *wlen);
-extern int otp_nvread(void *oh, char *data, uint *len);
+extern int otp_nvread(struct otpinfo *oi, char *data, uint *len);
 
 #endif				/* _BRCM_OTP_H_ */
-- 
1.7.4.1


