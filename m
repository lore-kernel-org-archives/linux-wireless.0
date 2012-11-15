Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3376 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933303Ab2KOCrF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:47:05 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 17/19] brcmfmac: sdio module load fix.
Date: Wed, 14 Nov 2012 18:46:21 -0800
Message-ID: <1352947583-25341-18-git-send-email-frankyl@broadcom.com> (sfid-20121115_041528_006736_F42A70F8)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

On sdio module unload followed by load (without removing the
device) the access window should be moved back to enumeration
space. Force this by removing initialisation of sbwad during
probe.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 4c3315c..334ddab 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -516,9 +516,6 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 
 	regs = SI_ENUM_BASE;
 
-	/* Report the BAR, to fix if needed */
-	sdiodev->sbwad = SI_ENUM_BASE;
-
 	/* try to attach to the target device */
 	sdiodev->bus = brcmf_sdbrcm_probe(regs, sdiodev);
 	if (!sdiodev->bus) {
-- 
1.7.9.5


