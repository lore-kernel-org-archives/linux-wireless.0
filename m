Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3863 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759254Ab3JONpR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/12] brcmfmac: fix brcmf_sdcard_recv_chain() for host
 without sg support
Date: Tue, 15 Oct 2013 15:44:57 +0200
Message-ID: <1381844697-24881-13-git-send-email-arend@broadcom.com> (sfid-20131015_154539_670253_B52AC107)
In-Reply-To: <1381844697-24881-1-git-send-email-arend@broadcom.com>
References: <1381844697-24881-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the SDIO host controller does not support scatter-gather the glom
superframe must be transfered from the device and the data for each
packet in the queue must be extracted from it.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   21 ++++++++++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +-
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 1103dc1..3e10b80 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -569,8 +569,10 @@ done:
 }
 
 int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			    uint flags, struct sk_buff_head *pktq)
+			    uint flags, struct sk_buff_head *pktq, uint totlen)
 {
+	struct sk_buff *glom_skb;
+	struct sk_buff *skb;
 	uint width;
 	int err = 0;
 
@@ -582,7 +584,22 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (err)
 		goto done;
 
-	err = brcmf_sdio_sglist_rw(sdiodev, fn, false, addr, pktq);
+	if (pktq->qlen == 1)
+		err = brcmf_sdio_buffrw(sdiodev, fn, false, addr, pktq->next);
+	else if (!sdiodev->sg_support) {
+		glom_skb = brcmu_pkt_buf_get_skb(totlen);
+		if (!glom_skb)
+			return -ENOMEM;
+		err = brcmf_sdio_buffrw(sdiodev, fn, false, addr, glom_skb);
+		if (err)
+			goto done;
+
+		skb_queue_walk(pktq, skb) {
+			memcpy(skb->data, glom_skb->data, skb->len);
+			skb_pull(glom_skb, skb->len);
+		}
+	} else
+		err = brcmf_sdio_sglist_rw(sdiodev, fn, false, addr, pktq);
 
 done:
 	return err;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index c927701..b02953c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1392,7 +1392,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		sdio_claim_host(bus->sdiodev->func[1]);
 		errcode = brcmf_sdcard_recv_chain(bus->sdiodev,
 				bus->sdiodev->sbwad,
-				SDIO_FUNC_2, F2SYNC, &bus->glom);
+				SDIO_FUNC_2, F2SYNC, &bus->glom, dlen);
 		sdio_release_host(bus->sdiodev->func[1]);
 		bus->sdcnt.f2rxdata++;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 59c456f..1b034ea 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -225,7 +225,7 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		      uint flags, u8 *buf, uint nbytes);
 extern int
 brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
-			uint flags, struct sk_buff_head *pktq);
+			uint flags, struct sk_buff_head *pktq, uint totlen);
 
 /* Flags bits */
 
-- 
1.7.10.4


