Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11745 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbaKLOmn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 09:42:43 -0500
From: Patrik Flykt <patrik.flykt@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/2] mac80211-hwsim: Factor out netlink attribute appending
Date: Wed, 12 Nov 2014 16:42:39 +0200
Message-Id: <1415803360-4073-2-git-send-email-patrik.flykt@linux.intel.com> (sfid-20141112_154252_610154_3687E769)
In-Reply-To: <1415803360-4073-1-git-send-email-patrik.flykt@linux.intel.com>
References: <1415803360-4073-1-git-send-email-patrik.flykt@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Factor out netlink message attribute appending in order to reuse it
with later code. As a result move netlink skb allocation to the
calling function.

Signed-off-by: Patrik Flykt <patrik.flykt@linux.intel.com>
---

v2: Free skb in error path

 drivers/net/wireless/mac80211_hwsim.c | 60 +++++++++++++++++------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 58f11bb..804c92f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2107,36 +2107,26 @@ static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
 				  HWSIM_MCGRP_CONFIG, GFP_KERNEL);
 }
 
-static struct sk_buff *build_radio_msg(int cmd, int id,
-				       struct hwsim_new_radio_params *param)
+static int append_radio_msg(struct sk_buff *skb, int id,
+			    struct hwsim_new_radio_params *param)
 {
-	struct sk_buff *skb;
-	void *data;
 	int ret;
 
-	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!skb)
-		return NULL;
-
-	data = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0, cmd);
-	if (!data)
-		goto error;
-
 	ret = nla_put_u32(skb, HWSIM_ATTR_RADIO_ID, id);
 	if (ret < 0)
-		goto error;
+		return ret;
 
 	if (param->channels) {
 		ret = nla_put_u32(skb, HWSIM_ATTR_CHANNELS, param->channels);
 		if (ret < 0)
-			goto error;
+			return ret;
 	}
 
 	if (param->reg_alpha2) {
 		ret = nla_put(skb, HWSIM_ATTR_REG_HINT_ALPHA2, 2,
 			      param->reg_alpha2);
 		if (ret < 0)
-			goto error;
+			return ret;
 	}
 
 	if (param->regd) {
@@ -2149,54 +2139,64 @@ static struct sk_buff *build_radio_msg(int cmd, int id,
 		if (i < ARRAY_SIZE(hwsim_world_regdom_custom)) {
 			ret = nla_put_u32(skb, HWSIM_ATTR_REG_CUSTOM_REG, i);
 			if (ret < 0)
-				goto error;
+				return ret;
 		}
 	}
 
 	if (param->reg_strict) {
 		ret = nla_put_flag(skb, HWSIM_ATTR_REG_STRICT_REG);
 		if (ret < 0)
-			goto error;
+			return ret;
 	}
 
 	if (param->p2p_device) {
 		ret = nla_put_flag(skb, HWSIM_ATTR_SUPPORT_P2P_DEVICE);
 		if (ret < 0)
-			goto error;
+			return ret;
 	}
 
 	if (param->use_chanctx) {
 		ret = nla_put_flag(skb, HWSIM_ATTR_USE_CHANCTX);
 		if (ret < 0)
-			goto error;
+			return ret;
 	}
 
 	if (param->hwname) {
 		ret = nla_put(skb, HWSIM_ATTR_RADIO_NAME,
 			      strlen(param->hwname), param->hwname);
 		if (ret < 0)
-			goto error;
+			return ret;
 	}
 
-	genlmsg_end(skb, data);
-
-	return skb;
-
-error:
-	nlmsg_free(skb);
-	return NULL;
+	return 0;
 }
 
-static void hswim_mcast_new_radio(int id, struct genl_info *info,
+static void hwsim_mcast_new_radio(int id, struct genl_info *info,
 				  struct hwsim_new_radio_params *param)
 {
 	struct sk_buff *mcast_skb;
+	void *data;
 
-	mcast_skb = build_radio_msg(HWSIM_CMD_NEW_RADIO, id, param);
+	mcast_skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!mcast_skb)
 		return;
 
+	data = genlmsg_put(mcast_skb, 0, 0, &hwsim_genl_family, 0,
+			   HWSIM_CMD_NEW_RADIO);
+	if (!data)
+		goto out_err;
+
+	if (append_radio_msg(mcast_skb, id, param) < 0)
+		goto out_err;
+
+	genlmsg_end(mcast_skb, data);
+
 	hwsim_mcast_config_msg(mcast_skb, info);
+	return;
+
+out_err:
+	genlmsg_cancel(mcast_skb, data);
+	nlmsg_free(mcast_skb);
 }
 
 static int mac80211_hwsim_new_radio(struct genl_info *info,
@@ -2442,7 +2442,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	if (idx > 0)
-		hswim_mcast_new_radio(idx, info, param);
+		hwsim_mcast_new_radio(idx, info, param);
 
 	return idx;
 
-- 
2.1.1

