Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1914 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034Ab1F2Xsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:54 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 012/119] staging: brcm80211: remove otp power control
 functions
Date: Wed, 29 Jun 2011 16:46:36 -0700
Message-ID: <1309391303-22741-13-git-send-email-frankyl@broadcom.com> (sfid-20110630_015113_870289_BD1807A4)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

For the devices supported by brcmsmac driver the OTP device is always
powered. Functions for reading power status and changing it are not
needed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |   14 --------------
 drivers/staging/brcm80211/brcmsmac/aiutils.h |    2 --
 drivers/staging/brcm80211/brcmsmac/otp.c     |   15 ++-------------
 3 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index d41104f..2018664 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -2277,17 +2277,3 @@ bool ai_is_otp_disabled(struct si_pub *sih)
 		return false;
 	}
 }
-
-bool ai_is_otp_powered(struct si_pub *sih)
-{
-	if (PMUCTL_ENAB(sih))
-		return si_pmu_is_otp_powered(sih);
-	return true;
-}
-
-void ai_otp_power(struct si_pub *sih, bool on)
-{
-	if (PMUCTL_ENAB(sih))
-		si_pmu_otp_power(sih, on);
-	udelay(1000);
-}
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 66d9471..965eb94 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -558,8 +558,6 @@ extern u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val,
 
 /* OTP status */
 extern bool ai_is_otp_disabled(struct si_pub *sih);
-extern bool ai_is_otp_powered(struct si_pub *sih);
-extern void ai_otp_power(struct si_pub *sih, bool on);
 
 /* SPROM availability */
 extern bool ai_is_sprom_available(struct si_pub *sih);
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index 2cda60f..4e19b35 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -310,10 +310,7 @@ static void *ipxotp_init(struct si_pub *sih)
 	if (ai_is_otp_disabled(sih))
 		return NULL;
 
-	/* Make sure OTP is powered up */
-	if (!ai_is_otp_powered(sih))
-		return NULL;
-
+	/* OTP is always powered */
 	oi = &otpinfo;
 
 	/* Check for otp size */
@@ -518,15 +515,10 @@ void *otp_init(struct si_pub *sih)
 int
 otp_read_region(struct si_pub *sih, int region, u16 *data,
 				 uint *wlen) {
-	bool wasup = false;
 	void *oh;
 	int err = 0;
 
-	wasup = ai_is_otp_powered(sih);
-	if (!wasup)
-		ai_otp_power(sih, true);
-
-	if (!ai_is_otp_powered(sih) || ai_is_otp_disabled(sih)) {
+	if (ai_is_otp_disabled(sih)) {
 		err = -EPERM;
 		goto out;
 	}
@@ -540,9 +532,6 @@ otp_read_region(struct si_pub *sih, int region, u16 *data,
 	err = (((otpinfo_t *) oh)->fn->read_region) (oh, region, data, wlen);
 
  out:
-	if (!wasup)
-		ai_otp_power(sih, false);
-
 	return err;
 }
 
-- 
1.7.1


