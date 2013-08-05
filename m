Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36202 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab3HET4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 15:56:31 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 05/12] ath9k: simplify ath_tx_form_aggr
Date: Mon,  5 Aug 2013 21:56:16 +0200
Message-Id: <1375732583-39001-5-git-send-email-nbd@openwrt.org> (sfid-20130805_215635_638035_53BE617C)
In-Reply-To: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check for ATH_AMPDU_SUBFRAME_DEFAULT is unnecessary, since it's set
to half the maximum BlockAck Window size, which is already the maximum
value that h_baw could possibly have. Also remove unnecessary variables.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 -
 drivers/net/wireless/ath/ath9k/xmit.c  | 33 ++++++++++++---------------------
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 919c8ee..88ef785 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -137,7 +137,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_AGGR_ENCRYPTDELIM      10
 /* minimum h/w qdepth to be sustained to maximize aggregation */
 #define ATH_AGGR_MIN_QDEPTH        2
-#define ATH_AMPDU_SUBFRAME_DEFAULT 32
 
 #define IEEE80211_SEQ_SEQ_SHIFT    4
 #define IEEE80211_SEQ_MAX          4096
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e54c3e5..8ce2d36 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -906,9 +906,9 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 {
 #define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
 	struct ath_buf *bf, *bf_first = NULL, *bf_prev = NULL;
-	int rl = 0, nframes = 0, ndelim, prev_al = 0;
+	int nframes = 0, ndelim;
 	u16 aggr_limit = 0, al = 0, bpad = 0,
-		al_delta, h_baw = tid->baw_size / 2;
+	    al_delta, h_baw = tid->baw_size / 2;
 	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
 	struct ieee80211_tx_info *tx_info;
 	struct ath_frame_info *fi;
@@ -925,33 +925,24 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		skb = bf->bf_mpdu;
 		fi = get_frame_info(skb);
 
-		if (!bf_first)
+		if (!bf_first) {
 			bf_first = bf;
-
-		if (!rl) {
 			ath_set_rates(tid->an->vif, tid->an->sta, bf);
 			aggr_limit = ath_lookup_rate(sc, bf, tid);
-			rl = 1;
 		}
 
 		/* do not exceed aggregation limit */
 		al_delta = ATH_AGGR_DELIM_SZ + fi->framelen;
+		if (nframes) {
+			if (aggr_limit < al + bpad + al_delta ||
+			    ath_lookup_legacy(bf) || nframes >= h_baw) {
+				status = ATH_AGGR_LIMITED;
+				break;
+			}
 
-		if (nframes &&
-		    ((aggr_limit < (al + bpad + al_delta + prev_al)) ||
-		     ath_lookup_legacy(bf))) {
-			status = ATH_AGGR_LIMITED;
-			break;
-		}
-
-		tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
-		if (nframes && (tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE))
-			break;
-
-		/* do not exceed subframe limit */
-		if (nframes >= min((int)h_baw, ATH_AMPDU_SUBFRAME_DEFAULT)) {
-			status = ATH_AGGR_LIMITED;
-			break;
+			tx_info = IEEE80211_SKB_CB(bf->bf_mpdu);
+			if (tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
+				break;
 		}
 
 		/* add padding for previous frame to aggregation length */
-- 
1.8.0.2

