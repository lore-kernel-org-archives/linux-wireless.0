Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:48678 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1K3Iuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 03:50:44 -0500
Date: Wed, 30 Nov 2011 11:49:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Alwin Beukers <alwin@broadcom.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] brcm80211: fmac: small memory leak on error
Message-ID: <20111130084937.GI6268@elgon.mountain> (sfid-20111130_095049_671505_4CF053EB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should free "bus_if" here, it's a small leak but it makes the static
checkers happy.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 77f84f8..b416e27 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -477,8 +477,10 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		if (!bus_if)
 			return -ENOMEM;
 		sdiodev = kzalloc(sizeof(struct brcmf_sdio_dev), GFP_KERNEL);
-		if (!sdiodev)
+		if (!sdiodev) {
+			kfree(bus_if);
 			return -ENOMEM;
+		}
 		sdiodev->dev = &func->card->dev;
 		sdiodev->func[0] = func->card->sdio_func[0];
 		sdiodev->func[1] = func;
