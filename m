Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3237 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab1HHN7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:35 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 62/82] staging: brcm80211: revert removal of atomic
 initialization
Date: Mon, 8 Aug 2011 15:58:46 +0200
Message-ID: <1312811946-16713-63-git-send-email-arend@broadcom.com> (sfid-20110808_160048_179240_D4FC8E38)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

The commit "staging: brcm80211: remove code for unsupported chip"
unintentionally got rid of initialization of the atomic variable
brcmf_mmc_suspend. The patch restore that particular piece of code.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 16ea6e8..2a9efc3 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -980,6 +980,8 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 			return -ENOMEM;
 		sdiodev->func1 = func;
 		dev_set_drvdata(&func->card->dev, sdiodev);
+
+		atomic_set(&brcmf_mmc_suspend, false);
 	}
 
 	gInstance->func[func->num] = func;
-- 
1.7.4.1


