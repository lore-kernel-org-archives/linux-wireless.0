Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2424 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab1JBRO7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:14:59 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 11/20] staging: brcm80211: reduce indentation level in
 dhd_sdio.c #2
Date: Sun, 2 Oct 2011 10:14:36 -0700
Message-ID: <1317575685-3156-12-git-send-email-frankyl@broadcom.com> (sfid-20111002_191515_202294_44302233)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

By introducing 1 new function.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  103 ++++++++++++++-----------
 1 files changed, 58 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 169c6b2..cabf912 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -1797,6 +1797,62 @@ brcmf_alloc_pkt_and_read(struct brcmf_bus *bus, u16 rdlen,
 	}
 }
 
+/* Checks the header */
+static int
+brcmf_check_rxbuf(struct brcmf_bus *bus, struct sk_buff *pkt, u8 *rxbuf,
+		  u8 rxseq, u16 nextlen, u16 *len)
+{
+	u16 check;
+	bool len_consistent;	/* Result of comparing readahead len and
+				   len from hw-hdr */
+
+	memcpy(bus->rxhdr, rxbuf, SDPCM_HDRLEN);
+
+	/* Extract hardware header fields */
+	*len = get_unaligned_le16(bus->rxhdr);
+	check = get_unaligned_le16(bus->rxhdr + sizeof(u16));
+
+	/* All zeros means readahead info was bad */
+	if (!(*len | check)) {
+		brcmf_dbg(INFO, "(nextlen): read zeros in HW header???\n");
+		goto fail;
+	}
+
+	/* Validate check bytes */
+	if ((u16)~(*len ^ check)) {
+		brcmf_dbg(ERROR, "(nextlen): HW hdr error: nextlen/len/check 0x%04x/0x%04x/0x%04x\n",
+			  nextlen, *len, check);
+		bus->rx_badhdr++;
+		brcmf_sdbrcm_rxfail(bus, false, false);
+		goto fail;
+	}
+
+	/* Validate frame length */
+	if (*len < SDPCM_HDRLEN) {
+		brcmf_dbg(ERROR, "(nextlen): HW hdr length invalid: %d\n",
+			  *len);
+		goto fail;
+	}
+
+	/* Check for consistency with readahead info */
+	len_consistent = (nextlen != (roundup(*len, 16) >> 4));
+	if (len_consistent) {
+		/* Mismatch, force retry w/normal
+			header (may be >4K) */
+		brcmf_dbg(ERROR, "(nextlen): mismatch, nextlen %d len %d rnd %d; expected rxseq %d\n",
+			  nextlen, *len, roundup(*len, 16),
+			  rxseq);
+		brcmf_sdbrcm_rxfail(bus, true, true);
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	brcmf_sdbrcm_pktfree2(bus, pkt);
+	return -EINVAL;
+}
+
 /* Return true if there may be more frames to read */
 static uint
 brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
@@ -1812,8 +1868,6 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 	uint rxleft = 0;	/* Remaining number of frames allowed */
 	int sdret;		/* Return code from calls */
 	u8 txmax;		/* Maximum tx sequence offered */
-	bool len_consistent;	/* Result of comparing readahead len and
-					 len from hw-hdr */
 	u8 *rxbuf;
 	int ifidx = 0;
 	uint rxcount = 0;	/* Total frames read */
@@ -1860,50 +1914,9 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 				continue;
 			}
 
-			/* Now check the header */
-			memcpy(bus->rxhdr, rxbuf, SDPCM_HDRLEN);
-
-			/* Extract hardware header fields */
-			len = get_unaligned_le16(bus->rxhdr);
-			check = get_unaligned_le16(bus->rxhdr + sizeof(u16));
-
-			/* All zeros means readahead info was bad */
-			if (!(len | check)) {
-				brcmf_dbg(INFO, "(nextlen): read zeros in HW header???\n");
-				brcmf_sdbrcm_pktfree2(bus, pkt);
-				continue;
-			}
-
-			/* Validate check bytes */
-			if ((u16)~(len ^ check)) {
-				brcmf_dbg(ERROR, "(nextlen): HW hdr error: nextlen/len/check 0x%04x/0x%04x/0x%04x\n",
-					  nextlen, len, check);
-				bus->rx_badhdr++;
-				brcmf_sdbrcm_rxfail(bus, false, false);
-				brcmf_sdbrcm_pktfree2(bus, pkt);
-				continue;
-			}
-
-			/* Validate frame length */
-			if (len < SDPCM_HDRLEN) {
-				brcmf_dbg(ERROR, "(nextlen): HW hdr length invalid: %d\n",
-					  len);
-				brcmf_sdbrcm_pktfree2(bus, pkt);
+			if (brcmf_check_rxbuf(bus, pkt, rxbuf, rxseq, nextlen,
+					      &len) < 0)
 				continue;
-			}
-
-			/* Check for consistency withreadahead info */
-			len_consistent = (nextlen != (roundup(len, 16) >> 4));
-			if (len_consistent) {
-				/* Mismatch, force retry w/normal
-					header (may be >4K) */
-				brcmf_dbg(ERROR, "(nextlen): mismatch, nextlen %d len %d rnd %d; expected rxseq %d\n",
-					  nextlen, len, roundup(len, 16),
-					  rxseq);
-				brcmf_sdbrcm_rxfail(bus, true, true);
-				brcmf_sdbrcm_pktfree2(bus, pkt);
-				continue;
-			}
 
 			/* Extract software header fields */
 			chan = SDPCM_PACKET_CHANNEL(
-- 
1.7.1


