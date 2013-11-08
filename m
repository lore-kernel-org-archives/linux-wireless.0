Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:49186 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511Ab3KHQe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 11:34:58 -0500
Received: by mail-wg0-f52.google.com with SMTP id z12so1100232wgg.7
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 08:34:56 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH 1/2] mac80211: minstrels: spare numerous useless calls to get_random_bytes
Date: Fri,  8 Nov 2013 17:34:32 +0100
Message-Id: <1383928473-798-1-git-send-email-karl.beldan@gmail.com> (sfid-20131108_173500_775416_DEBC22D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

These are called to init the sample tables.
This occurs once in minstrel_ht upon its registration (since it uses one
single common sample table for all STAs), and once per sta addition in
minstrel.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel.c    | 3 +--
 net/mac80211/rc80211_minstrel_ht.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 7fa1b36..a40e4e3 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -422,10 +422,9 @@ init_sample_table(struct minstrel_sta_info *mi)
 	memset(mi->sample_table, 0xff, SAMPLE_COLUMNS * mi->n_rates);
 
 	for (col = 0; col < SAMPLE_COLUMNS; col++) {
+		get_random_bytes(rnd, sizeof(rnd));
 		for (i = 0; i < mi->n_rates; i++) {
-			get_random_bytes(rnd, sizeof(rnd));
 			new_idx = (i + rnd[i & 7]) % mi->n_rates;
-
 			while (SAMPLE_TBL(mi, new_idx, col) != 0xff)
 				new_idx = (new_idx + 1) % mi->n_rates;
 
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 5d60779..aeec401 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1052,10 +1052,9 @@ init_sample_table(void)
 
 	memset(sample_table, 0xff, sizeof(sample_table));
 	for (col = 0; col < SAMPLE_COLUMNS; col++) {
+		get_random_bytes(rnd, sizeof(rnd));
 		for (i = 0; i < MCS_GROUP_RATES; i++) {
-			get_random_bytes(rnd, sizeof(rnd));
 			new_idx = (i + rnd[i]) % MCS_GROUP_RATES;
-
 			while (sample_table[col][new_idx] != 0xff)
 				new_idx = (new_idx + 1) % MCS_GROUP_RATES;
 
-- 
1.8.2

