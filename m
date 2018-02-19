Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:47999 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932343AbeBSXOe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 18:14:34 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 4/8] brcmfmac: usb: call brcmf_usb_up() during brcmf_bus_preinit()
Date: Tue, 20 Feb 2018 00:14:21 +0100
Message-Id: <1519082065-10128-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180220_001455_088383_23DE8BBF)
In-Reply-To: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By calling brcmf_usb_up() during brcmf_bus_preinit() it does not need
to be called in brcmf_usb_bus_setup().

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index b27170c..d22cd166 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1146,8 +1146,9 @@ static int brcmf_usb_get_fwname(struct device *dev, u32 chip, u32 chiprev,
 }
 
 static const struct brcmf_bus_ops brcmf_usb_bus_ops = {
-	.txdata = brcmf_usb_tx,
+	.preinit = brcmf_usb_up,
 	.stop = brcmf_usb_down,
+	.txdata = brcmf_usb_tx,
 	.txctl = brcmf_usb_tx_ctlpkt,
 	.rxctl = brcmf_usb_rx_ctlpkt,
 	.wowl_config = brcmf_usb_wowl_config,
@@ -1165,10 +1166,6 @@ static int brcmf_usb_bus_setup(struct brcmf_usbdev_info *devinfo)
 		return ret;
 	}
 
-	ret = brcmf_usb_up(devinfo->dev);
-	if (ret)
-		goto fail;
-
 	ret = brcmf_bus_started(devinfo->dev);
 	if (ret)
 		goto fail;
-- 
1.9.1
