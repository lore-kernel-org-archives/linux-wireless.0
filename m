Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41816 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1LPGRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 01:17:24 -0500
Received: by iaeh11 with SMTP id h11so3882277iae.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 22:17:24 -0800 (PST)
Date: Fri, 16 Dec 2011 11:47:15 +0530
From: Yogesh Ashok Powar <yogesh.powar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH V2] mac80211: Fixing sparse warning at sta_info.c
Message-ID: <20111216061715.GA11190@dugs> (sfid-20111216_071728_284744_4D683D46)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <82612>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit 42624d4913a00219a8fdbb4bafd634d1d843be85
created following sparse warning
>net/mac80211/sta_info.c:965:24: warning: incorrect type in assignment (different address spaces)
>net/mac80211/sta_info.c:965:24:    expected struct tid_ampdu_tx *tid_tx
>net/mac80211/sta_info.c:965:24:    got struct tid_ampdu_tx [noderef] <asn:4>*<noident>

Making use of rcu_dereference_protected to fix the problem.

V2:
 - Replacing rcu_dereference with rcu_dereference_protected
   as suggested by Johannes.
 - Adding mutex_lock/unlock to satisfy the condition at
   rcu_dereference_protected

Cc: Nishant Sarmukadam <nishants@marvell.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 net/mac80211/sta_info.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c6ca9bd..e4307b7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -959,10 +959,13 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
 	 * until the aggregation stop completes. Refer
 	 * http://thread.gmane.org/gmane.linux.kernel.wireless.general/81936
 	 */
+
+	mutex_lock(&sta->ampdu_mlme.mtx);
+
 	for (i = 0; i < STA_TID_NUM; i++) {
-		if (!sta->ampdu_mlme.tid_tx[i])
+		tid_tx = rcu_dereference_protected_tid_tx(sta, i);
+		if (!tid_tx)
 			continue;
-		tid_tx = sta->ampdu_mlme.tid_tx[i];
 		if (skb_queue_len(&tid_tx->pending)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 			wiphy_debug(local->hw.wiphy, "TX A-MPDU  purging %d "
@@ -974,6 +977,8 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
 		kfree_rcu(tid_tx, rcu_head);
 	}
 
+	mutex_unlock(&sta->ampdu_mlme.mtx);
+
 	__sta_info_free(local, sta);
 
 	return 0;
-- 
1.7.5.4

