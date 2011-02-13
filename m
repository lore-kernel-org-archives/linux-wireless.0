Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51268 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab1BMOlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 09:41:02 -0500
Received: by bwz15 with SMTP id 15so4702377bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 06:41:01 -0800 (PST)
From: Stanislav Fomichev <kernel@fomichev.me>
To: linux-wireless@vger.kernel.org
Cc: brudley@broadcom.com, gregkh@suse.de
Subject: [PATCH 5/8] brcm80211: replace FC_ defines
Date: Sun, 13 Feb 2011 17:40:40 +0300
Message-Id: <1297608043-18381-5-git-send-email-kernel@fomichev.me>
In-Reply-To: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
References: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
---
 drivers/staging/brcm80211/include/proto/802.11.h |   33 ------------
 drivers/staging/brcm80211/sys/wlc_ampdu.c        |    8 ++--
 drivers/staging/brcm80211/sys/wlc_mac80211.c     |   59 +++++++++++-----------
 3 files changed, 33 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/brcm80211/include/proto/802.11.h b/drivers/staging/brcm80211/include/proto/802.11.h
index 3238dad..4e3748f 100644
--- a/drivers/staging/brcm80211/include/proto/802.11.h
+++ b/drivers/staging/brcm80211/include/proto/802.11.h
@@ -128,43 +128,10 @@ typedef struct wme_param_ie wme_param_ie_t;
 #define DOT11_OPEN_SYSTEM	0
 #define DOT11_SHARED_KEY	1
 
-#define FC_TYPE_MASK		0xC
-#define FC_TYPE_SHIFT		2
-#define FC_SUBTYPE_MASK		0xF0
-#define FC_SUBTYPE_SHIFT	4
-#define FC_MOREFRAG		0x400
-
 #define SEQNUM_SHIFT		4
 #define SEQNUM_MAX		0x1000
 #define FRAGNUM_MASK		0xF
 
-#define FC_TYPE_MNG		0
-#define FC_TYPE_CTL		1
-#define FC_TYPE_DATA		2
-
-#define FC_SUBTYPE_PROBE_REQ		4
-#define FC_SUBTYPE_PROBE_RESP		5
-#define FC_SUBTYPE_BEACON		8
-#define FC_SUBTYPE_PS_POLL		10
-#define FC_SUBTYPE_RTS			11
-#define FC_SUBTYPE_CTS			12
-
-#define FC_SUBTYPE_ANY_QOS(s)		(((s) & 8) != 0)
-
-#define FC_KIND_MASK		(FC_TYPE_MASK | FC_SUBTYPE_MASK)
-
-#define FC_KIND(t, s)	(((t) << FC_TYPE_SHIFT) | ((s) << FC_SUBTYPE_SHIFT))
-
-#define FC_SUBTYPE(fc)	(((fc) & FC_SUBTYPE_MASK) >> FC_SUBTYPE_SHIFT)
-#define FC_TYPE(fc)	(((fc) & FC_TYPE_MASK) >> FC_TYPE_SHIFT)
-
-#define FC_PROBE_REQ	FC_KIND(FC_TYPE_MNG, FC_SUBTYPE_PROBE_REQ)
-#define FC_PROBE_RESP	FC_KIND(FC_TYPE_MNG, FC_SUBTYPE_PROBE_RESP)
-#define FC_BEACON	FC_KIND(FC_TYPE_MNG, FC_SUBTYPE_BEACON)
-#define FC_PS_POLL	FC_KIND(FC_TYPE_CTL, FC_SUBTYPE_PS_POLL)
-#define FC_RTS		FC_KIND(FC_TYPE_CTL, FC_SUBTYPE_RTS)
-#define FC_CTS		FC_KIND(FC_TYPE_CTL, FC_SUBTYPE_CTS)
-
 #define TLV_LEN_OFF		1
 #define TLV_HDR_LEN		2
 #define TLV_BODY_OFF		2
diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
index ae051de..cb98baa 100644
--- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
@@ -635,17 +635,17 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 		 * test whether need to break or change the epoch
 		 */
 		if (count == 0) {
-			u16 fc;
 			mcl |= (TXC_AMPDU_FIRST << TXC_AMPDU_SHIFT);
 			/* refill the bits since might be a retx mpdu */
 			mcl |= TXC_STARTMSDU;
 			rts = (struct ieee80211_rts *)&txh->rts_frame;
-			fc = le16_to_cpu(rts->frame_control);
-			if ((fc & FC_KIND_MASK) == FC_RTS) {
+
+			if (ieee80211_is_rts(rts->frame_control)) {
 				mcl |= TXC_SENDRTS;
 				use_rts = true;
 			}
-			if ((fc & FC_KIND_MASK) == FC_CTS) {
+
+			if (ieee80211_is_cts(rts->frame_control)) {
 				mcl |= TXC_SENDCTS;
 				use_cts = true;
 			}
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index ce13e2e..aa4d01f 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -5114,15 +5114,12 @@ wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
 	void *pkt;
 	struct scb *scb = &global_scb;
 	struct ieee80211_hdr *d11_header = (struct ieee80211_hdr *)(sdu->data);
-	u16 type, fc;
 
 	ASSERT(sdu);
 
-	fc = le16_to_cpu(d11_header->frame_control);
-	type = FC_TYPE(fc);
-
 	/* 802.11 standard requires management traffic to go at highest priority */
-	prio = (type == FC_TYPE_DATA ? sdu->priority : MAXPRIO);
+
+	prio = (ieee80211_is_data(d11_header->frame_control) ? sdu->priority : MAXPRIO);
 	fifo = prio2fifo[prio];
 
 	ASSERT((uint) skb_headroom(sdu) >= TXOFF);
@@ -5655,7 +5652,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	u8 *plcp, plcp_fallback[D11_PHY_HDR_LEN];
 	struct osl_info *osh;
 	int len, phylen, rts_phylen;
-	u16 fc, type, frameid, mch, phyctl, xfts, mainrates;
+	u16 frameid, mch, phyctl, xfts, mainrates;
 	u16 seq = 0, mcl = 0, status = 0;
 	ratespec_t rspec[2] = { WLC_RATE_1M, WLC_RATE_1M }, rts_rspec[2] = {
 	WLC_RATE_1M, WLC_RATE_1M};
@@ -5694,10 +5691,8 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 
 	/* locate 802.11 MAC header */
 	h = (struct ieee80211_hdr *)(p->data);
-	fc = le16_to_cpu(h->frame_control);
-	type = FC_TYPE(fc);
 
-	qos = (type == FC_TYPE_DATA && FC_SUBTYPE_ANY_QOS(FC_SUBTYPE(fc)));
+	qos = (ieee80211_is_data_qos(h->frame_control));
 
 	/* compute length of frame in bytes for use in PLCP computations */
 	len = pkttotlen(osh, p);
@@ -5749,7 +5744,8 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	frameid |= queue & TXFID_QUEUE_MASK;
 
 	/* set the ignpmq bit for all pkts tx'd in PS mode and for beacons */
-	if (SCB_PS(scb) || ((fc & FC_KIND_MASK) == FC_BEACON))
+
+	if (SCB_PS(scb) || ieee80211_is_beacon(h->frame_control))
 		mcl |= TXC_IGNOREPMQ;
 
 	ASSERT(hw->max_rates <= IEEE80211_TX_MAX_RATES);
@@ -5972,7 +5968,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	    plcp[0];
 
 	/* DUR field for main rate */
-	if ((fc != FC_PS_POLL) &&
+	if (!ieee80211_is_pspoll(h->frame_control) &&
 	    !is_multicast_ether_addr(h->addr1) && !use_rifs) {
 		durid =
 		    wlc_compute_frame_dur(wlc, rspec[0], preamble_type[0],
@@ -5989,7 +5985,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	}
 
 	/* DUR field for fallback rate */
-	if (fc == FC_PS_POLL)
+	if (ieee80211_is_pspoll(h->frame_control))
 		txh->FragDurFallback = h->duration_id;
 	else if (is_multicast_ether_addr(h->addr1) || use_rifs)
 		txh->FragDurFallback = 0;
@@ -6124,10 +6120,12 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		txh->RTSDurFallback = htol16(durid);
 
 		if (use_cts) {
-			rts->frame_control = cpu_to_le16(FC_CTS);
+			rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
+							 IEEE80211_STYPE_CTS);
 			bcopy((char *)h->addr2, (char *)rts->ra, ETH_ALEN);
 		} else {
-			rts->frame_control = cpu_to_le16((u16) FC_RTS);
+			rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
+							 IEEE80211_STYPE_RTS);
 			bcopy((char *)h->addr1, (char *)rts->ra,
 			      2 * ETH_ALEN);
 		}
@@ -6620,7 +6618,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	tx_rts_count =
 	    (txs->status & TX_STATUS_RTS_RTX_MASK) >> TX_STATUS_RTS_RTX_SHIFT;
 
-	lastframe = (fc & FC_MOREFRAG) == 0;
+	lastframe = (ieee80211_has_morefrags(h->frame_control) == 0);
 
 	if (!lastframe) {
 		WL_ERROR("Not last frame!\n");
@@ -7041,7 +7039,9 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	/* explicitly test bad src address to avoid sending bad deauth */
 	if (!is_amsdu) {
 		/* CTS and ACK CTL frames are w/o a2 */
-		if (FC_TYPE(fc) == FC_TYPE_DATA || FC_TYPE(fc) == FC_TYPE_MNG) {
+
+		if (ieee80211_is_data(h->frame_control) ||
+		    ieee80211_is_mgmt(h->frame_control)) {
 			if ((is_zero_ether_addr(h->addr2) ||
 			     is_multicast_ether_addr(h->addr2))) {
 				WL_ERROR("wl%d: %s: dropping a frame with invalid src mac address, a2: %pM\n",
@@ -7054,10 +7054,8 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	}
 
 	/* due to sheer numbers, toss out probe reqs for now */
-	if (FC_TYPE(fc) == FC_TYPE_MNG) {
-		if ((fc & FC_KIND_MASK) == FC_PROBE_REQ)
-			goto toss;
-	}
+	if (ieee80211_is_probe_req(h->frame_control))
+		goto toss;
 
 	if (is_amsdu) {
 		WL_ERROR("%s: is_amsdu causing toss\n", __func__);
@@ -7618,9 +7616,10 @@ wlc_bcn_prb_template(struct wlc_info *wlc, uint type, ratespec_t bcn_rspec,
 	int hdr_len, body_len;
 
 	ASSERT(*len >= 142);
-	ASSERT(type == FC_BEACON || type == FC_PROBE_RESP);
+	ASSERT(type == IEEE80211_STYPE_BEACON ||
+	       type == IEEE80211_STYPE_PROBE_RESP);
 
-	if (MBSS_BCN_ENAB(cfg) && type == FC_BEACON)
+	if (MBSS_BCN_ENAB(cfg) && type == IEEE80211_STYPE_BEACON)
 		hdr_len = DOT11_MAC_HDR_LEN;
 	else
 		hdr_len = D11_PHY_HDR_LEN + DOT11_MAC_HDR_LEN;
@@ -7634,7 +7633,7 @@ wlc_bcn_prb_template(struct wlc_info *wlc, uint type, ratespec_t bcn_rspec,
 	plcp = (cck_phy_hdr_t *) buf;
 
 	/* PLCP for Probe Response frames are filled in from core's rate table */
-	if (type == FC_BEACON && !MBSS_BCN_ENAB(cfg)) {
+	if (type == IEEE80211_STYPE_BEACON && !MBSS_BCN_ENAB(cfg)) {
 		/* fill in PLCP */
 		wlc_compute_plcp(wlc, bcn_rspec,
 				 (DOT11_MAC_HDR_LEN + body_len + DOT11_FCS_LEN),
@@ -7646,17 +7645,17 @@ wlc_bcn_prb_template(struct wlc_info *wlc, uint type, ratespec_t bcn_rspec,
 	if (!SOFTBCN_ENAB(cfg))
 		wlc_beacon_phytxctl_txant_upd(wlc, bcn_rspec);
 
-	if (MBSS_BCN_ENAB(cfg) && type == FC_BEACON)
+	if (MBSS_BCN_ENAB(cfg) && type == IEEE80211_STYPE_BEACON)
 		h = (struct ieee80211_mgmt *)&plcp[0];
 	else
 		h = (struct ieee80211_mgmt *)&plcp[1];
 
 	/* fill in 802.11 header */
-	h->frame_control = cpu_to_le16((u16) type);
+	h->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | type);
 
 	/* DUR is 0 for multicast bcn, or filled in by MAC for prb resp */
 	/* A1 filled in by MAC for prb resp, broadcast for bcn */
-	if (type == FC_BEACON)
+	if (type == IEEE80211_STYPE_BEACON)
 		bcopy((const char *)&ether_bcast, h->da,
 		      ETH_ALEN);
 	bcopy((char *)&cfg->cur_etheraddr, h->sa, ETH_ALEN);
@@ -7721,7 +7720,7 @@ void wlc_bss_update_beacon(struct wlc_info *wlc, wlc_bsscfg_t *cfg)
 			true));
 
 		/* update the template and ucode shm */
-		wlc_bcn_prb_template(wlc, FC_BEACON, wlc->bcn_rspec, cfg, bcn,
+		wlc_bcn_prb_template(wlc, IEEE80211_STYPE_BEACON, wlc->bcn_rspec, cfg, bcn,
 				     &len);
 		wlc_write_hw_bcntemplates(wlc, bcn, len, false);
 	}
@@ -7781,8 +7780,8 @@ wlc_bss_update_probe_resp(struct wlc_info *wlc, wlc_bsscfg_t *cfg, bool suspend)
 	if (!MBSS_PRB_ENAB(cfg)) {
 
 		/* create the probe response template */
-		wlc_bcn_prb_template(wlc, FC_PROBE_RESP, 0, cfg, prb_resp,
-				     &len);
+		wlc_bcn_prb_template(wlc, IEEE80211_STYPE_PROBE_RESP, 0, cfg,
+					     prb_resp, &len);
 
 		if (suspend)
 			wlc_suspend_mac_and_wait(wlc);
@@ -7845,7 +7844,7 @@ int wlc_prep_pdu(struct wlc_info *wlc, struct sk_buff *pdu, uint *fifop)
 		return BCME_BUSY;
 	}
 
-	if (FC_TYPE(ltoh16(txh->MacFrameControl)) != FC_TYPE_DATA)
+	if (!ieee80211_is_data(txh->MacFrameControl))
 		WLCNTINCR(wlc->pub->_cnt->txctl);
 
 	return 0;
-- 
1.7.1

