Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:45504
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752935AbdJaBFK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 21:05:10 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, vulyanov@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 7/9] qtnfmac: configure and start AP interface with a single command
Date: Mon, 30 Oct 2017 18:04:53 -0700
Message-Id: <20171031010455.27772-8-igor.mitsyanko.os@quantenna.com> (sfid-20171031_020522_615317_CAF0B323)
In-Reply-To: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
References: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Current logic artificially divides "start AP" procedure into three
stages:
- generic interface configuration (security, channel etc)
- IE's processing
- enable AP mode on interface

This separation would not allow to do a proper device configuration as
first stage needs to use information from IEs that are processed on
a second stage. Which means first and second stages have to be meged.
In that case there is no point anymore to keep third stage either, so
merge all three into a single command.

This new command carries all the same info as contained in
"struct cfg80211_ap_settings".

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 17 +-----
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 72 +++++++++++++----------
 drivers/net/wireless/quantenna/qtnfmac/commands.h |  5 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  5 +-
 4 files changed, 47 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 27b11dc..7d6dc76 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -271,26 +271,11 @@ static int qtnf_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
 	int ret;
 
-	ret = qtnf_cmd_send_config_ap(vif, settings);
-	if (ret) {
-		pr_err("VIF%u.%u: failed to push config to FW\n",
-		       vif->mac->macid, vif->vifid);
-		goto out;
-	}
-
-	ret = qtnf_mgmt_set_appie(vif, &settings->beacon);
-	if (ret) {
-		pr_err("VIF%u.%u: failed to add IEs to beacon\n",
-		       vif->mac->macid, vif->vifid);
-		goto out;
-	}
-
-	ret = qtnf_cmd_send_start_ap(vif);
+	ret = qtnf_cmd_send_start_ap(vif, settings);
 	if (ret)
 		pr_err("VIF%u.%u: failed to start AP\n", vif->mac->macid,
 		       vif->vifid);
 
-out:
 	return ret;
 }
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 294418c..5186116 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -162,56 +162,51 @@ static void qtnf_cmd_tlv_ie_set_add(struct sk_buff *cmd_skb, u8 frame_type,
 		memcpy(tlv->ie_data, buf, len);
 }
 
-int qtnf_cmd_send_start_ap(struct qtnf_vif *vif)
+static bool qtnf_cmd_start_ap_can_fit(const struct qtnf_vif *vif,
+				      const struct cfg80211_ap_settings *s)
 {
-	struct sk_buff *cmd_skb;
-	u16 res_code = QLINK_CMD_RESULT_OK;
-	int ret;
+	unsigned int len = sizeof(struct qlink_cmd_start_ap);
 
-	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
-					    QLINK_CMD_START_AP,
-					    sizeof(struct qlink_cmd));
-	if (unlikely(!cmd_skb))
-		return -ENOMEM;
+	len += s->ssid_len;
+	len += s->beacon.head_len;
+	len += s->beacon.tail_len;
+	len += s->beacon.beacon_ies_len;
+	len += s->beacon.proberesp_ies_len;
+	len += s->beacon.assocresp_ies_len;
+	len += s->beacon.probe_resp_len;
 
-	qtnf_bus_lock(vif->mac->bus);
-
-	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
+	if (cfg80211_chandef_valid(&s->chandef))
+		len += sizeof(struct qlink_tlv_chandef);
 
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret = -EFAULT;
-		goto out;
+	if (len > (sizeof(struct qlink_cmd) + QTNF_MAX_CMD_BUF_SIZE)) {
+		pr_err("VIF%u.%u: can not fit AP settings: %u\n",
+		       vif->mac->macid, vif->vifid, len);
+		return false;
 	}
 
-	netif_carrier_on(vif->netdev);
-
-out:
-	qtnf_bus_unlock(vif->mac->bus);
-	return ret;
+	return true;
 }
 
-int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
-			    const struct cfg80211_ap_settings *s)
+int qtnf_cmd_send_start_ap(struct qtnf_vif *vif,
+			   const struct cfg80211_ap_settings *s)
 {
 	struct sk_buff *cmd_skb;
-	struct qlink_cmd_config_ap *cmd;
+	struct qlink_cmd_start_ap *cmd;
 	struct qlink_auth_encr *aen;
 	u16 res_code = QLINK_CMD_RESULT_OK;
 	int ret;
 	int i;
 
+	if (!qtnf_cmd_start_ap_can_fit(vif, s))
+		return -E2BIG;
+
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
-					    QLINK_CMD_CONFIG_AP,
+					    QLINK_CMD_START_AP,
 					    sizeof(*cmd));
 	if (unlikely(!cmd_skb))
 		return -ENOMEM;
 
-	cmd = (struct qlink_cmd_config_ap *)cmd_skb->data;
+	cmd = (struct qlink_cmd_start_ap *)cmd_skb->data;
 	cmd->dtim_period = s->dtim_period;
 	cmd->beacon_interval = cpu_to_le16(s->beacon_interval);
 	cmd->hidden_ssid = qlink_hidden_ssid_nl2q(s->hidden_ssid);
@@ -256,6 +251,21 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
 		qlink_chandef_cfg2q(&s->chandef, &chtlv->chan);
 	}
 
+	qtnf_cmd_tlv_ie_set_add(cmd_skb, QLINK_IE_SET_BEACON_HEAD,
+				s->beacon.head, s->beacon.head_len);
+	qtnf_cmd_tlv_ie_set_add(cmd_skb, QLINK_IE_SET_BEACON_TAIL,
+				s->beacon.tail, s->beacon.tail_len);
+	qtnf_cmd_tlv_ie_set_add(cmd_skb, QLINK_IE_SET_BEACON_IES,
+				s->beacon.beacon_ies, s->beacon.beacon_ies_len);
+	qtnf_cmd_tlv_ie_set_add(cmd_skb, QLINK_IE_SET_PROBE_RESP,
+				s->beacon.probe_resp, s->beacon.probe_resp_len);
+	qtnf_cmd_tlv_ie_set_add(cmd_skb, QLINK_IE_SET_PROBE_RESP_IES,
+				s->beacon.proberesp_ies,
+				s->beacon.proberesp_ies_len);
+	qtnf_cmd_tlv_ie_set_add(cmd_skb, QLINK_IE_SET_ASSOC_RESP,
+				s->beacon.assocresp_ies,
+				s->beacon.assocresp_ies_len);
+
 	qtnf_bus_lock(vif->mac->bus);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
@@ -270,6 +280,8 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
 		goto out;
 	}
 
+	netif_carrier_on(vif->netdev);
+
 out:
 	qtnf_bus_unlock(vif->mac->bus);
 	return ret;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index d6fe3cc..d981a76 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -33,9 +33,8 @@ int qtnf_cmd_send_del_intf(struct qtnf_vif *vif);
 int qtnf_cmd_band_info_get(struct qtnf_wmac *mac,
 			   struct ieee80211_supported_band *band);
 int qtnf_cmd_send_regulatory_config(struct qtnf_wmac *mac, const char *alpha2);
-int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
-			    const struct cfg80211_ap_settings *s);
-int qtnf_cmd_send_start_ap(struct qtnf_vif *vif);
+int qtnf_cmd_send_start_ap(struct qtnf_vif *vif,
+			   const struct cfg80211_ap_settings *s);
 int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif);
 int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif, u16 frame_type, bool reg);
 int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u32 cookie, u16 flags,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 43ce451..e07f776 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -192,7 +192,6 @@ enum qlink_cmd_type {
 	QLINK_CMD_BAND_INFO_GET		= 0x001A,
 	QLINK_CMD_CHAN_SWITCH		= 0x001B,
 	QLINK_CMD_CHAN_GET		= 0x001C,
-	QLINK_CMD_CONFIG_AP		= 0x0020,
 	QLINK_CMD_START_AP		= 0x0021,
 	QLINK_CMD_STOP_AP		= 0x0022,
 	QLINK_CMD_GET_STA_INFO		= 0x0030,
@@ -542,7 +541,7 @@ enum qlink_hidden_ssid {
 };
 
 /**
- * struct qlink_cmd_config_ap - data for QLINK_CMD_CONFIG_AP command
+ * struct qlink_cmd_start_ap - data for QLINK_CMD_START_AP command
  *
  * @beacon_interval: beacon interval
  * @inactivity_timeout: station's inactivity period in seconds
@@ -554,7 +553,7 @@ enum qlink_hidden_ssid {
  * @aen: encryption info
  * @info: variable configurations
  */
-struct qlink_cmd_config_ap {
+struct qlink_cmd_start_ap {
 	struct qlink_cmd chdr;
 	__le16 beacon_interval;
 	__le16 inactivity_timeout;
-- 
2.9.5
