Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0071.outbound.protection.outlook.com ([104.47.41.71]:30144
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752117AbdFTT4G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 15:56:06 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 5/8] qtnfmac: enable reporting the current operating channel
Date: Tue, 20 Jun 2017 22:55:14 +0300
Message-Id: <20170620195517.18373-6-sergey.matyukevich.os@quantenna.com> (sfid-20170620_215610_767547_199205B9)
In-Reply-To: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements all the necessary features needed to keep
operating channel information in sync between firmware and driver:

- implement cfg80211 qtnf_get_channel handler
- implement QLINK_EVENT_FREQ_CHANGE event handling
  using this event firmware notifies host when operating channel is changed
- update qtnf_dump_survey
  specify current channel in use in survey report
- update qtnf_connect
  pass to firmware channel number rather than frequency

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 66 ++++++++++++++++++++++-
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  2 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 60 ++++++++++++++++++++-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 15 +++++-
 4 files changed, 136 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index eb648f02aa40..77afc0fc8c03 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -755,6 +755,7 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 	     struct cfg80211_connect_params *sme)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	struct cfg80211_chan_def chandef;
 	struct qtnf_bss_config *bss_cfg;
 	int ret;
 
@@ -767,9 +768,20 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 	bss_cfg = &vif->bss_cfg;
 	memset(bss_cfg, 0, sizeof(*bss_cfg));
 
+	if (sme->channel) {
+		/* FIXME: need to set proper nl80211_channel_type value */
+		cfg80211_chandef_create(&chandef, sme->channel,
+					NL80211_CHAN_HT20);
+		/* fall-back to minimal safe chandef description */
+		if (!cfg80211_chandef_valid(&chandef))
+			cfg80211_chandef_create(&chandef, sme->channel,
+						NL80211_CHAN_HT20);
+
+		memcpy(&bss_cfg->chandef, &chandef, sizeof(bss_cfg->chandef));
+	}
+
 	bss_cfg->ssid_len = sme->ssid_len;
 	memcpy(&bss_cfg->ssid, sme->ssid, bss_cfg->ssid_len);
-	bss_cfg->chandef.chan = sme->channel;
 	bss_cfg->auth_type = sme->auth_type;
 	bss_cfg->privacy = sme->privacy;
 	bss_cfg->mfp = sme->mfp;
@@ -845,10 +857,15 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct ieee80211_supported_band *sband;
+	struct cfg80211_chan_def *bss_chandef;
 	struct ieee80211_channel *chan;
 	struct qtnf_chan_stats stats;
+	struct qtnf_vif *vif;
 	int ret;
 
+	vif = qtnf_netdev_get_priv(dev);
+	bss_chandef = &vif->bss_cfg.chandef;
+
 	sband = wiphy->bands[NL80211_BAND_2GHZ];
 	if (sband && idx >= sband->n_channels) {
 		idx -= sband->n_channels;
@@ -867,6 +884,10 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 	survey->channel = chan;
 	survey->filled = 0x0;
 
+	if (bss_chandef->chan)
+		if (chan->hw_value == bss_chandef->chan->hw_value)
+			survey->filled |= SURVEY_INFO_IN_USE;
+
 	ret = qtnf_cmd_get_chan_stats(mac, chan->hw_value, &stats);
 	switch (ret) {
 	case 0:
@@ -905,6 +926,46 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+static int
+qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_chan_def *chandef)
+{
+	struct net_device *ndev = wdev->netdev;
+	struct qtnf_bss_config *bss_cfg;
+	struct qtnf_vif *vif;
+
+	if (!ndev)
+		return -ENODEV;
+
+	vif = qtnf_netdev_get_priv(wdev->netdev);
+	bss_cfg = &vif->bss_cfg;
+
+	switch (vif->wdev.iftype) {
+	case NL80211_IFTYPE_STATION:
+		if (vif->sta_state == QTNF_STA_DISCONNECTED) {
+			pr_warn("%s: STA disconnected\n", ndev->name);
+			return -ENODATA;
+		}
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		/* AP_VLAN: get primary vif and pass through to AP */
+		vif = vif->u.vlan.parent;
+		bss_cfg = &vif->bss_cfg;
+	case NL80211_IFTYPE_AP:
+		if (!(vif->bss_status & QTNF_STATE_AP_START)) {
+			pr_warn("%s: AP not started\n", ndev->name);
+			return -ENODATA;
+		}
+		break;
+	default:
+		pr_err("unsupported vif type (%d)\n", vif->wdev.iftype);
+		return -ENODATA;
+	}
+
+	memcpy(chandef, &bss_cfg->chandef, sizeof(*chandef));
+	return 0;
+}
+
 static struct cfg80211_ops qtn_cfg80211_ops = {
 	.add_virtual_intf	= qtnf_add_virtual_intf,
 	.change_virtual_intf	= qtnf_change_virtual_intf,
@@ -926,7 +987,8 @@ static struct cfg80211_ops qtn_cfg80211_ops = {
 	.scan			= qtnf_scan,
 	.connect		= qtnf_connect,
 	.disconnect		= qtnf_disconnect,
-	.dump_survey		= qtnf_dump_survey
+	.dump_survey		= qtnf_dump_survey,
+	.get_channel		= qtnf_get_channel
 };
 
 static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 22741bf6f4ac..2e7034a560aa 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2087,7 +2087,7 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 	ether_addr_copy(cmd->bssid, bss_cfg->bssid);
 
 	if (bss_cfg->chandef.chan)
-		cmd->freq = cpu_to_le16(bss_cfg->chandef.chan->center_freq);
+		cmd->channel = cpu_to_le16(bss_cfg->chandef.chan->hw_value);
 
 	cmd->bg_scan_period = cpu_to_le16(bss_cfg->bg_scan_period);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 9b61e9a83670..6e1e93ccc40e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -211,8 +211,8 @@ qtnf_event_handle_bss_leave(struct qtnf_vif *vif,
 
 	pr_debug("VIF%u.%u: disconnected\n", vif->mac->macid, vif->vifid);
 
-	cfg80211_disconnected(vif->netdev, leave_info->reason, NULL, 0, 0,
-			      GFP_KERNEL);
+	cfg80211_disconnected(vif->netdev, le16_to_cpu(leave_info->reason),
+			      NULL, 0, 0, GFP_KERNEL);
 
 	vif->sta_state = QTNF_STA_DISCONNECTED;
 	netif_carrier_off(vif->netdev);
@@ -350,6 +350,58 @@ qtnf_event_handle_scan_complete(struct qtnf_wmac *mac,
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
+	struct qtnf_bss_config *bss_cfg;
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
+	pr_info("MAC%d switch to new channel %u MHz\n", mac->macid, freq);
+
+	/* FIXME: need to figure out proper nl80211_channel_type value */
+	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
+	/* fall-back to minimal safe chandef description */
+	if (!cfg80211_chandef_valid(&chandef))
+		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
+
+	for (i = 0; i < QTNF_MAX_INTF; i++) {
+		vif = &mac->iflist[i];
+		if (vif->wdev.iftype == NL80211_IFTYPE_UNSPECIFIED)
+			continue;
+
+		if (vif->netdev) {
+			bss_cfg = &vif->bss_cfg;
+			memcpy(&bss_cfg->chandef, &chandef,
+			       sizeof(bss_cfg->chandef));
+
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
@@ -400,6 +452,10 @@ static int qtnf_event_parse(struct qtnf_wmac *mac,
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
index 847c80f40a9a..5859ef624058 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -390,7 +390,7 @@ enum qlink_sta_connect_flags {
 struct qlink_cmd_connect {
 	struct qlink_cmd chdr;
 	__le32 flags;
-	__le16 freq;
+	__le16 channel;
 	__le16 bg_scan_period;
 	u8 bssid[ETH_ALEN];
 	u8 payload[0];
@@ -673,6 +673,7 @@ enum qlink_event_type {
 	QLINK_EVENT_SCAN_COMPLETE	= 0x0025,
 	QLINK_EVENT_BSS_JOIN		= 0x0026,
 	QLINK_EVENT_BSS_LEAVE		= 0x0027,
+	QLINK_EVENT_FREQ_CHANGE		= 0x0028,
 };
 
 /**
@@ -739,7 +740,17 @@ struct qlink_event_bss_join {
  */
 struct qlink_event_bss_leave {
 	struct qlink_event ehdr;
-	u16 reason;
+	__le16 reason;
+} __packed;
+
+/**
+ * struct qlink_event_freq_change - data for QLINK_EVENT_FREQ_CHANGE event
+ *
+ * @freq: new operating frequency in MHz
+ */
+struct qlink_event_freq_change {
+	struct qlink_event ehdr;
+	__le32 freq;
 } __packed;
 
 enum qlink_rxmgmt_flags {
-- 
2.11.0
