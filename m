Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17184 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab1EPO1W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 10:27:22 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] nl80211: check return code for genlmsg_end
Date: Mon, 16 May 2011 07:24:08 -0700
Message-Id: <1305555848-17609-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110516_162725_013623_B6AF7B8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the return value for genlmsg_end and handle it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 net/wireless/nl80211.c |   40 +++++++++++++++++++++++++++++++---------
 1 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9ef8e28..51ffb8d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1686,7 +1686,9 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 	if (cookie.error)
 		goto nla_put_failure;
 
-	genlmsg_end(msg, hdr);
+	if (genlmsg_end(msg, hdr) < 0)
+		goto free_msg;
+
 	return genlmsg_reply(msg, info);
 
  nla_put_failure:
@@ -2851,7 +2853,9 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	NLA_PUT_U8(msg, NL80211_MESHCONF_HWMP_ROOTMODE,
 			cur_params.dot11MeshHWMPRootMode);
 	nla_nest_end(msg, pinfoattr);
-	genlmsg_end(msg, hdr);
+	if (genlmsg_end(msg, hdr) < 0)
+		goto out;
+
 	return genlmsg_reply(msg, info);
 
  nla_put_failure:
@@ -3098,7 +3102,9 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 
 	nla_nest_end(msg, nl_reg_rules);
 
-	genlmsg_end(msg, hdr);
+	if (genlmsg_end(msg, hdr) < 0)
+		goto put_failure;
+
 	err = genlmsg_reply(msg, info);
 	goto out;
 
@@ -4347,8 +4353,13 @@ int cfg80211_testmode_reply(struct sk_buff *skb)
 	}
 
 	nla_nest_end(skb, data);
-	genlmsg_end(skb, hdr);
+	if (genlmsg_end(skb, hdr) < 0)
+		goto out;
+
 	return genlmsg_reply(skb, rdev->testmode_info);
+out:
+	kfree_skb(skb);
+	return -ENOBUFS;
 }
 EXPORT_SYMBOL(cfg80211_testmode_reply);
 
@@ -4367,8 +4378,12 @@ void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
 	struct nlattr *data = ((void **)skb->cb)[2];
 
 	nla_nest_end(skb, data);
-	genlmsg_end(skb, hdr);
+	if (genlmsg_end(skb, hdr) < 0) {
+		kfree_skb(skb);
+		return;
+	}
 	genlmsg_multicast(skb, 0, nl80211_testmode_mcgrp.id, gfp);
+
 }
 EXPORT_SYMBOL(cfg80211_testmode_event);
 #endif
@@ -4612,7 +4627,8 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 
 	NLA_PUT_U64(msg, NL80211_ATTR_COOKIE, cookie);
 
-	genlmsg_end(msg, hdr);
+	if (genlmsg_end(msg, hdr) < 0)
+		goto free_msg;
 
 	return genlmsg_reply(msg, info);
 
@@ -4829,7 +4845,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	NLA_PUT_U64(msg, NL80211_ATTR_COOKIE, cookie);
 
-	genlmsg_end(msg, hdr);
+	if (genlmsg_end(msg, hdr) < 0)
+		goto free_msg;
+
 	return genlmsg_reply(msg, info);
 
  nla_put_failure:
@@ -4931,7 +4949,9 @@ static int nl80211_get_power_save(struct sk_buff *skb, struct genl_info *info)
 
 	NLA_PUT_U32(msg, NL80211_ATTR_PS_STATE, ps_state);
 
-	genlmsg_end(msg, hdr);
+	if (genlmsg_end(msg, hdr) < 0)
+		goto free_msg;
+
 	return genlmsg_reply(msg, info);
 
  nla_put_failure:
@@ -5105,7 +5125,9 @@ static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
 		nla_nest_end(msg, nl_wowlan);
 	}
 
-	genlmsg_end(msg, hdr);
+	if (genlmsg_end(msg, hdr) < 0)
+		goto nla_put_failure;
+
 	return genlmsg_reply(msg, info);
 
 nla_put_failure:
-- 
1.7.0.4

