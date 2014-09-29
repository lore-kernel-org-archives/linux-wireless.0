Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:40581 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaI2AhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2014 20:37:08 -0400
Received: by mail-we0-f179.google.com with SMTP id u56so4160169wes.38
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2014 17:37:06 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Subject: [PATCH] mac80211: minstrel_ht: fix MCS_GROUP_RATES usage
Date: Mon, 29 Sep 2014 02:36:30 +0200
Message-Id: <1411950990-24365-1-git-send-email-karl.beldan@gmail.com> (sfid-20140929_023720_954101_B6FE5031)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Commit 4441e8e9 ("mac80211: improve minstrel_ht rate sorting by
throughput & probability") replaced the constant 8 with MCS_GROUP_RATES
when getting the number of streams of an HT MCS. See commit 7a5e3fa2
("mac80211: minstrel_ht: replace some occurences of MCS_GROUP_RATES").

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index df90ce2..17ef54a 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -135,7 +135,7 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi);
 static int
 minstrel_ht_get_group_idx(struct ieee80211_tx_rate *rate)
 {
-	return GROUP_IDX((rate->idx / MCS_GROUP_RATES) + 1,
+	return GROUP_IDX((rate->idx / 8) + 1,
 			 !!(rate->flags & IEEE80211_TX_RC_SHORT_GI),
 			 !!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH));
 }
-- 
2.0.1

