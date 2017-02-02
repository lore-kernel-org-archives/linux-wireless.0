Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33343 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbdBBVdr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 16:33:47 -0500
Received: by mail-lf0-f66.google.com with SMTP id x1so50363lff.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2017 13:33:46 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V3 7/9] brcmfmac: sdio: store private pointer to struct brcmf_pub
Date: Thu,  2 Feb 2017 22:33:19 +0100
Message-Id: <20170202213321.11591-7-zajec5@gmail.com> (sfid-20170202_223359_708955_21E3EB5F)
In-Reply-To: <20170202213321.11591-1-zajec5@gmail.com>
References: <20170202213321.11591-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Having access to this struct is useful for using generic stuff and e.g.
improving logging messages.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Add this (new) patch
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index c5744b45ec8f..81a1e24852e0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -434,6 +434,7 @@ struct brcmf_sdio_count {
 struct brcmf_sdio {
 	struct brcmf_sdio_dev *sdiodev;	/* sdio device handler */
 	struct brcmf_chip *ci;	/* Chip info struct */
+	struct brcmf_pub *pub;	/* Bus generic struct */
 
 	u32 hostintmask;	/* Copy of Host Interrupt Mask */
 	atomic_t intstatus;	/* Intstatus bits (events) pending */
@@ -4155,6 +4156,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 		brcmf_err("brcmf_attach failed\n");
 		goto fail;
 	}
+	bus->pub = sdiodev->bus_if->drvr;
 
 	/* allocate scatter-gather table. sg support
 	 * will be disabled upon allocation failure.
-- 
2.11.0
