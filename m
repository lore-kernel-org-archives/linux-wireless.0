Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50775 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbaGXKj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 06:39:27 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so2523931wgh.30
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 03:39:26 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCHv2 2/2] mac80211: extend set_coverage_class signature
Date: Thu, 24 Jul 2014 12:39:22 +0200
Message-Id: <1406198362-4999-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140724_123932_122824_A5F38F5A)
In-Reply-To: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend set_coverage_class API in order to enable ACK timeout estimation
algorithm (dynack).

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 include/net/mac80211.h    | 5 +++--
 net/mac80211/driver-ops.h | 9 +++------
 net/mac80211/trace.h      | 4 ++--
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dae2e24..30fd354 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2666,7 +2666,8 @@ enum ieee80211_roc_type {
  *
  * @set_coverage_class: Set slot time for given coverage class as specified
  *	in IEEE 802.11-2007 section 17.3.8.6 and modify ACK timeout
- *	accordingly. This callback is not required and may sleep.
+ *	accordingly; coverage_class equals to -1 to enable ACK timeout
+ *	estimation algorithm. This callback is not required and may sleep.
  *
  * @testmode_cmd: Implement a cfg80211 test mode command. The passed @vif may
  *	be %NULL. The callback can sleep.
@@ -2950,7 +2951,7 @@ struct ieee80211_ops {
 	int (*get_survey)(struct ieee80211_hw *hw, int idx,
 		struct survey_info *survey);
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
-	void (*set_coverage_class)(struct ieee80211_hw *hw, u8 coverage_class);
+	int (*set_coverage_class)(struct ieee80211_hw *hw, s16 coverage_class);
 #ifdef CONFIG_NL80211_TESTMODE
 	int (*testmode_cmd)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    void *data, int len);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1142395..68a840d 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -450,17 +450,14 @@ static inline int drv_set_rts_threshold(struct ieee80211_local *local,
 }
 
 static inline int drv_set_coverage_class(struct ieee80211_local *local,
-					 u8 value)
+					 s16 value)
 {
-	int ret = 0;
+	int ret = -EOPNOTSUPP;
 	might_sleep();
 
 	trace_drv_set_coverage_class(local, value);
 	if (local->ops->set_coverage_class)
-		local->ops->set_coverage_class(&local->hw, value);
-	else
-		ret = -EOPNOTSUPP;
-
+		ret = local->ops->set_coverage_class(&local->hw, value);
 	trace_drv_return_int(local, ret);
 	return ret;
 }
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 02ac535..38fae7e 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -672,13 +672,13 @@ DEFINE_EVENT(local_u32_evt, drv_set_rts_threshold,
 );
 
 TRACE_EVENT(drv_set_coverage_class,
-	TP_PROTO(struct ieee80211_local *local, u8 value),
+	TP_PROTO(struct ieee80211_local *local, s16 value),
 
 	TP_ARGS(local, value),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
-		__field(u8, value)
+		__field(s16, value)
 	),
 
 	TP_fast_assign(
-- 
1.9.1

