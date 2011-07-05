Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2953 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab1GEWDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 31/31] staging: brcm80211: added newlines to some debug
 macros in bcmsdh_sdmmc.c
Date: Wed, 6 Jul 2011 00:02:58 +0200
Message-ID: <1309903378-29021-32-git-send-email-arend@broadcom.com> (sfid-20110706_000332_862898_57110949)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some macros were missing a terminating '\n' character. This commit fixes
those.

Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 6567363..38bd9ba 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -220,7 +220,7 @@ static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
 	sdio_release_host(gInstance->func[1]);
 	if (err_ret) {
 		sd_err(("brcmf_sdioh_enablefuncs: Failed to enable F1 "
-			"Err: 0x%08x", err_ret));
+			"Err: 0x%08x\n", err_ret));
 	}
 
 	return false;
@@ -671,7 +671,7 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 						if (err_ret)
 							sd_err(("request_byte: "
 								"enable F2 "
-								"failed:%d",
+								"failed:%d\n",
 								 err_ret));
 					} else {
 						/* Disable Function 2 */
@@ -681,7 +681,7 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 						if (err_ret)
 							sd_err(("request_byte: "
 								"Disab F2 "
-								"failed:%d",
+								"failed:%d\n",
 								 err_ret));
 					}
 					sdio_release_host(gInstance->func[2]);
@@ -789,7 +789,7 @@ brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 	sdio_release_host(gInstance->func[func]);
 
 	if (err_ret) {
-		sd_err(("brcmf: Failed to %s word, Err: 0x%08x",
+		sd_err(("brcmf: Failed to %s word, Err: 0x%08x\n",
 			rw ? "Write" : "Read", err_ret));
 	}
 
-- 
1.7.4.1


