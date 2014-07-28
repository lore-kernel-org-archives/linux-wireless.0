Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55812 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaG1OCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 10:02:36 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so4394891wiv.15
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2014 07:02:31 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCHv4 2/2] mac80211: extend set_coverage_class signature
Date: Mon, 28 Jul 2014 16:02:28 +0200
Message-Id: <1406556148-3924-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140728_160241_062276_6516441C)
In-Reply-To: <1406556148-3924-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1406556148-3924-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend set_coverage_class API in order to enable ACK timeout estimation
algorithm (dynack) passing coverage_class equals to -1 to lower drivers.
Synchronize set_coverage_class routine signature with mac80211 function pointer
for p54, ath9k, ath9k_htc and ath5k drivers.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath5k/mac80211-ops.c | 2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 2 +-
 drivers/net/wireless/ath/ath9k/main.c         | 3 ++-
 drivers/net/wireless/p54/main.c               | 3 ++-
 include/net/mac80211.h                        | 5 +++--
 net/mac80211/cfg.c                            | 9 +++++++--
 net/mac80211/driver-ops.h                     | 2 +-
 net/mac80211/trace.h                          | 4 ++--
 8 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index b65c38f..ab2709a 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -704,7 +704,7 @@ ath5k_get_survey(struct ieee80211_hw *hw, int idx, struct survey_info *survey)
  * reset.
  */
 static void
-ath5k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
+ath5k_set_coverage_class(struct ieee80211_hw *hw, s16 coverage_class)
 {
 	struct ath5k_hw *ah = hw->priv;
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 5627917..994fff1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1722,7 +1722,7 @@ static int ath9k_htc_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 }
 
 static void ath9k_htc_set_coverage_class(struct ieee80211_hw *hw,
-					 u8 coverage_class)
+					 s16 coverage_class)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e6ac8d2..97c028e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1959,7 +1959,8 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 	return 0;
 }
 
-static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
+static void ath9k_set_coverage_class(struct ieee80211_hw *hw,
+				     s16 coverage_class)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 7be3a48..97aeff0 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -696,7 +696,8 @@ static void p54_flush(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
 	WARN(total, "tx flush timeout, unresponsive firmware");
 }
 
-static void p54_set_coverage_class(struct ieee80211_hw *dev, u8 coverage_class)
+static void p54_set_coverage_class(struct ieee80211_hw *dev,
+				   s16 coverage_class)
 {
 	struct p54_common *priv = dev->priv;
 
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

