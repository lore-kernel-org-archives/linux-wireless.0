Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:38201 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaJVQVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 12:21:54 -0400
Received: by mail-wg0-f41.google.com with SMTP id b13so4190095wgh.12
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 09:21:52 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mac80211: minstrel_ht: use group flags instead of index to display rates
Date: Wed, 22 Oct 2014 18:20:37 +0200
Message-Id: <1413994837-3944-1-git-send-email-karl.beldan@gmail.com> (sfid-20141022_182158_297567_B1AC37B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

When displaying a rate through debugfs minstrel_ht guesses its flags
comparing group indexes.  Since 3ec373c421b6 ("mac80211: minstrel_ht:
include type (cck/ht) in rates flag"), the rate flags of interest are
present in the mcs_group-s, so use it.
While improving the code, this also fixes a smatch false positive
"error: testing array offset 'i' after use" in minstrel_ht_stats_dump.
This warning only triggers after 9208247d74bc ("mac80211: minstrel_ht:
add basic support for VHT rates <= 3SS@80MHz") with
CONFIG_MAC80211_RC_MINSTREL_VHT unset because then MINSTREL_VHT_GROUP_0
is above MINSTREL_GROUPS_NB and smatch only barks when the "testing
array offset" seems to prevent possible out of bonds accesses (which
does not happen here since i < ARRAY_SIZE(mi->groups)).

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 52bb6ef..20c676b 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -22,16 +22,19 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 	unsigned int j, tp, prob, eprob;
 	char htmode = '2';
 	char gimode = 'L';
+	u32 gflags;
 
 	if (!mi->groups[i].supported)
 		return p;
 
 	mg = &minstrel_mcs_groups[i];
-	if (mg->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+	gflags = mg->flags;
+
+	if (gflags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 		htmode = '4';
-	else if (mg->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+	else if (gflags & IEEE80211_TX_RC_80_MHZ_WIDTH)
 		htmode = '8';
-	if (mg->flags & IEEE80211_TX_RC_SHORT_GI)
+	if (gflags & IEEE80211_TX_RC_SHORT_GI)
 		gimode = 'S';
 
 	for (j = 0; j < MCS_GROUP_RATES; j++) {
@@ -42,12 +45,12 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		if (!(mi->groups[i].supported & BIT(j)))
 			continue;
 
-		if (i == MINSTREL_CCK_GROUP)
-			p += sprintf(p, " CCK/%cP   ", j < 4 ? 'L' : 'S');
-		else if (i >= MINSTREL_VHT_GROUP_0)
+		if (gflags & IEEE80211_TX_RC_MCS)
+			p += sprintf(p, " HT%c0/%cGI ", htmode, gimode);
+		else if (gflags & IEEE80211_TX_RC_VHT_MCS)
 			p += sprintf(p, "VHT%c0/%cGI ", htmode, gimode);
 		else
-			p += sprintf(p, " HT%c0/%cGI ", htmode, gimode);
+			p += sprintf(p, " CCK/%cP   ", j < 4 ? 'L' : 'S');
 
 		*(p++) = (idx == mi->max_tp_rate[0]) ? 'A' : ' ';
 		*(p++) = (idx == mi->max_tp_rate[1]) ? 'B' : ' ';
@@ -55,13 +58,14 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		*(p++) = (idx == mi->max_tp_rate[3]) ? 'D' : ' ';
 		*(p++) = (idx == mi->max_prob_rate) ? 'P' : ' ';
 
-		if (i == MINSTREL_CCK_GROUP) {
-			int r = bitrates[j % 4];
-			p += sprintf(p, " %2u.%1uM ", r / 10, r % 10);
-		} else if (i >= MINSTREL_VHT_GROUP_0) {
+		if (gflags & IEEE80211_TX_RC_MCS) {
+			p += sprintf(p, " MCS%-2u ", (mg->streams - 1) * 8 + j);
+		} else if (gflags & IEEE80211_TX_RC_VHT_MCS) {
 			p += sprintf(p, " MCS%-1u/%1u", j, mg->streams);
 		} else {
-			p += sprintf(p, " MCS%-2u ", (mg->streams - 1) * 8 + j);
+			int r = bitrates[j % 4];
+
+			p += sprintf(p, " %2u.%1uM ", r / 10, r % 10);
 		}
 
 		tp = mr->cur_tp / 10;
-- 
2.0.1

