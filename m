Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:57235 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3ABWz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 17:55:58 -0500
Received: by mail-pb0-f45.google.com with SMTP id mc8so8150385pbc.32
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 14:55:58 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linville@tuxdriver.org
Cc: j@w1.fi, linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 4/4] mac80211_hwsim: streamline beacon timestamp
Date: Wed,  2 Jan 2013 14:55:19 -0800
Message-Id: <1357167319-13338-4-git-send-email-thomas@cozybit.com> (sfid-20130102_235603_127234_22D649DB)
In-Reply-To: <1357167319-13338-1-git-send-email-thomas@cozybit.com>
References: <1357167319-13338-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the beacon timestamp once during "transmission" so the
monitor interface also gets a timestamped beacon.

Since the adjusted TSF is now used for the timestamp, we
must account for any delay in the global TSF time between
setting the timestamp and filling in RX mactime.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

---
v2:
	respin cleanly (Johannes)

 drivers/net/wireless/mac80211_hwsim.c |   52 +++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7b2acdd..2508249 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -359,6 +359,8 @@ struct mac80211_hwsim_data {
 	/* difference between this hw's clock and the real clock, in usecs */
 	s64 tsf_offset;
 	s64 bcn_delta;
+	/* absolute beacon transmission time. Used to cover up "tx" delay. */
+	u64 abs_bcn_tstamp;
 };
 
 
@@ -406,15 +408,19 @@ static netdev_tx_t hwsim_mon_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static inline u64 mac80211_hwsim_get_tsf_raw(void)
+{
+	return ktime_to_us(ktime_get_real());
+}
+
 static __le64 __mac80211_hwsim_get_tsf(struct mac80211_hwsim_data *data)
 {
-	struct timeval tv = ktime_to_timeval(ktime_get_real());
-	u64 now = tv.tv_sec * USEC_PER_SEC + tv.tv_usec;
+	u64 now = mac80211_hwsim_get_tsf_raw();
 	return cpu_to_le64(now + data->tsf_offset);
 }
 
 static u64 mac80211_hwsim_get_tsf(struct ieee80211_hw *hw,
-		struct ieee80211_vif *vif)
+				  struct ieee80211_vif *vif)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	return le64_to_cpu(__mac80211_hwsim_get_tsf(data));
@@ -701,7 +707,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_rx_status rx_status;
-	struct ieee80211_rate *txrate = ieee80211_get_tx_rate(hw, info);
+	u64 now;
 
 	memset(&rx_status, 0, sizeof(rx_status));
 	rx_status.flag |= RX_FLAG_MACTIME_START;
@@ -731,7 +737,6 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	spin_lock(&hwsim_radio_lock);
 	list_for_each_entry(data2, &hwsim_radios, list) {
 		struct sk_buff *nskb;
-		struct ieee80211_mgmt *mgmt;
 		struct tx_iter_data tx_iter_data = {
 			.receive = false,
 			.channel = chan,
@@ -767,17 +772,14 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 		if (mac80211_hwsim_addr_match(data2, hdr->addr1))
 			ack = true;
 
-		/* set bcn timestamp relative to receiver mactime */
-		rx_status.mactime =
-				le64_to_cpu(__mac80211_hwsim_get_tsf(data2));
-		mgmt = (struct ieee80211_mgmt *) nskb->data;
-		if (ieee80211_is_beacon(mgmt->frame_control) ||
-		    ieee80211_is_probe_resp(mgmt->frame_control))
-			mgmt->u.beacon.timestamp = cpu_to_le64(
-				rx_status.mactime +
-				(data->tsf_offset - data2->tsf_offset) +
-				24 * 8 * 10 / txrate->bitrate);
-
+		/*
+		 * Account for delay from filling in the timestamp to mactime.
+		 */
+		now = mac80211_hwsim_get_tsf_raw();
+		if (ieee80211_is_beacon(hdr->frame_control) ||
+		    ieee80211_is_probe_resp(hdr->frame_control))
+			now -= now - data->abs_bcn_tstamp;
+		rx_status.mactime = now + data2->tsf_offset;
 #if 0
 		/*
 		 * Don't enable this code by default as the OUI 00:00:00
@@ -967,8 +969,13 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
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
+	u64 now;
 
 	hwsim_check_magic(vif);
 
@@ -980,6 +987,15 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 	skb = ieee80211_beacon_get(hw, vif);
 	if (skb == NULL)
 		return;
+	info = IEEE80211_SKB_CB(skb);
+	txrate = ieee80211_get_tx_rate(hw, info);
+
+	mgmt = (struct ieee80211_mgmt *) skb->data;
+	/* fake header transmission time */
+	now = mac80211_hwsim_get_tsf_raw();
+	mgmt->u.beacon.timestamp = cpu_to_le64(now + data->tsf_offset +
+					       24 * 8 * 10 / txrate->bitrate);
+	data->abs_bcn_tstamp = now;
 
 	mac80211_hwsim_tx_frame(hw, skb,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
@@ -1003,7 +1019,7 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 
 	ieee80211_iterate_active_interfaces_atomic(
 		hw, IEEE80211_IFACE_ITER_NORMAL,
-		mac80211_hwsim_beacon_tx, hw);
+		mac80211_hwsim_beacon_tx, data);
 
 	/* beacon at new TBTT + beacon interval */
 	if (data->bcn_delta) {
-- 
1.7.10.4

