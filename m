Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4619 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757798Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 021/119] staging: brcm80211: parsed ADDBA response ack
 window parameter
Date: Wed, 29 Jun 2011 16:46:45 -0700
Message-ID: <1309391303-22741-22-git-send-email-frankyl@broadcom.com> (sfid-20110630_014936_535615_8B175FFB)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

IEEE80211_AMPDU_TX_OPERATIONAL provides a BA window size parameter. Code
is now using this parameter to restrict the amount of outstanding tx
AMPDUs.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |   55 +++++++---------------
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    9 +++-
 drivers/staging/brcm80211/brcmsmac/pub.h         |    2 +
 drivers/staging/brcm80211/brcmsmac/scb.h         |    3 +-
 4 files changed, 29 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 74c4055..e9b78bf 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -114,9 +114,6 @@ static void brcms_c_ffpld_init(struct ampdu_info *ampdu);
 static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int f);
 static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f);
 
-static scb_ampdu_tid_ini_t *brcms_c_ampdu_init_tid_ini(struct ampdu_info *ampdu,
-						   scb_ampdu_t *scb_ampdu,
-						   u8 tid, bool override);
 static void brcms_c_scb_ampdu_update_max_txlen(struct ampdu_info *ampdu,
 					       u8 dur);
 static void brcms_c_scb_ampdu_update_config(struct ampdu_info *ampdu,
@@ -411,22 +408,26 @@ static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
 	}
 }
 
-static void
-brcms_c_ampdu_agg(struct ampdu_info *ampdu, struct scb *scb, struct sk_buff *p,
-	      uint prec)
+void
+brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
+		  u8 ba_wsize)		/* negotiated ba window size (in pdu) */
 {
 	scb_ampdu_t *scb_ampdu;
 	scb_ampdu_tid_ini_t *ini;
-	u8 tid = (u8) (p->priority);
-
+	struct ampdu_info *ampdu = wlc->ampdu;
+	struct scb *scb = wlc->pub->global_scb;
 	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
 
-	/* initialize initiator on first packet; sends addba req */
-	ini = SCB_AMPDU_INI(scb_ampdu, tid);
-	if (ini->magic != INI_MAGIC) {
-		ini = brcms_c_ampdu_init_tid_ini(ampdu, scb_ampdu, tid, false);
+	if (!ampdu->ini_enable[tid]) {
+		wiphy_err(ampdu->wlc->wiphy, "%s: Rejecting tid %d\n",
+			  __func__, tid);
+		return;
 	}
-	return;
+
+	ini = SCB_AMPDU_INI(scb_ampdu, tid);
+	ini->tid = tid;
+	ini->scb = scb_ampdu->scb;
+	ini->ba_wsize = ba_wsize;
 }
 
 int
@@ -479,12 +480,13 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 
 	/* Let pressure continue to build ... */
 	qlen = pktq_plen(&qi->q, prec);
-	if (ini->tx_in_transit > 0 && qlen < scb_ampdu->max_pdu) {
+	if (ini->tx_in_transit > 0 &&
+	    qlen < min(scb_ampdu->max_pdu, ini->ba_wsize)) {
+		/* Collect multiple MPDU's to be sent in the next AMPDU */
 		return -EBUSY;
 	}
 
-	brcms_c_ampdu_agg(ampdu, scb, p, tid);
-
+	/* at this point we intend to transmit an AMPDU */
 	rr_retry_limit = ampdu->rr_retry_limit_tid[tid];
 	ampdu_len = 0;
 	dma_len = 0;
@@ -1083,27 +1085,6 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 }
 
-/* initialize the initiator code for tid */
-static scb_ampdu_tid_ini_t *brcms_c_ampdu_init_tid_ini(struct ampdu_info *ampdu,
-						   scb_ampdu_t *scb_ampdu,
-						   u8 tid, bool override)
-{
-	scb_ampdu_tid_ini_t *ini;
-
-	/* check for per-tid control of ampdu */
-	if (!ampdu->ini_enable[tid]) {
-		wiphy_err(ampdu->wlc->wiphy, "%s: Rejecting tid %d\n",
-			  __func__, tid);
-		return NULL;
-	}
-
-	ini = SCB_AMPDU_INI(scb_ampdu, tid);
-	ini->tid = tid;
-	ini->scb = scb_ampdu->scb;
-	ini->magic = INI_MAGIC;
-	return ini;
-}
-
 static int brcms_c_ampdu_set(struct ampdu_info *ampdu, bool on)
 {
 	struct brcms_c_info *wlc = ampdu->wlc;
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 73e60df..547df75 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -656,7 +656,14 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		/* Not sure what to do here */
+		/*
+		 * BA window size from ADDBA response ('buf_size') defines how
+		 * many outstanding MPDUs are allowed for the BA stream by
+		 * recipient and traffic class.
+		 */
+		LOCK(wl);
+		brcms_c_ampdu_tx_operational(wl->wlc, tid, buf_size);
+		UNLOCK(wl);
 		/* Power save wakeup */
 		break;
 	default:
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 2345a31..14c0d20 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -626,6 +626,8 @@ extern void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs);
 
 extern void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 			    struct ieee80211_sta *sta, u16 tid);
+extern void brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
+					 u8 ba_wsize);
 extern int brcms_c_set_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
 			   int val);
 extern int brcms_c_get_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
diff --git a/drivers/staging/brcm80211/brcmsmac/scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
index fa5c0b3..c2080e9 100644
--- a/drivers/staging/brcm80211/brcmsmac/scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/scb.h
@@ -25,11 +25,11 @@
 #define AMPDU_TX_BA_MAX_WSIZE	64	/* max Tx ba window size (in pdu) */
 /* structure to store per-tid state for the ampdu initiator */
 struct scb_ampdu_tid_ini {
-	u32 magic;
 	u8 tx_in_transit;	/* number of pending mpdus in transit in driver */
 	u8 tid;		/* initiator tid for easy lookup */
 	u8 txretry[AMPDU_TX_BA_MAX_WSIZE];	/* tx retry count; indexed by seq modulo */
 	struct scb *scb;	/* backptr for easy lookup */
+	u8 ba_wsize;		/* negotiated ba window size (in pdu) */
 };
 
 #define AMPDU_MAX_SCB_TID	NUMPRIO
@@ -51,7 +51,6 @@ struct scb_ampdu {
 };
 
 #define SCB_MAGIC 	0xbeefcafe
-#define INI_MAGIC 	0xabcd1234
 
 /* station control block - one per remote MAC address */
 struct scb {
-- 
1.7.1


