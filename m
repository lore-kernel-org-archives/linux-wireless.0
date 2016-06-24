Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35777 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbcFXIOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2016 04:14:51 -0400
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: johannes@sipsolutions.net, johannes.berg@intel.com,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH] mac80211_hwsim: Added vendor echo command
Date: Fri, 24 Jun 2016 10:13:54 +0200
Message-Id: <1466756034-5485-1-git-send-email-erik.stromdahl@gmail.com> (sfid-20160624_101501_108220_9410D57D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The purpose of the echo command is to provide a test
facility for user space programs.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4dd5adc..2e17bf1 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -332,14 +332,16 @@ static const struct ieee80211_rate hwsim_rates[] = {
 
 #define OUI_QCA 0x001374
 #define QCA_NL80211_SUBCMD_TEST 1
+#define QCA_NL80211_SUBCMD_ECHO 2
 enum qca_nl80211_vendor_subcmds {
 	QCA_WLAN_VENDOR_ATTR_TEST = 8,
-	QCA_WLAN_VENDOR_ATTR_MAX = QCA_WLAN_VENDOR_ATTR_TEST
+	QCA_WLAN_VENDOR_ATTR_ECHO,
+	QCA_WLAN_VENDOR_ATTR_MAX = QCA_WLAN_VENDOR_ATTR_ECHO
 };
 
 static const struct nla_policy
 hwsim_vendor_test_policy[QCA_WLAN_VENDOR_ATTR_MAX + 1] = {
-	[QCA_WLAN_VENDOR_ATTR_MAX] = { .type = NLA_U32 },
+	[QCA_WLAN_VENDOR_ATTR_TEST] = { .type = NLA_U32 },
 };
 
 static int mac80211_hwsim_vendor_cmd_test(struct wiphy *wiphy,
@@ -393,12 +395,33 @@ static int mac80211_hwsim_vendor_cmd_test(struct wiphy *wiphy,
 	return cfg80211_vendor_cmd_reply(skb);
 }
 
+static int mac80211_hwsim_vendor_cmd_echo(struct wiphy *wiphy,
+					  struct wireless_dev *wdev,
+					  const void *data, int data_len)
+{
+	struct sk_buff *skb;
+
+	skb = cfg80211_vendor_cmd_alloc_reply_skb(wiphy, data_len);
+	if (!skb)
+		return -ENOMEM;
+
+	nla_put(skb, QCA_WLAN_VENDOR_ATTR_ECHO, data_len, data);
+
+	return cfg80211_vendor_cmd_reply(skb);
+}
+
 static struct wiphy_vendor_command mac80211_hwsim_vendor_commands[] = {
 	{
 		.info = { .vendor_id = OUI_QCA,
 			  .subcmd = QCA_NL80211_SUBCMD_TEST },
 		.flags = WIPHY_VENDOR_CMD_NEED_NETDEV,
 		.doit = mac80211_hwsim_vendor_cmd_test,
+	},
+	{
+		.info = { .vendor_id = OUI_QCA,
+			  .subcmd = QCA_NL80211_SUBCMD_ECHO },
+		.flags = WIPHY_VENDOR_CMD_NEED_NETDEV,
+		.doit = mac80211_hwsim_vendor_cmd_echo,
 	}
 };
 
-- 
1.7.9.5

