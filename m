Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:33729 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbcBAMYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:24:24 -0500
Received: by mail-wm0-f50.google.com with SMTP id l66so67671044wml.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:24:23 -0800 (PST)
From: Sven Eckelmann <sven@open-mesh.com>
To: linux-wireless@vger.kernel.org
Cc: thomas@net.t-labs.tu-berlin.de, antonio@open-mesh.com,
	nbd@nbd.name, johannes@sipsolutions.net,
	Sven Eckelmann <sven@open-mesh.com>
Subject: [PATCH] mac80211: minstrel: Scale expected_throughput by 10
Date: Mon,  1 Feb 2016 13:24:10 +0100
Message-Id: <1454329450-31527-1-git-send-email-sven@open-mesh.com> (sfid-20160201_132429_424750_8B5B02B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The change from cur_tp to the function
minstrel_get_tp_avg/minstrel_ht_get_tp_avg changed the unit used for the
current throughtput. For example in minstrel_ht the correct
conversion between them would be:

    mrs->cur_tp / 10 == minstrel_ht_get_tp_avg(..).

This factor 10 must also be included in the calculation of
minstrel_get_expected_throughput and minstrel_ht_get_expected_throughput to
get similar results as before the change.

Fixes: 6a27b2c40b48 ("mac80211: restructure per-rate throughput calculation into function")
Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
---
 net/mac80211/rc80211_minstrel.c    | 2 +-
 net/mac80211/rc80211_minstrel_ht.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 3ece7d1..b54f398 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -711,7 +711,7 @@ static u32 minstrel_get_expected_throughput(void *priv_sta)
 	 * computing cur_tp
 	 */
 	tmp_mrs = &mi->r[idx].stats;
-	tmp_cur_tp = minstrel_get_tp_avg(&mi->r[idx], tmp_mrs->prob_ewma);
+	tmp_cur_tp = minstrel_get_tp_avg(&mi->r[idx], tmp_mrs->prob_ewma) * 10;
 	tmp_cur_tp = tmp_cur_tp * 1200 * 8 / 1024;
 
 	return tmp_cur_tp;
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 3928dbd..8928151 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1334,7 +1334,8 @@ static u32 minstrel_ht_get_expected_throughput(void *priv_sta)
 	prob = mi->groups[i].rates[j].prob_ewma;
 
 	/* convert tp_avg from pkt per second in kbps */
-	tp_avg = minstrel_ht_get_tp_avg(mi, i, j, prob) * AVG_PKT_SIZE * 8 / 1024;
+	tp_avg = minstrel_ht_get_tp_avg(mi, i, j, prob) * 10;
+	tp_avg *= AVG_PKT_SIZE * 8 / 1024;
 
 	return tp_avg;
 }
