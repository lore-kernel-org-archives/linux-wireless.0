Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37272 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdB1Ece (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 23:32:34 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 1/4] mac80211-hwsim: notify user-space about channel change.
Date: Mon, 27 Feb 2017 13:56:31 -0800
Message-Id: <1488232593-2552-2-git-send-email-greearb@candelatech.com> (sfid-20170228_053238_938538_2193D6CF)
In-Reply-To: <1488232593-2552-1-git-send-email-greearb@candelatech.com>
References: <1488232593-2552-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The goal is to allow the user-space application to properly
filter packets before sending them down to the kernel.  This
should more closely mimic what a real piece of hardware would
do.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v2:  Change IDs, add new ones for width, freq1, freq2.

 drivers/net/wireless/mac80211_hwsim.c | 67 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mac80211_hwsim.h | 16 +++++++++
 2 files changed, 83 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0150747..12e9333 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -527,6 +527,10 @@ struct mac80211_hwsim_data {
 	u8 scan_addr[ETH_ALEN];
 
 	struct ieee80211_channel *channel;
+	enum nl80211_chan_width ch_width;
+	u32 center_freq1;
+	u32 center_freq2;
+
 	u64 beacon_int	/* beacon interval in us */;
 	unsigned int rx_filter;
 	bool started, idle, scanning;
@@ -998,6 +1002,64 @@ static int hwsim_unicast_netgroup(struct mac80211_hwsim_data *data,
 	return res;
 }
 
+static void mac80211_hwsim_check_nl_notify(struct mac80211_hwsim_data *data)
+{
+	struct sk_buff *skb;
+	u32 center_freq = 0;
+	u32 _portid;
+	void *msg_head;
+
+	/* wmediumd mode check */
+	_portid = READ_ONCE(data->wmediumd);
+
+	if (!_portid)
+		return;
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!skb)
+		goto err_print;
+
+	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
+			       HWSIM_CMD_NOTIFY_CH_CHANGE);
+	if (!msg_head) {
+		pr_debug("mac80211_hwsim: problem with msg_head, notify-ch-change\n");
+		goto nla_put_failure;
+	}
+
+	if (nla_put_u32(skb, HWSIM_ATTR_RADIO_ID, data->idx))
+		goto nla_put_failure;
+
+	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
+		    ETH_ALEN, data->addresses[1].addr))
+		goto nla_put_failure;
+
+	if (data->channel)
+		center_freq = data->channel->center_freq;
+
+	if (nla_put_u32(skb, HWSIM_ATTR_FREQ, center_freq))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, HWSIM_ATTR_CH_FREQ1, data->center_freq1))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, HWSIM_ATTR_CH_FREQ2, data->center_freq2))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, HWSIM_ATTR_CH_WIDTH, data->ch_width))
+		goto nla_put_failure;
+
+	genlmsg_end(skb, msg_head);
+	if (genlmsg_unicast(&init_net, skb, _portid))
+		goto err_print;
+
+	return;
+
+nla_put_failure:
+	nlmsg_free(skb);
+err_print:
+	pr_debug("mac80211_hwsim: error occurred in %s\n", __func__);
+}
+
 static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 				       struct sk_buff *my_skb,
 				       int dst_portid)
@@ -1599,6 +1661,9 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 
 	data->channel = conf->chandef.chan;
+	data->ch_width = conf->chandef.width;
+	data->center_freq1 = conf->chandef.center_freq1;
+	data->center_freq2 = conf->chandef.center_freq2;
 
 	WARN_ON(data->channel && data->use_chanctx);
 
@@ -1615,6 +1680,8 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 				      HRTIMER_MODE_REL);
 	}
 
+	mac80211_hwsim_check_nl_notify(data);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 39f2246..1251fdd 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -71,6 +71,15 @@ enum hwsim_tx_control_flags {
  * @HWSIM_CMD_DEL_RADIO: destroy a radio, reply is multicasted
  * @HWSIM_CMD_GET_RADIO: fetch information about existing radios, uses:
  *	%HWSIM_ATTR_RADIO_ID
+ * @HWSIM_CMD_NOTIFY_CH_CHANGE: notify user-space about channel-change.  This is
+ *	designed to help the user-space app better emulate radio hardware.
+ *	This command uses:
+ *	%HWSIM_ATTR_FREQ # Notify current operating center frequency.
+ *	%HWSIM_ATTR_CH_FREQ1 # Configured center-freq-1.
+ *	%HWSIM_ATTR_CH_FREQ2 # Configured center-freq-2.
+ *	%HWSIM_ATTR_CH_WIDTH # Configured channel width.
+ *	%HWSIM_ATTR_ADDR_TRANSMITTER # ID which radio we are notifying about.
+ *	%HWSIM_ATTR_ADDR_ID # Numeric Radio ID.
  * @__HWSIM_CMD_MAX: enum limit
  */
 enum {
@@ -81,6 +90,7 @@ enum {
 	HWSIM_CMD_NEW_RADIO,
 	HWSIM_CMD_DEL_RADIO,
 	HWSIM_CMD_GET_RADIO,
+	HWSIM_CMD_NOTIFY_CH_CHANGE,
 	__HWSIM_CMD_MAX,
 };
 #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
@@ -123,6 +133,9 @@ enum {
  * @HWSIM_ATTR_RADIO_NAME: Name of radio, e.g. phy666
  * @HWSIM_ATTR_NO_VIF:  Do not create vif (wlanX) when creating radio.
  * @HWSIM_ATTR_FREQ: Frequency at which packet is transmitted or received.
+ * @HWSIM_ATTR_CH_FREQ1: Configured center-freq-1.
+ * @HWSIM_ATTR_CH_FREQ2: Configured center-freq-2.
+ * @HWSIM_ATTR_CH_WIDTH: Configured channel width.
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -149,6 +162,9 @@ enum {
 	HWSIM_ATTR_NO_VIF,
 	HWSIM_ATTR_FREQ,
 	HWSIM_ATTR_PAD,
+	HWSIM_ATTR_CH_FREQ1,
+	HWSIM_ATTR_CH_FREQ2,
+	HWSIM_ATTR_CH_WIDTH,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
2.4.11
