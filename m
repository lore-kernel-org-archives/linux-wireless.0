Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1378 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/31] staging: brcm80211: clean up checkpatch error
Date: Wed, 6 Jul 2011 00:02:28 +0200
Message-ID: <1309903378-29021-2-git-send-email-arend@broadcom.com> (sfid-20110706_000406_387519_10447006)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A checkpatch error was introduced in following commit:

0f22b8a staging: brcm80211: remove MMC_SDIO_ABORT macro definition

The patch gets rid of the error.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 4c0a031..3f3f0ee 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -567,8 +567,7 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 				sdio_writeb(gInstance->func[func], *byte,
 					    regaddr, &err_ret);
 				sdio_release_host(gInstance->func[func]);
-			}
-			else if (regaddr < 0xF0) {
+			} else if (regaddr < 0xF0) {
 				sd_err(("brcmf: F0 Wr:0x%02x: write "
 					"disallowed\n", regaddr));
 			} else {
-- 
1.7.4.1


