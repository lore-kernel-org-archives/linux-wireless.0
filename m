Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46020 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab2CBViR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:38:17 -0500
Received: by dajr28 with SMTP id r28so2435744daj.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 13:38:17 -0800 (PST)
MIME-Version: 1.0
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCHv4 1/2] mac80211_hwsim:  Add tsf to beacons, probe responses and radiotap header.
Date: Fri,  2 Mar 2012 13:38:10 -0800
Message-Id: <1330724291-9482-1-git-send-email-javier@cozybit.com> (sfid-20120302_223821_805514_965B5F64)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generate a tsf from internal kernel clock.  Prepare the path for having
different tsf offsets on the each phy.  This will be useful for testing
mesh synchronization algorithms.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
v2: Added timestamp to probe responses, as suggested by Johannes
    Also implement tx_last_beacon, useful for testing (new patch 1/3)
v3: Drop poorly implemented tx_last_beacon patch
    TSF in microsecs, not TUs!    (Johannes)
    Use high-resolution timer, not jiffies (Johannes)
v4: Do indeed return usecs, not msecs (Johannes)
    Improve patch series structure (Johannes)

 drivers/net/wireless/mac80211_hwsim.c |   41 +++++++++++++++++++++++++++++---
 1 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ba16f05..a8321ff 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -27,6 +27,7 @@
 #include <linux/etherdevice.h>
 #include <linux/debugfs.h>
 #include <linux/module.h>
+#include <linux/ktime.h>
 #include <net/genetlink.h>
 #include "mac80211_hwsim.h"
 
@@ -321,11 +322,15 @@ struct mac80211_hwsim_data {
 	struct dentry *debugfs_group;
 
 	int power_level;
+
+	/* difference between this hw's clock and the real clock, in usecs */
+	u64 tsf_offset;
 };
 
 
 struct hwsim_radiotap_hdr {
 	struct ieee80211_radiotap_header hdr;
+	u64 rt_tsft;
 	u8 rt_flags;
 	u8 rt_rate;
 	__le16 rt_channel;
@@ -367,6 +372,12 @@ static netdev_tx_t hwsim_mon_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static __le64 __mac80211_hwsim_get_tsf(struct mac80211_hwsim_data *data)
+{
+	struct timeval tv = ktime_to_timeval(ktime_get_real());
+	u64 now = tv.tv_sec * USEC_PER_SEC + tv.tv_usec;
+	return cpu_to_le64(now + data->tsf_offset);
+}
 
 static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
 				      struct sk_buff *tx_skb)
@@ -391,7 +402,9 @@ static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
 	hdr->hdr.it_len = cpu_to_le16(sizeof(*hdr));
 	hdr->hdr.it_present = cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
 					  (1 << IEEE80211_RADIOTAP_RATE) |
+					  (1 << IEEE80211_RADIOTAP_TSFT) |
 					  (1 << IEEE80211_RADIOTAP_CHANNEL));
+	hdr->rt_tsft = __mac80211_hwsim_get_tsf(data);
 	hdr->rt_flags = 0;
 	hdr->rt_rate = txrate->bitrate / 5;
 	hdr->rt_channel = cpu_to_le16(data->channel->center_freq);
@@ -610,7 +623,8 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	}
 
 	memset(&rx_status, 0, sizeof(rx_status));
-	/* TODO: set mactime */
+	rx_status.mactime = le64_to_cpu(__mac80211_hwsim_get_tsf(data));
+	rx_status.flag |= RX_FLAG_MACTIME_MPDU;
 	rx_status.freq = data->channel->center_freq;
 	rx_status.band = data->channel->band;
 	rx_status.rate_idx = info->control.rates[0].idx;
@@ -667,6 +681,19 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	bool ack;
 	struct ieee80211_tx_info *txi;
 	u32 _pid;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct mac80211_hwsim_data *data = hw->priv;
+	__le64 *tsfpos;
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	u16 fctypes = fc & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE);
+
+	if (fctypes == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_RESP) ||
+	    fctypes == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON)) {
+		struct ieee80211_hdr_3addr *hdr3 =
+			(struct ieee80211_hdr_3addr *) skb->data;
+		tsfpos = (__le64 *) (hdr3 + 1);
+		put_unaligned(__mac80211_hwsim_get_tsf(data), tsfpos);
+	}
 
 	mac80211_hwsim_monitor_rx(hw, skb);
 
@@ -685,10 +712,8 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	/* NO wmediumd detected, perfect medium simulation */
 	ack = mac80211_hwsim_tx_frame_no_nl(hw, skb);
 
-	if (ack && skb->len >= 16) {
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	if (ack && skb->len >= 16)
 		mac80211_hwsim_monitor_ack(hw, hdr->addr2);
-	}
 
 	txi = IEEE80211_SKB_CB(skb);
 
@@ -763,9 +788,12 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
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
 
@@ -779,6 +807,11 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
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

