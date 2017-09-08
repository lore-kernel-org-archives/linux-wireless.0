Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:32077 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753183AbdIHOQq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 10:16:46 -0400
Content-Type: text/plain
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [RFC 4/4] mac80211_hwsim: add radio idx param to netlink callback of radio creation
Date: Fri, 8 Sep 2017 16:11:37 +0200
In-Reply-To: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de>
References: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Message-ID: <c6eda3a2-ad9b-4c33-b3c8-ddc36199ea3e@MAIL1.uni-rostock.de> (sfid-20170908_161759_162528_35DB47F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the radio index is already a valid NL attribute, this patch simply
try to read it and create the radio specific to this index by the
previously used scheme.

Since this allows to create radios out of row, we need to search for a
free index for a new radio, when the index is not present as parameter.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 5dd4be2a8487..faa0e39523aa 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2436,6 +2436,7 @@ struct hwsim_new_radio_params {
 	bool destroy_on_close;
 	const char *hwname;
 	bool no_vif;
+	int idx;
 };
 
 static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
@@ -2645,13 +2646,9 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	skb_queue_head_init(&data->pending);
 
 	SET_IEEE80211_DEV(hw, data->dev);
-	eth_zero_addr(addr);
-	addr[0] = 0x02;
-	addr[3] = idx >> 8;
-	addr[4] = idx;
-	memcpy(data->addresses[0].addr, addr, ETH_ALEN);
-	memcpy(data->addresses[1].addr, addr, ETH_ALEN);
-	data->addresses[1].addr[0] |= 0x40;
+	memcpy(data->addresses[0].addr, &mac.addr, ETH_ALEN);
+	memcpy(data->addresses[1].addr, &mac.addr, ETH_ALEN);
+	data->addresses[0].addr[0] = 0x02;
 	hw->wiphy->n_addresses = 2;
 	hw->wiphy->addresses = data->addresses;
 
@@ -3304,6 +3301,11 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		param.regd = hwsim_world_regdom_custom[idx];
 	}
 
+	if (info->attrs[HWSIM_ATTR_RADIO_ID])
+		param.idx = nla_get_u32(info->attrs[HWSIM_ATTR_RADIO_ID]);
+	else
+		param.idx = -1;
+
 	return mac80211_hwsim_new_radio(info, &param);
 }
 
-- 
2.14.1
