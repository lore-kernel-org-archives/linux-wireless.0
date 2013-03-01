Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:40851 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3CASlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 13:41:07 -0500
Received: by mail-ie0-f178.google.com with SMTP id c13so3852077ieb.23
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2013 10:41:06 -0800 (PST)
Date: Fri, 1 Mar 2013 13:41:05 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes.berg@intel.com, nbd@openwrt.org
Subject: Re: [PATCH 7/7] mac80211: improve minstrels rate sorting by means
 of throughput & probability
Message-ID: <20130301184105.GC16369@localhost> (sfid-20130301_194111_950908_FFF872A6)
References: <1362159456-39448-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <1362159456-39448-8-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362159456-39448-8-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 01, 2013 at 06:37:36PM +0100, Thomas Huehn wrote:
> +		//printk(KERN_ERR "before sort: max_tp_rate[0]= %i, [1]= %i, [2]= %i, [3]= %i,", mi->max_tp_rate[0], mi->max_tp_rate[1], mi->max_tp_rate[2], mi->max_tp_rate[3]);

Some leftover debugging there, and elsewhere.

I take it the changes to minstrel_update_stats fix the problem where
a rate might get used more than once?  A while ago I wrote the following
patch for that, but never found the time to test it.  It would be great
to know it's fixed.

From: Bob Copeland <me@bobcopeland.com>
Date: Fri, 18 May 2012 22:57:49 -0400
Subject: [PATCH] minstrel: avoid reusing max tp/max prob rates if they are the same

Some testing I did a while ago with mac80211_hwsim showed that
the MRR chain would frequently have the same rate included more
than once because it would be both the "max throughput" rate and
the "max success probability" rate.

If we truly cannot deliver packets with that rate due to changes
in radio conditions, we can waste a lot of airtime with unsuccessful
retransmissions.  So, compute both of the max throughput rates up
front, and then pick the max prob. rate from the leftovers.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/rc80211_minstrel.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 79633ae..36255f1 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -73,7 +73,7 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
 static void
 minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 {
-	u32 max_tp = 0, index_max_tp = 0, index_max_tp2 = 0;
+	u32 max_tp = 0, index_max_tp = 0, max_tp2 = 0, index_max_tp2 = 0;
 	u32 max_prob = 0, index_max_prob = 0;
 	u32 usecs;
 	u32 p;
@@ -123,25 +123,26 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
 		if (max_tp < mr->cur_tp) {
+			max_tp2 = max_tp;
+			index_max_tp2 = index_max_tp;
 			index_max_tp = i;
 			max_tp = mr->cur_tp;
-		}
-		if (max_prob < mr->probability) {
-			index_max_prob = i;
-			max_prob = mr->probability;
+		} else if (max_tp2 < mr->cur_tp) {
+			index_max_tp2 = i;
+			max_tp2 = mr->cur_tp;
 		}
 	}
 
-	max_tp = 0;
+	max_prob = 0;
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
 
-		if (i == index_max_tp)
+		if (i == index_max_tp || i == index_max_tp2)
 			continue;
 
-		if (max_tp < mr->cur_tp) {
-			index_max_tp2 = i;
-			max_tp = mr->cur_tp;
+		if (max_prob < mr->probability) {
+			index_max_prob = i;
+			max_prob = mr->probability;
 		}
 	}
 	mi->max_tp_rate = index_max_tp;
-- 
1.7.2.5

-- 
Bob Copeland %% www.bobcopeland.com
