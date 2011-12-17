Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1522 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760976Ab1LQChg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:36 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/30] brcm80211: fmac: move maxctl to struct brcmf_bus
Date: Fri, 16 Dec 2011 18:37:03 -0800
Message-ID: <1324089440-8957-14-git-send-email-frankyl@broadcom.com> (sfid-20111217_035945_543160_1C0EB194)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

maxctl is the max size of rxctl request from protocol layer to bus
layer. Move it to bus interface structure brcmf_bus. This is part
of the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index bfd26e3..db30f02 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -576,6 +576,7 @@ struct brcmf_bus {
 	void *bus_priv;		/* pointer to bus private structure */
 	void *drvr;		/* pointer to driver pub structure brcmf_pub */
 	enum brcmf_bus_state state;
+	uint maxctl;		/* Max size rxctl request from proto to bus */
 };
 
 /* Forward decls for struct brcmf_pub (see below) */
@@ -596,7 +597,6 @@ struct brcmf_pub {
 	bool up;		/* Driver up/down (to OS) */
 	bool txoff;		/* Transmit flow-controlled */
 	uint hdrlen;		/* Total BRCMF header length (proto + bus) */
-	uint maxctl;		/* Max size rxctl request from proto to bus */
 	uint rxsz;		/* Rx buffer size bus module should use */
 	u8 wme_dp;		/* wme discard priority */
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 3f0b316..774aeac 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -437,7 +437,7 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 
 	drvr->prot = cdc;
 	drvr->hdrlen += BDC_HEADER_LEN;
-	drvr->maxctl = BRCMF_DCMD_MAXLEN +
+	drvr->bus_if->maxctl = BRCMF_DCMD_MAXLEN +
 			sizeof(struct brcmf_proto_cdc_dcmd) + ROUND_UP_MARGIN;
 	return 0;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 5fb0d90..cc2c653 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1534,7 +1534,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	if (bus->roundup && bus->blocksize && (rdlen > bus->blocksize)) {
 		pad = bus->blocksize - (rdlen % bus->blocksize);
 		if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
-		    ((len + pad) < bus->drvr->maxctl))
+		    ((len + pad) < bus->sdiodev->bus_if->maxctl))
 			rdlen += pad;
 	} else if (rdlen % BRCMF_SDALIGN) {
 		rdlen += BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
@@ -1545,17 +1545,17 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 		rdlen = roundup(rdlen, ALIGNMENT);
 
 	/* Drop if the read is too big or it exceeds our maximum */
-	if ((rdlen + BRCMF_FIRSTREAD) > bus->drvr->maxctl) {
+	if ((rdlen + BRCMF_FIRSTREAD) > bus->sdiodev->bus_if->maxctl) {
 		brcmf_dbg(ERROR, "%d-byte control read exceeds %d-byte buffer\n",
-			  rdlen, bus->drvr->maxctl);
+			  rdlen, bus->sdiodev->bus_if->maxctl);
 		bus->drvr->rx_errors++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
 	}
 
-	if ((len - doff) > bus->drvr->maxctl) {
+	if ((len - doff) > bus->sdiodev->bus_if->maxctl) {
 		brcmf_dbg(ERROR, "%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
-			  len, len - doff, bus->drvr->maxctl);
+			  len, len - doff, bus->sdiodev->bus_if->maxctl);
 		bus->drvr->rx_errors++;
 		bus->rx_toolong++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
@@ -3666,9 +3666,9 @@ static bool brcmf_sdbrcm_probe_malloc(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (bus->drvr->maxctl) {
+	if (bus->sdiodev->bus_if->maxctl) {
 		bus->rxblen =
-		    roundup((bus->drvr->maxctl + SDPCM_HDRLEN),
+		    roundup((bus->sdiodev->bus_if->maxctl + SDPCM_HDRLEN),
 			    ALIGNMENT) + BRCMF_SDALIGN;
 		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
 		if (!(bus->rxbuf))
-- 
1.7.5.4


