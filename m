Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYJ1SgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:36:12 -0400
Subject: [PATCH] wireless: fix a few sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 16:49:41 +0100
Message-Id: <1225208981.3598.10.camel@johannes.berg> (sfid-20081028_193616_533909_49FF65A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rc80211_minstrel.c |    2 +-
 net/mac80211/tx.c               |    1 -
 net/wireless/reg.c              |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

--- everything.orig/net/mac80211/rc80211_minstrel.c	2008-10-28 16:42:59.000000000 +0100
+++ everything/net/mac80211/rc80211_minstrel.c	2008-10-28 16:43:08.000000000 +0100
@@ -225,7 +225,7 @@ minstrel_get_next_sample(struct minstrel
 	return sample_ndx;
 }
 
-void
+static void
 minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 		  void *priv_sta, struct ieee80211_tx_rate_control *txrc)
 {
--- everything.orig/net/mac80211/tx.c	2008-10-28 16:43:18.000000000 +0100
+++ everything/net/mac80211/tx.c	2008-10-28 16:43:44.000000000 +0100
@@ -700,7 +700,6 @@ ieee80211_tx_h_fragment(struct ieee80211
 	left = payload_len - per_fragm;
 	for (i = 0; i < num_fragm - 1; i++) {
 		struct ieee80211_hdr *fhdr;
-		struct ieee80211_tx_info *info;
 		size_t copylen;
 
 		if (left <= 0)
--- everything.orig/net/wireless/reg.c	2008-10-28 16:45:29.000000000 +0100
+++ everything/net/wireless/reg.c	2008-10-28 16:45:33.000000000 +0100
@@ -638,7 +638,7 @@ static void print_regdomain(const struct
 	print_rd_rules(rd);
 }
 
-void print_regdomain_info(const struct ieee80211_regdomain *rd)
+static void print_regdomain_info(const struct ieee80211_regdomain *rd)
 {
 	printk(KERN_INFO "cfg80211: Regulatory domain: %c%c\n",
 		rd->alpha2[0], rd->alpha2[1]);


