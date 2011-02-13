Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43382 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab1BMOk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 09:40:58 -0500
Received: by bwz15 with SMTP id 15so4702350bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 06:40:57 -0800 (PST)
From: Stanislav Fomichev <kernel@fomichev.me>
To: linux-wireless@vger.kernel.org
Cc: brudley@broadcom.com, gregkh@suse.de
Subject: [PATCH 2/8] brcm80211: replace dot11_rts_frame with ieee80211_rts
Date: Sun, 13 Feb 2011 17:40:37 +0300
Message-Id: <1297608043-18381-2-git-send-email-kernel@fomichev.me>
In-Reply-To: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
References: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
---
 drivers/staging/brcm80211/include/d11.h          |    4 +++-
 drivers/staging/brcm80211/include/proto/802.11.h |    7 -------
 drivers/staging/brcm80211/sys/wlc_ampdu.c        |   12 ++++++------
 drivers/staging/brcm80211/sys/wlc_mac80211.c     |   22 +++++++++++-----------
 4 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/brcm80211/include/d11.h b/drivers/staging/brcm80211/include/d11.h
index be2d497..604ef60 100644
--- a/drivers/staging/brcm80211/include/d11.h
+++ b/drivers/staging/brcm80211/include/d11.h
@@ -17,6 +17,8 @@
 #ifndef	_D11_H
 #define	_D11_H
 
+#include <linux/ieee80211.h>
+
 /* This marks the start of a packed structure section. */
 #include <packed_section_start.h>
 
@@ -739,7 +741,7 @@ BWL_PRE_PACKED_STRUCT struct d11txh {
 	u16 MaxABytes_FBR;	/* 0x2a corerev >=16 */
 	u16 MinMBytes;	/* 0x2b corerev >=16 */
 	u8 RTSPhyHeader[D11_PHY_HDR_LEN];	/* 0x2c - 0x2e */
-	struct dot11_rts_frame rts_frame;	/* 0x2f - 0x36 */
+	struct ieee80211_rts rts_frame;	/* 0x2f - 0x36 */
 	u16 PAD;		/* 0x37 */
 } BWL_POST_PACKED_STRUCT;
 
diff --git a/drivers/staging/brcm80211/include/proto/802.11.h b/drivers/staging/brcm80211/include/proto/802.11.h
index 3bc066a..db4328d 100644
--- a/drivers/staging/brcm80211/include/proto/802.11.h
+++ b/drivers/staging/brcm80211/include/proto/802.11.h
@@ -45,13 +45,6 @@
 
 #define DOT11_OUI_LEN			3
 
-BWL_PRE_PACKED_STRUCT struct dot11_rts_frame {
-	u16 fc;
-	u16 durid;
-	struct ether_addr ra;
-	struct ether_addr ta;
-} BWL_POST_PACKED_STRUCT;
-
 #define	DOT11_RTS_LEN		16
 #define	DOT11_CTS_LEN		10
 #define	DOT11_ACK_LEN		10
diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
index 74da502..ae051de 100644
--- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
@@ -519,7 +519,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 	ratespec_t rspec = 0, rspec_fallback = 0;
 	ratespec_t rts_rspec = 0, rts_rspec_fallback = 0;
 	u16 mimo_ctlchbw = PHY_TXC1_BW_20MHZ;
-	struct dot11_rts_frame *rts;
+	struct ieee80211_rts *rts;
 	u8 rr_retry_limit;
 	wlc_fifo_info_t *f;
 	bool fbr_iscck;
@@ -639,8 +639,8 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 			mcl |= (TXC_AMPDU_FIRST << TXC_AMPDU_SHIFT);
 			/* refill the bits since might be a retx mpdu */
 			mcl |= TXC_STARTMSDU;
-			rts = (struct dot11_rts_frame *)&txh->rts_frame;
-			fc = ltoh16(rts->fc);
+			rts = (struct ieee80211_rts *)&txh->rts_frame;
+			fc = le16_to_cpu(rts->frame_control);
 			if ((fc & FC_KIND_MASK) == FC_RTS) {
 				mcl |= TXC_SENDRTS;
 				use_rts = true;
@@ -837,7 +837,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 		/* update RTS dur fields */
 		if (use_rts || use_cts) {
 			u16 durid;
-			rts = (struct dot11_rts_frame *)&txh->rts_frame;
+			rts = (struct ieee80211_rts *)&txh->rts_frame;
 			if ((mch & TXC_PREAMBLE_RTS_MAIN_SHORT) ==
 			    TXC_PREAMBLE_RTS_MAIN_SHORT)
 				rts_preamble_type = WLC_SHORT_PREAMBLE;
@@ -851,7 +851,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 						   rspec, rts_preamble_type,
 						   preamble_type, ampdu_len,
 						   true);
-			rts->durid = htol16(durid);
+			rts->duration = cpu_to_le16(durid);
 			durid = wlc_compute_rtscts_dur(wlc, use_cts,
 						       rts_rspec_fallback,
 						       rspec_fallback,
@@ -860,7 +860,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 						       ampdu_len, true);
 			txh->RTSDurFallback = htol16(durid);
 			/* set TxFesTimeNormal */
-			txh->TxFesTimeNormal = rts->durid;
+			txh->TxFesTimeNormal = rts->duration;
 			/* set fallback rate version of TxFesTimeNormal */
 			txh->TxFesTimeFallback = txh->RTSDurFallback;
 		}
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 96ff02f..391e958 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -1736,7 +1736,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	ASSERT(sizeof(d11txh_t) == D11_TXH_LEN);
 	ASSERT(sizeof(d11rxhdr_t) == RXHDR_LEN);
 	ASSERT(sizeof(struct ieee80211_hdr) == DOT11_A4_HDR_LEN);
-	ASSERT(sizeof(struct dot11_rts_frame) == DOT11_RTS_LEN);
+	ASSERT(sizeof(struct ieee80211_rts) == DOT11_RTS_LEN);
 	ASSERT(sizeof(struct dot11_management_header) == DOT11_MGMT_HDR_LEN);
 	ASSERT(sizeof(struct dot11_bcn_prb) == DOT11_BCN_PRB_LEN);
 	ASSERT(sizeof(tx_status_t) == TXSTATUS_LEN);
@@ -4858,7 +4858,7 @@ void wlc_print_txdesc(d11txh_t *txh)
 	u16 mmbyte = ltoh16(txh->MinMBytes);
 
 	u8 *rtsph = txh->RTSPhyHeader;
-	struct dot11_rts_frame rts = txh->rts_frame;
+	struct ieee80211_rts rts = txh->rts_frame;
 	char hexbuf[256];
 
 	/* add plcp header along with txh descriptor */
@@ -5666,7 +5666,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	u8 preamble_type[2] = { WLC_LONG_PREAMBLE, WLC_LONG_PREAMBLE };
 	u8 rts_preamble_type[2] = { WLC_LONG_PREAMBLE, WLC_LONG_PREAMBLE };
 	u8 *rts_plcp, rts_plcp_fallback[D11_PHY_HDR_LEN];
-	struct dot11_rts_frame *rts = NULL;
+	struct ieee80211_rts *rts = NULL;
 	bool qos;
 	uint ac;
 	u32 rate_val[2];
@@ -6110,12 +6110,12 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		      sizeof(txh->RTSPLCPFallback));
 
 		/* RTS frame fields... */
-		rts = (struct dot11_rts_frame *)&txh->rts_frame;
+		rts = (struct ieee80211_rts *)&txh->rts_frame;
 
 		durid = wlc_compute_rtscts_dur(wlc, use_cts, rts_rspec[0],
 					       rspec[0], rts_preamble_type[0],
 					       preamble_type[0], phylen, false);
-		rts->durid = htol16(durid);
+		rts->duration = cpu_to_le16(durid);
 		/* fallback rate version of RTS DUR field */
 		durid = wlc_compute_rtscts_dur(wlc, use_cts,
 					       rts_rspec[1], rspec[1],
@@ -6124,11 +6124,11 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		txh->RTSDurFallback = htol16(durid);
 
 		if (use_cts) {
-			rts->fc = htol16(FC_CTS);
-			bcopy((char *)h->addr2, (char *)&rts->ra, ETH_ALEN);
+			rts->frame_control = cpu_to_le16(FC_CTS);
+			bcopy((char *)h->addr2, (char *)rts->ra, ETH_ALEN);
 		} else {
-			rts->fc = htol16((u16) FC_RTS);
-			bcopy((char *)h->addr1, (char *)&rts->ra,
+			rts->frame_control = cpu_to_le16((u16) FC_RTS);
+			bcopy((char *)h->addr1, (char *)rts->ra,
 			      2 * ETH_ALEN);
 		}
 
@@ -6142,7 +6142,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	} else {
 		memset((char *)txh->RTSPhyHeader, 0, D11_PHY_HDR_LEN);
 		memset((char *)&txh->rts_frame, 0,
-			sizeof(struct dot11_rts_frame));
+			sizeof(struct ieee80211_rts));
 		memset((char *)txh->RTSPLCPFallback, 0,
 		      sizeof(txh->RTSPLCPFallback));
 		txh->RTSDurFallback = 0;
@@ -6249,7 +6249,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 				    wlc_calc_cts_time(wlc, rts_rspec[1],
 						      rts_preamble_type[1]);
 				/* (SIFS + CTS) + SIFS + frame + SIFS + ACK */
-				dur += ltoh16(rts->durid);
+				dur += le16_to_cpu(rts->duration);
 				dur_fallback += ltoh16(txh->RTSDurFallback);
 			} else if (use_rifs) {
 				dur = frag_dur;
-- 
1.7.1

