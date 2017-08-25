Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754421AbdHYCas (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:48 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Igor Mitsyanko <igor.mitsyanko@quantenna.com>
Subject: [PATCH 03/27] qtnfmac: retreive current channel info from EP
Date: Thu, 24 Aug 2017 19:30:00 -0700
Message-Id: <20170825023024.10565-4-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043100_643603_8D208EE1)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Do not try to cache current operational channel info in driver, this
is a potential source of synchronization issues + driver does not
really need that info.

Introduce GET_CHANNEL command and process it appropriately.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 34 ++++++++------------
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 38 +++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h |  1 +
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 11 +++++++
 4 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 856fa6e..8bfe61d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -793,37 +793,29 @@ qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct net_device *ndev = wdev->netdev;
 	struct qtnf_vif *vif;
+	int ret;
 
 	if (!ndev)
 		return -ENODEV;
 
 	vif = qtnf_netdev_get_priv(wdev->netdev);
 
-	switch (vif->wdev.iftype) {
-	case NL80211_IFTYPE_STATION:
-		if (vif->sta_state == QTNF_STA_DISCONNECTED) {
-			pr_warn("%s: STA disconnected\n", ndev->name);
-			return -ENODATA;
-		}
-		break;
-	case NL80211_IFTYPE_AP:
-		if (!(vif->bss_status & QTNF_STATE_AP_START)) {
-			pr_warn("%s: AP not started\n", ndev->name);
-			return -ENODATA;
-		}
-		break;
-	default:
-		pr_err("unsupported vif type (%d)\n", vif->wdev.iftype);
-		return -ENODATA;
+	ret = qtnf_cmd_get_channel(vif, chandef);
+	if (ret) {
+		pr_err("%s: failed to get channel: %d\n", ndev->name, ret);
+		goto out;
 	}
 
-	if (!cfg80211_chandef_valid(&mac->chandef)) {
-		pr_err("invalid channel settings on %s\n", ndev->name);
-		return -ENODATA;
+	if (!cfg80211_chandef_valid(chandef)) {
+		pr_err("%s: bad chan freq1=%u bw=%u\n", ndev->name,
+		       chandef->center_freq1, chandef->width);
+		ret = -ENODATA;
 	}
 
-	memcpy(chandef, &mac->chandef, sizeof(*chandef));
-	return 0;
+	memcpy(&mac->chandef, chandef, sizeof(mac->chandef));
+
+out:
+	return ret;
 }
 
 static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 4206886..806b88b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2358,3 +2358,41 @@ int qtnf_cmd_send_chan_switch(struct qtnf_wmac *mac,
 	qtnf_bus_unlock(mac->bus);
 	return ret;
 }
+
+int qtnf_cmd_get_channel(struct qtnf_vif *vif, struct cfg80211_chan_def *chdef)
+{
+	struct qtnf_bus *bus = vif->mac->bus;
+	const struct qlink_resp_channel_get *resp;
+	struct sk_buff *cmd_skb;
+	struct sk_buff *resp_skb = NULL;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	int ret;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_CHAN_GET,
+					    sizeof(struct qlink_cmd));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	qtnf_bus_lock(bus);
+
+	ret = qtnf_cmd_send_with_reply(bus, cmd_skb, &resp_skb, &res_code,
+				       sizeof(*resp), NULL);
+
+	qtnf_bus_unlock(bus);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		ret = -ENODATA;
+		goto out;
+	}
+
+	resp = (const struct qlink_resp_channel_get *)resp_skb->data;
+	qlink_chandef_q2cfg(priv_to_wiphy(vif->mac), &resp->chan, chdef);
+
+out:
+	consume_skb(resp_skb);
+	return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index 783b203..e1bcb83 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -75,5 +75,6 @@ int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u16 channel,
 			    struct qtnf_chan_stats *stats);
 int qtnf_cmd_send_chan_switch(struct qtnf_wmac *mac,
 			      struct cfg80211_csa_settings *params);
+int qtnf_cmd_get_channel(struct qtnf_vif *vif, struct cfg80211_chan_def *chdef);
 
 #endif /* QLINK_COMMANDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 5936854..fb88f3e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -169,6 +169,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_REG_NOTIFY		= 0x0019,
 	QLINK_CMD_CHANS_INFO_GET	= 0x001A,
 	QLINK_CMD_CHAN_SWITCH		= 0x001B,
+	QLINK_CMD_CHAN_GET		= 0x001C,
 	QLINK_CMD_CONFIG_AP		= 0x0020,
 	QLINK_CMD_START_AP		= 0x0021,
 	QLINK_CMD_STOP_AP		= 0x0022,
@@ -694,6 +695,16 @@ struct qlink_resp_get_chan_stats {
 	u8 info[0];
 } __packed;
 
+/**
+ * struct qlink_resp_channel_get - response for QLINK_CMD_CHAN_GET command
+ *
+ * @chan: definition of current operating channel.
+ */
+struct qlink_resp_channel_get {
+	struct qlink_resp rhdr;
+	struct qlink_chandef chan;
+} __packed;
+
 /* QLINK Events messages related definitions
  */
 
-- 
2.9.5
