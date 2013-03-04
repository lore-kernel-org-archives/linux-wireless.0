Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40852 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932169Ab3CDWaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 17:30:12 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v4 5/7] mac80211: add lowest rate into minstrel's random rate sampling table
Date: Mon,  4 Mar 2013 23:30:05 +0100
Message-Id: <1362436208-75786-6-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130304_233022_386756_72478A2E)
In-Reply-To: <1362436208-75786-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1362436208-75786-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While minstrel bootstraps and fills the success probabilities of each
rate the lowest rate has typically a very high success probability
(often 100% in our tests).
Its statistics are never updated but considered to setup the mrr chain.
In our tests we see that especially the 3rd mrr stage (which is that
rate providing highest success probability) is filled with the lowest rate
because its initial high sucess probability is never updated. By design
the 4th mrr stage is filled with the lowest rate so often 3rd and 4th
mrr stage are equal.

This patch follows minstrels general approach of assuming as little
as possible about rate dependencies. Consequently we include the
lowest rate into the random sampling table to get balanced up-to-date
statistics of all rates and therefore balanced decisions.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c    | 20 +++++++-------------
 net/mac80211/rc80211_minstrel.h    |  4 +++-
 net/mac80211/rc80211_minstrel_ht.c |  1 -
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index aa59f29..5c0f532 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -55,7 +55,6 @@
 #include "rate.h"
 #include "rc80211_minstrel.h"
 
-#define SAMPLE_COLUMNS	10
 #define SAMPLE_TBL(_mi, _idx, _col) \
 		_mi->sample_table[(_idx * SAMPLE_COLUMNS) + _col]
 
@@ -210,7 +209,7 @@ minstrel_get_next_sample(struct minstrel_sta_info *mi)
 	unsigned int sample_ndx;
 	sample_ndx = SAMPLE_TBL(mi, mi->sample_row, mi->sample_column);
 	mi->sample_row++;
-	if ((int) mi->sample_row > (mi->n_rates - 2)) {
+	if ((int) mi->sample_row >= mi->n_rates) {
 		mi->sample_row = 0;
 		mi->sample_column++;
 		if (mi->sample_column >= SAMPLE_COLUMNS)
@@ -370,26 +369,21 @@ static void
 init_sample_table(struct minstrel_sta_info *mi)
 {
 	unsigned int i, col, new_idx;
-	unsigned int n_srates = mi->n_rates - 1;
 	u8 rnd[8];
 
 	mi->sample_column = 0;
 	mi->sample_row = 0;
-	memset(mi->sample_table, 0, SAMPLE_COLUMNS * mi->n_rates);
+	memset(mi->sample_table, 0xff, SAMPLE_COLUMNS * mi->n_rates);
 
 	for (col = 0; col < SAMPLE_COLUMNS; col++) {
-		for (i = 0; i < n_srates; i++) {
+		for (i = 0; i < mi->n_rates; i++) {
 			get_random_bytes(rnd, sizeof(rnd));
-			new_idx = (i + rnd[i & 7]) % n_srates;
+			new_idx = (i + rnd[i & 7]) % mi->n_rates;
 
-			while (SAMPLE_TBL(mi, new_idx, col) != 0)
-				new_idx = (new_idx + 1) % n_srates;
+			while (SAMPLE_TBL(mi, new_idx, col) != 0xff)
+				new_idx = (new_idx + 1) % mi->n_rates;
 
-			/* Don't sample the slowest rate (i.e. slowest base
-			 * rate). We must presume that the slowest rate works
-			 * fine, or else other management frames will also be
-			 * failing and the link will break */
-			SAMPLE_TBL(mi, new_idx, col) = i + 1;
+			SAMPLE_TBL(mi, new_idx, col) = i;
 		}
 	}
 }
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 200b7e3..a0ccc57 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -9,7 +9,9 @@
 #ifndef __RC_MINSTREL_H
 #define __RC_MINSTREL_H
 
-#define EWMA_LEVEL 75	/* ewma weighting factor [%] */
+#define EWMA_LEVEL	75	/* ewma weighting factor [%] */
+#define SAMPLE_COLUMNS	10	/* number of columns in sample table */
+
 
 /* scaled fraction values */
 #define MINSTREL_SCALE  16
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index a3081e5..8f88108 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -17,7 +17,6 @@
 #include "rc80211_minstrel_ht.h"
 
 #define AVG_PKT_SIZE	1200
-#define SAMPLE_COLUMNS	10
 
 /* Number of bits for an average sized packet */
 #define MCS_NBITS (AVG_PKT_SIZE << 3)
-- 
1.8.1.1

