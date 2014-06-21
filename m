Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:16019 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbaFUKLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 06:11:23 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/8] brcmfmac: Add USB device 43566 to supported devices.
Date: Sat, 21 Jun 2014 12:11:13 +0200
Message-ID: <1403345479-13467-3-git-send-email-arend@broadcom.com> (sfid-20140621_121130_211212_ADC68E45)
In-Reply-To: <1403345479-13467-1-git-send-email-arend@broadcom.com>
References: <1403345479-13467-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Add the USB 43566 device to the supported devices list. The 43566
is a WiFi-only variant of the 43569. It uses the same FW as 43569.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index aa23559..d2927ac 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -929,6 +929,7 @@ static bool brcmf_usb_chip_support(int chipid, int chiprev)
 		return (chiprev == 3);
 	case 43242:
 		return true;
+	case 43566:
 	case 43569:
 		return true;
 	default:
@@ -1031,6 +1032,7 @@ static const char *brcmf_usb_get_fwname(struct brcmf_usbdev_info *devinfo)
 		return BRCMF_USB_43236_FW_NAME;
 	case 43242:
 		return BRCMF_USB_43242_FW_NAME;
+	case 43566:
 	case 43569:
 		return BRCMF_USB_43569_FW_NAME;
 	default:
-- 
1.7.9.5

