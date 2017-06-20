Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0063.outbound.protection.outlook.com ([104.47.34.63]:57766
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751002AbdFTTzu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 15:55:50 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 1/8] qtnfmac: updates and fixes for regulatory support
Date: Tue, 20 Jun 2017 22:55:10 +0300
Message-Id: <20170620195517.18373-2-sergey.matyukevich.os@quantenna.com> (sfid-20170620_215556_154558_C7E4A89A)
In-Reply-To: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces several changes for regulatory support
in qtnfmac driver:

* Introduce support for setting regdomain from host
New command is implemented to notify firmware about regdomain changes
performed by host. Firmware is supposed to check requested regdomain
changes. On success firmware enables updated hardware channel
configuration and then host driver updates channel info for each band.

* Introduce support of custom regulatory rules
Obtain custom regulatory rules from the firmware and
enable them during wiphy registration

* Regulatory for self-managed setup
Regdomain information needs to be registered with cfg80211
for devices with REGULATORY_WIPHY_SELF_MANAGED flag set.

* Misc fixes in regulatory code paths
  - add missing lock in qtnf_cmd_get_mac_chan_info
  - do not free band channel structure if channel count is the same
  - free allocated regdomain hw_info.rd structure on detach

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  83 +++----
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 286 ++++++++++++++++++----
 drivers/net/wireless/quantenna/qtnfmac/commands.h |   1 +
 drivers/net/wireless/quantenna/qtnfmac/core.c     |   3 +
 drivers/net/wireless/quantenna/qtnfmac/core.h     |   7 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 126 +++++++++-
 6 files changed, 403 insertions(+), 103 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index e3c090008125..825a6334fbfe 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -700,67 +700,45 @@ static struct cfg80211_ops qtn_cfg80211_ops = {
 	.disconnect		= qtnf_disconnect
 };
 
-static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy,
+static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
 				       struct regulatory_request *req)
 {
-	struct qtnf_wmac *mac = wiphy_priv(wiphy);
-	struct qtnf_bus *bus;
-	struct qtnf_vif *vif;
-	struct qtnf_wmac *chan_mac;
-	int i;
+	struct qtnf_wmac *mac = wiphy_priv(wiphy_in);
+	struct wiphy *wiphy;
+	struct qtnf_bus *bus = mac->bus;
+	unsigned int mac_idx;
 	enum nl80211_band band;
-
-	bus = mac->bus;
+	int ret;
 
 	pr_debug("MAC%u: initiator=%d alpha=%c%c\n", mac->macid, req->initiator,
 		 req->alpha2[0], req->alpha2[1]);
 
-	vif = qtnf_mac_get_base_vif(mac);
-	if (!vif) {
-		pr_err("MAC%u: primary VIF is not configured\n", mac->macid);
-		return;
-	}
-
-	/* ignore non-ISO3166 country codes */
-	for (i = 0; i < sizeof(req->alpha2); i++) {
-		if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
-			pr_err("MAC%u: not an ISO3166 code\n", mac->macid);
-			return;
-		}
-	}
-	if (!strncasecmp(req->alpha2, bus->hw_info.alpha2_code,
-			 sizeof(req->alpha2))) {
-		pr_warn("MAC%u: unchanged country code\n", mac->macid);
-		return;
-	}
-
-	if (qtnf_cmd_send_regulatory_config(mac, req->alpha2)) {
-		pr_err("MAC%u: failed to configure regulatory\n", mac->macid);
+	ret = qtnf_cmd_reg_notify(bus, req);
+	if (ret) {
+		if (ret != -EOPNOTSUPP && ret != -EALREADY)
+			pr_err("failed to update reg domain to %c%c\n",
+			       req->alpha2[0], req->alpha2[1]);
 		return;
 	}
 
-	for (i = 0; i < bus->hw_info.num_mac; i++) {
-		chan_mac = bus->mac[i];
-
-		if (!chan_mac)
+	for (mac_idx = 0; mac_idx < QTNF_MAX_MAC; ++mac_idx) {
+		if (!(bus->hw_info.mac_bitmap & (1 << mac_idx)))
 			continue;
 
-		if (!(bus->hw_info.mac_bitmap & BIT(i)))
-			continue;
+		mac = bus->mac[mac_idx];
+		wiphy = priv_to_wiphy(mac);
 
 		for (band = 0; band < NUM_NL80211_BANDS; ++band) {
 			if (!wiphy->bands[band])
 				continue;
 
-			if (qtnf_cmd_get_mac_chan_info(chan_mac,
-						       wiphy->bands[band])) {
-				pr_err("MAC%u: can't get channel info\n",
-				       chan_mac->macid);
-				qtnf_core_detach(bus);
-
-				return;
-			}
+			ret = qtnf_cmd_get_mac_chan_info(mac,
+							 wiphy->bands[band]);
+			if (ret)
+				pr_err("failed to get chan info for mac %u band %u\n",
+				       mac_idx, band);
 		}
+
 	}
 }
 
@@ -889,21 +867,26 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	ether_addr_copy(wiphy->perm_addr, mac->macaddr);
 
 	if (hw_info->hw_capab & QLINK_HW_SUPPORTS_REG_UPDATE) {
-		pr_debug("device supports REG_UPDATE\n");
+		wiphy->regulatory_flags |= REGULATORY_STRICT_REG |
+			REGULATORY_CUSTOM_REG;
 		wiphy->reg_notifier = qtnf_cfg80211_reg_notifier;
-		pr_debug("hint regulatory about EP region: %c%c\n",
-			 hw_info->alpha2_code[0],
-			 hw_info->alpha2_code[1]);
-		regulatory_hint(wiphy, hw_info->alpha2_code);
+		wiphy_apply_custom_regulatory(wiphy, hw_info->rd);
 	} else {
-		pr_debug("device doesn't support REG_UPDATE\n");
 		wiphy->regulatory_flags |= REGULATORY_WIPHY_SELF_MANAGED;
 	}
 
 	ret = wiphy_register(wiphy);
+	if (ret < 0)
+		goto out;
+
+	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+		ret = regulatory_set_wiphy_regd(wiphy, hw_info->rd);
+	else if (isalpha(hw_info->rd->alpha2[0]) &&
+		 isalpha(hw_info->rd->alpha2[1]))
+		ret = regulatory_hint(wiphy, hw_info->rd->alpha2);
 
 out:
-	if (ret < 0) {
+	if (ret) {
 		kfree(iface_comb);
 		return ret;
 	}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index cce62f39edaf..2ee007ecb236 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -181,38 +181,6 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif)
 	return ret;
 }
 
-int qtnf_cmd_send_regulatory_config(struct qtnf_wmac *mac, const char *alpha2)
-{
-	struct sk_buff *cmd_skb;
-	u16 res_code = QLINK_CMD_RESULT_OK;
-	int ret;
-
-	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
-					    QLINK_CMD_REG_REGION,
-					    sizeof(struct qlink_cmd));
-	if (unlikely(!cmd_skb))
-		return -ENOMEM;
-
-	qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_COUNTRY, alpha2,
-				 QTNF_MAX_ALPHA_LEN);
-
-	ret = qtnf_cmd_send(mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
-		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
-		ret = -EFAULT;
-		goto out;
-	}
-
-	memcpy(mac->bus->hw_info.alpha2_code, alpha2,
-	       sizeof(mac->bus->hw_info.alpha2_code));
-out:
-	return ret;
-}
-
 int qtnf_cmd_send_config_ap(struct qtnf_vif *vif)
 {
 	struct sk_buff *cmd_skb;
@@ -850,28 +818,175 @@ int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
 	return ret;
 }
 
+static u32 qtnf_cmd_resp_reg_rule_flags_parse(u32 qflags)
+{
+	u32 flags = 0;
+
+	if (qflags & QLINK_RRF_NO_OFDM)
+		flags |= NL80211_RRF_NO_OFDM;
+
+	if (qflags & QLINK_RRF_NO_CCK)
+		flags |= NL80211_RRF_NO_CCK;
+
+	if (qflags & QLINK_RRF_NO_INDOOR)
+		flags |= NL80211_RRF_NO_INDOOR;
+
+	if (qflags & QLINK_RRF_NO_OUTDOOR)
+		flags |= NL80211_RRF_NO_OUTDOOR;
+
+	if (qflags & QLINK_RRF_DFS)
+		flags |= NL80211_RRF_DFS;
+
+	if (qflags & QLINK_RRF_PTP_ONLY)
+		flags |= NL80211_RRF_PTP_ONLY;
+
+	if (qflags & QLINK_RRF_PTMP_ONLY)
+		flags |= NL80211_RRF_PTMP_ONLY;
+
+	if (qflags & QLINK_RRF_NO_IR)
+		flags |= NL80211_RRF_NO_IR;
+
+	if (qflags & QLINK_RRF_AUTO_BW)
+		flags |= NL80211_RRF_AUTO_BW;
+
+	if (qflags & QLINK_RRF_IR_CONCURRENT)
+		flags |= NL80211_RRF_IR_CONCURRENT;
+
+	if (qflags & QLINK_RRF_NO_HT40MINUS)
+		flags |= NL80211_RRF_NO_HT40MINUS;
+
+	if (qflags & QLINK_RRF_NO_HT40PLUS)
+		flags |= NL80211_RRF_NO_HT40PLUS;
+
+	if (qflags & QLINK_RRF_NO_80MHZ)
+		flags |= NL80211_RRF_NO_80MHZ;
+
+	if (qflags & QLINK_RRF_NO_160MHZ)
+		flags |= NL80211_RRF_NO_160MHZ;
+
+	return flags;
+}
+
 static int
 qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
-			   const struct qlink_resp_get_hw_info *resp)
+			   const struct qlink_resp_get_hw_info *resp,
+			   size_t info_len)
 {
 	struct qtnf_hw_info *hwinfo = &bus->hw_info;
+	const struct qlink_tlv_hdr *tlv;
+	const struct qlink_tlv_reg_rule *tlv_rule;
+	struct ieee80211_reg_rule *rule;
+	u16 tlv_type;
+	u16 tlv_value_len;
+	unsigned int rule_idx = 0;
+
+	if (WARN_ON(resp->n_reg_rules > NL80211_MAX_SUPP_REG_RULES))
+		return -E2BIG;
+
+	hwinfo->rd = kzalloc(sizeof(*hwinfo->rd)
+			     + sizeof(struct ieee80211_reg_rule)
+			     * resp->n_reg_rules, GFP_KERNEL);
+
+	if (!hwinfo->rd)
+		return -ENOMEM;
 
 	hwinfo->num_mac = resp->num_mac;
 	hwinfo->mac_bitmap = resp->mac_bitmap;
 	hwinfo->fw_ver = le32_to_cpu(resp->fw_ver);
 	hwinfo->ql_proto_ver = le16_to_cpu(resp->ql_proto_ver);
-	memcpy(hwinfo->alpha2_code, resp->alpha2_code,
-	       sizeof(hwinfo->alpha2_code));
 	hwinfo->total_tx_chain = resp->total_tx_chain;
 	hwinfo->total_rx_chain = resp->total_rx_chain;
 	hwinfo->hw_capab = le32_to_cpu(resp->hw_capab);
+	hwinfo->rd->n_reg_rules = resp->n_reg_rules;
+	hwinfo->rd->alpha2[0] = resp->alpha2[0];
+	hwinfo->rd->alpha2[1] = resp->alpha2[1];
+
+	switch (resp->dfs_region) {
+	case QLINK_DFS_FCC:
+		hwinfo->rd->dfs_region = NL80211_DFS_FCC;
+		break;
+	case QLINK_DFS_ETSI:
+		hwinfo->rd->dfs_region = NL80211_DFS_ETSI;
+		break;
+	case QLINK_DFS_JP:
+		hwinfo->rd->dfs_region = NL80211_DFS_JP;
+		break;
+	case QLINK_DFS_UNSET:
+	default:
+		hwinfo->rd->dfs_region = NL80211_DFS_UNSET;
+		break;
+	}
+
+	tlv = (const struct qlink_tlv_hdr *)resp->info;
+
+	while (info_len >= sizeof(*tlv)) {
+		tlv_type = le16_to_cpu(tlv->type);
+		tlv_value_len = le16_to_cpu(tlv->len);
+
+		if (tlv_value_len + sizeof(*tlv) > info_len) {
+			pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
+				tlv_type, tlv_value_len);
+			goto err;
+		}
+
+		switch (tlv_type) {
+		case QTN_TLV_ID_REG_RULE:
+			if (rule_idx >= resp->n_reg_rules) {
+				pr_warn("unexpected number of rules: %u\n",
+					resp->n_reg_rules);
+				goto err;
+			}
+
+			if (tlv_value_len != sizeof(*tlv_rule) - sizeof(*tlv)) {
+				pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
+					tlv_type, tlv_value_len);
+				goto err;
+			}
+
+			tlv_rule = (const struct qlink_tlv_reg_rule *)tlv;
+			rule = &hwinfo->rd->reg_rules[rule_idx++];
+
+			rule->freq_range.start_freq_khz =
+				le32_to_cpu(tlv_rule->start_freq_khz);
+			rule->freq_range.end_freq_khz =
+				le32_to_cpu(tlv_rule->end_freq_khz);
+			rule->freq_range.max_bandwidth_khz =
+				le32_to_cpu(tlv_rule->max_bandwidth_khz);
+			rule->power_rule.max_antenna_gain =
+				le32_to_cpu(tlv_rule->max_antenna_gain);
+			rule->power_rule.max_eirp =
+				le32_to_cpu(tlv_rule->max_eirp);
+			rule->dfs_cac_ms =
+				le32_to_cpu(tlv_rule->dfs_cac_ms);
+			rule->flags = qtnf_cmd_resp_reg_rule_flags_parse(
+					le32_to_cpu(tlv_rule->flags));
+			break;
+		default:
+			break;
+		}
+
+		info_len -= tlv_value_len + sizeof(*tlv);
+		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
+	}
+
+	if (rule_idx != resp->n_reg_rules) {
+		pr_warn("unexpected number of rules: expected %u got %u\n",
+			resp->n_reg_rules, rule_idx);
+		goto err;
+	}
 
 	pr_info("fw_version=%d, MACs map %#x, alpha2=\"%c%c\", chains Tx=%u Rx=%u\n",
 		hwinfo->fw_ver, hwinfo->mac_bitmap,
-		hwinfo->alpha2_code[0], hwinfo->alpha2_code[1],
+		hwinfo->rd->alpha2[0], hwinfo->rd->alpha2[1],
 		hwinfo->total_tx_chain, hwinfo->total_rx_chain);
 
 	return 0;
+
+err:
+	kfree(hwinfo->rd);
+	hwinfo->rd = NULL;
+
+	return -EINVAL;
 }
 
 static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
@@ -1015,14 +1130,24 @@ qtnf_cmd_resp_fill_channels_info(struct ieee80211_supported_band *band,
 	unsigned int chidx = 0;
 	u32 qflags;
 
-	kfree(band->channels);
-	band->channels = NULL;
+	if (band->channels) {
+		if (band->n_channels == resp->num_chans) {
+			memset(band->channels, 0,
+			       sizeof(*band->channels) * band->n_channels);
+		} else {
+			kfree(band->channels);
+			band->n_channels = 0;
+			band->channels = NULL;
+		}
+	}
 
 	band->n_channels = resp->num_chans;
 	if (band->n_channels == 0)
 		return 0;
 
-	band->channels = kcalloc(band->n_channels, sizeof(*chan), GFP_KERNEL);
+	if (!band->channels)
+		band->channels = kcalloc(band->n_channels, sizeof(*chan),
+					 GFP_KERNEL);
 	if (!band->channels) {
 		band->n_channels = 0;
 		return -ENOMEM;
@@ -1258,6 +1383,7 @@ int qtnf_cmd_get_hw_info(struct qtnf_bus *bus)
 	const struct qlink_resp_get_hw_info *resp;
 	u16 res_code = QLINK_CMD_RESULT_OK;
 	int ret = 0;
+	size_t info_len;
 
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
 					    QLINK_CMD_GET_HW_INFO,
@@ -1268,7 +1394,7 @@ int qtnf_cmd_get_hw_info(struct qtnf_bus *bus)
 	qtnf_bus_lock(bus);
 
 	ret = qtnf_cmd_send_with_reply(bus, cmd_skb, &resp_skb, &res_code,
-				       sizeof(*resp), NULL);
+				       sizeof(*resp), &info_len);
 
 	if (unlikely(ret))
 		goto out;
@@ -1280,7 +1406,7 @@ int qtnf_cmd_get_hw_info(struct qtnf_bus *bus)
 	}
 
 	resp = (const struct qlink_resp_get_hw_info *)resp_skb->data;
-	ret = qtnf_cmd_resp_proc_hw_info(bus, resp);
+	ret = qtnf_cmd_resp_proc_hw_info(bus, resp, info_len);
 
 out:
 	qtnf_bus_unlock(bus);
@@ -1322,6 +1448,9 @@ int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac,
 
 	cmd = (struct qlink_cmd_chans_info_get *)cmd_skb->data;
 	cmd->band = qband;
+
+	qtnf_bus_lock(mac->bus);
+
 	ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb, &res_code,
 				       sizeof(*resp), &info_len);
 
@@ -1345,6 +1474,7 @@ int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac,
 	ret = qtnf_cmd_resp_fill_channels_info(band, resp, info_len);
 
 out:
+	qtnf_bus_unlock(mac->bus);
 	consume_skb(resp_skb);
 
 	return ret;
@@ -1980,3 +2110,77 @@ int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif, bool up)
 	qtnf_bus_unlock(vif->mac->bus);
 	return ret;
 }
+
+int qtnf_cmd_reg_notify(struct qtnf_bus *bus, struct regulatory_request *req)
+{
+	struct sk_buff *cmd_skb;
+	int ret;
+	u16 res_code;
+	struct qlink_cmd_reg_notify *cmd;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
+					    QLINK_CMD_REG_NOTIFY,
+					    sizeof(*cmd));
+	if (!cmd_skb)
+		return -ENOMEM;
+
+	cmd = (struct qlink_cmd_reg_notify *)cmd_skb->data;
+	cmd->alpha2[0] = req->alpha2[0];
+	cmd->alpha2[1] = req->alpha2[1];
+
+	switch (req->initiator) {
+	case NL80211_REGDOM_SET_BY_CORE:
+		cmd->initiator = QLINK_REGDOM_SET_BY_CORE;
+		break;
+	case NL80211_REGDOM_SET_BY_USER:
+		cmd->initiator = QLINK_REGDOM_SET_BY_USER;
+		break;
+	case NL80211_REGDOM_SET_BY_DRIVER:
+		cmd->initiator = QLINK_REGDOM_SET_BY_DRIVER;
+		break;
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		cmd->initiator = QLINK_REGDOM_SET_BY_COUNTRY_IE;
+		break;
+	}
+
+	switch (req->user_reg_hint_type) {
+	case NL80211_USER_REG_HINT_USER:
+		cmd->user_reg_hint_type = QLINK_USER_REG_HINT_USER;
+		break;
+	case NL80211_USER_REG_HINT_CELL_BASE:
+		cmd->user_reg_hint_type = QLINK_USER_REG_HINT_CELL_BASE;
+		break;
+	case NL80211_USER_REG_HINT_INDOOR:
+		cmd->user_reg_hint_type = QLINK_USER_REG_HINT_INDOOR;
+		break;
+	}
+
+	qtnf_bus_lock(bus);
+
+	ret = qtnf_cmd_send(bus, cmd_skb, &res_code);
+	if (ret)
+		goto out;
+
+	switch (res_code) {
+	case QLINK_CMD_RESULT_ENOTSUPP:
+		pr_warn("reg update not supported\n");
+		ret = -EOPNOTSUPP;
+		break;
+	case QLINK_CMD_RESULT_EALREADY:
+		pr_info("regulatory domain is already set to %c%c",
+			req->alpha2[0], req->alpha2[1]);
+		ret = -EALREADY;
+		break;
+	case QLINK_CMD_RESULT_OK:
+		ret = 0;
+		break;
+	default:
+		ret = -EFAULT;
+		break;
+	}
+
+out:
+	qtnf_bus_unlock(bus);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index 6c51854ef5e7..155b265d42bf 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -70,5 +70,6 @@ int qtnf_cmd_send_disconnect(struct qtnf_vif *vif,
 			     u16 reason_code);
 int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif,
 			      bool up);
+int qtnf_cmd_reg_notify(struct qtnf_bus *bus, struct regulatory_request *req);
 
 #endif /* QLINK_COMMANDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index c5ac252464f4..21cbe6dcf6fa 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -549,6 +549,9 @@ void qtnf_core_detach(struct qtnf_bus *bus)
 		destroy_workqueue(bus->workqueue);
 	}
 
+	kfree(bus->hw_info.rd);
+	bus->hw_info.rd = NULL;
+
 	qtnf_trans_free(bus);
 }
 EXPORT_SYMBOL_GPL(qtnf_core_detach);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index a616434281cf..31b7ec2bfd3e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -42,7 +42,6 @@
 
 #define QTNF_MAX_SSID_LIST_LENGTH	2
 #define QTNF_MAX_VSIE_LEN		255
-#define QTNF_MAX_ALPHA_LEN		2
 #define QTNF_MAX_INTF			8
 #define QTNF_MAX_EVENT_QUEUE_LEN	255
 #define QTNF_DEFAULT_BG_SCAN_PERIOD	300
@@ -136,14 +135,14 @@ struct qtnf_wmac {
 };
 
 struct qtnf_hw_info {
+	u16 ql_proto_ver;
 	u8 num_mac;
 	u8 mac_bitmap;
-	u8 alpha2_code[QTNF_MAX_ALPHA_LEN];
 	u32 fw_ver;
-	u16 ql_proto_ver;
+	u32 hw_capab;
+	struct ieee80211_regdomain *rd;
 	u8 total_tx_chain;
 	u8 total_rx_chain;
-	u32 hw_capab;
 };
 
 struct qtnf_vif *qtnf_mac_get_free_vif(struct qtnf_wmac *mac);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 6eafc15e0065..e27833b78940 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -19,7 +19,7 @@
 
 #include <linux/ieee80211.h>
 
-#define QLINK_PROTO_VER		3
+#define QLINK_PROTO_VER		4
 
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -133,6 +133,9 @@ enum qlink_channel_width {
  *	number of operational channels and information on each of the channel.
  *	This command is generic to a specified MAC, interface index must be set
  *	to QLINK_VIFID_RSVD in command header.
+ * @QLINK_CMD_REG_NOTIFY: notify device about regulatory domain change. This
+ *	command is supported only if device reports QLINK_HW_SUPPORTS_REG_UPDATE
+ *	capability.
  */
 enum qlink_cmd_type {
 	QLINK_CMD_FW_INIT		= 0x0001,
@@ -148,7 +151,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_DEL_INTF		= 0x0016,
 	QLINK_CMD_CHANGE_INTF		= 0x0017,
 	QLINK_CMD_UPDOWN_INTF		= 0x0018,
-	QLINK_CMD_REG_REGION		= 0x0019,
+	QLINK_CMD_REG_NOTIFY		= 0x0019,
 	QLINK_CMD_CHANS_INFO_GET	= 0x001A,
 	QLINK_CMD_CONFIG_AP		= 0x0020,
 	QLINK_CMD_START_AP		= 0x0021,
@@ -430,6 +433,44 @@ struct qlink_cmd_chans_info_get {
 	u8 band;
 } __packed;
 
+/**
+ * enum qlink_reg_initiator - Indicates the initiator of a reg domain request
+ *
+ * See &enum nl80211_reg_initiator for more info.
+ */
+enum qlink_reg_initiator {
+	QLINK_REGDOM_SET_BY_CORE,
+	QLINK_REGDOM_SET_BY_USER,
+	QLINK_REGDOM_SET_BY_DRIVER,
+	QLINK_REGDOM_SET_BY_COUNTRY_IE,
+};
+
+/**
+ * enum qlink_user_reg_hint_type - type of user regulatory hint
+ *
+ * See &enum nl80211_user_reg_hint_type for more info.
+ */
+enum qlink_user_reg_hint_type {
+	QLINK_USER_REG_HINT_USER	= 0,
+	QLINK_USER_REG_HINT_CELL_BASE	= 1,
+	QLINK_USER_REG_HINT_INDOOR	= 2,
+};
+
+/**
+ * struct qlink_cmd_reg_notify - data for QLINK_CMD_REG_NOTIFY command
+ *
+ * @alpha2: the ISO / IEC 3166 alpha2 country code.
+ * @initiator: which entity sent the request, one of &enum qlink_reg_initiator.
+ * @user_reg_hint_type: type of hint for QLINK_REGDOM_SET_BY_USER request, one
+ *	of &enum qlink_user_reg_hint_type.
+ */
+struct qlink_cmd_reg_notify {
+	struct qlink_cmd chdr;
+	u8 alpha2[2];
+	u8 initiator;
+	u8 user_reg_hint_type;
+} __packed;
+
 /* QLINK Command Responses messages related definitions
  */
 
@@ -438,6 +479,7 @@ enum qlink_cmd_result {
 	QLINK_CMD_RESULT_INVALID,
 	QLINK_CMD_RESULT_ENOTSUPP,
 	QLINK_CMD_RESULT_ENOTFOUND,
+	QLINK_CMD_RESULT_EALREADY,
 };
 
 /**
@@ -497,6 +539,18 @@ struct qlink_resp_get_mac_info {
 } __packed;
 
 /**
+ * enum qlink_dfs_regions - regulatory DFS regions
+ *
+ * Corresponds to &enum nl80211_dfs_regions.
+ */
+enum qlink_dfs_regions {
+	QLINK_DFS_UNSET	= 0,
+	QLINK_DFS_FCC	= 1,
+	QLINK_DFS_ETSI	= 2,
+	QLINK_DFS_JP	= 3,
+};
+
+/**
  * struct qlink_resp_get_hw_info - response for QLINK_CMD_GET_HW_INFO command
  *
  * Description of wireless hardware capabilities and features.
@@ -504,22 +558,29 @@ struct qlink_resp_get_mac_info {
  * @fw_ver: wireless hardware firmware version.
  * @hw_capab: Bitmap of capabilities supported by firmware.
  * @ql_proto_ver: Version of QLINK protocol used by firmware.
- * @country_code: country code ID firmware is configured to.
  * @num_mac: Number of separate physical radio devices provided by hardware.
  * @mac_bitmap: Bitmap of MAC IDs that are active and can be used in firmware.
  * @total_tx_chains: total number of transmit chains used by device.
  * @total_rx_chains: total number of receive chains.
+ * @alpha2: country code ID firmware is configured to.
+ * @n_reg_rules: number of regulatory rules TLVs in variable portion of the
+ *	message.
+ * @dfs_region: regulatory DFS region, one of @enum qlink_dfs_region.
+ * @info: variable-length HW info, can contain QTN_TLV_ID_REG_RULE.
  */
 struct qlink_resp_get_hw_info {
 	struct qlink_resp rhdr;
 	__le32 fw_ver;
 	__le32 hw_capab;
 	__le16 ql_proto_ver;
-	u8 alpha2_code[2];
 	u8 num_mac;
 	u8 mac_bitmap;
 	u8 total_tx_chain;
 	u8 total_rx_chain;
+	u8 alpha2[2];
+	u8 n_reg_rules;
+	u8 dfs_region;
+	u8 info[0];
 } __packed;
 
 /**
@@ -741,6 +802,7 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_LRETRY_LIMIT		= 0x0204,
 	QTN_TLV_ID_BCN_PERIOD		= 0x0205,
 	QTN_TLV_ID_DTIM			= 0x0206,
+	QTN_TLV_ID_REG_RULE		= 0x0207,
 	QTN_TLV_ID_CHANNEL		= 0x020F,
 	QTN_TLV_ID_COVERAGE_CLASS	= 0x0213,
 	QTN_TLV_ID_IFACE_LIMIT		= 0x0214,
@@ -844,12 +906,54 @@ struct qlink_tlv_cclass {
 	u8 cclass;
 } __packed;
 
-enum qlink_dfs_state {
-	QLINK_DFS_USABLE,
-	QLINK_DFS_UNAVAILABLE,
-	QLINK_DFS_AVAILABLE,
+/**
+ * enum qlink_reg_rule_flags - regulatory rule flags
+ *
+ * See description of &enum nl80211_reg_rule_flags
+ */
+enum qlink_reg_rule_flags {
+	QLINK_RRF_NO_OFDM	= BIT(0),
+	QLINK_RRF_NO_CCK	= BIT(1),
+	QLINK_RRF_NO_INDOOR	= BIT(2),
+	QLINK_RRF_NO_OUTDOOR	= BIT(3),
+	QLINK_RRF_DFS		= BIT(4),
+	QLINK_RRF_PTP_ONLY	= BIT(5),
+	QLINK_RRF_PTMP_ONLY	= BIT(6),
+	QLINK_RRF_NO_IR		= BIT(7),
+	QLINK_RRF_AUTO_BW	= BIT(8),
+	QLINK_RRF_IR_CONCURRENT	= BIT(9),
+	QLINK_RRF_NO_HT40MINUS	= BIT(10),
+	QLINK_RRF_NO_HT40PLUS	= BIT(11),
+	QLINK_RRF_NO_80MHZ	= BIT(12),
+	QLINK_RRF_NO_160MHZ	= BIT(13),
 };
 
+/**
+ * struct qlink_tlv_reg_rule - data for QTN_TLV_ID_REG_RULE TLV
+ *
+ * Regulatory rule description.
+ *
+ * @start_freq_khz: start frequency of the range the rule is attributed to.
+ * @end_freq_khz: end frequency of the range the rule is attributed to.
+ * @max_bandwidth_khz: max bandwidth that channels in specified range can be
+ *	configured to.
+ * @max_antenna_gain: max antenna gain that can be used in the specified
+ *	frequency range, dBi.
+ * @max_eirp: maximum EIRP.
+ * @flags: regulatory rule flags in &enum qlink_reg_rule_flags.
+ * @dfs_cac_ms: DFS CAC period.
+ */
+struct qlink_tlv_reg_rule {
+	struct qlink_tlv_hdr hdr;
+	__le32 start_freq_khz;
+	__le32 end_freq_khz;
+	__le32 max_bandwidth_khz;
+	__le32 max_antenna_gain;
+	__le32 max_eirp;
+	__le32 flags;
+	__le32 dfs_cac_ms;
+} __packed;
+
 enum qlink_channel_flags {
 	QLINK_CHAN_DISABLED		= BIT(0),
 	QLINK_CHAN_NO_IR		= BIT(1),
@@ -865,6 +969,12 @@ enum qlink_channel_flags {
 	QLINK_CHAN_NO_10MHZ		= BIT(12),
 };
 
+enum qlink_dfs_state {
+	QLINK_DFS_USABLE,
+	QLINK_DFS_UNAVAILABLE,
+	QLINK_DFS_AVAILABLE,
+};
+
 struct qlink_tlv_channel {
 	struct qlink_tlv_hdr hdr;
 	__le16 hw_value;
-- 
2.11.0
