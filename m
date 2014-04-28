Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5395 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaD1IWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 04:22:31 -0400
Date: Mon, 28 Apr 2014 11:22:25 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] mac80211: Support dynamic AP mode channel width changes
Message-ID: <20140428082225.GA15459@jouni.qca.qualcomm.com> (sfid-20140428_102235_742637_6457CF01)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the new cfg80211 capability to enable mac80211-based drivers
to support for dynamic channel bandwidth changes (e.g., HT 20/40 MHz
changes).

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/cfg.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aaa59d7..1ce407a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3949,6 +3949,21 @@ static int ieee80211_set_qos_map(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_ap_channel(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	int ret;
+	u32 changed = 0;
+
+	ret = ieee80211_vif_change_bandwidth(sdata, chandef, &changed);
+	if (ret == 0)
+		ieee80211_bss_info_change_notify(sdata, changed);
+
+	return ret;
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -4029,4 +4044,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.start_radar_detection = ieee80211_start_radar_detection,
 	.channel_switch = ieee80211_channel_switch,
 	.set_qos_map = ieee80211_set_qos_map,
+	.set_ap_channel = ieee80211_set_ap_channel,
 };
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
