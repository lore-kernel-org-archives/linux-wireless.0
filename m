Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3748 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/19] brcm80211: smac: replace own access category
 definitions with mac80211 enum
Date: Thu, 10 Nov 2011 20:30:18 +0100
Message-ID: <1320953434-16859-5-git-send-email-arend@broadcom.com> (sfid-20111110_203135_107427_9B0C3F79)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmsmac had own definitions for the access categories. The mac80211
header provides these as well as they are used in the conf_tx callback.
As the definitions did not match the driver configured the tx parameters
to the wrong queue.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   35 ++++++++++++++---------
 drivers/net/wireless/brcm80211/brcmsmac/main.h |    8 ++---
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index f193fab..0e8873e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -109,11 +109,6 @@
 #define BPHY_PLCP_TIME			192
 #define RIFS_11N_TIME			2
 
-#define AC_BE				0
-#define AC_BK				1
-#define AC_VI				2
-#define AC_VO				3
-
 /* length of the BCN template area */
 #define BCN_TMPL_LEN			512
 
@@ -305,10 +300,22 @@ uint brcm_msg_level =
 #endif				/* BCMDBG */
 
 /* TX FIFO number to WME/802.1E Access Category */
-static const u8 wme_fifo2ac[] = { AC_BK, AC_BE, AC_VI, AC_VO, AC_BE, AC_BE };
+static const u8 wme_fifo2ac[] = {
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BE,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VO,
+	IEEE80211_AC_BE,
+	IEEE80211_AC_BE
+};
 
-/* WME/802.1E Access Category to TX FIFO number */
-static const u8 wme_ac2fifo[] = { 1, 0, 2, 3 };
+/* ieee80211 Access Category to TX FIFO number */
+static const u8 wme_ac2fifo[] = {
+	TX_AC_VO_FIFO,
+	TX_AC_VI_FIFO,
+	TX_AC_BE_FIFO,
+	TX_AC_BK_FIFO
+};
 
 /* 802.1D Priority to precedence queue mapping */
 const u8 wlc_prio2prec_map[] = {
@@ -893,7 +900,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 		    lfbl,	/* Long Frame Rate Fallback Limit */
 		    fbl;
 
-		if (queue < AC_COUNT) {
+		if (queue < IEEE80211_NUM_ACS) {
 			sfbl = GFIELD(wlc->wme_retries[wme_fifo2ac[queue]],
 				      EDCF_SFB);
 			lfbl = GFIELD(wlc->wme_retries[wme_fifo2ac[queue]],
@@ -4125,7 +4132,7 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 	    EDCF_TXOP2USEC(acp_shm.txop);
 	acp_shm.aifs = (params->aifs & EDCF_AIFSN_MASK);
 
-	if (aci == AC_VI && acp_shm.txop == 0
+	if (aci == IEEE80211_AC_VI && acp_shm.txop == 0
 	    && acp_shm.aifs < EDCF_AIFSN_MAX)
 		acp_shm.aifs++;
 
@@ -4175,7 +4182,7 @@ static void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 	}; /* ucode needs these parameters during its initialization */
 	const struct edcf_acparam *edcf_acp = &default_edcf_acparams[0];
 
-	for (i_ac = 0; i_ac < AC_COUNT; i_ac++, edcf_acp++) {
+	for (i_ac = 0; i_ac < IEEE80211_NUM_ACS; i_ac++, edcf_acp++) {
 		/* find out which ac this set of params applies to */
 		aci = (edcf_acp->ACI & EDCF_ACI_MASK) >> EDCF_ACI_SHIFT;
 
@@ -5172,7 +5179,7 @@ static void brcms_c_wme_retries_write(struct brcms_c_info *wlc)
 	if (!wlc->clk)
 		return;
 
-	for (ac = 0; ac < AC_COUNT; ac++)
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 		brcms_b_write_shm(wlc->hw, M_AC_TXLMT_ADDR(ac),
 				  wlc->wme_retries[ac]);
 }
@@ -5647,7 +5654,7 @@ int brcms_c_set_rate_limit(struct brcms_c_info *wlc, u16 srl, u16 lrl)
 
 	brcms_b_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
 
-	for (ac = 0; ac < AC_COUNT; ac++) {
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		wlc->wme_retries[ac] =	SFIELD(wlc->wme_retries[ac],
 					       EDCF_SHORT,  wlc->SRL);
 		wlc->wme_retries[ac] =	SFIELD(wlc->wme_retries[ac],
@@ -8358,7 +8365,7 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 		/* Uninitialized; read from HW */
 		int ac;
 
-		for (ac = 0; ac < AC_COUNT; ac++)
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			wlc->wme_retries[ac] =
 			    brcms_b_read_shm(wlc->hw, M_AC_TXLMT_ADDR(ac));
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 9a7535d..251c350 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -44,8 +44,6 @@
 /* transmit buffer max headroom for protocol headers */
 #define TXOFF (D11_TXH_LEN + D11_PHY_HDR_LEN)
 
-#define AC_COUNT		4
-
 /* Macros for doing definition and get/set of bitfields
  * Usage example, e.g. a three-bit field (bits 4-6):
  *    #define <NAME>_M	BITFIELD_MASK(3)
@@ -436,7 +434,7 @@ struct brcms_txq_info {
  * bcn_li_dtim: beacon listen interval in # dtims.
  * WDarmed: watchdog timer is armed.
  * WDlast: last time wlc_watchdog() was called.
- * edcf_txop[AC_COUNT]: current txop for each ac.
+ * edcf_txop[IEEE80211_NUM_ACS]: current txop for each ac.
  * wme_retries: per-AC retry limits.
  * tx_prec_map: Precedence map based on HW FIFO space.
  * fifo2prec_map[NFIFO]: pointer to fifo2_prec map based on WME.
@@ -535,9 +533,9 @@ struct brcms_c_info {
 	u32 WDlast;
 
 	/* WME */
-	u16 edcf_txop[AC_COUNT];
+	u16 edcf_txop[IEEE80211_NUM_ACS];
 
-	u16 wme_retries[AC_COUNT];
+	u16 wme_retries[IEEE80211_NUM_ACS];
 	u16 tx_prec_map;
 	u16 fifo2prec_map[NFIFO];
 
-- 
1.7.5.4


