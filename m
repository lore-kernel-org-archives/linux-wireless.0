Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f51.google.com ([209.85.210.51]:43531 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab2LSCBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2012 21:01:04 -0500
Received: by mail-da0-f51.google.com with SMTP id i30so644088dad.10
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2012 18:01:02 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linville@tuxdriver.com
Cc: j@wl.fi, jlopex@cozybit.com, linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 3/3] mac80211_hwsim: emulate proper beaconing
Date: Tue, 18 Dec 2012 17:37:01 -0800
Message-Id: <1355881021-7071-3-git-send-email-thomas@cozybit.com> (sfid-20121219_030110_324822_97C487C8)
In-Reply-To: <1355881021-7071-1-git-send-email-thomas@cozybit.com>
References: <1355881021-7071-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What this means:

1) Fill in beacon timestamp for the monitor interface, and
   don't make the timestamp adjustment so contrived.
2) Change beacon time in response to TSF adjustment. This
   means hwsim PHYs can now be told to beacon offset
   (Toffset) from each other in time by adjusting the TSF.
3) PHY TSF offset adjustments are cumulative. i.e. +1000,
   then -1000 should not result in a TSF with offset -1000.

Per-station Toffset tracking has been tested, and beacons
are transmitted shortly after TBTT as shown in the
timestamp.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   50 ++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 764a358..e160319 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -357,7 +357,8 @@ struct mac80211_hwsim_data {
 	int power_level;
 
 	/* difference between this hw's clock and the real clock, in usecs */
-	u64 tsf_offset;
+	s64 tsf_offset;
+	s64 bcn_delta;
 	struct tasklet_struct bcn_tasklet;
 };
 
@@ -408,8 +409,7 @@ static netdev_tx_t hwsim_mon_xmit(struct sk_buff *skb,
 
 static __le64 __mac80211_hwsim_get_tsf(struct mac80211_hwsim_data *data)
 {
-	struct timeval tv = ktime_to_timeval(ktime_get_real());
-	u64 now = tv.tv_sec * USEC_PER_SEC + tv.tv_usec;
+	u64 now = ktime_to_ns(hrtimer_cb_get_time(&data->beacon_timer)) / 1000;
 	return cpu_to_le64(now + data->tsf_offset);
 }
 
@@ -424,9 +424,12 @@ static void mac80211_hwsim_set_tsf(struct ieee80211_hw *hw,
 		struct ieee80211_vif *vif, u64 tsf)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
-	struct timeval tv = ktime_to_timeval(ktime_get_real());
-	u64 now = tv.tv_sec * USEC_PER_SEC + tv.tv_usec;
-	data->tsf_offset = tsf - now;
+	u64 now = __mac80211_hwsim_get_tsf(data);
+	s32 delta = tsf - now;
+
+	data->tsf_offset += delta;
+	/* adjust after beaconing with new timestamp at old TBTT */
+	data->bcn_delta = delta;
 }
 
 static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
@@ -697,7 +700,6 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_rx_status rx_status;
-	struct ieee80211_rate *txrate = ieee80211_get_tx_rate(hw, info);
 
 	memset(&rx_status, 0, sizeof(rx_status));
 	rx_status.flag |= RX_FLAG_MACTIME_START;
@@ -727,7 +729,6 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	spin_lock(&hwsim_radio_lock);
 	list_for_each_entry(data2, &hwsim_radios, list) {
 		struct sk_buff *nskb;
-		struct ieee80211_mgmt *mgmt;
 		struct tx_iter_data tx_iter_data = {
 			.receive = false,
 			.channel = chan,
@@ -763,17 +764,8 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 		if (mac80211_hwsim_addr_match(data2, hdr->addr1))
 			ack = true;
 
-		/* set bcn timestamp relative to receiver mactime */
 		rx_status.mactime =
 				le64_to_cpu(__mac80211_hwsim_get_tsf(data2));
-		mgmt = (struct ieee80211_mgmt *) nskb->data;
-		if (ieee80211_is_beacon(mgmt->frame_control) ||
-		    ieee80211_is_probe_resp(mgmt->frame_control))
-			mgmt->u.beacon.timestamp = cpu_to_le64(
-				rx_status.mactime +
-				(data->tsf_offset - data2->tsf_offset) +
-				24 * 8 * 10 / txrate->bitrate);
-
 #if 0
 		/*
 		 * Don't enable this code by default as the OUI 00:00:00
@@ -964,7 +956,11 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 				     struct ieee80211_vif *vif)
 {
-	struct ieee80211_hw *hw = arg;
+	struct mac80211_hwsim_data *data = arg;
+	struct ieee80211_hw *hw = data->hw;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_rate *txrate;
+	struct ieee80211_mgmt *mgmt;
 	struct sk_buff *skb;
 
 	hwsim_check_magic(vif);
@@ -977,6 +973,13 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 	skb = ieee80211_beacon_get(hw, vif);
 	if (skb == NULL)
 		return;
+	info = IEEE80211_SKB_CB(skb);
+	txrate = ieee80211_get_tx_rate(hw, info);
+
+	mgmt = (struct ieee80211_mgmt *) skb->data;
+	/* fake header transmission time */
+	mgmt->u.beacon.timestamp = cpu_to_le64(__mac80211_hwsim_get_tsf(data) +
+					       24 * 8 * 10 / txrate->bitrate);
 
 	mac80211_hwsim_tx_frame(hw, skb,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
@@ -989,7 +992,7 @@ static void mac80211_hwsim_bcn_tasklet(unsigned long d)
 
 	ieee80211_iterate_active_interfaces_atomic(
 		hw, IEEE80211_IFACE_ITER_NORMAL,
-		mac80211_hwsim_beacon_tx, hw);
+		mac80211_hwsim_beacon_tx, data);
 }
 
 static enum hrtimer_restart
@@ -997,6 +1000,7 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 {
 	struct mac80211_hwsim_data *data =
 		container_of(timer, struct mac80211_hwsim_data, beacon_timer);
+	u64 bcn_int = ktime_to_ns(data->beacon_int) / 1000;
 
 	if (!data->started)
 		return HRTIMER_NORESTART;
@@ -1004,7 +1008,13 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 	/* must defer here since hrtimers are run in hard-IRQ */
 	tasklet_schedule(&data->bcn_tasklet);
 
-	hrtimer_forward(timer, hrtimer_get_expires(timer), data->beacon_int);
+	/* beacon at new TBTT + beacon interval */
+	if (data->bcn_delta) {
+		bcn_int -= data->bcn_delta;
+		data->bcn_delta = 0;
+	}
+	hrtimer_forward(timer, hrtimer_get_expires(timer),
+			ns_to_ktime(bcn_int * 1000));
 	return HRTIMER_RESTART;
 }
 
-- 
1.7.10.4

