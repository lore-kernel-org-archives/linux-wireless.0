Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2364 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933180Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 24/26] staging: brcm80211: remove N mode validation
 function
Date: Tue, 4 Oct 2011 23:19:10 +0200
Message-ID: <1317763152-17607-25-git-send-email-arend@broadcom.com> (sfid-20111004_232041_918935_BC626BB4)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Removed the brcms_c_nmode_validate function as it only checks N-mode
capability, which should always be true.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   29 -----------------------------
 1 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 30c5573..9fa8485 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -5912,40 +5912,11 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	return ret;
 }
 
-static int brcms_c_nmode_validate(struct brcms_c_info *wlc, s32 nmode)
-{
-	int err = 0;
-
-	switch (nmode) {
-
-	case OFF:
-		break;
-
-	case AUTO:
-	case WL_11N_2x2:
-	case WL_11N_3x3:
-		if (!(BRCMS_PHY_11N_CAP(wlc->band)))
-			err = -EINVAL;
-		break;
-
-	default:
-		err = -EINVAL;
-		break;
-	}
-
-	return err;
-}
-
 int brcms_c_set_nmode(struct brcms_c_info *wlc)
 {
 	uint i;
-	int err;
 	s32 nmode = AUTO;
 
-	err = brcms_c_nmode_validate(wlc, nmode);
-	if (err)
-		return err;
-
 	if (wlc->stf->txstreams == WL_11N_3x3)
 		nmode = WL_11N_3x3;
 	else
-- 
1.7.4.1


