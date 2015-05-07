Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35578 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbbEGMN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 08:13:26 -0400
Received: by widdi4 with SMTP id di4so239663938wid.0
        for <linux-wireless@vger.kernel.org>; Thu, 07 May 2015 05:13:25 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: check result of USB firmware request
Date: Thu,  7 May 2015 14:13:03 +0200
Message-Id: <1431000783-17411-1-git-send-email-zajec5@gmail.com> (sfid-20150507_141330_375518_A40A6829)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prevents silence failures with driver waiting (infinitely) for a
callback.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
I don't really have any opinion if this should go for next or as a fix.
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 5df6aa7..daba86d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1270,8 +1270,13 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 	bus->chiprev = bus_pub->chiprev;
 
 	/* request firmware here */
-	brcmf_fw_get_firmwares(dev, 0, brcmf_usb_get_fwname(devinfo), NULL,
-			       brcmf_usb_probe_phase2);
+	ret = brcmf_fw_get_firmwares(dev, 0, brcmf_usb_get_fwname(devinfo),
+				     NULL, brcmf_usb_probe_phase2);
+	if (ret) {
+		brcmf_err("firmware request failed: %d\n", ret);
+		goto fail;
+	}
+
 	return 0;
 
 fail:
-- 
1.8.4.5

