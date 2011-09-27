Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4762 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab1I0Rpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:47 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 23/26] staging: brcm80211: use d11rxhdr structure in
 brcms_c_recover_tsf64()
Date: Tue, 27 Sep 2011 10:45:27 -0700
Message-ID: <1317145530-18839-24-git-send-email-frankyl@broadcom.com> (sfid-20110927_194711_548637_B1A79643)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

All information needed for this function is available in the d11rxhdr
structure. This is the last place where the brcms_d11rxhdr structure
so it can be removed.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/d11.h   |   17 -----------------
 drivers/staging/brcm80211/brcmsmac/main.c  |    9 +++------
 drivers/staging/brcm80211/brcmsmac/types.h |    1 -
 3 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index 1f05e8a..ed51616 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -1407,23 +1407,6 @@ struct d11rxhdr {
 	u16 RxStatus2;
 	u16 RxTSFTime;
 	u16 RxChan;
-};
-
-/*
- * rxhdr: received frame header data
- * rssi: rssi computed by PHY
- * rxpwr0: obsoleted, place holder for legacy ROM code. use rxpwr[]
- * rxpwr1: obsoleted, place holder for legacy ROM code. use rxpwr[]
- * do_rssi_ma: do per-pkt sampling for per-antenna ma in HIGH
- * rxpwr: rssi for supported antennas
- */
-struct brcms_d11rxhdr {
-	struct d11rxhdr rxh_cpu;
-	s8 rssi;
-	s8 rxpwr0;
-	s8 rxpwr1;
-	s8 do_rssi_ma;
-	s8 rxpwr[WL_RSSI_ANT_MAX];
 } __packed;
 
 /* PhyRxStatus_0: */
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index bdc0611..4f79a42 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -783,7 +783,6 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 	struct sk_buff *tail = NULL;
 	uint n = 0;
 	uint bound_limit = bound ? RXBND : -1;
-	struct brcms_d11rxhdr *wlc_rxhdr = NULL;
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 	/* gather received frames */
@@ -813,7 +812,6 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 
 		rxh_le = (struct d11rxhdr_le *)p->data;
 		rxh = (struct d11rxhdr *)p->data;
-		wlc_rxhdr = (struct brcms_d11rxhdr *) p->data;
 
 		/* fixup rx header endianness */
 		rxh->RxFrameSize = le16_to_cpu(rxh_le->RxFrameSize);
@@ -8117,7 +8115,7 @@ brcms_b_read_tsf(struct brcms_hardware *wlc_hw, u32 *tsf_l_ptr,
  * are used. Finally, the tsf_h is read from the tsf register.
  */
 static u64 brcms_c_recover_tsf64(struct brcms_c_info *wlc,
-				 struct brcms_d11rxhdr *rxh)
+				 struct d11rxhdr *rxh)
 {
 	u32 tsf_h, tsf_l;
 	u16 rx_tsf_0_15, rx_tsf_16_31;
@@ -8125,7 +8123,7 @@ static u64 brcms_c_recover_tsf64(struct brcms_c_info *wlc,
 	brcms_b_read_tsf(wlc->hw, &tsf_l, &tsf_h);
 
 	rx_tsf_16_31 = (u16)(tsf_l >> 16);
-	rx_tsf_0_15 = rxh->rxh_cpu.RxTSFTime;
+	rx_tsf_0_15 = rxh->RxTSFTime;
 
 	/*
 	 * a greater tsf time indicates the low 16 bits of
@@ -8145,14 +8143,13 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 		     struct sk_buff *p,
 		     struct ieee80211_rx_status *rx_status)
 {
-	struct brcms_d11rxhdr *wlc_rxh = (struct brcms_d11rxhdr *) rxh;
 	int preamble;
 	int channel;
 	u32 rspec;
 	unsigned char *plcp;
 
 	/* fill in TSF and flag its presence */
-	rx_status->mactime = brcms_c_recover_tsf64(wlc, wlc_rxh);
+	rx_status->mactime = brcms_c_recover_tsf64(wlc, rxh);
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
 	channel = BRCMS_CHAN_CHANNEL(rxh->RxChan);
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 415ab8b..23969fe 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -336,7 +336,6 @@ struct dma_pub;
 struct si_pub;
 struct tx_status;
 struct d11rxhdr;
-struct brcms_d11rxhdr;
 struct txpwr_limits;
 
 /* iovar structure */
-- 
1.7.1


