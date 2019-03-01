Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69502C10F03
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 22:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DB7620840
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 22:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfCAWsl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 17:48:41 -0500
Received: from Galois.linutronix.de ([146.0.238.70]:33409 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbfCAWsk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 17:48:40 -0500
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1gzqxH-0005fb-KU; Fri, 01 Mar 2019 23:48:35 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, tglx@linutronix.de,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/3] mac80211_hwsim: Replace hrtimer tasklet with softirq hrtimer
Date:   Fri,  1 Mar 2019 23:48:19 +0100
Message-Id: <20190301224821.29843-2-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190301224821.29843-1-bigeasy@linutronix.de>
References: <20190301224821.29843-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Switch the timer to HRTIMER_MODE_REL_SOFT, which executed the timer callback in
softirq context and remove the hrtimer_tasklet.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 46 ++++++++++++---------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 6359053bd0c78..f46999a9e8ca5 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -521,7 +521,7 @@ struct mac80211_hwsim_data {
 	unsigned int rx_filter;
 	bool started, idle, scanning;
 	struct mutex mutex;
-	struct tasklet_hrtimer beacon_timer;
+	struct hrtimer beacon_timer;
 	enum ps_mode {
 		PS_DISABLED, PS_ENABLED, PS_AUTO_POLL, PS_MANUAL_POLL
 	} ps;
@@ -1458,7 +1458,7 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	data->started = false;
-	tasklet_hrtimer_cancel(&data->beacon_timer);
+	hrtimer_cancel(&data->beacon_timer);
 	wiphy_dbg(hw->wiphy, "%s\n", __func__);
 }
 
@@ -1581,14 +1581,12 @@ static enum hrtimer_restart
 mac80211_hwsim_beacon(struct hrtimer *timer)
 {
 	struct mac80211_hwsim_data *data =
-		container_of(timer, struct mac80211_hwsim_data,
-			     beacon_timer.timer);
+		container_of(timer, struct mac80211_hwsim_data, beacon_timer);
 	struct ieee80211_hw *hw = data->hw;
 	u64 bcn_int = data->beacon_int;
-	ktime_t next_bcn;
 
 	if (!data->started)
-		goto out;
+		return HRTIMER_NORESTART;
 
 	ieee80211_iterate_active_interfaces_atomic(
 		hw, IEEE80211_IFACE_ITER_NORMAL,
@@ -1599,12 +1597,9 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 		bcn_int -= data->bcn_delta;
 		data->bcn_delta = 0;
 	}
-
-	next_bcn = ktime_add(hrtimer_get_expires(timer),
-			     ns_to_ktime(bcn_int * 1000));
-	tasklet_hrtimer_start(&data->beacon_timer, next_bcn, HRTIMER_MODE_ABS);
-out:
-	return HRTIMER_NORESTART;
+	hrtimer_forward(&data->beacon_timer, hrtimer_get_expires(timer),
+			ns_to_ktime(bcn_int * NSEC_PER_USEC));
+	return HRTIMER_RESTART;
 }
 
 static const char * const hwsim_chanwidths[] = {
@@ -1678,15 +1673,15 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_unlock(&data->mutex);
 
 	if (!data->started || !data->beacon_int)
-		tasklet_hrtimer_cancel(&data->beacon_timer);
-	else if (!hrtimer_is_queued(&data->beacon_timer.timer)) {
+		hrtimer_cancel(&data->beacon_timer);
+	else if (!hrtimer_is_queued(&data->beacon_timer)) {
 		u64 tsf = mac80211_hwsim_get_tsf(hw, NULL);
 		u32 bcn_int = data->beacon_int;
 		u64 until_tbtt = bcn_int - do_div(tsf, bcn_int);
 
-		tasklet_hrtimer_start(&data->beacon_timer,
-				      ns_to_ktime(until_tbtt * 1000),
-				      HRTIMER_MODE_REL);
+		hrtimer_start(&data->beacon_timer,
+			      ns_to_ktime(until_tbtt * NSEC_PER_USEC),
+			      HRTIMER_MODE_REL_SOFT);
 	}
 
 	return 0;
@@ -1749,7 +1744,7 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 			  info->enable_beacon, info->beacon_int);
 		vp->bcn_en = info->enable_beacon;
 		if (data->started &&
-		    !hrtimer_is_queued(&data->beacon_timer.timer) &&
+		    !hrtimer_is_queued(&data->beacon_timer) &&
 		    info->enable_beacon) {
 			u64 tsf, until_tbtt;
 			u32 bcn_int;
@@ -1757,9 +1752,10 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 			tsf = mac80211_hwsim_get_tsf(hw, vif);
 			bcn_int = data->beacon_int;
 			until_tbtt = bcn_int - do_div(tsf, bcn_int);
-			tasklet_hrtimer_start(&data->beacon_timer,
-					      ns_to_ktime(until_tbtt * 1000),
-					      HRTIMER_MODE_REL);
+
+			hrtimer_start(&data->beacon_timer,
+				      ns_to_ktime(until_tbtt * NSEC_PER_USEC),
+				      HRTIMER_MODE_REL_SOFT);
 		} else if (!info->enable_beacon) {
 			unsigned int count = 0;
 			ieee80211_iterate_active_interfaces_atomic(
@@ -1768,7 +1764,7 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 			wiphy_dbg(hw->wiphy, "  beaconing vifs remaining: %u",
 				  count);
 			if (count == 0) {
-				tasklet_hrtimer_cancel(&data->beacon_timer);
+				hrtimer_cancel(&data->beacon_timer);
 				data->beacon_int = 0;
 			}
 		}
@@ -2919,9 +2915,9 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 
-	tasklet_hrtimer_init(&data->beacon_timer,
-			     mac80211_hwsim_beacon,
-			     CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	hrtimer_init(&data->beacon_timer, CLOCK_MONOTONIC,
+		     HRTIMER_MODE_ABS_SOFT);
+	data->beacon_timer.function = mac80211_hwsim_beacon;
 
 	err = ieee80211_register_hw(hw);
 	if (err < 0) {
-- 
2.20.1

