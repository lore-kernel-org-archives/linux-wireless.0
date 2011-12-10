Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp201.alice.it ([82.57.200.97]:40475 "EHLO smtp201.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab1LJRvM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 12:51:12 -0500
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: "Franky Lin" <frankyl@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH] brcm80211: fmac: try to add a dummy interupt handler for sdio function 2
Date: Sat, 10 Dec 2011 18:51:03 +0100
Message-Id: <1323539463-6072-2-git-send-email-GNUtoo@no-log.org> (sfid-20111210_185121_542391_BFC263A8)
In-Reply-To: <1323539463-6072-1-git-send-email-GNUtoo@no-log.org>
References: <4ECC1F41.90003@broadcom.com>
 <1323539463-6072-1-git-send-email-GNUtoo@no-log.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 74933dc..62cb779 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -52,10 +52,19 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 	sdio_claim_host(func);
 }
 
+static void brcmf_sdioh_dummy_irqhandler(struct sdio_func *func)
+{
+	brcmf_dbg(TRACE, "*** DUMMY IRQHandler\n");
+}
+
 int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
 {
 	brcmf_dbg(TRACE, "Entering\n");
 
+	sdio_claim_host(sdiodev->func[2]);
+	sdio_claim_irq(sdiodev->func[2], brcmf_sdioh_dummy_irqhandler);
+	sdio_release_host(sdiodev->func[2]);
+
 	sdio_claim_host(sdiodev->func[1]);
 	sdio_claim_irq(sdiodev->func[1], brcmf_sdioh_irqhandler);
 	sdio_release_host(sdiodev->func[1]);
@@ -71,6 +80,10 @@ int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev)
 	sdio_release_irq(sdiodev->func[1]);
 	sdio_release_host(sdiodev->func[1]);
 
+	sdio_claim_host(sdiodev->func[2]);
+	sdio_release_irq(sdiodev->func[2]);
+	sdio_release_host(sdiodev->func[2]);
+
 	return 0;
 }
 
-- 
1.7.4.1

