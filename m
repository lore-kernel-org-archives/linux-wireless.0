Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34683 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbaJTWtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 18:49:51 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 5/6] mac80211-hwsim: support creating wiphy w/out creating wlanX.
Date: Mon, 20 Oct 2014 15:49:37 -0700
Message-Id: <1413845378-27837-5-git-send-email-greearb@candelatech.com> (sfid-20141021_005000_387470_E6F134F9)
In-Reply-To: <1413845378-27837-1-git-send-email-greearb@candelatech.com>
References: <1413845378-27837-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Good for automated testing, where user can create wlan
interfaces with specified names.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 13 ++++++++++---
 drivers/net/wireless/mac80211_hwsim.h |  2 ++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ef793d5..fc5695d 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2023,7 +2023,7 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 				       const struct ieee80211_regdomain *regd,
 				       bool reg_strict, bool p2p_device,
 				       bool use_chanctx, bool destroy_on_close,
-				       u32 portid, char *hwname)
+				       u32 portid, char *hwname, bool no_vdev)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2230,6 +2230,9 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 		schedule_timeout_interruptible(1);
 	}
 
+	if (no_vdev)
+		hw->flags |= IEEE80211_HW_NO_AUTO_VDEV;
+
 	err = ieee80211_register_hw(hw);
 	if (err < 0) {
 		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
@@ -2516,11 +2519,15 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	bool p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
 	bool destroy_on_close = info->attrs[HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE];
 	bool use_chanctx;
+	bool no_vdev = false;
 	char *hwname = NULL;
 
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
 		chans = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
 
+	if (info->attrs[HWSIM_ATTR_NO_VDEV])
+		no_vdev = true;
+
 	if (info->attrs[HWSIM_ATTR_RADIO_NAME])
 		hwname = nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]);
 
@@ -2543,7 +2550,7 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict,
 					   p2p_device, use_chanctx,
 					   destroy_on_close, info->snd_portid,
-					   hwname);
+					   hwname, no_vdev);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2800,7 +2807,7 @@ static int __init init_mac80211_hwsim(void)
 		err = mac80211_hwsim_create_radio(channels, reg_alpha2,
 						  regd, reg_strict,
 						  support_p2p_device,
-						  channels > 1, false, 0, NULL);
+						  channels > 1, false, 0, NULL, false);
 		if (err < 0)
 			goto out_free_radios;
 	}
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 98c6998..71bf498 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -114,6 +114,7 @@ enum {
  * @HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE: used with the %HWSIM_CMD_CREATE_RADIO
  *	command to force radio removal when process that created the radio dies
  * @HWSIM_ATTR_RADIO_NAME: Name of radio, e.g. phy666
+ * @HWSIM_ATTR_NO_VDEV:  Do not create vdev (wlanX) when creating radio.
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -137,6 +138,7 @@ enum {
 	HWSIM_ATTR_USE_CHANCTX,
 	HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE,
 	HWSIM_ATTR_RADIO_NAME,
+	HWSIM_ATTR_NO_VDEV,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
1.7.11.7

