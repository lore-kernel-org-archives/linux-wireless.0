Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49133 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2CAA3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 19:29:48 -0500
Received: by dado14 with SMTP id o14so50664dad.11
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 16:29:48 -0800 (PST)
MIME-Version: 1.0
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211_hwsim:  Add tsf to beacons and radiotap header.
Date: Wed, 29 Feb 2012 16:29:35 -0800
Message-Id: <1330561776-8135-1-git-send-email-javier@cozybit.com> (sfid-20120301_012952_517230_8E37477D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generate a tsf from jiffies.  Prepare the path for having different tsf
offsets on the each phy.  This will be useful for testing mesh
synchronization algorithms.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ba16f05..b926a89 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -321,11 +321,13 @@ struct mac80211_hwsim_data {
 	struct dentry *debugfs_group;
 
 	int power_level;
+	int tsf_offset;			/* in TUs */
 };
 
 
 struct hwsim_radiotap_hdr {
 	struct ieee80211_radiotap_header hdr;
+	u64 rt_tsft;
 	u8 rt_flags;
 	u8 rt_rate;
 	__le16 rt_channel;
@@ -367,6 +369,11 @@ static netdev_tx_t hwsim_mon_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static __le64 __mac80211_hwsim_get_tsf(struct mac80211_hwsim_data *data)
+{
+	return cpu_to_le64(jiffies_to_msecs(jiffies)*1000/1024 +
+			data->tsf_offset);
+}
 
 static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
 				      struct sk_buff *tx_skb)
@@ -391,7 +398,9 @@ static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
 	hdr->hdr.it_len = cpu_to_le16(sizeof(*hdr));
 	hdr->hdr.it_present = cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
 					  (1 << IEEE80211_RADIOTAP_RATE) |
+					  (1 << IEEE80211_RADIOTAP_TSFT) |
 					  (1 << IEEE80211_RADIOTAP_CHANNEL));
+	hdr->rt_tsft = __mac80211_hwsim_get_tsf(data);
 	hdr->rt_flags = 0;
 	hdr->rt_rate = txrate->bitrate / 5;
 	hdr->rt_channel = cpu_to_le16(data->channel->center_freq);
@@ -610,7 +619,8 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	}
 
 	memset(&rx_status, 0, sizeof(rx_status));
-	/* TODO: set mactime */
+	rx_status.mactime = le64_to_cpu(__mac80211_hwsim_get_tsf(data));
+	rx_status.flag |= RX_FLAG_MACTIME_MPDU;
 	rx_status.freq = data->channel->center_freq;
 	rx_status.band = data->channel->band;
 	rx_status.rate_idx = info->control.rates[0].idx;
@@ -763,9 +773,12 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 				     struct ieee80211_vif *vif)
 {
 	struct ieee80211_hw *hw = arg;
+	struct mac80211_hwsim_data *data = hw->priv;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *info;
 	u32 _pid;
+	struct ieee80211_hdr_3addr *hdr;
+	__le64 *tsfpos;
 
 	hwsim_check_magic(vif);
 
@@ -779,6 +792,11 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 		return;
 	info = IEEE80211_SKB_CB(skb);
 
+	/* add the timestamp to the beacon */
+	hdr = (struct ieee80211_hdr_3addr *) skb->data;
+	tsfpos = (__le64 *) (hdr + 1);
+	put_unaligned(__mac80211_hwsim_get_tsf(data), tsfpos);
+
 	mac80211_hwsim_monitor_rx(hw, skb);
 
 	/* wmediumd mode check */
-- 
1.7.6

