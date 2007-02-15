Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965748AbXBOPAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 10:00:08 -0500
Message-Id: <20070215144257.949316000@sipsolutions.net>
References: <20070215144241.847938000@sipsolutions.net>
Date: Thu, 15 Feb 2007 15:42:45 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 04/10] cfg/nl80211: make association explicit
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes association explicit.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |    3 +++
 include/net/cfg80211.h  |    7 ++++++-
 net/wireless/nl80211.c  |   10 ++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

--- wireless-dev.orig/include/net/cfg80211.h	2007-02-15 13:41:33.057940064 +0100
+++ wireless-dev/include/net/cfg80211.h	2007-02-15 13:48:54.087940064 +0100
@@ -78,13 +78,17 @@ struct wiphy;
  *
  * @configure: configure the given interface as requested in the config struct.
  *	       must not ignore any configuration item, if something is
- *	       is requested that cannot be fulfilled return an error
+ *	       is requested that cannot be fulfilled return an error.
+ *             This call does not actually initiate any association or such.
  *
  * @get_config: fill the given config structure with the current configuration
  *
  * @get_config_valid: return a bitmask of CFG80211_CFG_VALID_* indicating
  *		      which parameters can be set.
  *
+ * @associate: associate with previously given settings (SSID, BSSID
+ *             if userspace roaming is enabled)
+ *
  * @reassociate: reassociate with current settings (SSID, BSSID if
  *		 userspace roaming is enabled)
  *
@@ -135,6 +139,7 @@ struct cfg80211_ops {
 				    struct net_device *dev);
 
 
+	int	(*associate)(struct wiphy *wiphy, struct net_device *dev);
 	int	(*reassociate)(struct wiphy *wiphy, struct net_device *dev);
 	int	(*disassociate)(struct wiphy *wiphy, struct net_device *dev);
 	int	(*deauth)(struct wiphy *wiphy, struct net_device *dev);
--- wireless-dev.orig/include/linux/nl80211.h	2007-02-15 13:41:26.287940064 +0100
+++ wireless-dev/include/linux/nl80211.h	2007-02-15 13:48:53.357940064 +0100
@@ -98,6 +98,9 @@ enum {
 	/* deauth from current AP */
 	NL80211_CMD_DEAUTH,
 
+	/* associate with current settings */
+	NL80211_CMD_ASSOCIATE,
+
 	/* re-associate with current settings
 	 * (SSID and BSSID if roaming control in userspace) */
 	NL80211_CMD_REASSOCIATE,
--- wireless-dev.orig/net/wireless/nl80211.c	2007-02-15 13:41:33.067940064 +0100
+++ wireless-dev/net/wireless/nl80211.c	2007-02-15 13:49:48.257940064 +0100
@@ -130,6 +130,7 @@ static int nl80211_get_cmdlist(struct sk
 	CHECK_CMD(del_virtual_intf, DEL_VIRTUAL_INTERFACE);
 	CHECK_CMD(configure, CONFIGURE);
 	CHECK_CMD(get_config, GET_CONFIG);
+	CHECK_CMD(associate, ASSOCIATE);
 	CHECK_CMD(reassociate, REASSOCIATE);
 	CHECK_CMD(disassociate, DISASSOCIATE);
 	CHECK_CMD(deauth, DEAUTH);
@@ -699,6 +700,9 @@ static int nl80211_assoc_deauth(struct s
 		return err;
 
 	switch (info->genlhdr->cmd) {
+	case NL80211_CMD_ASSOCIATE:
+		act = drv->ops->associate;
+		break;
 	case NL80211_CMD_DISASSOCIATE:
 		act = drv->ops->disassociate;
 		break;
@@ -964,6 +968,12 @@ static struct genl_ops nl80211_ops[] = {
 		/* can be retrieved by unprivileged users */
 	},
 	{
+		.cmd = NL80211_CMD_ASSOCIATE,
+		.doit = nl80211_assoc_deauth,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
 		.cmd = NL80211_CMD_DISASSOCIATE,
 		.doit = nl80211_assoc_deauth,
 		.policy = nl80211_policy,

--

