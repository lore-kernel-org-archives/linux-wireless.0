Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55071 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0HaT3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 15:29:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: cancel scan in ieee80211_restart_hw if software scan pending
Date: Tue, 31 Aug 2010 15:25:37 -0400
Message-Id: <1283282737-27749-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1283246981.3733.7.camel@jlt3.sipsolutions.net>
References: <1283246981.3733.7.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function exists to clean-up after a hardware error or something
similar.  The restart is accomplished using the same infrastructure used
to resume after a suspend.  The suspend path cancels running scans, so
it seems appropriate to do that here as well for software-based scans.
If a hardware-based scan is pending, issue a warning message since this
indicates that the drivers has failed to clean-up after itself.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/main.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 93194f6..a06b6ee 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -305,7 +305,13 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
 
 	trace_api_restart_hw(local);
 
-	/* use this reason, __ieee80211_resume will unblock it */
+	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
+		"%s called with hardware scan in progress\n", __func__);
+
+	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)))
+		ieee80211_scan_cancel(local);
+
+	/* use this reason, ieee80211_reconfig will unblock it */
 	ieee80211_stop_queues_by_reason(hw,
 		IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
-- 
1.7.2.2

