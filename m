Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:5000 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab2H3IGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 04:06:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/4] brcmfmac: dont use ZERO flag for usb IN
Date: Thu, 30 Aug 2012 10:05:35 +0200
Message-ID: <1346313937-3605-3-git-send-email-arend@broadcom.com> (sfid-20120830_100614_392123_5DC175FF)
In-Reply-To: <1346313937-3605-1-git-send-email-arend@broadcom.com>
References: <1346313937-3605-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

URB_ZERO_PACKET should only be set or bulk OUT and this condition
is checked with a WARN_ON in usb_submit_urb(). This patch fixes
brcmfmac to get rid of this warning filling the logs.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index f72dfb7..8ea2db7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -581,7 +581,6 @@ static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
 	usb_fill_bulk_urb(req->urb, devinfo->usbdev, devinfo->rx_pipe,
 			  skb->data, skb_tailroom(skb), brcmf_usb_rx_complete,
 			  req);
-	req->urb->transfer_flags |= URB_ZERO_PACKET;
 	req->devinfo = devinfo;
 
 	ret = usb_submit_urb(req->urb, GFP_ATOMIC);
-- 
1.7.9.5


