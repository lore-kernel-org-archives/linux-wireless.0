Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56682 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbaJVTXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 15:23:17 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 7/9] mac80211-hwsim: support creating wiphy w/out creating wlanX
Date: Wed, 22 Oct 2014 12:23:04 -0700
Message-Id: <1414005786-27572-7-git-send-email-greearb@candelatech.com> (sfid-20141022_212330_887834_74446753)
In-Reply-To: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
References: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Good for automated testing, where user can create wlan
interfaces with specified names.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 15 ++++++++++++---
 drivers/net/wireless/mac80211_hwsim.h |  2 ++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 783a9ec..21f11d6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2023,7 +2023,8 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 				       const struct ieee80211_regdomain *regd,
 				       bool reg_strict, bool p2p_device,
 				       bool use_chanctx, bool destroy_on_close,
-				       u32 portid, const char *hwname)
+				       u32 portid, const char *hwname,
+				       bool no_vif)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2230,6 +2231,9 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 		schedule_timeout_interruptible(1);
 	}
 
+	if (no_vif)
+		hw->flags |= IEEE80211_HW_NO_AUTO_VIF;
+
 	err = ieee80211_register_hw(hw);
 	if (err < 0) {
 		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
@@ -2516,11 +2520,15 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	bool p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
 	bool destroy_on_close = info->attrs[HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE];
 	bool use_chanctx;
+	bool no_vif = false;
 	const char *hwname = NULL;
 
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
 		chans = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
 
+	if (info->attrs[HWSIM_ATTR_NO_VIF])
+		no_vif = true;
+
 	if (info->attrs[HWSIM_ATTR_RADIO_NAME])
 		hwname = nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]);
 
@@ -2543,7 +2551,7 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict,
 					   p2p_device, use_chanctx,
 					   destroy_on_close, info->snd_portid,
-					   hwname);
+					   hwname, no_vif);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2800,7 +2808,8 @@ static int __init init_mac80211_hwsim(void)
 		err = mac80211_hwsim_create_radio(channels, reg_alpha2,
 						  regd, reg_strict,
 						  support_p2p_device,
-						  channels > 1, false, 0, NULL);
+						  channels > 1, false, 0, NULL,
+						  false);
 		if (err < 0)
 			goto out_free_radios;
 	}
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 98c6998..f560b74 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -114,6 +114,7 @@ enum {
  * @HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE: used with the %HWSIM_CMD_CREATE_RADIO
  *	command to force radio removal when process that created the radio dies
  * @HWSIM_ATTR_RADIO_NAME: Name of radio, e.g. phy666
+ * @HWSIM_ATTR_NO_VIF:  Do not create vif (wlanX) when creating radio.
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -137,6 +138,7 @@ enum {
 	HWSIM_ATTR_USE_CHANCTX,
 	HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE,
 	HWSIM_ATTR_RADIO_NAME,
+	HWSIM_ATTR_NO_VIF,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
1.7.11.7

