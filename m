Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49087 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab0IAU3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 16:29:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: only cancel software-based scans on suspend
Date: Wed,  1 Sep 2010 16:17:28 -0400
Message-Id: <1283372248-1043-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1283368226.4124.12.camel@jlt3.sipsolutions.net>
References: <1283368226.4124.12.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise the hardware scan handler could access an invalid scan request
structure.  The driver should cancel any pending hardware scans during
the suspend process anyway, so also add a warning if the hardware scan
is still pending when the device resumes.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_i.h |    6 ++++++
 net/mac80211/pm.c          |    3 ++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 16f7fb1..4e635e2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1186,6 +1186,12 @@ int __ieee80211_suspend(struct ieee80211_hw *hw);
 
 static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 {
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
+		"%s: resume with hardware scan still in progress\n",
+		wiphy_name(hw->wiphy));
+
 	return ieee80211_reconfig(hw_to_local(hw));
 }
 #else
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index d287fde..ce671df 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -12,7 +12,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
-	ieee80211_scan_cancel(local);
+	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)))
+		ieee80211_scan_cancel(local);
 
 	ieee80211_stop_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
-- 
1.7.2.2

