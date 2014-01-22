Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40330 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbaAVKfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:35:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/7] mac80211: minstrel_ht: sample_table can be __read_mostly
Date: Wed, 22 Jan 2014 11:34:57 +0100
Message-Id: <1390386898-14316-7-git-send-email-johannes@sipsolutions.net> (sfid-20140122_113515_184509_D1F6D6C7)
In-Reply-To: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
References: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The sample table is initialized only once at module start, so
is really __read_mostly. Additionally, the code to init it can
be marked __init since it will never be needed again, it is
likely automatically inlined into the __init function already
by the compiler, so this doesn't really make a difference.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index a6d6cc5..bccaf85 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -124,7 +124,7 @@ const struct mcs_group minstrel_mcs_groups[] = {
 
 #define MINSTREL_CCK_GROUP	(ARRAY_SIZE(minstrel_mcs_groups) - 1)
 
-static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES];
+static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES] __read_mostly;
 
 static void
 minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi);
@@ -1048,8 +1048,7 @@ static const struct rate_control_ops mac80211_minstrel_ht = {
 };
 
 
-static void
-init_sample_table(void)
+static void __init init_sample_table(void)
 {
 	int col, i, new_idx;
 	u8 rnd[MCS_GROUP_RATES];
-- 
1.8.5.1

