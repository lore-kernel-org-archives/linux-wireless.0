Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2379 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933184Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/26] staging: brcm80211: decreased indentation level
 of brcms_c_wme_setparams function
Date: Tue, 4 Oct 2011 23:19:01 +0200
Message-ID: <1317763152-17607-16-git-send-email-arend@broadcom.com> (sfid-20111004_232017_932966_16CEDFC4)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   40 +++++++++++++----------------
 1 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index d75756d..3349716 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -4199,26 +4199,23 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 		return;
 	}
 
-	do {
-		memset((char *)&acp_shm, 0, sizeof(struct shm_acparams));
-		/* fill in shm ac params struct */
-		acp_shm.txop = params->txop;
-		/* convert from units of 32us to us for ucode */
-		wlc->edcf_txop[aci & 0x3] = acp_shm.txop =
-		    EDCF_TXOP2USEC(acp_shm.txop);
-		acp_shm.aifs = (params->aifs & EDCF_AIFSN_MASK);
-
-		if (aci == AC_VI && acp_shm.txop == 0
-		    && acp_shm.aifs < EDCF_AIFSN_MAX)
-			acp_shm.aifs++;
-
-		if (acp_shm.aifs < EDCF_AIFSN_MIN
-		    || acp_shm.aifs > EDCF_AIFSN_MAX) {
-			wiphy_err(wlc->wiphy, "wl%d: edcf_setparams: bad "
-				  "aifs %d\n", wlc->pub->unit, acp_shm.aifs);
-			continue;
-		}
-
+	memset((char *)&acp_shm, 0, sizeof(struct shm_acparams));
+	/* fill in shm ac params struct */
+	acp_shm.txop = params->txop;
+	/* convert from units of 32us to us for ucode */
+	wlc->edcf_txop[aci & 0x3] = acp_shm.txop =
+	    EDCF_TXOP2USEC(acp_shm.txop);
+	acp_shm.aifs = (params->aifs & EDCF_AIFSN_MASK);
+
+	if (aci == AC_VI && acp_shm.txop == 0
+	    && acp_shm.aifs < EDCF_AIFSN_MAX)
+		acp_shm.aifs++;
+
+	if (acp_shm.aifs < EDCF_AIFSN_MIN
+	    || acp_shm.aifs > EDCF_AIFSN_MAX) {
+		wiphy_err(wlc->wiphy, "wl%d: edcf_setparams: bad "
+			  "aifs %d\n", wlc->pub->unit, acp_shm.aifs);
+	} else {
 		acp_shm.cwmin = params->cw_min;
 		acp_shm.cwmax = params->cw_max;
 		acp_shm.cwcur = acp_shm.cwmin;
@@ -4239,8 +4236,7 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 					  M_EDCF_QINFO +
 					  wme_ac2fifo[aci] * M_EDCF_QLEN + i,
 					  *shm_entry++);
-
-	} while (0);
+	}
 
 	if (suspend)
 		brcms_c_suspend_mac_and_wait(wlc);
-- 
1.7.4.1


