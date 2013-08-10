Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2734 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968545Ab3HJK14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:27:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/12] brcmfmac: use configurable sdio bus header length
 for tx packet
Date: Sat, 10 Aug 2013 12:27:29 +0200
Message-ID: <1376130450-29746-12-git-send-email-arend@broadcom.com> (sfid-20130810_122820_463876_3A3EC740)
In-Reply-To: <1376130450-29746-1-git-send-email-arend@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Host tx glomming require an extended hardware sdio bus header to store
information for dongle. Introduce a variable in struct brcmf_sdio to replace
macro SDPCM_HDRLEN

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 30 ++++++++++++----------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 02ab5cd..1aa75d5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -461,6 +461,8 @@ struct brcmf_sdio {
 	struct brcmf_sdio_count sdcnt;
 	bool sr_enabled; /* SaveRestore enabled */
 	bool sleeping; /* SDIO bus sleeping */
+
+	u8 tx_hdrlen;		/* sdio bus header length for tx packet */
 };
 
 /* clkstate */
@@ -1025,7 +1027,6 @@ static void brcmf_sdbrcm_free_glom(struct brcmf_sdio *bus)
 #define SDPCM_HWHDR_LEN			4
 #define SDPCM_SWHDR_LEN			8
 #define SDPCM_HDRLEN			(SDPCM_HWHDR_LEN + SDPCM_SWHDR_LEN)
-#define SDPCM_RESERVE			(SDPCM_HDRLEN + BRCMF_SDALIGN)
 /* software header */
 #define SDPCM_SEQ_MASK			0x000000ff
 #define SDPCM_SEQ_WRAP			256
@@ -1838,7 +1839,7 @@ brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		}
 		skb_push(pkt_next, head_pad);
 		dat_buf = (u8 *)(pkt_next->data);
-		memset(dat_buf, 0, head_pad + SDPCM_HDRLEN);
+		memset(dat_buf, 0, head_pad + bus->tx_hdrlen);
 	}
 
 	/* Check tail padding */
@@ -1874,7 +1875,7 @@ brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 	else
 		hd_info.len = pkt_next->len - tail_pad;
 	hd_info.channel = chan;
-	hd_info.dat_offset = head_pad + SDPCM_HDRLEN;
+	hd_info.dat_offset = head_pad + bus->tx_hdrlen;
 	brcmf_sdio_hdpack(bus, dat_buf, &hd_info);
 
 	if (BRCMF_BYTES_ON() &&
@@ -1882,7 +1883,7 @@ brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 	     (BRCMF_DATA_ON() && chan != SDPCM_CONTROL_CHANNEL)))
 		brcmf_dbg_hex_dump(true, pkt_next, hd_info.len, "Tx Frame:\n");
 	else if (BRCMF_HDRS_ON())
-		brcmf_dbg_hex_dump(true, pkt_next, head_pad + SDPCM_HDRLEN,
+		brcmf_dbg_hex_dump(true, pkt_next, head_pad + bus->tx_hdrlen,
 				   "Tx Header:\n");
 
 	return 0;
@@ -1989,7 +1990,6 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	u32 intstatus = 0;
 	int ret = 0, prec_out;
 	uint cnt = 0;
-	uint datalen;
 	u8 tx_prec_map;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -2005,7 +2005,6 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 			break;
 		}
 		spin_unlock_bh(&bus->txqlock);
-		datalen = pkt->len - SDPCM_HDRLEN;
 
 		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL);
 
@@ -2392,7 +2391,7 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	datalen = pkt->len;
 
 	/* Add space for the header */
-	skb_push(pkt, SDPCM_HDRLEN);
+	skb_push(pkt, bus->tx_hdrlen);
 	/* precondition: IS_ALIGNED((unsigned long)(pkt->data), 2) */
 
 	prec = prio2prec((pkt->priority & PRIOMASK));
@@ -2405,7 +2404,7 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	/* Priority based enq */
 	spin_lock_irqsave(&bus->txqlock, flags);
 	if (!brcmf_c_prec_enq(bus->sdiodev->dev, &bus->txq, pkt, prec)) {
-		skb_pull(pkt, SDPCM_HDRLEN);
+		skb_pull(pkt, bus->tx_hdrlen);
 		brcmf_err("out of bus->txq !!!\n");
 		ret = -ENOSR;
 	} else {
@@ -2566,8 +2565,8 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Back the pointer to make a room for bus header */
-	frame = msg - SDPCM_HDRLEN;
-	len = (msglen += SDPCM_HDRLEN);
+	frame = msg - bus->tx_hdrlen;
+	len = (msglen += bus->tx_hdrlen);
 
 	/* Add alignment padding (optional for ctl frames) */
 	doff = ((unsigned long)frame % BRCMF_SDALIGN);
@@ -2575,10 +2574,10 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 		frame -= doff;
 		len += doff;
 		msglen += doff;
-		memset(frame, 0, doff + SDPCM_HDRLEN);
+		memset(frame, 0, doff + bus->tx_hdrlen);
 	}
 	/* precondition: doff < BRCMF_SDALIGN */
-	doff += SDPCM_HDRLEN;
+	doff += bus->tx_hdrlen;
 
 	/* Round send length to next SDIO block */
 	if (bus->roundup && bus->blocksize && (len > bus->blocksize)) {
@@ -3895,8 +3894,11 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	bus->sdiodev->bus_if->chip = bus->ci->chip;
 	bus->sdiodev->bus_if->chiprev = bus->ci->chiprev;
 
-	/* Attach to the brcmf/OS/network interface */
-	ret = brcmf_attach(SDPCM_RESERVE, bus->sdiodev->dev);
+	/* default sdio bus header length for tx packet */
+	bus->tx_hdrlen = SDPCM_HWHDR_LEN + SDPCM_SWHDR_LEN;
+
+	/* Attach to the common layer, reserve hdr space */
+	ret = brcmf_attach(bus->tx_hdrlen, bus->sdiodev->dev);
 	if (ret != 0) {
 		brcmf_err("brcmf_attach failed\n");
 		goto fail;
-- 
1.8.1.3


