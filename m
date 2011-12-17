Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1465 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/30] brcm80211: fmac: register a dummy irq handler for
 SDIO function 2
Date: Fri, 16 Dec 2011 18:36:53 -0800
Message-ID: <1324089440-8957-4-git-send-email-frankyl@broadcom.com> (sfid-20111217_033735_691535_4DA121A7)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When there is data available in dongle for driver to fetch, an
interrupt will be triggered and both SDIO function 1 and 2 will be
flagged by default in bcm4329. These two interrupt flags are
identical and only need to be handled once. Since there is no way
to turn off one flag from the dongle side, a dummy handler for
function 2 interrupt is placed.

Reported-by: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 6c85d66..32d72a0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -51,12 +51,18 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 	sdio_claim_host(func);
 }
 
+/* dummy handler for SDIO function 2 interrupt */
+static void brcmf_sdioh_dummy_irq_handler(struct sdio_func *func)
+{
+}
+
 int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
 {
 	brcmf_dbg(TRACE, "Entering\n");
 
 	sdio_claim_host(sdiodev->func[1]);
 	sdio_claim_irq(sdiodev->func[1], brcmf_sdioh_irqhandler);
+	sdio_claim_irq(sdiodev->func[2], brcmf_sdioh_dummy_irq_handler);
 	sdio_release_host(sdiodev->func[1]);
 
 	return 0;
@@ -67,6 +73,7 @@ int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev)
 	brcmf_dbg(TRACE, "Entering\n");
 
 	sdio_claim_host(sdiodev->func[1]);
+	sdio_release_irq(sdiodev->func[2]);
 	sdio_release_irq(sdiodev->func[1]);
 	sdio_release_host(sdiodev->func[1]);
 
-- 
1.7.5.4


