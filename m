Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4758 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab1I0Rpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:47 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 15/26] staging: brcm80211: removed global var
 global_scb from softmac
Date: Tue, 27 Sep 2011 10:45:19 -0700
Message-ID: <1317145530-18839-16-git-send-email-frankyl@broadcom.com> (sfid-20110927_194650_752421_F3E440CD)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Global variables are undesirable unless they are read only. Removed by
instead using an already defined Station Control Block variable in a
per-device structure.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |    6 +++---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   19 ++++---------------
 drivers/staging/brcm80211/brcmsmac/main.c        |   21 +++++++++++++--------
 drivers/staging/brcm80211/brcmsmac/main.h        |    4 ++++
 drivers/staging/brcm80211/brcmsmac/pub.h         |    1 -
 5 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index b94d60c..e29c62e 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -314,7 +314,7 @@ static void brcms_c_scb_ampdu_update_config(struct ampdu_info *ampdu,
 
 static void brcms_c_scb_ampdu_update_config_all(struct ampdu_info *ampdu)
 {
-	brcms_c_scb_ampdu_update_config(ampdu, ampdu->wlc->pub->global_scb);
+	brcms_c_scb_ampdu_update_config(ampdu, &ampdu->wlc->pri_scb);
 }
 
 static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
@@ -482,7 +482,7 @@ brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 	struct scb_ampdu *scb_ampdu;
 	struct scb_ampdu_tid_ini *ini;
 	struct ampdu_info *ampdu = wlc->ampdu;
-	struct scb *scb = wlc->pub->global_scb;
+	struct scb *scb = &wlc->pri_scb;
 	scb_ampdu = &scb->scb_ampdu;
 
 	if (!ampdu->ini_enable[tid]) {
@@ -542,7 +542,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 
 	f = ampdu->fifo_tb + prio2fifo[tid];
 
-	scb = wlc->pub->global_scb;
+	scb = &wlc->pri_scb;
 	scb_ampdu = &scb->scb_ampdu;
 	ini = &scb_ampdu->ini[tid];
 
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index d5d0d9e..1c45687 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -616,25 +616,14 @@ static int
 brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	       struct ieee80211_sta *sta)
 {
-	struct scb *scb;
-
-	int i;
 	struct brcms_info *wl = hw->priv;
+	struct scb *scb = &wl->wlc->pri_scb;
 
-	/* Init the scb */
-	scb = (struct scb *)sta->drv_priv;
-	memset(scb, 0, sizeof(struct scb));
-	for (i = 0; i < NUMPRIO; i++)
-		scb->seqctl[i] = 0xFFFF;
-	scb->seqctl_nonqos = 0xFFFF;
-	scb->magic = SCB_MAGIC;
+	brcms_c_init_scb(scb);
 
-	wl->pub->global_scb = scb;
 	wl->pub->global_ampdu = &(scb->scb_ampdu);
 	wl->pub->global_ampdu->scb = scb;
 	wl->pub->global_ampdu->max_pdu = 16;
-	brcmu_pktq_init(&scb->scb_ampdu.txq, AMPDU_MAX_SCB_TID,
-		  AMPDU_MAX_SCB_TID * PKTQ_LEN_DEFAULT);
 
 	sta->ht_cap.ht_supported = true;
 	sta->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
@@ -657,8 +646,8 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
 		    u8 buf_size)
 {
-	struct scb *scb = (struct scb *)sta->drv_priv;
 	struct brcms_info *wl = hw->priv;
+	struct scb *scb = &wl->wlc->pri_scb;
 	int status;
 
 	if (WARN_ON(scb->magic != SCB_MAGIC))
@@ -1038,7 +1027,7 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 
 	hw->rate_control_algorithm = "minstrel_ht";
 
-	hw->sta_data_size = sizeof(struct scb);
+	hw->sta_data_size = 0;
 	return ieee_hw_rate_init(hw);
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index a3c0157..7a14ab9 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -882,7 +882,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
 
 	if (tx_info->control.sta)
-		scb = (struct scb *)tx_info->control.sta->drv_priv;
+		scb = &wlc->pri_scb;
 
 	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 		brcms_c_ampdu_dotxstatus(wlc->ampdu, scb, p, txs);
@@ -3331,14 +3331,21 @@ static u16 brcms_c_init_chanspec(struct brcms_c_info *wlc)
 	return chanspec;
 }
 
-static struct scb global_scb;
-
-static void brcms_c_init_scb(struct brcms_c_info *wlc, struct scb *scb)
+void brcms_c_init_scb(struct scb *scb)
 {
 	int i;
+
+	memset(scb, 0, sizeof(struct scb));
 	scb->flags = SCB_WMECAP | SCB_HTCAP;
-	for (i = 0; i < NUMPRIO; i++)
+	for (i = 0; i < NUMPRIO; i++) {
 		scb->seqnum[i] = 0;
+		scb->seqctl[i] = 0xFFFF;
+	}
+
+	scb->seqctl_nonqos = 0xFFFF;
+	scb->magic = SCB_MAGIC;
+	brcmu_pktq_init(&scb->scb_ampdu.txq, AMPDU_MAX_SCB_TID,
+		  AMPDU_MAX_SCB_TID * PKTQ_LEN_DEFAULT);
 }
 
 /* d11 core init
@@ -3799,8 +3806,6 @@ void brcms_c_init(struct brcms_c_info *wlc)
 
 	brcms_c_bandinit_ordered(wlc, chanspec);
 
-	brcms_c_init_scb(wlc, &global_scb);
-
 	/* init probe response timeout */
 	brcms_c_write_shm(wlc, M_PRS_MAXTIME, wlc->prb_resp_timeout);
 
@@ -7684,7 +7689,7 @@ void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 {
 	u8 prio;
 	uint fifo;
-	struct scb *scb = &global_scb;
+	struct scb *scb = &wlc->pri_scb;
 	struct ieee80211_hdr *d11_header = (struct ieee80211_hdr *)(sdu->data);
 
 	/*
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 9e12a14..47665da 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -22,6 +22,7 @@
 #include <brcmu_utils.h>
 #include "types.h"
 #include "d11.h"
+#include "scb.h"
 
 #define	INVCHANNEL		255	/* invalid channel */
 
@@ -483,6 +484,7 @@ struct brcms_txq_info {
  * tx_duty_cycle_cck: maximum allowed duty cycle for CCK.
  * pkt_queue: txq for transmit packets.
  * wiphy:
+ * pri_scb: primary Station Control Block
  */
 struct brcms_c_info {
 	struct brcms_pub *pub;
@@ -610,6 +612,7 @@ struct brcms_c_info {
 
 	struct brcms_txq_info *pkt_queue;
 	struct wiphy *wiphy;
+	struct scb pri_scb;
 };
 
 /* antsel module specific state */
@@ -864,5 +867,6 @@ extern void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on);
 extern void brcms_b_txant_set(struct brcms_hardware *wlc_hw, u16 phytxant);
 extern void brcms_b_band_stf_ss_set(struct brcms_hardware *wlc_hw,
 				    u8 stf_mode);
+extern void brcms_c_init_scb(struct scb *scb);
 
 #endif				/* _BRCM_MAIN_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 9670309..b69833e 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -144,7 +144,6 @@ struct brcms_bss_info {
 struct brcms_pub {
 	struct brcms_c_info *wlc;
 	struct ieee80211_hw *ieee_hw;
-	struct scb *global_scb;
 	struct scb_ampdu *global_ampdu;
 	uint mac80211_state;
 	uint unit;		/* device instance number */
-- 
1.7.1


