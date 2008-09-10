Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYIJWLC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:11:02 -0400
Message-Id: <20080910220425.307168000@sipsolutions.net> (sfid-20080911_001107_086475_A0F614F4)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:02:00 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/18] mac80211: warn on some invalid vlan operations
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These should never happen, but better warn about them than
crashing a driver, the fact that they never happen is rather
subtle throughout mac80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- everything.orig/net/mac80211/main.c	2008-09-10 23:58:08.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-10 23:58:09.000000000 +0200
@@ -156,6 +156,9 @@ int ieee80211_if_config(struct ieee80211
 	if (WARN_ON(!netif_running(sdata->dev)))
 		return 0;
 
+	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
+		return -EINVAL;
+
 	if (!local->ops->config_interface)
 		return 0;
 
@@ -321,6 +324,9 @@ void ieee80211_bss_info_change_notify(st
 {
 	struct ieee80211_local *local = sdata->local;
 
+	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
+		return;
+
 	if (!changed)
 		return;
 

-- 

