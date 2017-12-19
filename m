Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0052.outbound.protection.outlook.com ([104.47.42.52]:40224
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965176AbdLSL3Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 06:29:24 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH v2 03/10] qtnfmac: add support for radar detection and CAC
Date: Tue, 19 Dec 2017 14:28:49 +0300
Message-Id: <20171219112856.22463-4-sergey.matyukevich.os@quantenna.com> (sfid-20171219_122931_113228_2D187152)
In-Reply-To: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
References: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Implement two parts of radar handling logic:
- cfg80211 .start_radar_detect callback to allow nl80211 to initiate CAC
- radar event to allow wlan device to advertize CAC and radar events

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 18 ++++++-
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 38 ++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h |  3 ++
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 61 +++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 36 +++++++++++++
 5 files changed, 155 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index b8e5f32cebdf..d4a98d62ecbe 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -751,6 +751,21 @@ static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+static int qtnf_start_radar_detection(struct wiphy *wiphy,
+				      struct net_device *ndev,
+				      struct cfg80211_chan_def *chandef,
+				      u32 cac_time_ms)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
+	int ret;
+
+	ret = qtnf_cmd_start_cac(vif, chandef, cac_time_ms);
+	if (ret)
+		pr_err("%s: failed to start CAC ret=%d\n", ndev->name, ret);
+
+	return ret;
+}
+
 static struct cfg80211_ops qtn_cfg80211_ops = {
 	.add_virtual_intf	= qtnf_add_virtual_intf,
 	.change_virtual_intf	= qtnf_change_virtual_intf,
@@ -774,7 +789,8 @@ static struct cfg80211_ops qtn_cfg80211_ops = {
 	.disconnect		= qtnf_disconnect,
 	.dump_survey		= qtnf_dump_survey,
 	.get_channel		= qtnf_get_channel,
-	.channel_switch		= qtnf_channel_switch
+	.channel_switch		= qtnf_channel_switch,
+	.start_radar_detection	= qtnf_start_radar_detection,
 };
 
 static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index bed81f0cb1cd..7089f3eb7a87 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2512,3 +2512,41 @@ int qtnf_cmd_get_channel(struct qtnf_vif *vif, struct cfg80211_chan_def *chdef)
 	consume_skb(resp_skb);
 	return ret;
 }
+
+int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
+		       const struct cfg80211_chan_def *chdef,
+		       u32 cac_time_ms)
+{
+	struct qtnf_bus *bus = vif->mac->bus;
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_start_cac *cmd;
+	int ret;
+	u16 res_code;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_START_CAC,
+					    sizeof(*cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	cmd = (struct qlink_cmd_start_cac *)cmd_skb->data;
+	cmd->cac_time_ms = cpu_to_le32(cac_time_ms);
+	qlink_chandef_cfg2q(chdef, &cmd->chan);
+
+	qtnf_bus_lock(bus);
+	ret = qtnf_cmd_send(bus, cmd_skb, &res_code);
+	qtnf_bus_unlock(bus);
+
+	if (ret)
+		return ret;
+
+	switch (res_code) {
+	case QLINK_CMD_RESULT_OK:
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index d981a76e5835..07a957af9a58 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -76,5 +76,8 @@ int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u16 channel,
 int qtnf_cmd_send_chan_switch(struct qtnf_vif *vif,
 			      struct cfg80211_csa_settings *params);
 int qtnf_cmd_get_channel(struct qtnf_vif *vif, struct cfg80211_chan_def *chdef);
+int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
+		       const struct cfg80211_chan_def *chdef,
+		       u32 cac_time_ms);
 
 #endif /* QLINK_COMMANDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index a3a18d8469ae..9843ca36b74b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -395,6 +395,63 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 	return 0;
 }
 
+static int qtnf_event_handle_radar(struct qtnf_vif *vif,
+				   const struct qlink_event_radar *ev,
+				   u16 len)
+{
+	struct wiphy *wiphy = priv_to_wiphy(vif->mac);
+	struct cfg80211_chan_def chandef;
+
+	if (len < sizeof(*ev)) {
+		pr_err("MAC%u: payload is too short\n", vif->mac->macid);
+		return -EINVAL;
+	}
+
+	if (!wiphy->registered || !vif->netdev)
+		return 0;
+
+	qlink_chandef_q2cfg(wiphy, &ev->chan, &chandef);
+
+	if (!cfg80211_chandef_valid(&chandef)) {
+		pr_err("MAC%u: bad channel f1=%u f2=%u bw=%u\n",
+		       vif->mac->macid,
+		       chandef.center_freq1, chandef.center_freq2,
+		       chandef.width);
+		return -EINVAL;
+	}
+
+	pr_info("%s: radar event=%u f1=%u f2=%u bw=%u\n",
+		vif->netdev->name, ev->event,
+		chandef.center_freq1, chandef.center_freq2,
+		chandef.width);
+
+	switch (ev->event) {
+	case QLINK_RADAR_DETECTED:
+		cfg80211_radar_event(wiphy, &chandef, GFP_KERNEL);
+		break;
+	case QLINK_RADAR_CAC_FINISHED:
+		if (!vif->wdev.cac_started)
+			break;
+
+		cfg80211_cac_event(vif->netdev, &chandef,
+				   NL80211_RADAR_CAC_FINISHED, GFP_KERNEL);
+		break;
+	case QLINK_RADAR_CAC_ABORTED:
+		if (!vif->wdev.cac_started)
+			break;
+
+		cfg80211_cac_event(vif->netdev, &chandef,
+				   NL80211_RADAR_CAC_ABORTED, GFP_KERNEL);
+		break;
+	default:
+		pr_warn("%s: unhandled radar event %u\n",
+			vif->netdev->name, ev->event);
+		break;
+	}
+
+	return 0;
+}
+
 static int qtnf_event_parse(struct qtnf_wmac *mac,
 			    const struct sk_buff *event_skb)
 {
@@ -449,6 +506,10 @@ static int qtnf_event_parse(struct qtnf_wmac *mac,
 		ret = qtnf_event_handle_freq_change(mac, (const void *)event,
 						    event_len);
 		break;
+	case QLINK_EVENT_RADAR:
+		ret = qtnf_event_handle_radar(vif, (const void *)event,
+					      event_len);
+		break;
 	default:
 		pr_warn("unknown event type: %x\n", event_id);
 		break;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 534d11e4175a..3e3de4629a53 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -205,6 +205,7 @@ struct qlink_auth_encr {
  * @QLINK_CMD_REG_NOTIFY: notify device about regulatory domain change. This
  *	command is supported only if device reports QLINK_HW_SUPPORTS_REG_UPDATE
  *	capability.
+ * @QLINK_CMD_START_CAC: start radar detection procedure on a specified channel.
  */
 enum qlink_cmd_type {
 	QLINK_CMD_FW_INIT		= 0x0001,
@@ -224,6 +225,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_BAND_INFO_GET		= 0x001A,
 	QLINK_CMD_CHAN_SWITCH		= 0x001B,
 	QLINK_CMD_CHAN_GET		= 0x001C,
+	QLINK_CMD_START_CAC		= 0x001D,
 	QLINK_CMD_START_AP		= 0x0021,
 	QLINK_CMD_STOP_AP		= 0x0022,
 	QLINK_CMD_GET_STA_INFO		= 0x0030,
@@ -617,6 +619,18 @@ struct qlink_cmd_start_ap {
 	u8 info[0];
 } __packed;
 
+/**
+ * struct qlink_cmd_start_cac - data for QLINK_CMD_START_CAC command
+ *
+ * @chan: a channel to start a radar detection procedure on.
+ * @cac_time_ms: CAC time.
+ */
+struct qlink_cmd_start_cac {
+	struct qlink_cmd chdr;
+	struct qlink_chandef chan;
+	__le32 cac_time_ms;
+} __packed;
+
 /* QLINK Command Responses messages related definitions
  */
 
@@ -814,6 +828,7 @@ enum qlink_event_type {
 	QLINK_EVENT_BSS_JOIN		= 0x0026,
 	QLINK_EVENT_BSS_LEAVE		= 0x0027,
 	QLINK_EVENT_FREQ_CHANGE		= 0x0028,
+	QLINK_EVENT_RADAR		= 0x0029,
 };
 
 /**
@@ -963,6 +978,27 @@ struct qlink_event_scan_complete {
 	__le32 flags;
 } __packed;
 
+enum qlink_radar_event {
+	QLINK_RADAR_DETECTED,
+	QLINK_RADAR_CAC_FINISHED,
+	QLINK_RADAR_CAC_ABORTED,
+	QLINK_RADAR_NOP_FINISHED,
+	QLINK_RADAR_PRE_CAC_EXPIRED,
+};
+
+/**
+ * struct qlink_event_radar - data for QLINK_EVENT_RADAR event
+ *
+ * @chan: channel on which radar event happened.
+ * @event: radar event type, one of &enum qlink_radar_event.
+ */
+struct qlink_event_radar {
+	struct qlink_event ehdr;
+	struct qlink_chandef chan;
+	u8 event;
+	u8 rsvd[3];
+} __packed;
+
 /* QLINK TLVs (Type-Length Values) definitions
  */
 
-- 
2.11.0
