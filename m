Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2051 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1GNV3t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:49 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 01/35] staging: brcm80211: bugfix for len==0 parameter
 in 3 fullmac functions
Date: Thu, 14 Jul 2011 14:28:57 -0700
Message-ID: <1310678971-28952-2-git-send-email-frankyl@broadcom.com> (sfid-20110714_232954_014762_1F845F6B)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
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
index 7fa95b6..acad298 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -3123,7 +3123,7 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	if (name == NULL || len <= 0)
+	if (name == NULL || len < 0)
 		return -EINVAL;
 
 	/* Set does not take qualifiers */
-- 
1.7.1


