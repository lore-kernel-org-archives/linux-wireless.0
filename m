Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56827 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762261AbZE3RhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:37:12 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so6938274ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:37:14 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 03/23] cfg80211: allow drivers that can't scan for specific ssids
Date: Sat, 30 May 2009 18:36:37 +0100
Message-Id: <1243705017-8784-4-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 net/wireless/core.c        |    3 ---
 net/wireless/wext-compat.c |    3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index a5dbea1..72b2008 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -298,9 +298,6 @@ int wiphy_register(struct wiphy *wiphy)
 	int i;
 	u16 ifmodes = wiphy->interface_modes;
 
-	if (WARN_ON(wiphy->max_scan_ssids < 1))
-		return -EINVAL;
-
 	/* sanity check ifmodes */
 	WARN_ON(!ifmodes);
 	ifmodes &= ((1 << __NL80211_IFTYPE_AFTER_LAST) - 1) & ~1;
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index b132f85..9ec9fc5 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -244,7 +244,8 @@ int cfg80211_wext_giwrange(struct net_device *dev,
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWSCAN);
 
-	range->scan_capa |= IW_SCAN_CAPA_ESSID;
+	if (wdev->wiphy->max_scan_ssids > 0)
+		range->scan_capa |= IW_SCAN_CAPA_ESSID;
 
 	return 0;
 }
-- 
1.6.0.6

