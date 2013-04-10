Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:35963 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761650Ab3DJWnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 18:43:14 -0400
Received: by mail-da0-f48.google.com with SMTP id p8so399803dan.35
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 15:43:14 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: fix ieee80211_queue_stopped()
Date: Wed, 10 Apr 2013 15:41:40 -0700
Message-Id: <1365633700-16509-1-git-send-email-thomas@cozybit.com> (sfid-20130411_004318_709703_95577EF5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg notes mac80211 drivers which use
ieee80211_queue_stopped() really only want to know if they
previously requested a queue stop.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/util.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 447e665..53e9d8a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -485,7 +485,8 @@ int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
 		return true;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	ret = !!local->queue_stop_reasons[queue];
+	ret = !!(local->queue_stop_reasons[queue] &
+		 IEEE80211_QUEUE_STOP_REASON_DRIVER);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 	return ret;
 }
-- 
1.7.10.4

