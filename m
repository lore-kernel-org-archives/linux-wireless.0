Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab2E3M7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 08:59:40 -0400
Message-ID: <1338382776.4511.15.camel@jlt3.sipsolutions.net> (sfid-20120530_145944_226954_0E2A121B)
Subject: [PATCH] mac80211_hwsim: advertise interface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Nirav Shah <nirav.j2.shah@intel.com>
Date: Wed, 30 May 2012 14:59:36 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Enforcing interface combinations broke uses of hwsim
with multiple virtual interfaces. Advertise that all
combinations are possible to fix this.

Reported-by: Nirav Shah <nirav.j2.shah@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/net/wireless/mac80211_hwsim.c	2012-05-29 21:12:48.000000000 +0200
+++ b/drivers/net/wireless/mac80211_hwsim.c	2012-05-30 14:58:07.000000000 +0200
@@ -1721,6 +1721,24 @@ static void hwsim_exit_netlink(void)
 		       "unregister family %i\n", ret);
 }
 
+static const struct ieee80211_iface_limit hwsim_if_limits[] = {
+	{ .max = 1, .types = BIT(NL80211_IFTYPE_ADHOC) },
+	{ .max = 2048,  .types = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
+#ifdef CONFIG_MAC80211_MESH
+				 BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+				 BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_P2P_GO) },
+};
+
+static const struct ieee80211_iface_combination hwsim_if_comb = {
+	.limits = hwsim_if_limits,
+	.n_limits = ARRAY_SIZE(hwsim_if_limits),
+	.max_interfaces = 2048,
+	.num_different_channels = 1,
+};
+
 static int __init init_mac80211_hwsim(void)
 {
 	int i, err = 0;
@@ -1782,6 +1800,9 @@ static int __init init_mac80211_hwsim(vo
 		hw->wiphy->n_addresses = 2;
 		hw->wiphy->addresses = data->addresses;
 
+		hw->wiphy->iface_combinations = &hwsim_if_comb;
+		hw->wiphy->n_iface_combinations = 1;
+
 		if (fake_hw_scan) {
 			hw->wiphy->max_scan_ssids = 255;
 			hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;


