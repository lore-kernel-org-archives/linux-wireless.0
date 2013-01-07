Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52939 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3AGWsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 17:48:45 -0500
Received: by mail-pb0-f54.google.com with SMTP id wz12so10909619pbc.27
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 14:48:44 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v3] mac80211_hwsim: fix beacon timestamp and mactime
Date: Mon,  7 Jan 2013 14:48:07 -0800
Message-Id: <1357598887-7617-1-git-send-email-thomas@cozybit.com> (sfid-20130107_234849_178452_5F7AA741)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the beacon timestamp once during "transmission" so the
monitor interface also gets a timestamped beacon.

Also use a common base between TX timestamp and RX
mactime. This eliminates "TX" path delay, which shows up
as a constant error in Toffset.

Get the global TSF once before iterating over all RX HWs,
so they all set a mactime with the same time base.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---

v2:
	respin cleanly (Johannes)
v3:
	refactor (Johannes)

 drivers/net/wireless/mac80211_hwsim.c |   57 ++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c918cdb..2bc3945 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -363,6 +363,8 @@ struct mac80211_hwsim_data {
 	/* difference between this hw's clock and the real clock, in usecs */
 	s64 tsf_offset;
 	s64 bcn_delta;
+	/* absolute beacon transmission time. Used to cover up "tx" delay. */
+	u64 abs_bcn_ts;
 };
 
 
@@ -410,15 +412,19 @@ static netdev_tx_t hwsim_mon_xmit(struct sk_buff *skb,
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
@@ -705,7 +711,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_rx_status rx_status;
-	struct ieee80211_rate *txrate = ieee80211_get_tx_rate(hw, info);
+	u64 now;
 
 	memset(&rx_status, 0, sizeof(rx_status));
 	rx_status.flag |= RX_FLAG_MACTIME_START;
@@ -731,11 +737,23 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	secpath_reset(skb);
 	nf_reset(skb);
 
+	/*
+	 * Get absolute mactime here so all HWs RX at the "same time", and
+	 * absolute TX time for beacon mactime so the timestamp matches.
+	 * Giving beacons a different mactime than non-beacons looks messy, but
+	 * it helps the Toffset be exact and a ~10us mactime discrepancy
+	 * probably doesn't really matter.
+	 */
+	if (ieee80211_is_beacon(hdr->frame_control) ||
+	    ieee80211_is_probe_resp(hdr->frame_control))
+		now = data->abs_bcn_ts;
+	else
+		now = mac80211_hwsim_get_tsf_raw();
+
 	/* Copy skb to all enabled radios that are on the current frequency */
 	spin_lock(&hwsim_radio_lock);
 	list_for_each_entry(data2, &hwsim_radios, list) {
 		struct sk_buff *nskb;
-		struct ieee80211_mgmt *mgmt;
 		struct tx_iter_data tx_iter_data = {
 			.receive = false,
 			.channel = chan,
@@ -787,17 +805,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
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
+		rx_status.mactime = now + data2->tsf_offset;
 #if 0
 		/*
 		 * Don't enable this code by default as the OUI 00:00:00
@@ -987,7 +995,11 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
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
@@ -1000,6 +1012,15 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 	skb = ieee80211_beacon_get(hw, vif);
 	if (skb == NULL)
 		return;
+	info = IEEE80211_SKB_CB(skb);
+	txrate = ieee80211_get_tx_rate(hw, info);
+
+	mgmt = (struct ieee80211_mgmt *) skb->data;
+	/* fake header transmission time */
+	data->abs_bcn_ts = mac80211_hwsim_get_tsf_raw();
+	mgmt->u.beacon.timestamp = cpu_to_le64(data->abs_bcn_ts +
+					       data->tsf_offset +
+					       24 * 8 * 10 / txrate->bitrate);
 
 	mac80211_hwsim_tx_frame(hw, skb,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
@@ -1023,7 +1044,7 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 
 	ieee80211_iterate_active_interfaces_atomic(
 		hw, IEEE80211_IFACE_ITER_NORMAL,
-		mac80211_hwsim_beacon_tx, hw);
+		mac80211_hwsim_beacon_tx, data);
 
 	/* beacon at new TBTT + beacon interval */
 	if (data->bcn_delta) {
-- 
1.7.10.4

