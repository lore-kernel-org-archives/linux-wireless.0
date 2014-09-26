Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59730 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbaIZXY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 19:24:27 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 4/4] hwsim:  support creating wiphy w/out creating wlanX.
Date: Fri, 26 Sep 2014 16:24:16 -0700
Message-Id: <1411773856-25042-4-git-send-email-greearb@candelatech.com> (sfid-20140927_012440_871377_8AAD11F5)
In-Reply-To: <1411773856-25042-1-git-send-email-greearb@candelatech.com>
References: <1411773856-25042-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Good for automated testing, where user can create wlan
interfaces with specified names.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  New to the series, more help with automation.

 drivers/net/wireless/mac80211_hwsim.c | 15 ++++++++++++---
 drivers/net/wireless/mac80211_hwsim.h |  2 ++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e78c149..c803dd6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2018,7 +2018,8 @@ static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 				       const struct ieee80211_regdomain *regd,
 				       bool reg_strict, bool p2p_device,
-				       bool use_chanctx, char *hwname)
+				       bool use_chanctx, char *hwname,
+				       bool no_vdev)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2223,6 +2224,9 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 		schedule_timeout_interruptible(1);
 	}
 
+	if (no_vdev)
+		hw->flags |= IEEE80211_HW_NO_AUTO_VDEV;
+
 	err = ieee80211_register_hw(hw);
 	if (err < 0) {
 		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
@@ -2517,11 +2521,15 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	bool reg_strict = info->attrs[HWSIM_ATTR_REG_STRICT_REG];
 	bool p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
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
 
@@ -2542,7 +2550,8 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	}
 
 	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict,
-					   p2p_device, use_chanctx, hwname);
+					   p2p_device, use_chanctx, hwname,
+					   no_vdev);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2774,7 +2783,7 @@ static int __init init_mac80211_hwsim(void)
 		err = mac80211_hwsim_create_radio(channels, reg_alpha2,
 						  regd, reg_strict,
 						  support_p2p_device,
-						  channels > 1, NULL);
+						  channels > 1, NULL, false);
 		if (err < 0)
 			goto out_free_radios;
 	}
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 37c040b..6efd9f3 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -112,6 +112,7 @@ enum {
  *	command to force use of channel contexts even when only a
  *	single channel is supported
  * @HWSIM_ATTR_RADIO_NAME: Name of radio, ie phy666
+ * @HWSIM_ATTR_NO_VDEV:  Do not create vdev (wlanX) when creating radio.
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -134,6 +135,7 @@ enum {
 	HWSIM_ATTR_SUPPORT_P2P_DEVICE,
 	HWSIM_ATTR_USE_CHANCTX,
 	HWSIM_ATTR_RADIO_NAME,
+	HWSIM_ATTR_NO_VDEV,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
1.7.11.7

