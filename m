Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbZHLVdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 17:33:50 -0400
Subject: [PATCH] cfg80211: allow driver to override PS default
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 23:33:20 +0200
Message-Id: <1250112800.12285.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes drivers might have a good reason to override
the PS default, like iwlwifi right now where it affects
RX performance significantly at this point. This will
allow them to override the default, if desired, in a
way that users can still change it according to their
trade-off choices, not the driver's, like would happen
if the driver just disabled PS completely then.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |    4 ++++
 net/wireless/core.c    |    4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-08-12 23:17:58.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-08-12 23:19:13.000000000 +0200
@@ -1108,6 +1108,9 @@ struct cfg80211_ops {
  * @net: the network namespace this wiphy currently lives in
  * @netnsok: if set to false, do not allow changing the netns of this
  *	wiphy at all
+ * @ps_default: default for powersave, will be set depending on the
+ *	kernel's default on wiphy_new(), but can be changed by the
+ *	driver if it has a good reason to override the default
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -1123,6 +1126,7 @@ struct wiphy {
 	bool disable_beacon_hints;
 
 	bool netnsok;
+	bool ps_default;
 
 	enum cfg80211_signal_type signal_type;
 
--- wireless-testing.orig/net/wireless/core.c	2009-08-12 23:19:17.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-08-12 23:19:56.000000000 +0200
@@ -412,6 +412,8 @@ struct wiphy *wiphy_new(const struct cfg
 	rdev->wiphy.dev.class = &ieee80211_class;
 	rdev->wiphy.dev.platform_data = rdev;
 
+	rdev->wiphy.ps_default = CONFIG_CFG80211_DEFAULT_PS_VALUE;
+
 	wiphy_net_set(&rdev->wiphy, &init_net);
 
 	rdev->rfkill_ops.set_block = cfg80211_rfkill_set_block;
@@ -674,7 +676,7 @@ static int cfg80211_netdev_notifier_call
 		wdev->wext.default_key = -1;
 		wdev->wext.default_mgmt_key = -1;
 		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
-		wdev->wext.ps = CONFIG_CFG80211_DEFAULT_PS_VALUE;
+		wdev->wext.ps = wdev->wiphy->ps_default;
 		wdev->wext.ps_timeout = 100;
 		if (rdev->ops->set_power_mgmt)
 			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,


