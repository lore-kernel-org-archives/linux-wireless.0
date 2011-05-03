Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2426 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab1ECJgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 31/61] staging: brcm80211: provide TSF value in receive
 status
Date: Tue, 3 May 2011 11:35:31 +0200
Message-ID: <1304415361-7813-32-git-send-email-arend@broadcom.com> (sfid-20110503_113821_015605_30495095)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Packets passed to the mac80211 stack have a mactime field in the
receive status indicating the actual time it was received by the
phy radio. It was not (properly) filled in before this change.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |   50 ++++++++++++++++++++----
 1 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 1f25fc3..0213844 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -284,6 +284,7 @@ static void wlc_compute_ofdm_plcp(ratespec_t rate, uint length, u8 *plcp);
 static void wlc_compute_mimo_plcp(ratespec_t rate, uint length, u8 *plcp);
 static u16 wlc_compute_frame_dur(struct wlc_info *wlc, ratespec_t rate,
 				    u8 preamble_type, uint next_frag_len);
+static u64 wlc_recover_tsf64(struct wlc_info *wlc, struct wlc_d11rxhdr *rxh);
 static void wlc_recvctl(struct wlc_info *wlc,
 			d11rxhdr_t *rxh, struct sk_buff *p);
 static uint wlc_calc_frame_len(struct wlc_info *wlc, ratespec_t rate,
@@ -6474,25 +6475,56 @@ void wlc_bcn_li_upd(struct wlc_info *wlc)
 			      (wlc->bcn_li_dtim << 8) | wlc->bcn_li_bcn);
 }
 
+/*
+ * recover 64bit TSF value from the 16bit TSF value in the rx header
+ * given the assumption that the TSF passed in header is within 65ms
+ * of the current tsf.
+ *
+ * 6       5       4       4       3       2       1
+ * 3.......6.......8.......0.......2.......4.......6.......8......0
+ * |<---------- tsf_h ----------->||<--- tsf_l -->||<-RxTSFTime ->|
+ *
+ * The RxTSFTime are the lowest 16 bits and provided by the ucode. The
+ * tsf_l is filled in by wlc_bmac_recv, which is done earlier in the
+ * receive call sequence after rx interrupt. Only the higher 16 bits
+ * are used. Finally, the tsf_h is read from the tsf register.
+ */
+static u64 wlc_recover_tsf64(struct wlc_info *wlc, struct wlc_d11rxhdr *rxh)
+{
+	u32 tsf_h, tsf_l;
+	u16 rx_tsf_0_15, rx_tsf_16_31;
+
+	wlc_bmac_read_tsf(wlc->hw, &tsf_l, &tsf_h);
+
+	rx_tsf_16_31 = (u16)(tsf_l >> 16);
+	rx_tsf_0_15 = rxh->rxhdr.RxTSFTime;
+
+	/*
+	 * a greater tsf time indicates the low 16 bits of
+	 * tsf_l wrapped, so decrement the high 16 bits.
+	 */
+	if ((u16)tsf_l < rx_tsf_0_15) {
+		rx_tsf_16_31 -= 1;
+		if (rx_tsf_16_31 == 0xffff)
+			tsf_h -= 1;
+	}
+
+	return ((u64)tsf_h << 32) | (((u32)rx_tsf_16_31 << 16) + rx_tsf_0_15);
+}
+
 static void
 prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
 		     struct ieee80211_rx_status *rx_status)
 {
-	u32 tsf_l, tsf_h;
 	wlc_d11rxhdr_t *wlc_rxh = (wlc_d11rxhdr_t *) rxh;
 	int preamble;
 	int channel;
 	ratespec_t rspec;
 	unsigned char *plcp;
 
-#if 0
-	/* Clearly, this is bogus -- reading the TSF now is wrong */
-	wlc_read_tsf(wlc, &tsf_l, &tsf_h);	/* mactime */
-	rx_status->mactime = tsf_h;
-	rx_status->mactime <<= 32;
-	rx_status->mactime |= tsf_l;
-	rx_status->flag |= RX_FLAG_MACTIME_MPDU; /* clearly wrong */
-#endif
+	/* fill in TSF and flag its presence */
+	rx_status->mactime = wlc_recover_tsf64(wlc, wlc_rxh);
+	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
 	channel = WLC_CHAN_CHANNEL(rxh->RxChan);
 
-- 
1.7.4.1


