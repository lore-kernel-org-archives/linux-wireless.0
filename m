Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4045 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab1IMHuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:18 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/17] staging: brcm80211: cleanup of softmac macro
 EDCF_ENAB()
Date: Tue, 13 Sep 2011 09:49:46 +0200
Message-ID: <1315900197-7260-7-git-send-email-rvossen@broadcom.com> (sfid-20110913_095028_112079_99504290)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since structure member pub->_wme is set to AUTO early in init, macro
EDCF_ENAB is always 'true' after that. All code that uses ECDF_ENAB()
appears in the code flow after the init.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   53 ++++-------------------------
 drivers/staging/brcm80211/brcmsmac/main.h |    2 -
 drivers/staging/brcm80211/brcmsmac/pub.h  |    4 --
 drivers/staging/brcm80211/brcmsmac/scb.h  |    2 +-
 4 files changed, 8 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index bf3634e..9921af2 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -3579,19 +3579,10 @@ static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc)
 	wlc->tx_prec_map = BRCMS_PREC_BMP_ALL;
 	memset(wlc->fifo2prec_map, 0, NFIFO * sizeof(u16));
 
-	/*
-	 * For non-WME, both fifos have overlapping MAXPRIO. So just
-	 * disable all precedences if either is full.
-	 */
-	if (!EDCF_ENAB(wlc->pub)) {
-		wlc->fifo2prec_map[TX_DATA_FIFO] = BRCMS_PREC_BMP_ALL;
-		wlc->fifo2prec_map[TX_CTL_FIFO] = BRCMS_PREC_BMP_ALL;
-	} else {
-		wlc->fifo2prec_map[TX_AC_BK_FIFO] = BRCMS_PREC_BMP_AC_BK;
-		wlc->fifo2prec_map[TX_AC_BE_FIFO] = BRCMS_PREC_BMP_AC_BE;
-		wlc->fifo2prec_map[TX_AC_VI_FIFO] = BRCMS_PREC_BMP_AC_VI;
-		wlc->fifo2prec_map[TX_AC_VO_FIFO] = BRCMS_PREC_BMP_AC_VO;
-	}
+	wlc->fifo2prec_map[TX_AC_BK_FIFO] = BRCMS_PREC_BMP_AC_BK;
+	wlc->fifo2prec_map[TX_AC_BE_FIFO] = BRCMS_PREC_BMP_AC_BE;
+	wlc->fifo2prec_map[TX_AC_VI_FIFO] = BRCMS_PREC_BMP_AC_VI;
+	wlc->fifo2prec_map[TX_AC_VO_FIFO] = BRCMS_PREC_BMP_AC_VO;
 }
 
 static void
@@ -3698,10 +3689,8 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	brcms_c_bsinit(wlc);
 
 	/* Enable EDCF mode (while the MAC is suspended) */
-	if (EDCF_ENAB(wlc->pub)) {
-		OR_REG(&regs->ifs_ctl, IFS_USEEDCF);
-		brcms_c_edcf_setparams(wlc, false);
-	}
+	OR_REG(&regs->ifs_ctl, IFS_USEEDCF);
+	brcms_c_edcf_setparams(wlc, false);
 
 	/* Init precedence maps for empty FIFOs */
 	brcms_c_tx_prec_map_init(wlc);
@@ -4538,7 +4527,6 @@ void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 	wlc->LRL = RETRY_LONG_DEF;
 
 	/* WME QoS mode is Auto by default */
-	wlc->pub->_wme = AUTO;
 	wlc->pub->_ampdu = AMPDU_AGG_HOST;
 	wlc->pub->bcmerror = 0;
 
@@ -5745,10 +5733,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	brcms_c_radio_monitor_stop(wlc);
 
 	/* Set EDCF hostflags */
-	if (EDCF_ENAB(wlc->pub))
-		brcms_c_mhf(wlc, MHF1, MHF1_EDCF, MHF1_EDCF, BRCM_BAND_ALL);
-	else
-		brcms_c_mhf(wlc, MHF1, MHF1_EDCF, 0, BRCM_BAND_ALL);
+	brcms_c_mhf(wlc, MHF1, MHF1_EDCF, MHF1_EDCF, BRCM_BAND_ALL);
 
 	if (BRCMS_WAR16165(wlc))
 		brcms_c_mhf(wlc, MHF2, MHF2_PCISLOWCLKWAR, MHF2_PCISLOWCLKWAR,
@@ -6715,27 +6700,12 @@ void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 	prio = sdu->priority;
 
 	if (!brcms_c_prec_enq(wlc, q, sdu, prec)) {
-		if (!EDCF_ENAB(wlc->pub))
-			wiphy_err(wlc->wiphy, "wl%d: txq_enq: txq overflow"
-				  "\n", wlc->pub->unit);
-
 		/*
 		 * we might hit this condtion in case
 		 * packet flooding from mac80211 stack
 		 */
 		brcmu_pkt_buf_free_skb(sdu);
 	}
-
-	/*
-	 * Check if flow control needs to be turned on after enqueuing the
-	 * packet. Don't turn on flow control if EDCF is enabled. Driver
-	 * would make the decision on what to drop instead of relying on
-	 * stack to make the right decision
-	 */
-	if (!EDCF_ENAB(wlc->pub)) {
-		if (pktq_len(q) >= BRCMS_DATAHIWAT)
-			brcms_c_txflowcontrol(wlc, qi, ON, ALLPRIO);
-	}
 }
 
 /*
@@ -7729,15 +7699,6 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 		}
 	}
 
-	/*
-	 * Check if flow control needs to be turned off after
-	 * sending the packet
-	 */
-	if (!EDCF_ENAB(wlc->pub)) {
-		if (brcms_c_txflowcontrol_prio_isset(wlc, qi, ALLPRIO)
-		    && (pktq_len(q) < BRCMS_DATAHIWAT / 2))
-			brcms_c_txflowcontrol(wlc, qi, OFF, ALLPRIO);
-	}
 	in_send_q = false;
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index ed8369f..0462250 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -849,8 +849,6 @@ extern void brcms_c_set_home_chanspec(struct brcms_c_info *wlc,
 				      u16 chanspec);
 extern bool brcms_c_ps_allowed(struct brcms_c_info *wlc);
 extern bool brcms_c_stay_awake(struct brcms_c_info *wlc);
-extern void brcms_c_wme_initparams_sta(struct brcms_c_info *wlc,
-				       struct wme_param_ie *pe);
 
 extern void brcms_b_antsel_type_set(struct brcms_hardware *wlc_hw,
 				     u8 antsel_type);
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 2069d16..6230350 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -153,7 +153,6 @@ struct brcms_pub {
 
 	bool promisc;		/* promiscuous destination address */
 	bool delayed_down;	/* down delayed */
-	int _wme;		/* WME QoS mode */
 	bool associated;	/* true:part of [I]BSS, false: not */
 	/* (union of stas_associated, aps_associated) */
 	bool _ampdu;		/* ampdu enabled or not */
@@ -197,9 +196,6 @@ enum wlc_par_id {
 /* WL11N Support */
 #define AMPDU_AGG_HOST	1
 
-#define EDCF_ENAB(pub) ((pub)->_wme != OFF)
-#define QOS_ENAB(pub) ((pub)->_wme != OFF || (pub)->_n_enab & SUPPORT_11N)
-
 /* pri is priority encoded in the packet. This maps the Packet priority to
  * enqueue precedence as defined in wlc_prec_map
  */
diff --git a/drivers/staging/brcm80211/brcmsmac/scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
index b2aacf3..122d3c3 100644
--- a/drivers/staging/brcm80211/brcmsmac/scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/scb.h
@@ -27,7 +27,7 @@
 #define AMPDU_MAX_SCB_TID	NUMPRIO
 
 /* scb flags */
-#define SCB_WMECAP		0x0040	/* may ONLY be set if pub->_wme!=OFF */
+#define SCB_WMECAP		0x0040
 #define SCB_HTCAP		0x10000	/* HT (MIMO) capable device */
 #define SCB_IS40		0x80000	/* 40MHz capable */
 #define SCB_STBCCAP		0x40000000	/* STBC Capable */
-- 
1.7.4.1


