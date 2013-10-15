Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4377 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759251Ab3JONpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/12] brcmfmac: fix brcmf_sdcard_send_pkt() for host
 without sg support
Date: Tue, 15 Oct 2013 15:44:55 +0200
Message-ID: <1381844697-24881-11-git-send-email-arend@broadcom.com> (sfid-20131015_154538_464928_D4F8C9AE)
In-Reply-To: <1381844697-24881-1-git-send-email-arend@broadcom.com>
References: <1381844697-24881-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the host does not support scatter-gather transmit the packets
in the pktq individually using brcmf_sdio_buffrw().

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 92818d79..1103dc1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -620,6 +620,7 @@ int
 brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, struct sk_buff_head *pktq)
 {
+	struct sk_buff *skb;
 	uint width;
 	int err;
 
@@ -631,9 +632,16 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (err)
 		return err;
 
-	if (pktq->qlen == 1)
-		return brcmf_sdio_buffrw(sdiodev, fn, true, addr, pktq->next);
-	return brcmf_sdio_sglist_rw(sdiodev, fn, true, addr, pktq);
+	if (pktq->qlen == 1 || !sdiodev->sg_support)
+		skb_queue_walk(pktq, skb) {
+			err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, skb);
+			if (err)
+				break;
+		}
+	else
+		err = brcmf_sdio_sglist_rw(sdiodev, fn, true, addr, pktq);
+
+	return err;
 }
 
 int
-- 
1.7.10.4


