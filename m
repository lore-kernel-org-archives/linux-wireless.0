Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52289 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934716Ab3BTUqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 15:46:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: eric.dumazet@gmail.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: clarify alignment comment
Date: Wed, 20 Feb 2013 21:46:42 +0100
Message-Id: <1361393202-10281-1-git-send-email-johannes@sipsolutions.net> (sfid-20130220_214701_592057_04D1B4D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The comment says something about __skb_push(), but that
isn't even called in the code any more. Looking at the
git history, that comment never even made sense when it
was still called, so just replace that part to note it
still works even when align isn't 0 or 2.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bb73ed2d..acf006f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1894,8 +1894,10 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 		 * 'align' will only take the values 0 or 2 here
 		 * since all frames are required to be aligned
 		 * to 2-byte boundaries when being passed to
-		 * mac80211. That also explains the __skb_push()
-		 * below.
+		 * mac80211; the code here works just as well if
+		 * that isn't true, but mac80211 assumes it can
+		 * access fields as 2-byte aligned (e.g. for
+		 * compare_ether_addr)
 		 */
 		align = ((unsigned long)(skb->data + sizeof(struct ethhdr))) & 3;
 		if (align) {
-- 
1.8.0

