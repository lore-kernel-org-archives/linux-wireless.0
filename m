Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35584 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdBBVdn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 16:33:43 -0500
Received: by mail-lf0-f66.google.com with SMTP id v186so42608lfa.2
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2017 13:33:43 -0800 (PST)
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
Subject: [PATCH V3 5/9] brcmfmac: pcie: store private pointer to struct brcmf_pub
Date: Thu,  2 Feb 2017 22:33:17 +0100
Message-Id: <20170202213321.11591-5-zajec5@gmail.com> (sfid-20170202_223359_398446_F4F36D60)
In-Reply-To: <20170202213321.11591-1-zajec5@gmail.com>
References: <20170202213321.11591-1-zajec5@gmail.com>
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
index 6fae4cf3f6ab..8a3c6e2e4b38 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -265,6 +265,7 @@ struct brcmf_pciedev_info {
 	void (*write_ptr)(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
 			  u16 value);
 	struct brcmf_mp_device *settings;
+	struct brcmf_pub *pub;
 };
 
 struct brcmf_pcie_ringbuf {
@@ -1564,14 +1565,18 @@ static void brcmf_pcie_release_resource(struct brcmf_pciedev_info *devinfo)
 
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
