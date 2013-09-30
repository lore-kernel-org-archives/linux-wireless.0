Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:55461 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900Ab3I3JgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 05:36:13 -0400
Date: Mon, 30 Sep 2013 12:36:05 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Run deferred scan if last roc_list item is not
 started
Message-ID: <20130930093605.GA23614@w1.fi> (sfid-20130930_113616_627099_8F3FCAD4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 scan processing could get stuck if roc work for pending, but
not started when a scan request was deferred due to such roc item.
Normally the deferred scan would be started from
ieee80211_start_next_roc(), but ieee80211_sw_roc_work() calls that only
if the finished ROC was started. Fix this by calling
ieee80211_run_deferred_scan() in the case the last ROC was not actually
started.

This issue was hit relatively easily in P2P find operations where Listen
state (remain-on-channel) and Search state (scan) are repeated in a
loop.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 net/mac80211/offchannel.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index acd1f71..0c2a294 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -394,6 +394,8 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 
 		if (started)
 			ieee80211_start_next_roc(local);
+		else if (list_empty(&local->roc_list))
+			ieee80211_run_deferred_scan(local);
 	}
 
  out_unlock:
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
