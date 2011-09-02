Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4336 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab1IBOBC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:01:02 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 11/12] staging: brcm80211: cleaned up softmac scb.h
 macro's
Date: Fri, 2 Sep 2011 16:00:38 +0200
Message-ID: <1314972039-27098-12-git-send-email-rvossen@broadcom.com> (sfid-20110902_160119_296907_47C470FC)
In-Reply-To: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted/removed macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    8 ++++----
 drivers/staging/brcm80211/brcmsmac/main.h |    3 ++-
 drivers/staging/brcm80211/brcmsmac/rate.h |   16 ----------------
 drivers/staging/brcm80211/brcmsmac/scb.h  |   24 ++++++++++--------------
 4 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 4436b4f..6d2fc103 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -7196,11 +7196,11 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		} else {
 			/* Increment the counter for first fragment */
 			if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-				SCB_SEQNUM(scb, p->priority)++;
+				scb->seqnum[p->priority]++;
 
 			/* extract fragment number from frame first */
 			seq = le16_to_cpu(seq) & FRAGNUM_MASK;
-			seq |= (SCB_SEQNUM(scb, p->priority) << SEQNUM_SHIFT);
+			seq |= (scb->seqnum[p->priority] << SEQNUM_SHIFT);
 			h->seq_ctrl = cpu_to_le16(seq);
 
 			frameid = ((seq << TXFID_SEQ_SHIFT) & TXFID_SEQ_MASK) |
@@ -7210,7 +7210,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	frameid |= queue & TXFID_QUEUE_MASK;
 
 	/* set the ignpmq bit for all pkts tx'd in PS mode and for beacons */
-	if (SCB_PS(scb) || ieee80211_is_beacon(h->frame_control))
+	if (ieee80211_is_beacon(h->frame_control))
 		mcl |= TXC_IGNOREPMQ;
 
 	txrate[0] = tx_info->control.rates;
@@ -7685,7 +7685,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	}
 
 	ac = skb_get_queue_mapping(p);
-	if (SCB_WME(scb) && qos && wlc->edcf_txop[ac]) {
+	if ((scb->flags & SCB_WMECAP) && qos && wlc->edcf_txop[ac]) {
 		uint frag_dur, dur, dur_fallback;
 
 		/* WME: Update TXOP threshold */
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 047c422..a0dcacc 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -221,7 +221,8 @@ struct brcms_stf {
 
 #define BRCMS_STF_SS_STBC_TX(wlc, scb) \
 	(((wlc)->stf->txstreams > 1) && (((wlc)->band->band_stf_stbc_tx == ON) \
-	 || (SCB_STBC_CAP((scb)) && (wlc)->band->band_stf_stbc_tx == AUTO && \
+	 || (((scb)->flags & SCB_STBCCAP) && \
+	     (wlc)->band->band_stf_stbc_tx == AUTO && \
 	     isset(&((wlc)->stf->ss_algo_channel), PHY_TXC1_MODE_STBC))))
 
 #define BRCMS_STBC_CAP_PHY(wlc) (BRCMS_ISNPHY(wlc->band) && \
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index 39e1796..ae5479b 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -123,22 +123,6 @@ extern const struct brcms_mcs_info mcs_table[];
 		  RSPEC_ISSGI(rspec)) : \
 	(rspec & RSPEC_RATE_MASK))
 
-/* return rate in unit of 500Kbps -- for internal use in wlc_rate_sel.c */
-#define RSPEC2RATE500K(rspec) \
-	((rspec & RSPEC_MIMORATE) ? \
-	 MCS_RATE((rspec & RSPEC_RATE_MASK), state->is40bw, \
-		   RSPEC_ISSGI(rspec))/500 : \
-	(rspec & RSPEC_RATE_MASK))
-
-#define CRSPEC2RATE500K(rspec) \
-	((rspec & RSPEC_MIMORATE) ? \
-	 MCS_RATE((rspec & RSPEC_RATE_MASK), RSPEC_IS40MHZ(rspec), \
-		   RSPEC_ISSGI(rspec))/500 :\
-	(rspec & RSPEC_RATE_MASK))
-
-#define RSPEC2KBPS(rspec) \
-	(IS_MCS(rspec) ? RSPEC2RATE(rspec) : RSPEC2RATE(rspec)*500)
-
 #define RSPEC_PHYTXBYTE2(rspec)	((rspec & 0xff00) >> 8)
 
 #define RSPEC_GET_BW(rspec)	((rspec & RSPEC_BW_MASK) >> RSPEC_BW_SHIFT)
diff --git a/drivers/staging/brcm80211/brcmsmac/scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
index 3fe9cf2..b2aacf3 100644
--- a/drivers/staging/brcm80211/brcmsmac/scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/scb.h
@@ -24,6 +24,16 @@
 
 #define AMPDU_TX_BA_MAX_WSIZE	64	/* max Tx ba window size (in pdu) */
 
+#define AMPDU_MAX_SCB_TID	NUMPRIO
+
+/* scb flags */
+#define SCB_WMECAP		0x0040	/* may ONLY be set if pub->_wme!=OFF */
+#define SCB_HTCAP		0x10000	/* HT (MIMO) capable device */
+#define SCB_IS40		0x80000	/* 40MHz capable */
+#define SCB_STBCCAP		0x40000000	/* STBC Capable */
+
+#define SCB_MAGIC	0xbeefcafe
+
 /* structure to store per-tid state for the ampdu initiator */
 struct scb_ampdu_tid_ini {
 	u8 tx_in_transit; /* number of pending mpdus in transit in driver */
@@ -34,8 +44,6 @@ struct scb_ampdu_tid_ini {
 	u8 ba_wsize;	  /* negotiated ba window size (in pdu) */
 };
 
-#define AMPDU_MAX_SCB_TID	NUMPRIO
-
 struct scb_ampdu {
 	struct scb *scb;	/* back pointer for easy reference */
 	u8 mpdu_density;	/* mpdu density */
@@ -54,8 +62,6 @@ struct scb_ampdu {
 	struct scb_ampdu_tid_ini ini[AMPDU_MAX_SCB_TID];
 };
 
-#define SCB_MAGIC	0xbeefcafe
-
 /* station control block - one per remote MAC address */
 struct scb {
 	u32 magic;
@@ -74,14 +80,4 @@ struct scb {
 	struct scb_ampdu scb_ampdu;	/* AMPDU state including per tid info */
 };
 
-/* scb flags */
-#define SCB_WMECAP		0x0040	/* may ONLY be set if pub->_wme!=OFF */
-#define SCB_HTCAP		0x10000	/* HT (MIMO) capable device */
-#define SCB_IS40		0x80000	/* 40MHz capable */
-#define SCB_STBCCAP		0x40000000	/* STBC Capable */
-#define SCB_WME(a)		((a)->flags & SCB_WMECAP)/* implies WME enab */
-#define SCB_SEQNUM(scb, prio)	((scb)->seqnum[(prio)])
-#define SCB_PS(a)		NULL
-#define SCB_STBC_CAP(a)		((a)->flags & SCB_STBCCAP)
-#define SCB_AMPDU(a)		true
 #endif				/* _BRCM_SCB_H_ */
-- 
1.7.4.1


