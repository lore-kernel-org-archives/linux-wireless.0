Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34771 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaE0K4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:35 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/16] brcmfmac: Add log of superspeed device detection to USB probe.
Date: Tue, 27 May 2014 12:56:20 +0200
Message-ID: <1401188188-16492-9-git-send-email-arend@broadcom.com> (sfid-20140527_125648_479103_FA30CD84)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 3c3ffff..8d67940 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1417,7 +1417,9 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	devinfo->interval = IFEPDESC(usb, CONTROL_IF, 0).bInterval;
 
-	if (usb->speed == USB_SPEED_HIGH)
+	if (usb->speed == USB_SPEED_SUPER)
+		brcmf_dbg(USB, "Broadcom super speed USB wireless device detected\n");
+	else if (usb->speed == USB_SPEED_HIGH)
 		brcmf_dbg(USB, "Broadcom high speed USB wireless device detected\n");
 	else
 		brcmf_dbg(USB, "Broadcom full speed USB wireless device detected\n");
-- 
1.7.9.5

