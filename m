Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1659 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab2KFAWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:45 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 18/24] brcmfmac: change return type of
 brcmf_sdio_hdparser
Date: Mon, 5 Nov 2012 16:22:26 -0800
Message-ID: <1352161352-30405-19-git-send-email-frankyl@broadcom.com> (sfid-20121106_013118_296833_BAEF8752)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use int instead of bool as the return type of function
brcmf_sdio_hdparser to explicitly describe error returns.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   47 ++++++++++----------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index eec1cbf..ba339f7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1037,9 +1037,9 @@ static void brcmf_sdbrcm_free_glom(struct brcmf_sdio *bus)
 	}
 }
 
-static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
-				struct brcmf_sdio_read *rd,
-				enum brcmf_sdio_frmtype type)
+static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
+			       struct brcmf_sdio_read *rd,
+			       enum brcmf_sdio_frmtype type)
 {
 	u16 len, checksum;
 	u8 rx_seq, fc, tx_seq_max;
@@ -1054,26 +1054,26 @@ static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	/* All zero means no more to read */
 	if (!(len | checksum)) {
 		bus->rxpending = false;
-		return false;
+		return -ENODATA;
 	}
 	if ((u16)(~(len ^ checksum))) {
 		brcmf_dbg(ERROR, "HW header checksum error\n");
 		bus->sdcnt.rx_badhdr++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
-		return false;
+		return -EIO;
 	}
 	if (len < SDPCM_HDRLEN) {
 		brcmf_dbg(ERROR, "HW header length error\n");
-		return false;
+		return -EPROTO;
 	}
 	if (type == BRCMF_SDIO_FT_SUPER &&
 	    (roundup(len, bus->blocksize) != rd->len)) {
 		brcmf_dbg(ERROR, "HW superframe header length error\n");
-		return false;
+		return -EPROTO;
 	}
 	if (type == BRCMF_SDIO_FT_SUB && len > rd->len) {
 		brcmf_dbg(ERROR, "HW subframe header length error\n");
-		return false;
+		return -EPROTO;
 	}
 	rd->len = len;
 
@@ -1091,7 +1091,7 @@ static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	    SDPCM_GLOMDESC(&header[SDPCM_FRAMETAG_LEN])) {
 		brcmf_dbg(ERROR, "Glom descriptor found in superframe head\n");
 		rd->len = 0;
-		return false;
+		return -EINVAL;
 	}
 	rx_seq = SDPCM_PACKET_SEQUENCE(&header[SDPCM_FRAMETAG_LEN]);
 	rd->channel = SDPCM_PACKET_CHANNEL(&header[SDPCM_FRAMETAG_LEN]);
@@ -1102,18 +1102,18 @@ static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 		bus->sdcnt.rx_toolong++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		rd->len = 0;
-		return false;
+		return -EPROTO;
 	}
 	if (type == BRCMF_SDIO_FT_SUPER && rd->channel != SDPCM_GLOM_CHANNEL) {
 		brcmf_dbg(ERROR, "Wrong channel for superframe\n");
 		rd->len = 0;
-		return false;
+		return -EINVAL;
 	}
 	if (type == BRCMF_SDIO_FT_SUB && rd->channel != SDPCM_DATA_CHANNEL &&
 	    rd->channel != SDPCM_EVENT_CHANNEL) {
 		brcmf_dbg(ERROR, "Wrong channel for subframe\n");
 		rd->len = 0;
-		return false;
+		return -EINVAL;
 	}
 	rd->dat_offset = SDPCM_DOFFSET_VALUE(&header[SDPCM_FRAMETAG_LEN]);
 	if (rd->dat_offset < SDPCM_HDRLEN || rd->dat_offset > rd->len) {
@@ -1121,7 +1121,7 @@ static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 		bus->sdcnt.rx_badhdr++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		rd->len = 0;
-		return false;
+		return -ENXIO;
 	}
 	if (rd->seq_num != rx_seq) {
 		brcmf_dbg(ERROR, "seq %d: sequence number error, expect %d\n",
@@ -1131,7 +1131,7 @@ static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	}
 	/* no need to check the reset for subframe */
 	if (type == BRCMF_SDIO_FT_SUB)
-		return true;
+		return 0;
 	rd->len_nxtfrm = header[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
 	if (rd->len_nxtfrm << 4 > MAX_RX_DATASZ) {
 		/* only warm for NON glom packet */
@@ -1155,7 +1155,7 @@ static bool brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	}
 	bus->tx_max = tx_seq_max;
 
-	return true;
+	return 0;
 }
 
 static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
@@ -1323,8 +1323,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		rd_new.seq_num = rxseq;
 		rd_new.len = dlen;
 		sdio_claim_host(bus->sdiodev->func[1]);
-		errcode = -!brcmf_sdio_hdparser(bus, pfirst->data, &rd_new,
-						   BRCMF_SDIO_FT_SUPER);
+		errcode = brcmf_sdio_hdparser(bus, pfirst->data, &rd_new,
+					      BRCMF_SDIO_FT_SUPER);
 		sdio_release_host(bus->sdiodev->func[1]);
 		bus->cur_read.len = rd_new.len_nxtfrm << 4;
 
@@ -1342,9 +1342,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			rd_new.len = pnext->len;
 			rd_new.seq_num = rxseq++;
 			sdio_claim_host(bus->sdiodev->func[1]);
-			errcode = -!brcmf_sdio_hdparser(bus, pnext->data,
-							   &rd_new,
-							   BRCMF_SDIO_FT_SUB);
+			errcode = brcmf_sdio_hdparser(bus, pnext->data, &rd_new,
+						      BRCMF_SDIO_FT_SUB);
 			sdio_release_host(bus->sdiodev->func[1]);
 			brcmf_dbg_hex_dump(BRCMF_GLOM_ON(),
 					   pnext->data, 32, "subframe:\n");
@@ -1612,8 +1611,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					   bus->rxhdr, SDPCM_HDRLEN,
 					   "RxHdr:\n");
 
-			if (!brcmf_sdio_hdparser(bus, bus->rxhdr, rd,
-						 BRCMF_SDIO_FT_NORMAL)) {
+			if (brcmf_sdio_hdparser(bus, bus->rxhdr, rd,
+						BRCMF_SDIO_FT_NORMAL)) {
 				sdio_release_host(bus->sdiodev->func[1]);
 				if (!bus->rxpending)
 					break;
@@ -1679,8 +1678,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			memcpy(bus->rxhdr, pkt->data, SDPCM_HDRLEN);
 			rd_new.seq_num = rd->seq_num;
 			sdio_claim_host(bus->sdiodev->func[1]);
-			if (!brcmf_sdio_hdparser(bus, bus->rxhdr, &rd_new,
-						 BRCMF_SDIO_FT_NORMAL)) {
+			if (brcmf_sdio_hdparser(bus, bus->rxhdr, &rd_new,
+						BRCMF_SDIO_FT_NORMAL)) {
 				rd->len = 0;
 				brcmu_pkt_buf_free_skb(pkt);
 			}
-- 
1.7.9.5


