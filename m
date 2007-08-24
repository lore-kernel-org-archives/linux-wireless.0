Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45006 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237AbXHXMbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 08:31:52 -0400
Message-Id: <20070824122910.617307000@sipsolutions.net>
References: <20070824122705.549190000@sipsolutions.net>
Date: Fri, 24 Aug 2007 14:27:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/15] mac80211: support changing default key index via  cfg80211
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the necessary hook to mac80211 so that you can
change the default key index via nl80211/cfg80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/cfg.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- wireless-dev.orig/net/mac80211/cfg.c	2007-08-24 14:16:41.539417211 +0200
+++ wireless-dev/net/mac80211/cfg.c	2007-08-24 14:16:51.139417211 +0200
@@ -144,9 +144,22 @@ static int ieee80211_del_key(struct wiph
 	return 0;
 }
 
+static int ieee80211_config_default_key(struct wiphy *wiphy,
+					struct net_device *dev,
+					u8 key_idx)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	ieee80211_set_default_key(sdata, key_idx);
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
 	.add_key = ieee80211_add_key,
 	.del_key = ieee80211_del_key,
+	.set_default_key = ieee80211_config_default_key,
 };

-- 

