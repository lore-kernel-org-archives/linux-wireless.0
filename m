Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4291 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389Ab1GNV34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:56 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/35] staging: brcm80211: removed function declaration
 typedefs from otp.c
Date: Thu, 14 Jul 2011 14:29:06 -0700
Message-ID: <1310678971-28952-11-git-send-email-frankyl@broadcom.com> (sfid-20110714_233135_072058_2AD5D482)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Softmac related code cleanup. Typedefs are undesirable according to the
CodingStyle document.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/otp.c |   34 +++++++++++------------------
 1 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index 34253cf..a257ed8 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -59,23 +59,15 @@
 
 #define MAXNUMRDES		9	/* Maximum OTP redundancy entries */
 
-/* OTP common function type */
-typedef int (*otp_status_t) (void *oh);
-typedef int (*otp_size_t) (void *oh);
-typedef void *(*otp_init_t) (struct si_pub *sih);
-typedef u16(*otp_read_bit_t) (void *oh, chipcregs_t *cc, uint off);
-typedef int (*otp_read_region_t) (struct si_pub *sih, int region, u16 *data,
-				  uint *wlen);
-typedef int (*otp_nvread_t) (void *oh, char *data, uint *len);
-
 /* OTP function struct */
 struct otp_fn_s {
-	otp_size_t size;
-	otp_read_bit_t read_bit;
-	otp_init_t init;
-	otp_read_region_t read_region;
-	otp_nvread_t nvread;
-	otp_status_t status;
+	int (*size)(void *oh);
+	u16 (*read_bit)(void *oh, chipcregs_t *cc, uint off);
+	void *(*init)(struct si_pub *sih);
+	int (*read_region)(struct si_pub *sih, int region, u16 *data,
+			   uint *wlen);
+	int (*nvread)(void *oh, char *data, uint *len);
+	int (*status)(void *oh);
 };
 
 struct otpinfo {
@@ -445,14 +437,14 @@ static int ipxotp_nvread(void *oh, char *data, uint *len)
 }
 
 static struct otp_fn_s ipxotp_fn = {
-	(otp_size_t) ipxotp_size,
-	(otp_read_bit_t) ipxotp_read_bit,
+	(int (*)(void *)) ipxotp_size,
+	(u16 (*)(void *, chipcregs_t *, uint)) ipxotp_read_bit,
 
-	(otp_init_t) ipxotp_init,
-	(otp_read_region_t) ipxotp_read_region,
-	(otp_nvread_t) ipxotp_nvread,
+	(void *(*)(struct si_pub *)) ipxotp_init,
+	(int (*)(struct si_pub *, int, u16 *, uint *)) ipxotp_read_region,
+	(int (*)(void *, char *, uint *)) ipxotp_nvread,
 
-	(otp_status_t) ipxotp_status
+	(int (*)(void *)) ipxotp_status
 };
 
 /*
-- 
1.7.1


