Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2120 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbbBZN1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 08:27:16 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 2/2] mac80211_hwsim: Add minimal capability for vendor command/event testing
Date: Thu, 26 Feb 2015 15:26:54 +0200
Message-ID: <1424957214-6363-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20150226_142719_262392_6FC084E4)
In-Reply-To: <1424957214-6363-1-git-send-email-jouni@qca.qualcomm.com>
References: <1424957214-6363-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows wpa_supplicant/hostapd to send a vendor command and verify
response to that command and a vendor event.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
v2: rebased on top of updated cfg80211_vendor_event_alloc() changes

 drivers/net/wireless/mac80211_hwsim.c | 83 +++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e259ee1..32bd2f0 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -330,6 +330,83 @@ static const struct ieee80211_rate hwsim_rates[] = {
 	{ .bitrate = 540 }
 };
 
+#define OUI_QCA 0x001374
+#define QCA_NL80211_SUBCMD_TEST 1
+enum qca_nl80211_vendor_subcmds {
+	QCA_WLAN_VENDOR_ATTR_TEST = 8,
+	QCA_WLAN_VENDOR_ATTR_MAX = QCA_WLAN_VENDOR_ATTR_TEST
+};
+
+static const struct nla_policy
+hwsim_vendor_test_policy[QCA_WLAN_VENDOR_ATTR_MAX + 1] = {
+	[QCA_WLAN_VENDOR_ATTR_MAX] = { .type = NLA_U32 },
+};
+
+static int mac80211_hwsim_vendor_cmd_test(struct wiphy *wiphy,
+					  struct wireless_dev *wdev,
+					  const void *data, int data_len)
+{
+	struct sk_buff *skb;
+	struct nlattr *tb[QCA_WLAN_VENDOR_ATTR_MAX + 1];
+	int err;
+	u32 val;
+
+	err = nla_parse(tb, QCA_WLAN_VENDOR_ATTR_MAX, data, data_len,
+			hwsim_vendor_test_policy);
+	if (err)
+		return err;
+	if (!tb[QCA_WLAN_VENDOR_ATTR_TEST])
+		return -EINVAL;
+	val = nla_get_u32(tb[QCA_WLAN_VENDOR_ATTR_TEST]);
+	wiphy_debug(wiphy, "%s: test=%u\n", __func__, val);
+
+	/* Send a vendor event as a test. Note that this would not normally be
+	 * done within a command handler, but rather, based on some other
+	 * trigger. For simplicity, this command is used to trigger the event
+	 * here.
+	 *
+	 * event_idx = 0 (index in mac80211_hwsim_vendor_commands)
+	 */
+	skb = cfg80211_vendor_event_alloc(wiphy, wdev, 100, 0, GFP_KERNEL);
+	if (skb) {
+		/* skb_put() or nla_put() will fill up data within
+		 * NL80211_ATTR_VENDOR_DATA.
+		 */
+
+		/* Add vendor data */
+		nla_put_u32(skb, QCA_WLAN_VENDOR_ATTR_TEST, val + 1);
+
+		/* Send the event - this will call nla_nest_end() */
+		cfg80211_vendor_event(skb, GFP_KERNEL);
+	}
+
+	/* Send a response to the command */
+	skb = cfg80211_vendor_cmd_alloc_reply_skb(wiphy, 10);
+	if (!skb)
+		return -ENOMEM;
+
+	/* skb_put() or nla_put() will fill up data within
+	 * NL80211_ATTR_VENDOR_DATA
+	 */
+	nla_put_u32(skb, QCA_WLAN_VENDOR_ATTR_TEST, val + 2);
+
+	return cfg80211_vendor_cmd_reply(skb);
+}
+
+static struct wiphy_vendor_command mac80211_hwsim_vendor_commands[] = {
+	{
+		.info = { .vendor_id = OUI_QCA,
+			  .subcmd = QCA_NL80211_SUBCMD_TEST },
+		.flags = WIPHY_VENDOR_CMD_NEED_NETDEV,
+		.doit = mac80211_hwsim_vendor_cmd_test,
+	}
+};
+
+/* Advertise support vendor specific events */
+static const struct nl80211_vendor_cmd_info mac80211_hwsim_vendor_events[] = {
+	{ .vendor_id = OUI_QCA, .subcmd = 1 },
+};
+
 static const struct ieee80211_iface_limit hwsim_if_limits[] = {
 	{ .max = 1, .types = BIT(NL80211_IFTYPE_ADHOC) },
 	{ .max = 2048,  .types = BIT(NL80211_IFTYPE_STATION) |
@@ -2416,6 +2493,12 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	hw->max_rates = 4;
 	hw->max_rate_tries = 11;
 
+	hw->wiphy->vendor_commands = mac80211_hwsim_vendor_commands;
+	hw->wiphy->n_vendor_commands =
+		ARRAY_SIZE(mac80211_hwsim_vendor_commands);
+	hw->wiphy->vendor_events = mac80211_hwsim_vendor_events;
+	hw->wiphy->n_vendor_events = ARRAY_SIZE(mac80211_hwsim_vendor_events);
+
 	if (param->reg_strict)
 		hw->wiphy->regulatory_flags |= REGULATORY_STRICT_REG;
 	if (param->regd) {
-- 
1.9.1

