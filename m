Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:44848 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757345AbZLUVu5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 16:50:57 -0500
From: =?UTF-8?q?Luk=C3=A1=C5=A1=20Turek?= <8an@praha12.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	lrodriguez@atheros.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH v3 2/5] mac80211: Add new callback set_coverage_class
Date: Mon, 21 Dec 2009 22:50:48 +0100
Message-Id: <1261432252-1855-3-git-send-email-8an@praha12.net>
In-Reply-To: <1261432252-1855-1-git-send-email-8an@praha12.net>
References: <1261432252-1855-1-git-send-email-8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mac80211 callback to driver set_coverage_class() sets slot time and ACK
timeout for given IEEE 802.11 coverage class. The callback is optional,
but it's essential for long distance links.

Signed-off-by: Lukas Turek <8an@praha12.net>
---
 include/net/mac80211.h      |    5 +++++
 net/mac80211/cfg.c          |    7 +++++++
 net/mac80211/driver-ops.h   |   15 +++++++++++++++
 net/mac80211/driver-trace.h |   23 +++++++++++++++++++++++
 4 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 538d6b7..669e57d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1483,6 +1483,10 @@ enum ieee80211_ampdu_mlme_action {
  *	need to set wiphy->rfkill_poll to %true before registration,
  *	and need to call wiphy_rfkill_set_hw_state() in the callback.
  *
+ * @set_coverage_class: Set slot time for given coverage class as specified
+ *	in IEEE 802.11-2007 section 17.3.8.6 and modify ACK timeout
+ *	accordingly. This callback is not required and may sleep.
+ *
  * @testmode_cmd: Implement a cfg80211 test mode command.
  */
 struct ieee80211_ops {
@@ -1537,6 +1541,7 @@ struct ieee80211_ops {
 			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
+	void (*set_coverage_class)(struct ieee80211_hw *hw, u8 coverage_class);
 #ifdef CONFIG_NL80211_TESTMODE
 	int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
 #endif
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6dc3579..d63819b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1237,6 +1237,13 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	int err;
 
+	if (changed & WIPHY_PARAM_COVERAGE_CLASS) {
+		err = drv_set_coverage_class(local, wiphy->coverage_class);
+
+		if (err)
+			return err;
+	}
+
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
 		err = drv_set_rts_threshold(local, wiphy->rts_threshold);
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 921dd9c..bba1e69 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -178,6 +178,21 @@ static inline int drv_set_rts_threshold(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_set_coverage_class(struct ieee80211_local *local,
+					 u8 value)
+{
+	int ret = 0;
+	might_sleep();
+
+	if (local->ops->set_coverage_class)
+		local->ops->set_coverage_class(&local->hw, value);
+	else
+		ret = -EOPNOTSUPP;
+
+	trace_drv_set_coverage_class(local, value, ret);
+	return ret;
+}
+
 static inline void drv_sta_notify(struct ieee80211_local *local,
 				  struct ieee80211_vif *vif,
 				  enum sta_notify_cmd cmd,
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index ee94ea0..1b770ae 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -489,6 +489,29 @@ TRACE_EVENT(drv_set_rts_threshold,
 	)
 );
 
+TRACE_EVENT(drv_set_coverage_class,
+	TP_PROTO(struct ieee80211_local *local, u8 value, int ret),
+
+	TP_ARGS(local, value, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u8, value)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->ret = ret;
+		__entry->value = value;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " value:%d ret:%d",
+		LOCAL_PR_ARG, __entry->value, __entry->ret
+	)
+);
+
 TRACE_EVENT(drv_sta_notify,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_vif *vif,
-- 
1.6.4.4

