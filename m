Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63924 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2CaSbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 14:31:44 -0400
Received: by dake40 with SMTP id e40so816411dak.11
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2012 11:31:43 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>,
	Pavel Zubarev <pavel.zubarev@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] mac80211_hwsim: Fill timestamp beacon at the time it is transmitted
Date: Sat, 31 Mar 2012 11:31:30 -0700
Message-Id: <1333218693-30093-2-git-send-email-javier@cozybit.com> (sfid-20120331_203146_999361_523571F8)
In-Reply-To: <1333218693-30093-1-git-send-email-javier@cozybit.com>
References: <1333218693-30093-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generate more acurate tsf values in hwsim by setting the tsf value on
trasmitted beacons immediately before they are moved to the rx path.
Also, adjust the beacon timestamp to be the time at which the first byte
of the timestamp is transmitted.

With these changes the observed tsf offset between two hwsim/mesh peers
is 0 (unless the offset is modified via debugfs)

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b7ce6a6..9ef0de6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -632,6 +632,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_rx_status rx_status;
+	struct ieee80211_rate *txrate = ieee80211_get_tx_rate(hw, info);
 
 	if (data->idle) {
 		wiphy_debug(hw->wiphy, "Trying to TX when idle - reject\n");
@@ -666,6 +667,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	spin_lock(&hwsim_radio_lock);
 	list_for_each_entry(data2, &hwsim_radios, list) {
 		struct sk_buff *nskb;
+		struct ieee80211_mgmt *mgmt;
 
 		if (data == data2)
 			continue;
@@ -683,8 +685,17 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 
 		if (mac80211_hwsim_addr_match(data2, hdr->addr1))
 			ack = true;
+
+		/* set bcn timestamp relative to receiver mactime */
 		rx_status.mactime =
-			le64_to_cpu(__mac80211_hwsim_get_tsf(data2));
+				le64_to_cpu(__mac80211_hwsim_get_tsf(data2));
+		mgmt = (struct ieee80211_mgmt *) nskb->data;
+		if (ieee80211_is_beacon(mgmt->frame_control) ||
+		    ieee80211_is_probe_resp(mgmt->frame_control))
+			mgmt->u.beacon.timestamp = cpu_to_le64(
+				rx_status.mactime +
+				24 * 8 * 10 / txrate->bitrate);
+
 		memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
 		ieee80211_rx_irqsafe(data2->hw, nskb);
 	}
@@ -698,12 +709,6 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	bool ack;
 	struct ieee80211_tx_info *txi;
 	u32 _pid;
-	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) skb->data;
-	struct mac80211_hwsim_data *data = hw->priv;
-
-	if (ieee80211_is_beacon(mgmt->frame_control) ||
-	    ieee80211_is_probe_resp(mgmt->frame_control))
-		mgmt->u.beacon.timestamp = __mac80211_hwsim_get_tsf(data);
 
 	mac80211_hwsim_monitor_rx(hw, skb);
 
@@ -800,11 +805,9 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 				     struct ieee80211_vif *vif)
 {
 	struct ieee80211_hw *hw = arg;
-	struct mac80211_hwsim_data *data = hw->priv;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *info;
 	u32 _pid;
-	struct ieee80211_mgmt *mgmt;
 
 	hwsim_check_magic(vif);
 
@@ -818,9 +821,6 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 		return;
 	info = IEEE80211_SKB_CB(skb);
 
-	mgmt = (struct ieee80211_mgmt *) skb->data;
-	mgmt->u.beacon.timestamp = __mac80211_hwsim_get_tsf(data);
-
 	mac80211_hwsim_monitor_rx(hw, skb);
 
 	/* wmediumd mode check */
@@ -1444,7 +1444,7 @@ DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
 			hwsim_fops_group_read, hwsim_fops_group_write,
 			"%llx\n");
 
-struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(
+static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(
 			     struct mac_address *addr)
 {
 	struct mac80211_hwsim_data *data;
-- 
1.7.5.4

