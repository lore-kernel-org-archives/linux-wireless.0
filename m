Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30288 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbZGWKCo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:02:44 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:02:45 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19048.13633.548084.579577@localhost.localdomain>
Date: Thu, 23 Jul 2009 15:32:41 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/6] ath9k: Remove a few redundant variables/macros
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/xmit.c  |   24 ++++++++++--------------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9d01d99..e94e8f9 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -190,7 +190,6 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_AGGR_MIN_QDEPTH        2
 #define ATH_AMPDU_SUBFRAME_DEFAULT 32
 #define ATH_AMPDU_LIMIT_MAX        (64 * 1024 - 1)
-#define ATH_AMPDU_LIMIT_DEFAULT    ATH_AMPDU_LIMIT_MAX
 
 #define IEEE80211_SEQ_SEQ_SHIFT    4
 #define IEEE80211_SEQ_MAX          4096
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index fd07aa1..b7806e2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -458,7 +458,7 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	struct ieee80211_tx_rate *rates;
 	struct ath_tx_info_priv *tx_info_priv;
 	u32 max_4ms_framelen, frmlen;
-	u16 aggr_limit, legacy = 0, maxampdu;
+	u16 aggr_limit, legacy = 0;
 	int i;
 
 	skb = bf->bf_mpdu;
@@ -493,16 +493,15 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	if (tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE || legacy)
 		return 0;
 
-	aggr_limit = min(max_4ms_framelen, (u32)ATH_AMPDU_LIMIT_DEFAULT);
+	aggr_limit = min(max_4ms_framelen, (u32)ATH_AMPDU_LIMIT_MAX);
 
 	/*
 	 * h/w can accept aggregates upto 16 bit lengths (65535).
 	 * The IE, however can hold upto 65536, which shows up here
 	 * as zero. Ignore 65536 since we  are constrained by hw.
 	 */
-	maxampdu = tid->an->maxampdu;
-	if (maxampdu)
-		aggr_limit = min(aggr_limit, maxampdu);
+	if (tid->an->maxampdu)
+		aggr_limit = min(aggr_limit, tid->an->maxampdu);
 
 	return aggr_limit;
 }
@@ -510,7 +509,6 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 /*
  * Returns the number of delimiters to be added to
  * meet the minimum required mpdudensity.
- * caller should make sure that the rate is HT rate .
  */
 static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 				  struct ath_buf *bf, u16 frmlen)
@@ -518,7 +516,7 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	const struct ath_rate_table *rt = sc->cur_rate_table;
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	u32 nsymbits, nsymbols, mpdudensity;
+	u32 nsymbits, nsymbols;
 	u16 minlen;
 	u8 rc, flags, rix;
 	int width, half_gi, ndelim, mindelim;
@@ -540,14 +538,12 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	 * on highest rate in rate series (i.e. first rate) to determine
 	 * required minimum length for subframe. Take into account
 	 * whether high rate is 20 or 40Mhz and half or full GI.
-	 */
-	mpdudensity = tid->an->mpdudensity;
-
-	/*
+	 *
 	 * If there is no mpdu density restriction, no further calculation
 	 * is needed.
 	 */
-	if (mpdudensity == 0)
+
+	if (tid->an->mpdudensity == 0)
 		return ndelim;
 
 	rix = tx_info->control.rates[0].idx;
@@ -557,9 +553,9 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	half_gi = (flags & IEEE80211_TX_RC_SHORT_GI) ? 1 : 0;
 
 	if (half_gi)
-		nsymbols = NUM_SYMBOLS_PER_USEC_HALFGI(mpdudensity);
+		nsymbols = NUM_SYMBOLS_PER_USEC_HALFGI(tid->an->mpdudensity);
 	else
-		nsymbols = NUM_SYMBOLS_PER_USEC(mpdudensity);
+		nsymbols = NUM_SYMBOLS_PER_USEC(tid->an->mpdudensity);
 
 	if (nsymbols == 0)
 		nsymbols = 1;
-- 
1.6.3.3

