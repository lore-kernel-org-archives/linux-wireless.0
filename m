Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0048.outbound.protection.outlook.com ([104.47.41.48]:1585
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751635AbdG0XHo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 19:07:44 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 08/12] qtnfmac: implement cfg80211 channel_switch handler
Date: Fri, 28 Jul 2017 02:06:50 +0300
Message-Id: <20170727230654.30850-9-sergey.matyukevich.os@quantenna.com> (sfid-20170728_010749_830265_FBD36CF6)
In-Reply-To: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements cfg80211 channel_switch handler enabling CSA
channel-switch procedure.

Driver performs only basic validation of the requested new channel
and then sends command to firmware. Beacon IEs are not sent since
beacon update is handled by firmware.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 60 +++++++++++++++++++++-
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 55 ++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h |  2 +
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  6 +++
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 61 +++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 28 +++++++++++
 6 files changed, 210 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index d47050934f00..ac8fdc1db482 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -812,6 +812,59 @@ qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 	return 0;
 }
 
+static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+			       struct cfg80211_csa_settings *params)
+{
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	int ret;
+
+	pr_debug("%s: chan(%u) count(%u) radar(%u) block_tx(%u)\n", dev->name,
+		 params->chandef.chan->hw_value, params->count,
+		 params->radar_required, params->block_tx);
+
+	switch (vif->wdev.iftype) {
+	case NL80211_IFTYPE_AP:
+		if (!(vif->bss_status & QTNF_STATE_AP_START)) {
+			pr_warn("AP not started on %s\n", dev->name);
+			return -ENOTCONN;
+		}
+		break;
+	default:
+		pr_err("unsupported vif type (%d) on %s\n",
+		       vif->wdev.iftype, dev->name);
+		return -EOPNOTSUPP;
+	}
+
+	if (vif->vifid != 0) {
+		if (!(mac->status & QTNF_MAC_CSA_ACTIVE))
+			return -EOPNOTSUPP;
+
+		if (!cfg80211_chandef_identical(&params->chandef,
+						&mac->csa_chandef))
+			return -EINVAL;
+
+		return 0;
+	}
+
+	if (!cfg80211_chandef_valid(&params->chandef)) {
+		pr_err("%s: invalid channel\n", dev->name);
+		return -EINVAL;
+	}
+
+	if (cfg80211_chandef_identical(&params->chandef, &mac->chandef)) {
+		pr_err("%s: switch request to the same channel\n", dev->name);
+		return -EALREADY;
+	}
+
+	ret = qtnf_cmd_send_chan_switch(mac, params);
+	if (ret)
+		pr_warn("%s: failed to switch to channel (%u)\n",
+			dev->name, params->chandef.chan->hw_value);
+
+	return ret;
+}
+
 static struct cfg80211_ops qtn_cfg80211_ops = {
 	.add_virtual_intf	= qtnf_add_virtual_intf,
 	.change_virtual_intf	= qtnf_change_virtual_intf,
@@ -834,7 +887,8 @@ static struct cfg80211_ops qtn_cfg80211_ops = {
 	.connect		= qtnf_connect,
 	.disconnect		= qtnf_disconnect,
 	.dump_survey		= qtnf_dump_survey,
-	.get_channel		= qtnf_get_channel
+	.get_channel		= qtnf_get_channel,
+	.channel_switch		= qtnf_channel_switch
 };
 
 static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
@@ -981,6 +1035,7 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 
 	wiphy->iface_combinations = iface_comb;
 	wiphy->n_iface_combinations = 1;
+	wiphy->max_num_csa_counters = 2;
 
 	/* Initialize cipher suits */
 	wiphy->cipher_suites = qtnf_cipher_suites;
@@ -988,7 +1043,8 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
-			WIPHY_FLAG_AP_UAPSD;
+			WIPHY_FLAG_AP_UAPSD |
+			WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
 	wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index a3c3dddb194c..524269d2c30c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2283,3 +2283,58 @@ int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u16 channel,
 	consume_skb(resp_skb);
 	return ret;
 }
+
+int qtnf_cmd_send_chan_switch(struct qtnf_wmac *mac,
+			      struct cfg80211_csa_settings *params)
+{
+	struct qlink_cmd_chan_switch *cmd;
+	struct sk_buff *cmd_skb;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, 0x0,
+					    QLINK_CMD_CHAN_SWITCH,
+					    sizeof(*cmd));
+
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(mac->bus);
+
+	cmd = (struct qlink_cmd_chan_switch *)cmd_skb->data;
+	cmd->channel = cpu_to_le16(params->chandef.chan->hw_value);
+	cmd->radar_required = params->radar_required;
+	cmd->block_tx = params->block_tx;
+	cmd->beacon_count = params->count;
+
+	ret = qtnf_cmd_send(mac->bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	switch (res_code) {
+	case QLINK_CMD_RESULT_OK:
+		memcpy(&mac->csa_chandef, &params->chandef,
+		       sizeof(mac->csa_chandef));
+		mac->status |= QTNF_MAC_CSA_ACTIVE;
+		ret = 0;
+		break;
+	case QLINK_CMD_RESULT_ENOTFOUND:
+		ret = -ENOENT;
+		break;
+	case QLINK_CMD_RESULT_ENOTSUPP:
+		ret = -EOPNOTSUPP;
+		break;
+	case QLINK_CMD_RESULT_EALREADY:
+		ret = -EALREADY;
+		break;
+	case QLINK_CMD_RESULT_INVALID:
+	default:
+		ret = -EFAULT;
+		break;
+	}
+
+out:
+	qtnf_bus_unlock(mac->bus);
+	return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index 41e2d50988b7..783b20364296 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -73,5 +73,7 @@ int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif,
 int qtnf_cmd_reg_notify(struct qtnf_bus *bus, struct regulatory_request *req);
 int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u16 channel,
 			    struct qtnf_chan_stats *stats);
+int qtnf_cmd_send_chan_switch(struct qtnf_wmac *mac,
+			      struct cfg80211_csa_settings *params);
 
 #endif /* QLINK_COMMANDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 6830ff45976d..099aad76afeb 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -88,6 +88,10 @@ enum qtnf_sta_state {
 	QTNF_STA_CONNECTED
 };
 
+enum qtnf_mac_status {
+	QTNF_MAC_CSA_ACTIVE	= BIT(0)
+};
+
 struct qtnf_vif {
 	struct wireless_dev wdev;
 	u8 vifid;
@@ -136,11 +140,13 @@ struct qtnf_wmac {
 	u8 macid;
 	u8 wiphy_registered;
 	u8 macaddr[ETH_ALEN];
+	u32 status;
 	struct qtnf_bus *bus;
 	struct qtnf_mac_info macinfo;
 	struct qtnf_vif iflist[QTNF_MAX_INTF];
 	struct cfg80211_scan_request *scan_req;
 	struct cfg80211_chan_def chandef;
+	struct cfg80211_chan_def csa_chandef;
 };
 
 struct qtnf_hw_info {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 00570de918e6..43d2e7fd6e02 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -350,6 +350,63 @@ qtnf_event_handle_scan_complete(struct qtnf_wmac *mac,
 	return 0;
 }
 
+static int
+qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
+			      const struct qlink_event_freq_change *data,
+			      u16 len)
+{
+	struct wiphy *wiphy = priv_to_wiphy(mac);
+	struct cfg80211_chan_def chandef;
+	struct ieee80211_channel *chan;
+	struct qtnf_vif *vif;
+	int freq;
+	int i;
+
+	if (len < sizeof(*data)) {
+		pr_err("payload is too short\n");
+		return -EINVAL;
+	}
+
+	freq = le32_to_cpu(data->freq);
+	chan = ieee80211_get_channel(wiphy, freq);
+	if (!chan) {
+		pr_err("channel at %d MHz not found\n", freq);
+		return -EINVAL;
+	}
+
+	pr_debug("MAC%d switch to new channel %u MHz\n", mac->macid, freq);
+
+	if (mac->status & QTNF_MAC_CSA_ACTIVE) {
+		mac->status &= ~QTNF_MAC_CSA_ACTIVE;
+		if (chan->hw_value != mac->csa_chandef.chan->hw_value)
+			pr_warn("unexpected switch to %u during CSA to %u\n",
+				chan->hw_value,
+				mac->csa_chandef.chan->hw_value);
+	}
+
+	/* FIXME: need to figure out proper nl80211_channel_type value */
+	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
+	/* fall-back to minimal safe chandef description */
+	if (!cfg80211_chandef_valid(&chandef))
+		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
+
+	memcpy(&mac->chandef, &chandef, sizeof(mac->chandef));
+
+	for (i = 0; i < QTNF_MAX_INTF; i++) {
+		vif = &mac->iflist[i];
+		if (vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)
+			continue;
+
+		if (vif->netdev) {
+			mutex_lock(&vif->wdev.mtx);
+			cfg80211_ch_switch_notify(vif->netdev, &chandef);
+			mutex_unlock(&vif->wdev.mtx);
+		}
+	}
+
+	return 0;
+}
+
 static int qtnf_event_parse(struct qtnf_wmac *mac,
 			    const struct sk_buff *event_skb)
 {
@@ -400,6 +457,10 @@ static int qtnf_event_parse(struct qtnf_wmac *mac,
 		ret = qtnf_event_handle_bss_leave(vif, (const void *)event,
 						  event_len);
 		break;
+	case QLINK_EVENT_FREQ_CHANGE:
+		ret = qtnf_event_handle_freq_change(mac, (const void *)event,
+						    event_len);
+		break;
 	default:
 		pr_warn("unknown event type: %x\n", event_id);
 		break;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 5c2d8f0abd7f..c529cc1994b4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -153,6 +153,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_UPDOWN_INTF		= 0x0018,
 	QLINK_CMD_REG_NOTIFY		= 0x0019,
 	QLINK_CMD_CHANS_INFO_GET	= 0x001A,
+	QLINK_CMD_CHAN_SWITCH		= 0x001B,
 	QLINK_CMD_CONFIG_AP		= 0x0020,
 	QLINK_CMD_START_AP		= 0x0021,
 	QLINK_CMD_STOP_AP		= 0x0022,
@@ -482,6 +483,22 @@ struct qlink_cmd_reg_notify {
 	u8 user_reg_hint_type;
 } __packed;
 
+/**
+ * struct qlink_cmd_chan_switch - data for QLINK_CMD_CHAN_SWITCH command
+ *
+ * @channel: channel number according to 802.11 17.3.8.3.2 and Annex J
+ * @radar_required: whether radar detection is required on the new channel
+ * @block_tx: whether transmissions should be blocked while changing
+ * @beacon_count: number of beacons until switch
+ */
+struct qlink_cmd_chan_switch {
+	struct qlink_cmd chdr;
+	__le16 channel;
+	u8 radar_required;
+	u8 block_tx;
+	u8 beacon_count;
+} __packed;
+
 /* QLINK Command Responses messages related definitions
  */
 
@@ -667,6 +684,7 @@ enum qlink_event_type {
 	QLINK_EVENT_SCAN_COMPLETE	= 0x0025,
 	QLINK_EVENT_BSS_JOIN		= 0x0026,
 	QLINK_EVENT_BSS_LEAVE		= 0x0027,
+	QLINK_EVENT_FREQ_CHANGE		= 0x0028,
 };
 
 /**
@@ -736,6 +754,16 @@ struct qlink_event_bss_leave {
 	__le16 reason;
 } __packed;
 
+/**
+ * struct qlink_event_freq_change - data for QLINK_EVENT_FREQ_CHANGE event
+ *
+ * @freq: new operating frequency in MHz
+ */
+struct qlink_event_freq_change {
+	struct qlink_event ehdr;
+	__le32 freq;
+} __packed;
+
 enum qlink_rxmgmt_flags {
 	QLINK_RXMGMT_FLAG_ANSWERED = 1 << 0,
 };
-- 
2.11.0
