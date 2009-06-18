Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbZFRWVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:21:46 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:21:49 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 03/23] cfg80211: allow drivers that can't scan for specific ssids
Date: Thu, 18 Jun 2009 23:21:15 +0100
Message-Id: <1245363695-8289-4-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c        |    3 ---
 net/wireless/wext-compat.c |    3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d585029..a98670c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -346,9 +346,6 @@ int wiphy_register(struct wiphy *wiphy)
 	int i;
 	u16 ifmodes = wiphy->interface_modes;
 
-	if (WARN_ON(wiphy->max_scan_ssids < 1))
-		return -EINVAL;
-
 	/* sanity check ifmodes */
 	WARN_ON(!ifmodes);
 	ifmodes &= ((1 << __NL80211_IFTYPE_AFTER_LAST) - 1) & ~1;
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 7dbe6c6..bb97061 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -247,7 +247,8 @@ int cfg80211_wext_giwrange(struct net_device *dev,
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWSCAN);
 
-	range->scan_capa |= IW_SCAN_CAPA_ESSID;
+	if (wdev->wiphy->max_scan_ssids > 0)
+		range->scan_capa |= IW_SCAN_CAPA_ESSID;
 
 	return 0;
 }
-- 
1.6.0.6

