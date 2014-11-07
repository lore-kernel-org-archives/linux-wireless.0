Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2030 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaKGIWC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 03:22:02 -0500
From: Patrik Flykt <patrik.flykt@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211-hwsim: Factor out netlink attribute appending
Date: Fri,  7 Nov 2014 10:21:59 +0200
Message-Id: <1415348520-28558-2-git-send-email-patrik.flykt@linux.intel.com> (sfid-20141107_092208_883031_E35223C8)
In-Reply-To: <1415348520-28558-1-git-send-email-patrik.flykt@linux.intel.com>
References: <1415348520-28558-1-git-send-email-patrik.flykt@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Factor out netlink message attribute appending in order to reuse it
with later code. As a result move netlink skb allocation to the calling
function.

Signed-off-by: Patrik Flykt <patrik.flykt@linux.intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 60 +++++++++++++++++------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 209db62..686975e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2057,36 +2057,26 @@ static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
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
@@ -2099,54 +2089,64 @@ static struct sk_buff *build_radio_msg(int cmd, int id,
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
+	if (genlmsg_end(mcast_skb, data))
+		goto out_err;
+
 	hwsim_mcast_config_msg(mcast_skb, info);
+	return;
+
+out_err:
+	genlmsg_cancel(mcast_skb, data);
 }
 
 static int mac80211_hwsim_new_radio(struct genl_info *info,
@@ -2392,7 +2392,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	if (idx > 0)
-		hswim_mcast_new_radio(idx, info, param);
+		hwsim_mcast_new_radio(idx, info, param);
 
 	return idx;
 
-- 
2.1.1

