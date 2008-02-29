Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:23981 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbYCCUUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 15:20:17 -0500
Received: by wa-out-1112.google.com with SMTP id v27so277416wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 12:20:15 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 29 Feb 2008 12:15:28 -0800
Subject: [PATCH 02/10] mac80211: fix incorrect parenthesis
Message-ID: <47cc5d7e.01f6600a.48b7.ffff858f@mx.google.com> (sfid-20080303_202055_788832_BAD483C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pointed out by Johannes Berg.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/ieee80211_sta.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 892b5f9..c9d0018 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -3878,8 +3878,8 @@ ieee80211_sta_scan_result(struct net_device *dev,
 						  bss->ssid);
 	}
 
-	if (bss->capability & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS
-	    || bss_mesh_cfg(bss))) {
+	if (bss->capability & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)
+	    || bss_mesh_cfg(bss)) {
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = SIOCGIWMODE;
 		if (bss_mesh_cfg(bss))
-- 
1.5.2.5



