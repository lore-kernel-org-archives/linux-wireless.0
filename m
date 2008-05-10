Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbYEJWWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 18:22:14 -0400
Received: from [91.5.117.77] (helo=[10.0.0.127])
	by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1JuxSH-0000zO-83
	for linux-wireless@vger.kernel.org; Sun, 11 May 2008 00:22:13 +0200
Message-Id: <20080510221906.961300000@sipsolutions.net> (sfid-20080511_002252_858584_C9D2BAA8)
References: <20080510221845.340428000@sipsolutions.net>
Date: Sun, 11 May 2008 00:18:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFT/C 3/7] mac80211: fix bugs in queue handling functions
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 55c308c1315bc7267dbb88011c208fd743cdce31
("mac80211: QoS related cleanups") introduced another bug,
the queue handling functions that operate on all queues now
only operated on the first queues, not the A-MPDU queues as
expected. This patch fixes this.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/util.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- everything.orig/net/mac80211/util.c	2008-05-10 19:19:36.000000000 +0200
+++ everything/net/mac80211/util.c	2008-05-10 19:20:46.000000000 +0200
@@ -355,7 +355,7 @@ void ieee80211_start_queues(struct ieee8
 	struct ieee80211_local *local = hw_to_local(hw);
 	int i;
 
-	for (i = 0; i < local->hw.queues; i++)
+	for (i = 0; i < hw->queues + hw->ampdu_queues; i++)
 		clear_bit(IEEE80211_LINK_STATE_XOFF, &local->state[i]);
 	if (!ieee80211_qdisc_installed(local->mdev))
 		netif_start_queue(local->mdev);
@@ -366,7 +366,7 @@ void ieee80211_stop_queues(struct ieee80
 {
 	int i;
 
-	for (i = 0; i < hw->queues; i++)
+	for (i = 0; i < hw->queues + hw->ampdu_queues; i++)
 		ieee80211_stop_queue(hw, i);
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
@@ -375,7 +375,7 @@ void ieee80211_wake_queues(struct ieee80
 {
 	int i;
 
-	for (i = 0; i < hw->queues; i++)
+	for (i = 0; i < hw->queues + hw->ampdu_queues; i++)
 		ieee80211_wake_queue(hw, i);
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);

-- 

