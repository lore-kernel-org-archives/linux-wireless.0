Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56668 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbaJVTXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 15:23:15 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 1/9] mac80211-hwsim: add ethtool stats support
Date: Wed, 22 Oct 2014 12:22:58 -0700
Message-Id: <1414005786-27572-1-git-send-email-greearb@candelatech.com> (sfid-20141022_212320_672556_51A45D16)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This gives a view into packet activity at the virtual radio
level.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 75 ++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 6ffe073..0224cc3 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -450,6 +450,14 @@ struct mac80211_hwsim_data {
 	s64 bcn_delta;
 	/* absolute beacon transmission time. Used to cover up "tx" delay. */
 	u64 abs_bcn_ts;
+
+	/* Stats */
+	u64 tx_pkts;
+	u64 rx_pkts;
+	u64 tx_bytes;
+	u64 rx_bytes;
+	u64 tx_dropped;
+	u64 tx_failed;
 };
 
 
@@ -865,8 +873,10 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	/* If the queue contains MAX_QUEUE skb's drop some */
 	if (skb_queue_len(&data->pending) >= MAX_QUEUE) {
 		/* Droping until WARN_QUEUE level */
-		while (skb_queue_len(&data->pending) >= WARN_QUEUE)
+		while (skb_queue_len(&data->pending) >= WARN_QUEUE) {
 			ieee80211_free_txskb(hw, skb_dequeue(&data->pending));
+			data->tx_dropped++;
+		}
 	}
 
 	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_ATOMIC);
@@ -921,11 +931,14 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 
 	/* Enqueue the packet */
 	skb_queue_tail(&data->pending, my_skb);
+	data->tx_pkts++;
+	data->tx_bytes += my_skb->len;
 	return;
 
 nla_put_failure:
 	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
 	ieee80211_free_txskb(hw, my_skb);
+	data->tx_failed++;
 }
 
 static bool hwsim_chans_compat(struct ieee80211_channel *c1,
@@ -1071,6 +1084,8 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 		rx_status.mactime = now + data2->tsf_offset;
 
 		memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
+		data2->rx_pkts++;
+		data2->rx_bytes += nskb->len;
 		ieee80211_rx_irqsafe(data2->hw, nskb);
 	}
 	spin_unlock(&hwsim_radio_lock);
@@ -1138,6 +1153,8 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 		return mac80211_hwsim_tx_frame_nl(hw, skb, _portid);
 
 	/* NO wmediumd detected, perfect medium simulation */
+	data->tx_pkts++;
+	data->tx_bytes += skb->len;
 	ack = mac80211_hwsim_tx_frame_no_nl(hw, skb, channel);
 
 	if (ack && skb->len >= 16) {
@@ -1921,6 +1938,57 @@ static void mac80211_hwsim_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	hwsim_check_chanctx_magic(ctx);
 }
 
+static const char mac80211_hwsim_gstrings_stats[][ETH_GSTRING_LEN] = {
+	"tx_pkts_nic",
+	"tx_bytes_nic",
+	"rx_pkts_nic",
+	"rx_bytes_nic",
+	"d_tx_dropped",
+	"d_tx_failed",
+	"d_ps_mode",
+	"d_group",
+	"d_tx_power",
+};
+
+#define MAC80211_HWSIM_SSTATS_LEN ARRAY_SIZE(mac80211_hwsim_gstrings_stats)
+
+void mac80211_hwsim_get_et_strings(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   u32 sset, u8 *data)
+{
+	if (sset == ETH_SS_STATS)
+		memcpy(data, *mac80211_hwsim_gstrings_stats,
+		       sizeof(mac80211_hwsim_gstrings_stats));
+}
+
+int mac80211_hwsim_get_et_sset_count(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif, int sset)
+{
+	if (sset == ETH_SS_STATS)
+		return MAC80211_HWSIM_SSTATS_LEN;
+	return 0;
+}
+
+void mac80211_hwsim_get_et_stats(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct ethtool_stats *stats, u64 *data)
+{
+	struct mac80211_hwsim_data *ar = hw->priv;
+	int i = 0;
+
+	data[i++] = ar->tx_pkts;
+	data[i++] = ar->tx_bytes;
+	data[i++] = ar->rx_pkts;
+	data[i++] = ar->rx_bytes;
+	data[i++] = ar->tx_dropped;
+	data[i++] = ar->tx_failed;
+	data[i++] = ar->ps;
+	data[i++] = ar->group;
+	data[i++] = ar->power_level;
+
+	WARN_ON(i != MAC80211_HWSIM_SSTATS_LEN);
+}
+
 static const struct ieee80211_ops mac80211_hwsim_ops = {
 	.tx = mac80211_hwsim_tx,
 	.start = mac80211_hwsim_start,
@@ -1944,6 +2012,9 @@ static const struct ieee80211_ops mac80211_hwsim_ops = {
 	.flush = mac80211_hwsim_flush,
 	.get_tsf = mac80211_hwsim_get_tsf,
 	.set_tsf = mac80211_hwsim_set_tsf,
+	.get_et_sset_count = mac80211_hwsim_get_et_sset_count,
+	.get_et_stats = mac80211_hwsim_get_et_stats,
+	.get_et_strings = mac80211_hwsim_get_et_strings,
 };
 
 static struct ieee80211_ops mac80211_hwsim_mchan_ops;
@@ -2394,6 +2465,8 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+	data2->rx_pkts++;
+	data2->rx_bytes += skb->len;
 	ieee80211_rx_irqsafe(data2->hw, skb);
 
 	return 0;
-- 
1.7.11.7

