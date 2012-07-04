Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2GDK70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 06:59:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: add testmode code to stop/wake queues
Date: Wed,  4 Jul 2012 12:59:17 +0200
Message-Id: <1341399557-12814-1-git-send-email-johannes@sipsolutions.net> (sfid-20120704_125929_972260_2F4D2778)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This was useful for debugging the queue stop/wake
issues and is pretty small so let's just put it in.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index f0a906b..9388338 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1082,6 +1082,8 @@ enum hwsim_testmode_attr {
 enum hwsim_testmode_cmd {
 	HWSIM_TM_CMD_SET_PS		= 0,
 	HWSIM_TM_CMD_GET_PS		= 1,
+	HWSIM_TM_CMD_STOP_QUEUES	= 2,
+	HWSIM_TM_CMD_WAKE_QUEUES	= 3,
 };
 
 static const struct nla_policy hwsim_testmode_policy[HWSIM_TM_ATTR_MAX + 1] = {
@@ -1121,6 +1123,12 @@ static int mac80211_hwsim_testmode_cmd(struct ieee80211_hw *hw,
 		if (nla_put_u32(skb, HWSIM_TM_ATTR_PS, hwsim->ps))
 			goto nla_put_failure;
 		return cfg80211_testmode_reply(skb);
+	case HWSIM_TM_CMD_STOP_QUEUES:
+		ieee80211_stop_queues(hw);
+		return 0;
+	case HWSIM_TM_CMD_WAKE_QUEUES:
+		ieee80211_wake_queues(hw);
+		return 0;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
1.7.10

