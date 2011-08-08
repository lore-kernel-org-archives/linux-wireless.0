Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1713 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab1HHN71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:27 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 11/82] staging: brcm80211: removed function
 declaration typedefs from otp.c
Date: Mon, 8 Aug 2011 15:57:55 +0200
Message-ID: <1312811946-16713-12-git-send-email-arend@broadcom.com> (sfid-20110808_160152_642315_37654363)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Softmac related code cleanup. Typedefs are undesirable according to the
CodingStyle document.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
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
1.7.4.1


