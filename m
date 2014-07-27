Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:45920 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaG0Vgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2014 17:36:55 -0400
Received: by mail-we0-f179.google.com with SMTP id u57so6552365wes.38
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2014 14:36:54 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: [PATCHv3 2/6] mac80211: extend set_coverage_class signature
Date: Sun, 27 Jul 2014 23:36:48 +0200
Message-Id: <1406497008-25383-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140727_233701_012840_C5CADAC9)
In-Reply-To: <1406497008-25383-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1406497008-25383-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend set_coverage_class API in order to enable ACK timeout estimation
algorithm (dynack) passing coverage_class equals to -1 to lower drivers.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 include/net/mac80211.h    | 5 +++--
 net/mac80211/cfg.c        | 9 +++++++--
 net/mac80211/driver-ops.h | 2 +-
 net/mac80211/trace.h      | 4 ++--
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dae2e24..3a43f66 100644
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
+	void (*set_coverage_class)(struct ieee80211_hw *hw, s16 coverage_class);
 #ifdef CONFIG_NL80211_TESTMODE
 	int (*testmode_cmd)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    void *data, int len);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 927b4ea..5927822 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1984,8 +1984,13 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 			return err;
 	}
 
-	if (changed & WIPHY_PARAM_COVERAGE_CLASS) {
-		err = drv_set_coverage_class(local, wiphy->coverage_class);
+	if ((changed & WIPHY_PARAM_COVERAGE_CLASS) ||
+	    (changed & WIPHY_PARAM_DYN_ACK)) {
+		s16 coverage_class;
+
+		coverage_class = (changed & WIPHY_PARAM_COVERAGE_CLASS)
+				  ? wiphy->coverage_class : -1;
+		err = drv_set_coverage_class(local, coverage_class);
 
 		if (err)
 			return err;
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1142395..196d48c 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -450,7 +450,7 @@ static inline int drv_set_rts_threshold(struct ieee80211_local *local,
 }
 
 static inline int drv_set_coverage_class(struct ieee80211_local *local,
-					 u8 value)
+					 s16 value)
 {
 	int ret = 0;
 	might_sleep();
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

