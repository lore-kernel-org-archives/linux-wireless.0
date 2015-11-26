Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36347 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbbKZK5y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 05:57:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/8] mac80211: fix mgmt-tx abort cookie and leak
Date: Thu, 26 Nov 2015 11:57:44 +0100
Message-Id: <1448535468-12237-4-git-send-email-johannes@sipsolutions.net> (sfid-20151126_115830_768708_3A4CF362)
In-Reply-To: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
References: <1448535468-12237-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a mgmt-tx operation is aborted before it runs, the wrong
cookie is reported back to userspace, and the ack_skb gets
leaked since the frame is freed directly instead of freeing
it using ieee80211_free_txskb(). Fix that.

Fixes: 3b79af973cf4 ("mac80211: stop using pointers as userspace cookies")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/offchannel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 04401037140e..0fe9f746cd7e 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -308,11 +308,10 @@ void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free)
 
 	/* was never transmitted */
 	if (roc->frame) {
-		cfg80211_mgmt_tx_status(&roc->sdata->wdev,
-					(unsigned long)roc->frame,
+		cfg80211_mgmt_tx_status(&roc->sdata->wdev, roc->mgmt_tx_cookie,
 					roc->frame->data, roc->frame->len,
 					false, GFP_KERNEL);
-		kfree_skb(roc->frame);
+		ieee80211_free_txskb(&roc->sdata->local->hw, roc->frame);
 	}
 
 	if (!roc->mgmt_tx_cookie)
-- 
2.6.2

