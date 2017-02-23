Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36284 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdBWMbz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 07:31:55 -0500
Received: by mail-wr0-f193.google.com with SMTP id z61so3727997wrc.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 04:31:54 -0800 (PST)
Received: from localhost.localdomain ([92.176.165.227])
        by smtp.gmail.com with ESMTPSA id m83sm6536101wmc.33.2017.02.23.04.02.19
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Feb 2017 04:02:19 -0800 (PST)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2][RFC] mac80211_hwsim: Report radio addresses in NEW_RADIO/GET_RADIO
Date: Thu, 23 Feb 2017 13:02:11 +0100
Message-Id: <20170223120211.22358-2-andrew.zaborowski@intel.com> (sfid-20170223_133157_932062_C356BD66)
In-Reply-To: <20170223120211.22358-1-andrew.zaborowski@intel.com>
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a HWSIM_ATTR_RADIO_ADDR attribute to those to events/response so
that a userspace medium can query the list of addresses in the
simulator.

When a userspace medium needs to handle a broadcast frame it can't
easily implement the equivalent of what the default kernel medium does
because it doesn't know who to forward the frame to.  The
HWSIM_CMD_GET_RADIO command is a little useless in this respect.
Userspace needs to use HWSIM_CMD_GET_RADIO, then cross-reference the
radio names with wiphy names using NL80211_CMD_GET_WIPHY dump, map the
wiphy names to wiphy indexes (those are more useful than wiphy names
because they don't change -- a wiphy name change doesn't generate an
event so this can't be easily tracked), and use the
NL80211_CMD_GET_INTERFACES dump to obtain the wiphy_idx to mac address
mapping.

Additionally there are two addresses used by hwsim radios
(data->addresses[0] and [1]), first used at the network level and the
second used at hwsim radio level and in HWSIM_ATTR_ADDR_TRANSMITTER /
_RECEIVER.  By default they differ by 0x40 in the first byte but I'm not
sure userspace can make this assumption to do the mapping from the
address inside the frame headers to the address of the hwsim receiving
radio.  I suspect the network layers can change address 0 and they will
be out of sync.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
Additionally I tried to add a HWSIM_ATTR_WIPHY to report the wiphy index
directly without users going through wiphy name to index mapping, but
get_wiphy_idx() is internal to cfg80211.  The index is exposed to
userspace and is more useful than the name so I wonder if this function
should be exported from cfg80211.
---
 drivers/net/wireless/mac80211_hwsim.c | 16 ++++++++++++++++
 drivers/net/wireless/mac80211_hwsim.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ba4978d..dcc1df0 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2305,6 +2305,7 @@ struct hwsim_new_radio_params {
 	bool destroy_on_close;
 	const char *hwname;
 	bool no_vif;
+	const struct mac_address *addrs;
 };
 
 static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
@@ -2318,10 +2319,15 @@ static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
 				  HWSIM_MCGRP_CONFIG, GFP_KERNEL);
 }
 
+#define HWSIM_ADDR_COUNT \
+	ARRAY_SIZE(((struct mac80211_hwsim_data *) NULL)->addresses)
+
 static int append_radio_msg(struct sk_buff *skb, int id,
 			    struct hwsim_new_radio_params *param)
 {
 	int ret;
+	int i;
+	uint8_t addr_buf[HWSIM_ADDR_COUNT * ETH_ALEN];
 
 	ret = nla_put_u32(skb, HWSIM_ATTR_RADIO_ID, id);
 	if (ret < 0)
@@ -2379,6 +2385,13 @@ static int append_radio_msg(struct sk_buff *skb, int id,
 			return ret;
 	}
 
+	for (i = 0; i < HWSIM_ADDR_COUNT; i++)
+		memcpy(addr_buf + i * ETH_ALEN, param->addrs[i].addr, ETH_ALEN);
+
+	ret = nla_put(skb, HWSIM_ATTR_RADIO_ADDR, sizeof(addr_buf), addr_buf);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
@@ -2682,6 +2695,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	list_add_tail(&data->list, &hwsim_radios);
 	spin_unlock_bh(&hwsim_radio_lock);
 
+	param->addrs = data->addresses;
+
 	if (idx > 0)
 		hwsim_mcast_new_radio(idx, info, param);
 
@@ -2772,6 +2787,7 @@ static int mac80211_hwsim_get_radio(struct sk_buff *skb,
 	param.regd = data->regd;
 	param.channels = data->channels;
 	param.hwname = wiphy_name(data->hw->wiphy);
+	param.addrs = data->addresses;
 
 	res = append_radio_msg(skb, data->idx, &param);
 	if (res < 0)
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 39f2246..53b4cd7 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -123,6 +123,7 @@ enum {
  * @HWSIM_ATTR_RADIO_NAME: Name of radio, e.g. phy666
  * @HWSIM_ATTR_NO_VIF:  Do not create vif (wlanX) when creating radio.
  * @HWSIM_ATTR_FREQ: Frequency at which packet is transmitted or received.
+ * @HWSIM_ATTR_RADIO_ADDR: Radio hardware addresses as an array
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -149,6 +150,7 @@ enum {
 	HWSIM_ATTR_NO_VIF,
 	HWSIM_ATTR_FREQ,
 	HWSIM_ATTR_PAD,
+	HWSIM_ATTR_RADIO_ADDR,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
2.9.3
