Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3078 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1HHN7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:22 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 02/82] staging: brcm80211: bugfix for len==0 parameter
 in 3 fullmac functions
Date: Mon, 8 Aug 2011 15:57:46 +0200
Message-ID: <1312811946-16713-3-git-send-email-arend@broadcom.com> (sfid-20110808_155926_156903_8C47C706)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Three functions use the same method to check incoming parameters. The
'len' parameter can be equal to 0 in case of a 'set' operation.
Currently these functions return an error code under that condition,
which is incorrect. The problem was introduced in recent patches in
which asserts were removed from the fullmac.

Despite this being a bug, my regression testing has not shown any problems.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 38bd9ba..e345af7 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -407,7 +407,7 @@ brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 	bool bool_val;
 	u32 actionid;
 
-	if (name == NULL || len <= 0)
+	if (name == NULL || len < 0)
 		return -EINVAL;
 
 	/* Set does not take qualifiers */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index fdec468..1e757b7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -311,7 +311,7 @@ brcmf_c_iovar_op(struct brcmf_pub *drvr, const char *name,
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	if (name == NULL || len <= 0)
+	if (name == NULL || len < 0)
 		return -EINVAL;
 
 	/* Set does not take qualifiers */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index ca6e60f..126a7ce 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -3123,7 +3123,7 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	if (name == NULL || len <= 0)
+	if (name == NULL || len < 0)
 		return -EINVAL;
 
 	/* Set does not take qualifiers */
-- 
1.7.4.1


