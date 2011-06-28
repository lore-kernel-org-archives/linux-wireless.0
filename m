Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44449 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904Ab1F1MAu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 08:00:50 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 05:00:13 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 1/2] ath9k: minor cleanup in tx_form_aggregation
Date: Tue, 28 Jun 2011 17:30:42 +0530
Message-ID: <1309262442-21383-1-git-send-email-mshajakhan@atheros.com> (sfid-20110628_141458_395029_95647F24)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

moves a macro to the main header file ath9k.h and removes a redundant
variable/if check

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 ++
 drivers/net/wireless/ath/ath9k/xmit.c  |    9 ++-------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 56a0ac4..ac9ec3c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -129,6 +129,8 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 	 (((_tid) == 4) || ((_tid) == 5)) ? WME_AC_VI :	\
 	 WME_AC_VO)
 
+#define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
+
 #define ATH_AGGR_DELIM_SZ          4
 #define ATH_AGGR_MINPLEN           256 /* in bytes, minimum packet length */
 /* number of delimiters for encryption padding */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a1fed6c..18f02c0 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -708,9 +708,8 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 					     struct list_head *bf_q,
 					     int *aggr_len)
 {
-#define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
 	struct ath_buf *bf, *bf_first, *bf_prev = NULL;
-	int rl = 0, nframes = 0, ndelim, prev_al = 0;
+	int nframes = 0, ndelim, prev_al = 0;
 	u16 aggr_limit = 0, al = 0, bpad = 0,
 		al_delta, h_baw = tid->baw_size / 2;
 	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
@@ -729,10 +728,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 			break;
 		}
 
-		if (!rl) {
-			aggr_limit = ath_lookup_rate(sc, bf, tid);
-			rl = 1;
-		}
+		aggr_limit = ath_lookup_rate(sc, bf, tid);
 
 		/* do not exceed aggregation limit */
 		al_delta = ATH_AGGR_DELIM_SZ + fi->framelen;
@@ -785,7 +781,6 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 	*aggr_len = al;
 
 	return status;
-#undef PADBYTES
 }
 
 static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
-- 
1.7.0.4

