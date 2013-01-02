Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3914 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab3ABOXD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:03 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/18] brcmfmac: do not reconfigure refill rx on
 0-length packet.
Date: Wed, 2 Jan 2013 15:22:38 +0100
Message-ID: <1357136572-18273-6-git-send-email-arend@broadcom.com> (sfid-20130102_152313_395252_CE02F1C7)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When USB device gets removed rx complete comes with 0-length
packets. Do not refill those packets. In some rare cases it can
cause infinite loop.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 914c56f..22eae57 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -467,7 +467,11 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 			devinfo->bus_pub.bus->dstats.rx_errors++;
 		} else
 			brcmf_rx_packet(devinfo->dev, ifidx, skb);
-		brcmf_usb_rx_refill(devinfo, req);
+		/* zero lenght packets indicate usb "failure". Do not refill */
+		if (urb->actual_length)
+			brcmf_usb_rx_refill(devinfo, req);
+		else
+			brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req, NULL);
 	} else {
 		brcmu_pkt_buf_free_skb(skb);
 		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req, NULL);
-- 
1.7.10.4


