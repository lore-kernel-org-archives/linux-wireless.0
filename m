Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3345 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Franky Lin" <frankyl@broadcom.com>, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/29] staging: brcm80211: remove code for unsupported
 chip
Date: Fri, 22 Jul 2011 20:56:56 +0200
Message-ID: <1311361036-3175-10-git-send-email-arend@broadcom.com> (sfid-20110722_205848_940203_CFDCB9E6)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Currently fullmac only support bcm4329. Remove dead code for
unsupported chip.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
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


