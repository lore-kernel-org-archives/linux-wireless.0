Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41974 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab0FXPaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 11:30:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] minstrel_ht: make *idx unsigned in minstrel_downgrade_rate
Date: Thu, 24 Jun 2010 11:19:57 -0400
Message-Id: <1277392797-11260-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/mac80211/rc80211_minstrel_ht.c:440:46: warning: incorrect type in argument 2 (different signedness)
net/mac80211/rc80211_minstrel_ht.c:440:46:    expected int *idx
net/mac80211/rc80211_minstrel_ht.c:440:46:    got unsigned int *<noident>
net/mac80211/rc80211_minstrel_ht.c:446:46: warning: incorrect type in argument 2 (different signedness)
net/mac80211/rc80211_minstrel_ht.c:446:46:    expected int *idx
net/mac80211/rc80211_minstrel_ht.c:446:46:    got unsigned int *<noident>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index a8f658c..ae91ad9 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -328,7 +328,8 @@ minstrel_next_sample_idx(struct minstrel_ht_sta *mi)
 }
 
 static void
-minstrel_downgrade_rate(struct minstrel_ht_sta *mi, int *idx, bool primary)
+minstrel_downgrade_rate(struct minstrel_ht_sta *mi, unsigned int *idx,
+			bool primary)
 {
 	int group, orig_group;
 
-- 
1.7.0.1

