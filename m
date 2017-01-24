Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33269 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbdAXPGe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 10:06:34 -0500
Received: by mail-lf0-f65.google.com with SMTP id x1so17837350lff.0
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2017 07:06:28 -0800 (PST)
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
Subject: [PATCH 3/6] brcmfmac: pcie: store private pointer to struct brcmf_pub
Date: Tue, 24 Jan 2017 16:06:09 +0100
Message-Id: <20170124150612.25138-3-zajec5@gmail.com> (sfid-20170124_160641_695597_F02FD9B0)
In-Reply-To: <20170124150612.25138-1-zajec5@gmail.com>
References: <20170124150612.25138-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Getting this pointer in PCIe code is not trivial and requires using
dev_get_drvdata helper which adds extra line of code. Having access to
this struct is useful for using generic stuff and e.g. improving logging
messages.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 19db8f26729a..a6e7f670d893 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -265,6 +265,7 @@ struct brcmf_pciedev_info {
 	void (*write_ptr)(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
 			  u16 value);
 	struct brcmf_mp_device *settings;
+	struct brcmf_pub *pub;
 };
 
 struct brcmf_pcie_ringbuf {
@@ -1565,14 +1566,18 @@ static void brcmf_pcie_release_resource(struct brcmf_pciedev_info *devinfo)
 
 static int brcmf_pcie_attach_bus(struct brcmf_pciedev_info *devinfo)
 {
+	struct device *dev = &devinfo->pdev->dev;
+	struct brcmf_bus *bus = dev_get_drvdata(dev);
 	int ret;
 
 	/* Attach to the common driver interface */
-	ret = brcmf_attach(&devinfo->pdev->dev, devinfo->settings);
+	ret = brcmf_attach(dev, devinfo->settings);
 	if (ret) {
 		brcmf_err("brcmf_attach failed\n");
 	} else {
-		ret = brcmf_bus_started(&devinfo->pdev->dev);
+		devinfo->pub = bus->drvr;
+
+		ret = brcmf_bus_started(dev);
 		if (ret)
 			brcmf_err("dongle is not responding\n");
 	}
-- 
2.11.0
