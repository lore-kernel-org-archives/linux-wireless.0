Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:30964 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3LLK7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:18 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 18/18] brcmfmac: clarify struct brcmf_sdio_dev::func[0] reference
Date: Thu, 12 Dec 2013 11:59:06 +0100
Message-ID: <1386845946-9859-19-git-send-email-arend@broadcom.com> (sfid-20131212_115933_859330_91A5BDE8)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The struct brcmf_sdio_dev contains array of sdio functions that
are used in the driver. However, during probe func[0] entry was
assigned to the function 1 reference. This was corrected upon
doing the actual I/O access. This patch makes it more clear by
creating the func[0] entry properly and use it as is during
I/O access.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   36 ++++++++++------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 337802c..6bf0473 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -197,32 +197,21 @@ int brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 	return 0;
 }
 
-static inline int brcmf_sdiod_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
-					    uint regaddr, u8 *byte)
+static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func,
+					uint regaddr, u8 byte)
 {
-	struct sdio_func *sdfunc = sdiodev->func[0];
 	int err_ret;
 
 	/*
 	 * Can only directly write to some F0 registers.
-	 * Handle F2 enable/disable and Abort command
+	 * Handle CCCR_IENx and CCCR_ABORT command
 	 * as a special case.
 	 */
 	if ((regaddr == SDIO_CCCR_ABORT) ||
-	    (regaddr == SDIO_CCCR_IENx)) {
-		sdfunc = kmemdup(sdiodev->func[0], sizeof(struct sdio_func),
-				 GFP_KERNEL);
-		if (!sdfunc)
-			return -ENOMEM;
-		sdfunc->num = 0;
-		sdio_writeb(sdfunc, *byte, regaddr, &err_ret);
-		kfree(sdfunc);
-	} else if (regaddr < 0xF0) {
-		brcmf_err("F0 Wr:0x%02x: write disallowed\n", regaddr);
-		err_ret = -EPERM;
-	} else {
-		sdio_f0_writeb(sdfunc, *byte, regaddr, &err_ret);
-	}
+	    (regaddr == SDIO_CCCR_IENx))
+		sdio_writeb(func, byte, regaddr, &err_ret);
+	else
+		sdio_f0_writeb(func, byte, regaddr, &err_ret);
 
 	return err_ret;
 }
@@ -240,7 +229,8 @@ static int brcmf_sdiod_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw,
 
 	if (rw && func == 0) {
 		/* handle F0 separately */
-		err_ret = brcmf_sdiod_f0_write_byte(sdiodev, regaddr, byte);
+		err_ret = brcmf_sdiod_f0_writeb(sdiodev->func[func],
+						regaddr, *byte);
 	} else {
 		if (rw) /* CMD52 Write */
 			sdio_writeb(sdiodev->func[func], *byte, regaddr,
@@ -1030,7 +1020,11 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		return -ENOMEM;
 	}
 
-	sdiodev->func[0] = func->card->sdio_func[0];
+	/* store refs to functions used. mmc_card does
+	 * not hold the F0 function pointer.
+	 */
+	sdiodev->func[0] = kmemdup(func, sizeof(*func), GFP_KERNEL);
+	sdiodev->func[0]->num = 0;
 	sdiodev->func[1] = func->card->sdio_func[0];
 	sdiodev->func[2] = func;
 
@@ -1060,6 +1054,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 fail:
 	dev_set_drvdata(&func->dev, NULL);
 	dev_set_drvdata(&sdiodev->func[1]->dev, NULL);
+	kfree(sdiodev->func[0]);
 	kfree(sdiodev);
 	kfree(bus_if);
 	return err;
@@ -1087,6 +1082,7 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 		dev_set_drvdata(&sdiodev->func[2]->dev, NULL);
 
 		kfree(bus_if);
+		kfree(sdiodev->func[0]);
 		kfree(sdiodev);
 	}
 
-- 
1.7.10.4

