Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58938 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767968Ab2KOOIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:54 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 18/22] brcmsmac: Add brcms_dbg_ht() debug macro
Date: Thu, 15 Nov 2012 08:08:08 -0600
Message-Id: <1352988492-21340-19-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150902_329428_013FB669)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also convert relevant messages to use this macro.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |   35 ++++++++++++-----------
 drivers/net/wireless/brcm80211/brcmsmac/debug.h |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/stf.c   |    8 ++++--
 drivers/net/wireless/brcm80211/include/defs.h   |    1 +
 4 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 2916ddf..56d2d6b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -371,7 +371,8 @@ static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 				      offsetof(struct macstat, txfunfl[fid]));
 	new_txunfl = (u16) (cur_txunfl - fifo->prev_txfunfl);
 	if (new_txunfl == 0) {
-		BCMMSG(wlc->wiphy, "TX status FRAG set but no tx underflows\n");
+		brcms_dbg_ht(wlc->hw->d11core,
+			     "TX status FRAG set but no tx underflows\n");
 		return -1;
 	}
 	fifo->prev_txfunfl = cur_txunfl;
@@ -393,8 +394,8 @@ static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 	if (fifo->accum_txfunfl < 10)
 		return 0;
 
-	BCMMSG(wlc->wiphy, "ampdu_count %d  tx_underflows %d\n",
-		current_ampdu_cnt, fifo->accum_txfunfl);
+	brcms_dbg_ht(wlc->hw->d11core, "ampdu_count %d  tx_underflows %d\n",
+		     current_ampdu_cnt, fifo->accum_txfunfl);
 
 	/*
 	   compute the current ratio of tx unfl per ampdu.
@@ -447,9 +448,10 @@ static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 		      (max_mpdu * FFPLD_MPDU_SIZE - fifo->ampdu_pld_size))
 		     / (max_mpdu * FFPLD_MPDU_SIZE)) * 100;
 
-		BCMMSG(wlc->wiphy, "DMA estimated transfer rate %d; "
-			"pre-load size %d\n",
-			fifo->dmaxferrate, fifo->ampdu_pld_size);
+		brcms_dbg_ht(wlc->hw->d11core,
+			     "DMA estimated transfer rate %d; "
+			     "pre-load size %d\n",
+			     fifo->dmaxferrate, fifo->ampdu_pld_size);
 	} else {
 
 		/* decrease ampdu size */
@@ -810,9 +812,9 @@ void brcms_c_ampdu_finalize(struct brcms_ampdu_session *session)
 		BRCMS_SET_MIMO_PLCP_AMPDU(txh->FragPLCPFallback);
 	}
 
-	BCMMSG(wlc->wiphy, "wl%d: count %d ampdu_len %d\n",
-		wlc->pub->unit, skb_queue_len(&session->skb_list),
-		session->ampdu_len);
+	brcms_dbg_ht(wlc->hw->d11core, "wl%d: count %d ampdu_len %d\n",
+		     wlc->pub->unit, skb_queue_len(&session->skb_list),
+		     session->ampdu_len);
 }
 
 static void
@@ -852,7 +854,6 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	u8 antselid = 0;
 	u8 retry_limit, rr_retry_limit;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(p);
-	struct wiphy *wiphy = wlc->wiphy;
 
 #ifdef DEBUG
 	u8 hole[AMPDU_MAX_MPDU];
@@ -956,10 +957,10 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		ack_recd = false;
 		if (ba_recd) {
 			bindex = MODSUB_POW2(seq, start_seq, SEQNUM_MAX);
-			BCMMSG(wiphy,
-			       "tid %d seq %d, start_seq %d, bindex %d set %d, index %d\n",
-			       tid, seq, start_seq, bindex,
-			       isset(bitmap, bindex), index);
+			brcms_dbg_ht(wlc->hw->d11core,
+				     "tid %d seq %d, start_seq %d, bindex %d set %d, index %d\n",
+				     tid, seq, start_seq, bindex,
+				     isset(bitmap, bindex), index);
 			/* if acked then clear bit and free packet */
 			if ((bindex < AMPDU_TX_BA_MAX_WSIZE)
 			    && isset(bitmap, bindex)) {
@@ -1010,9 +1011,9 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				    IEEE80211_TX_STAT_AMPDU_NO_BACK;
 				skb_pull(p, D11_PHY_HDR_LEN);
 				skb_pull(p, D11_TXH_LEN);
-				BCMMSG(wiphy,
-				       "BA Timeout, seq %d, in_transit %d\n",
-				       seq, ini->tx_in_transit);
+				brcms_dbg_ht(wlc->hw->d11core,
+					     "BA Timeout, seq %d, in_transit %d\n",
+					     seq, ini->tx_in_transit);
 				ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw,
 							    p);
 			}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.h b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
index 2e7e077..c0d2cf7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/debug.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
@@ -41,5 +41,6 @@ static inline void __brcms_dbg(struct device *dev, u32 level,
 #define brcms_dbg_tx(core, f, a...)		brcms_dbg(core, BRCM_DL_TX, f, ##a)
 #define brcms_dbg_int(core, f, a...)		brcms_dbg(core, BRCM_DL_INT, f, ##a)
 #define brcms_dbg_dma(core, f, a...)		brcms_dbg(core, BRCM_DL_DMA, f, ##a)
+#define brcms_dbg_ht(core, f, a...)		brcms_dbg(core, BRCM_DL_HT, f, ##a)
 
 #endif /* _BRCMS_DEBUG_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/stf.c b/drivers/net/wireless/brcm80211/brcmsmac/stf.c
index ed1d1aa..dd91627 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/stf.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/stf.c
@@ -23,6 +23,7 @@
 #include "channel.h"
 #include "main.h"
 #include "stf.h"
+#include "debug.h"
 
 #define MIN_SPATIAL_EXPANSION	0
 #define MAX_SPATIAL_EXPANSION	1
@@ -160,8 +161,8 @@ bool brcms_c_stf_stbc_rx_set(struct brcms_c_info *wlc, s32 int_val)
 static int brcms_c_stf_txcore_set(struct brcms_c_info *wlc, u8 Nsts,
 				  u8 core_mask)
 {
-	BCMMSG(wlc->wiphy, "wl%d: Nsts %d core_mask %x\n",
-		 wlc->pub->unit, Nsts, core_mask);
+	brcms_dbg_ht(wlc->hw->d11core, "wl%d: Nsts %d core_mask %x\n",
+		     wlc->pub->unit, Nsts, core_mask);
 
 	if (hweight8(core_mask) > wlc->stf->txstreams)
 		core_mask = 0;
@@ -194,7 +195,8 @@ static int brcms_c_stf_spatial_policy_set(struct brcms_c_info *wlc, int val)
 	int i;
 	u8 core_mask = 0;
 
-	BCMMSG(wlc->wiphy, "wl%d: val %x\n", wlc->pub->unit, val);
+	brcms_dbg_ht(wlc->hw->d11core, "wl%d: val %x\n", wlc->pub->unit,
+		     val);
 
 	wlc->stf->spatial_policy = (s8) val;
 	for (i = 1; i <= MAX_STREAMS_SUPPORTED; i++) {
diff --git a/drivers/net/wireless/brcm80211/include/defs.h b/drivers/net/wireless/brcm80211/include/defs.h
index 54ffe7f..fb7cbcf 100644
--- a/drivers/net/wireless/brcm80211/include/defs.h
+++ b/drivers/net/wireless/brcm80211/include/defs.h
@@ -85,6 +85,7 @@
 #define BRCM_DL_TX		0x00000008
 #define BRCM_DL_INT		0x00000010
 #define BRCM_DL_DMA		0x00000020
+#define BRCM_DL_HT		0x00000040
 
 #define PM_OFF	0
 #define PM_MAX	1
-- 
1.7.9.5

