Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38328 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695AbZEETbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 15:31:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Karol Szuster <qflon@o2.pl>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: avoid NULL ptr deref when finding max_rates in PID and minstrel
Date: Tue,  5 May 2009 15:18:26 -0400
Message-Id: <1241551106-16938-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <4A0088EE.7010804@o2.pl>
References: <4A0088EE.7010804@o2.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"There is another problem with this piece of code. The sband will be NULL
after second iteration on single band device and cause null pointer
dereference. Everything is working with dual band card. Sorry, but i
don't know how to explain this clearly in English. I have looked on the
second patch for pid algorithm and found similar bug."

Reported-by: Karol Szuster <qflon@o2.pl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/rc80211_minstrel.c |    2 +-
 net/mac80211/rc80211_pid_algo.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 70df3dc..d9233ec 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -477,7 +477,7 @@ minstrel_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		sband = hw->wiphy->bands[i];
-		if (sband->n_bitrates > max_rates)
+		if (sband && sband->n_bitrates > max_rates)
 			max_rates = sband->n_bitrates;
 	}
 
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index 01d59a8..8bef9a1 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -378,7 +378,7 @@ static void *rate_control_pid_alloc(struct ieee80211_hw *hw,
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		sband = hw->wiphy->bands[i];
-		if (sband->n_bitrates > max_rates)
+		if (sband && sband->n_bitrates > max_rates)
 			max_rates = sband->n_bitrates;
 	}
 
-- 
1.6.0.6

