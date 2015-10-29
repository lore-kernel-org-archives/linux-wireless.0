Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:9595 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283AbbJ2Tnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 15:43:50 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 5/9] brcmfmac: Disable runtime pm for USB.
Date: Thu, 29 Oct 2015 20:33:15 +0100
Message-ID: <1446147199-21671-6-git-send-email-arend@broadcom.com> (sfid-20151029_204359_574485_8176BD9C)
In-Reply-To: <1446147199-21671-1-git-send-email-arend@broadcom.com>
References: <1446147199-21671-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Currently runtime pm is enabled for USB, but it is not properly
supported by driver. This patch disables the runtime PM support
completely for USB, as it currently can result in problems on
some systems.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 689e64d..fe8b2bc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1504,7 +1504,6 @@ static struct usb_driver brcmf_usbdrvr = {
 	.suspend = brcmf_usb_suspend,
 	.resume = brcmf_usb_resume,
 	.reset_resume = brcmf_usb_reset_resume,
-	.supports_autosuspend = 1,
 	.disable_hub_initiated_lpm = 1,
 };
 
-- 
1.9.1

