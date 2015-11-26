Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5319 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbbKZSvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 13:51:04 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211_hwsim: Update timestamp in Probe Response frames
Date: Thu, 26 Nov 2015 20:50:12 +0200
Message-ID: <1448563812-27385-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20151126_195117_576989_F45E8F88)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, this was done only for Beacon frames, but similar timestamp
update is needed for Probe Response frames to make these more accurately
match the real IEEE 802.11 behavior. Previously, all zeros timestamp was
sent in Probe Response frames.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e922a4d..551dfff 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1250,6 +1250,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	struct ieee80211_tx_info *txi = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *channel;
 	bool ack;
@@ -1295,6 +1296,22 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 				       ARRAY_SIZE(txi->control.rates));
 
 	txi->rate_driver_data[0] = channel;
+
+	if (skb->len >= 24 + 8 &&
+	    ieee80211_is_probe_resp(hdr->frame_control)) {
+		/* fake header transmission time */
+		struct ieee80211_mgmt *mgmt;
+		struct ieee80211_rate *txrate;
+		u64 ts;
+
+		mgmt = (struct ieee80211_mgmt *)skb->data;
+		txrate = ieee80211_get_tx_rate(hw, txi);
+		ts = mac80211_hwsim_get_tsf_raw();
+		mgmt->u.probe_resp.timestamp =
+			cpu_to_le64(ts + data->tsf_offset +
+				    24 * 8 * 10 / txrate->bitrate);
+	}
+
 	mac80211_hwsim_monitor_rx(hw, skb, channel);
 
 	/* wmediumd mode check */
-- 
1.9.1

