Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4626 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933212Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 23/26] staging: brcm80211: combined if statements
Date: Tue, 4 Oct 2011 23:19:09 +0200
Message-ID: <1317763152-17607-24-git-send-email-arend@broadcom.com> (sfid-20111004_232001_272856_5ED867FD)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Combined if statements in brcms_c_edcf_setparams and brcms_c_wme_setparams functions.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 4e2226e..30c5573 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -4186,12 +4186,10 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 					  *shm_entry++);
 	}
 
-	if (suspend)
+	if (suspend) {
 		brcms_c_suspend_mac_and_wait(wlc);
-
-	if (suspend)
 		brcms_c_enable_mac(wlc);
-
+	}
 }
 
 void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
@@ -4223,12 +4221,10 @@ void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 		brcms_c_wme_setparams(wlc, aci, &txq_pars, suspend);
 	}
 
-	if (suspend)
+	if (suspend) {
 		brcms_c_suspend_mac_and_wait(wlc);
-
-	if (suspend)
 		brcms_c_enable_mac(wlc);
-
+	}
 }
 
 /* maintain LED behavior in down state */
-- 
1.7.4.1


