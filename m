Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4902 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab2I0MSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:18:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/11] brcmfmac: notify common driver about usb tx
 completion.
Date: Thu, 27 Sep 2012 14:17:50 +0200
Message-ID: <1348748277-21460-5-git-send-email-arend@broadcom.com> (sfid-20120927_141839_572389_326DBBA1)
In-Reply-To: <1348748277-21460-1-git-send-email-arend@broadcom.com>
References: <1348748277-21460-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

brcmf_usb_tx_complete now calls brcmf_txcomplete to correct
eapol counter.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 555ccdd..a2b4b1e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -465,6 +465,8 @@ static void brcmf_usb_tx_complete(struct urb *urb)
 	else
 		devinfo->bus_pub.bus->dstats.tx_errors++;
 
+	brcmf_txcomplete(devinfo->dev, req->skb, urb->status == 0);
+
 	brcmu_pkt_buf_free_skb(req->skb);
 	req->skb = NULL;
 	brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req, &devinfo->tx_freecount);
-- 
1.7.9.5


