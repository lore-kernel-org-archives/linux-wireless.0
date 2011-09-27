Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4460 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab1I0Rps (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 20/26] staging: brcm80211: convert endianess before
 handling the frame
Date: Tue, 27 Sep 2011 10:45:24 -0700
Message-ID: <1317145530-18839-21-git-send-email-frankyl@broadcom.com> (sfid-20110927_194643_731765_DC0B99DB)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The received frame from the device is in little-endian order and
converted in the receive path. However, the phy code was doing
the rssi calculation with packet in LE order. This has been changed
to do the le_to_cpu conversion before doing the rssi computation
and further receive processing.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c        |   27 ++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    6 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |    8 +++---
 3 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index ef96358..1a7d005 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -813,11 +813,23 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 		wlc_rxhdr = (struct brcms_d11rxhdr *) p->data;
 		rxh = (struct d11rxhdr *)p->data;
 
+		/* fixup rx header endianness */
+		rxh->RxFrameSize = le16_to_cpu(rxh->RxFrameSize);
+		rxh->PhyRxStatus_0 = le16_to_cpu(rxh->PhyRxStatus_0);
+		rxh->PhyRxStatus_1 = le16_to_cpu(rxh->PhyRxStatus_1);
+		rxh->PhyRxStatus_2 = le16_to_cpu(rxh->PhyRxStatus_2);
+		rxh->PhyRxStatus_3 = le16_to_cpu(rxh->PhyRxStatus_3);
+		rxh->PhyRxStatus_4 = le16_to_cpu(rxh->PhyRxStatus_4);
+		rxh->PhyRxStatus_5 = le16_to_cpu(rxh->PhyRxStatus_5);
+		rxh->RxStatus1 = le16_to_cpu(rxh->RxStatus1);
+		rxh->RxStatus2 = le16_to_cpu(rxh->RxStatus2);
+		rxh->RxTSFTime = le16_to_cpu(rxh->RxTSFTime);
+		rxh->RxChan = le16_to_cpu(rxh->RxChan);
+
 		/*
 		 * compute the RSSI from d11rxhdr and record it in wlc_rxd11hr
 		 */
 		wlc_rxhdr->rssi = wlc_phy_rssi_compute(wlc_hw->band->pi, rxh);
-
 		brcms_c_recv(wlc_hw->wlc, p);
 	}
 
@@ -8289,19 +8301,6 @@ void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 	/* strip off rxhdr */
 	skb_pull(p, BRCMS_HWRXOFF);
 
-	/* fixup rx header endianness */
-	rxh->RxFrameSize = le16_to_cpu(rxh->RxFrameSize);
-	rxh->PhyRxStatus_0 = le16_to_cpu(rxh->PhyRxStatus_0);
-	rxh->PhyRxStatus_1 = le16_to_cpu(rxh->PhyRxStatus_1);
-	rxh->PhyRxStatus_2 = le16_to_cpu(rxh->PhyRxStatus_2);
-	rxh->PhyRxStatus_3 = le16_to_cpu(rxh->PhyRxStatus_3);
-	rxh->PhyRxStatus_4 = le16_to_cpu(rxh->PhyRxStatus_4);
-	rxh->PhyRxStatus_5 = le16_to_cpu(rxh->PhyRxStatus_5);
-	rxh->RxStatus1 = le16_to_cpu(rxh->RxStatus1);
-	rxh->RxStatus2 = le16_to_cpu(rxh->RxStatus2);
-	rxh->RxTSFTime = le16_to_cpu(rxh->RxTSFTime);
-	rxh->RxChan = le16_to_cpu(rxh->RxChan);
-
 	/* MAC inserts 2 pad bytes for a4 headers or QoS or A-MSDU subframes */
 	if (rxh->RxStatus1 & RXS_PBPRES) {
 		if (p->len < 2) {
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index c359a10..f9702c0 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -2613,18 +2613,18 @@ void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_cmplx_pwr_dB, u8 core)
 int wlc_phy_rssi_compute(struct brcms_phy_pub *pih,
 			 struct d11rxhdr *rxh)
 {
-	int rssi = le16_to_cpu(rxh->PhyRxStatus_1) & PRXS1_JSSI_MASK;
+	int rssi = rxh->PhyRxStatus_1 & PRXS1_JSSI_MASK;
 	uint radioid = pih->radioid;
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if ((pi->sh->corerev >= 11)
-	    && !(le16_to_cpu(rxh->RxStatus2) & RXS_PHYRXST_VALID)) {
+	    && !(rxh->RxStatus2 & RXS_PHYRXST_VALID)) {
 		rssi = BRCMS_RSSI_INVALID;
 		goto end;
 	}
 
 	if (ISLCNPHY(pi)) {
-		u8 gidx = (le16_to_cpu(rxh->PhyRxStatus_2) & 0xFC00) >> 10;
+		u8 gidx = (rxh->PhyRxStatus_2 & 0xFC00) >> 10;
 		struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 		if (rssi > 127)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index ff8b1d8..a34d292 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -23115,16 +23115,16 @@ wlc_phy_rssi_compute_nphy(struct brcms_phy *pi, struct d11rxhdr *rxh)
 	s16 phyRx0_l, phyRx2_l;
 
 	rxpwr = 0;
-	rxpwr0 = le16_to_cpu(rxh->PhyRxStatus_1) & PRXS1_nphy_PWR0_MASK;
-	rxpwr1 = (le16_to_cpu(rxh->PhyRxStatus_1) & PRXS1_nphy_PWR1_MASK) >> 8;
+	rxpwr0 = rxh->PhyRxStatus_1 & PRXS1_nphy_PWR0_MASK;
+	rxpwr1 = (rxh->PhyRxStatus_1 & PRXS1_nphy_PWR1_MASK) >> 8;
 
 	if (rxpwr0 > 127)
 		rxpwr0 -= 256;
 	if (rxpwr1 > 127)
 		rxpwr1 -= 256;
 
-	phyRx0_l = le16_to_cpu(rxh->PhyRxStatus_0) & 0x00ff;
-	phyRx2_l = le16_to_cpu(rxh->PhyRxStatus_2) & 0x00ff;
+	phyRx0_l = rxh->PhyRxStatus_0 & 0x00ff;
+	phyRx2_l = rxh->PhyRxStatus_2 & 0x00ff;
 	if (phyRx2_l > 127)
 		phyRx2_l -= 256;
 
-- 
1.7.1


