Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36053 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbdAXPGp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 10:06:45 -0500
Received: by mail-lf0-f68.google.com with SMTP id h65so17688323lfi.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2017 07:06:44 -0800 (PST)
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
Subject: [PATCH 4/6] brcmfmac: usb: store private pointer to struct brcmf_pub
Date: Tue, 24 Jan 2017 16:06:10 +0100
Message-Id: <20170124150612.25138-4-zajec5@gmail.com> (sfid-20170124_160652_484174_44E0DE77)
In-Reply-To: <20170124150612.25138-1-zajec5@gmail.com>
References: <20170124150612.25138-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Having access to this struct is useful for using generic stuff and e.g.
improving logging messages.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index d93ebbdc7737..523949c44861 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -174,6 +174,7 @@ struct brcmf_usbdev_info {
 
 	bool wowl_enabled;
 	struct brcmf_mp_device *settings;
+	struct brcmf_pub *pub;
 };
 
 static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
@@ -1135,26 +1136,29 @@ static const struct brcmf_bus_ops brcmf_usb_bus_ops = {
 
 static int brcmf_usb_bus_setup(struct brcmf_usbdev_info *devinfo)
 {
+	struct device *dev = devinfo->dev;
+	struct brcmf_bus *bus = dev_get_drvdata(dev);
 	int ret;
 
 	/* Attach to the common driver interface */
-	ret = brcmf_attach(devinfo->dev, devinfo->settings);
+	ret = brcmf_attach(dev, devinfo->settings);
 	if (ret) {
 		brcmf_err("brcmf_attach failed\n");
 		return ret;
 	}
+	devinfo->pub = bus->drvr;
 
-	ret = brcmf_usb_up(devinfo->dev);
+	ret = brcmf_usb_up(dev);
 	if (ret)
 		goto fail;
 
-	ret = brcmf_bus_started(devinfo->dev);
+	ret = brcmf_bus_started(dev);
 	if (ret)
 		goto fail;
 
 	return 0;
 fail:
-	brcmf_detach(devinfo->dev);
+	brcmf_detach(dev);
 	return ret;
 }
 
-- 
2.11.0
