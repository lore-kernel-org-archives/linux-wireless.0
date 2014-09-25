Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48206 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaIYX7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 19:59:47 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] mac-sim:  support creating radios with specific name.
Date: Thu, 25 Sep 2014 16:59:44 -0700
Message-Id: <1411689584-16136-2-git-send-email-greearb@candelatech.com> (sfid-20140926_015951_078853_5A323268)
In-Reply-To: <1411689584-16136-1-git-send-email-greearb@candelatech.com>
References: <1411689584-16136-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, it can be very difficult to know which is which
if you are trying to do detailed testing.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

NOTE:  This depends on the earlier patch that added the radio-name
    attribute.

 drivers/net/wireless/mac80211_hwsim.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b755920..2b54413 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2018,7 +2018,7 @@ static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 				       const struct ieee80211_regdomain *regd,
 				       bool reg_strict, bool p2p_device,
-				       bool use_chanctx)
+				       bool use_chanctx, char* hwname)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2230,6 +2230,12 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 		goto failed_hw;
 	}
 
+	if (hwname)
+		/* If this fails, continue on anyway, treat it as request
+		 * instead of command.
+		 */
+		cfg80211_dev_rename_wiphy(hw->wiphy, hwname);
+
 	wiphy_debug(hw->wiphy, "hwaddr %pM registered\n", hw->wiphy->perm_addr);
 
 	if (reg_alpha2)
@@ -2508,10 +2514,14 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	bool reg_strict = info->attrs[HWSIM_ATTR_REG_STRICT_REG];
 	bool p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
 	bool use_chanctx;
+	char* hwname = NULL;
 
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
 		chans = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
 
+	if (info->attrs[HWSIM_ATTR_RADIO_NAME])
+		hwname = nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]);
+
 	if (info->attrs[HWSIM_ATTR_USE_CHANCTX])
 		use_chanctx = true;
 	else
@@ -2529,7 +2539,7 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	}
 
 	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict,
-					   p2p_device, use_chanctx);
+					   p2p_device, use_chanctx, hwname);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2761,7 +2771,7 @@ static int __init init_mac80211_hwsim(void)
 		err = mac80211_hwsim_create_radio(channels, reg_alpha2,
 						  regd, reg_strict,
 						  support_p2p_device,
-						  channels > 1);
+						  channels > 1, NULL);
 		if (err < 0)
 			goto out_free_radios;
 	}
-- 
1.7.11.7

