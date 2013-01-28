Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:42844 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134Ab3A1QMh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:12:37 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	ordex@autistici.org, simon.wunderlich@s2003.tu-chemnitz.de,
	rgibson@futurec.net, Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 3/3] nl80211: Allow to set IBSS key even before IBSS_JOIN
Date: Mon, 28 Jan 2013 17:11:53 +0100
Message-Id: <1359389513-1554-3-git-send-email-sven@narfation.org> (sfid-20130128_171253_123516_1BA65E9C)
In-Reply-To: <1359389513-1554-1-git-send-email-sven@narfation.org>
References: <30210911.93HAZKKtRJ@bentobox>
 <1359389513-1554-1-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WPA_NONE will use a shared group key for unicast and multicast. It is therefore
better to allow early setting of keys to prevent any leakage of information
through multicast frames.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/wireless/nl80211.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33de803..3fb3491 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -766,10 +766,7 @@ static int nl80211_key_allowed(struct wireless_dev *wdev)
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_MESH_POINT:
-		break;
 	case NL80211_IFTYPE_ADHOC:
-		if (!wdev->current_bss)
-			return -ENOLINK;
 		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
-- 
1.7.10.4

