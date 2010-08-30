Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60834 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab0H3TOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:14:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: cancel scan in ieee80211_restart_hw
Date: Mon, 30 Aug 2010 15:14:31 -0400
Message-Id: <1283195671-4086-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function exists to clean-up after a hardware error or something
similar.  The restart is accomplished using the same infrastructure used
to resume after a suspend.  The suspend path cancels running scans, so
it seems appropriate to do that here as well.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 93194f6..8b43d85 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -305,7 +305,9 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
 
 	trace_api_restart_hw(local);
 
-	/* use this reason, __ieee80211_resume will unblock it */
+	ieee80211_scan_cancel(local);
+
+	/* use this reason, ieee80211_reconfig will unblock it */
 	ieee80211_stop_queues_by_reason(hw,
 		IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
-- 
1.7.2.2

