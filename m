Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56305 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3KKMMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 07:12:12 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so2098519wgh.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 04:12:11 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH v2] mac80211: minstrel_ht: do not sample unsupported rates
Date: Mon, 11 Nov 2013 13:10:49 +0100
Message-Id: <1384171849-21058-1-git-send-email-karl.beldan@gmail.com> (sfid-20131111_131216_028051_72BE1243)
In-Reply-To: <527D14B7.3090204@openwrt.org>
References: <527D14B7.3090204@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

ATM minstrel_ht does not check whether a sampling rate is supported.
Unsupported rates attempts can trigger when there are holes in bitfields
of supported MCSes belonging to the same group (e.g many devices are
MCS32 capable without MCS33->39 capable, also we systematically have a
hole for CCK rates).
I originally replaced an unsupported sample index with the fls of the
bitfield of supported indexes of the sta current sample group, instead,
this change simply drops the sample attempt, as suggested by Felix.

This is not a problem in minstrel which fills a per STA sample table
with only supported rates (though only at init).

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index aeec401..1076bca 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -701,12 +701,16 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	if (!mi->sample_tries)
 		return -1;
 
-	mg = &mi->groups[mi->sample_group];
+	sample_group = mi->sample_group;
+	mg = &mi->groups[sample_group];
 	sample_idx = sample_table[mg->column][mg->index];
+	minstrel_next_sample_idx(mi);
+
+	if (!(mg->supported & BIT(sample_idx)))
+		return -1;
+
 	mr = &mg->rates[sample_idx];
-	sample_group = mi->sample_group;
 	sample_idx += sample_group * MCS_GROUP_RATES;
-	minstrel_next_sample_idx(mi);
 
 	/*
 	 * Sampling might add some overhead (RTS, no aggregation)
-- 
1.8.2

