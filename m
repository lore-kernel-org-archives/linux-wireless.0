Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59728 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbaIZXY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 19:24:27 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 2/4] mac-sim:  support creating radios with specific name.
Date: Fri, 26 Sep 2014 16:24:14 -0700
Message-Id: <1411773856-25042-2-git-send-email-greearb@candelatech.com> (sfid-20140927_012440_298974_FDF8FB4C)
In-Reply-To: <1411773856-25042-1-git-send-email-greearb@candelatech.com>
References: <1411773856-25042-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, it can be very difficult to know which is which
if you are trying to do detailed testing.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Add rtnl lock around rename logic.

 drivers/net/wireless/mac80211_hwsim.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b755920..e78c149 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2018,7 +2018,7 @@ static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 				       const struct ieee80211_regdomain *regd,
 				       bool reg_strict, bool p2p_device,
-				       bool use_chanctx)
+				       bool use_chanctx, char *hwname)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2230,6 +2230,15 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 		goto failed_hw;
 	}
 
+	if (hwname) {
+		/* If this fails, continue on anyway, treat it as request
+		 * instead of command.
+		 */
+		rtnl_lock();
+		cfg80211_dev_rename_wiphy(hw->wiphy, hwname);
+		rtnl_unlock();
+	}
+
 	wiphy_debug(hw->wiphy, "hwaddr %pM registered\n", hw->wiphy->perm_addr);
 
 	if (reg_alpha2)
@@ -2508,10 +2517,14 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	bool reg_strict = info->attrs[HWSIM_ATTR_REG_STRICT_REG];
 	bool p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
 	bool use_chanctx;
+	char *hwname = NULL;
 
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
 		chans = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
 
+	if (info->attrs[HWSIM_ATTR_RADIO_NAME])
+		hwname = nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]);
+
 	if (info->attrs[HWSIM_ATTR_USE_CHANCTX])
 		use_chanctx = true;
 	else
@@ -2529,7 +2542,7 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	}
 
 	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict,
-					   p2p_device, use_chanctx);
+					   p2p_device, use_chanctx, hwname);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2761,7 +2774,7 @@ static int __init init_mac80211_hwsim(void)
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

