Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3296 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab1EIOdn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:43 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 01/10] staging: brcm80211: cleanup unnecessary functions
 from wlc_ampdu.c
Date: Mon, 9 May 2011 16:33:20 +0200
Message-ID: <1304951609-2493-1-git-send-email-arend@broadcom.com> (sfid-20110509_163741_889211_1F896397)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Couple of functions are not used or empty and have been removed.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcoom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |   85 ++---------------------
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h |    3 -
 drivers/staging/brcm80211/brcmsmac/wlc_main.c  |    1 -
 3 files changed, 8 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index e9f62dd..54ed03e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -120,6 +120,12 @@ struct ampdu_info {
 
 };
 
+/* used for plushing ampdu packets */
+struct cb_del_ampdu_pars {
+	struct ieee80211_sta *sta;
+	u16 tid;
+};
+
 #define AMPDU_CLEANUPFLAG_RX   (0x1)
 #define AMPDU_CLEANUPFLAG_TX   (0x2)
 
@@ -133,9 +139,6 @@ static void wlc_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f);
 static scb_ampdu_tid_ini_t *wlc_ampdu_init_tid_ini(struct ampdu_info *ampdu,
 						   scb_ampdu_t *scb_ampdu,
 						   u8 tid, bool override);
-static void ampdu_cleanup_tid_ini(struct ampdu_info *ampdu,
-				  scb_ampdu_t *scb_ampdu,
-				  u8 tid, bool force);
 static void ampdu_update_max_txlen(struct ampdu_info *ampdu, u8 dur);
 static void scb_ampdu_update_config(struct ampdu_info *ampdu, struct scb *scb);
 static void scb_ampdu_update_config_all(struct ampdu_info *ampdu);
@@ -220,24 +223,6 @@ void wlc_ampdu_detach(struct ampdu_info *ampdu)
 	kfree(ampdu);
 }
 
-void scb_ampdu_cleanup(struct ampdu_info *ampdu, struct scb *scb)
-{
-	scb_ampdu_t *scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
-	u8 tid;
-
-	BCMMSG(ampdu->wlc->wiphy, "enter\n");
-	for (tid = 0; tid < AMPDU_MAX_SCB_TID; tid++) {
-		ampdu_cleanup_tid_ini(ampdu, scb_ampdu, tid, false);
-	}
-}
-
-/* reset the ampdu state machine so that it can gracefully handle packets that were
- * freed from the dma and tx queues during reinit
- */
-void wlc_ampdu_reset(struct ampdu_info *ampdu)
-{
-}
-
 static void scb_ampdu_update_config(struct ampdu_info *ampdu, struct scb *scb)
 {
 	scb_ampdu_t *scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
@@ -266,7 +251,7 @@ static void scb_ampdu_update_config(struct ampdu_info *ampdu, struct scb *scb)
 				 mcs2ampdu_table[FFPLD_MAX_MCS]);
 }
 
-void scb_ampdu_update_config_all(struct ampdu_info *ampdu)
+static void scb_ampdu_update_config_all(struct ampdu_info *ampdu)
 {
 	scb_ampdu_update_config(ampdu, ampdu->wlc->pub->global_scb);
 }
@@ -911,7 +896,7 @@ wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 	wlc_ampdu_txflowcontrol(wlc, scb_ampdu, ini);
 }
 
-void
+static void
 rate_status(struct wlc_info *wlc, struct ieee80211_tx_info *tx_info,
 	    tx_status_t *txs, u8 mcs)
 {
@@ -1131,26 +1116,6 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	wlc_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 }
 
-static void
-ampdu_cleanup_tid_ini(struct ampdu_info *ampdu, scb_ampdu_t *scb_ampdu, u8 tid,
-		      bool force)
-{
-	scb_ampdu_tid_ini_t *ini;
-	ini = SCB_AMPDU_INI(scb_ampdu, tid);
-	if (!ini)
-		return;
-
-	BCMMSG(ampdu->wlc->wiphy, "wl%d: tid %d\n", ampdu->wlc->pub->unit, tid);
-
-	if (ini->tx_in_transit && !force)
-		return;
-
-	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, ini->scb);
-
-	/* free all buffered tx packets */
-	bcm_pktq_pflush(&scb_ampdu->txq, ini->tid, true, NULL, 0);
-}
-
 /* initialize the initiator code for tid */
 static scb_ampdu_tid_ini_t *wlc_ampdu_init_tid_ini(struct ampdu_info *ampdu,
 						   scb_ampdu_t *scb_ampdu,
@@ -1226,35 +1191,6 @@ static void ampdu_update_max_txlen(struct ampdu_info *ampdu, u8 dur)
 	}
 }
 
-u8 BCMFASTPATH
-wlc_ampdu_null_delim_cnt(struct ampdu_info *ampdu, struct scb *scb,
-			 ratespec_t rspec, int phylen)
-{
-	scb_ampdu_t *scb_ampdu;
-	int bytes, cnt, tmp;
-	u8 tx_density;
-
-	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
-	if (scb_ampdu->mpdu_density == 0)
-		return 0;
-
-	/* RSPEC2RATE is in kbps units ==> ~RSPEC2RATE/2^13 is in bytes/usec
-	   density x is in 2^(x-4) usec
-	   ==> # of bytes needed for req density = rate/2^(17-x)
-	   ==> # of null delimiters = ceil(ceil(rate/2^(17-x)) - phylen)/4)
-	 */
-
-	tx_density = scb_ampdu->mpdu_density;
-	tmp = 1 << (17 - tx_density);
-	bytes = CEIL(RSPEC2RATE(rspec), tmp);
-
-	if (bytes > phylen) {
-		cnt = CEIL(bytes - phylen, AMPDU_DELIMITER_LEN);
-		return (u8) cnt;
-	} else
-		return 0;
-}
-
 void wlc_ampdu_macaddr_upd(struct wlc_info *wlc)
 {
 	char template[T_RAM_ACCESS_SZ * 2];
@@ -1286,11 +1222,6 @@ void wlc_ampdu_shm_upd(struct ampdu_info *ampdu)
 	}
 }
 
-struct cb_del_ampdu_pars {
-	struct ieee80211_sta *sta;
-	u16 tid;
-};
-
 /*
  * callback function that helps flushing ampdu packets from a priority queue
  */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h
index 17e9ebc..63d403b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h
@@ -23,10 +23,7 @@ extern int wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 			 struct sk_buff **aggp, int prec);
 extern void wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 				 struct sk_buff *p, tx_status_t *txs);
-extern void wlc_ampdu_reset(struct ampdu_info *ampdu);
 extern void wlc_ampdu_macaddr_upd(struct wlc_info *wlc);
 extern void wlc_ampdu_shm_upd(struct ampdu_info *ampdu);
-extern u8 wlc_ampdu_null_delim_cnt(struct ampdu_info *ampdu, struct scb *scb,
-				      ratespec_t rspec, int phylen);
 
 #endif				/* _wlc_ampdu_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 0e244d9..9697e12 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -398,7 +398,6 @@ void wlc_reset(struct wlc_info *wlc)
 		sizeof(macstat_t));
 
 	wlc_bmac_reset(wlc->hw);
-	wlc_ampdu_reset(wlc->ampdu);
 	wlc->txretried = 0;
 
 }
-- 
1.7.4.1


