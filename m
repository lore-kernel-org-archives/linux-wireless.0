Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:41213
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750967AbaJ0K4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 06:56:11 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.18] mac80211: flush keys for AP mode on ieee80211_do_stop
Date: Mon, 27 Oct 2014 11:56:06 +0100
Message-Id: <1414407366-52891-1-git-send-email-nbd@openwrt.org> (sfid-20141027_115614_671585_591A4406)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Userspace can add keys to an AP mode interface before start_ap has been
called. If there have been no calls to start_ap/stop_ap in the mean
time, the keys will still be around when the interface is brought down.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/iface.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index af23722..b8efd5b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -931,9 +931,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		 * another CPU.
 		 */
 		ieee80211_free_keys(sdata, true);
-
-		/* fall through */
-	case NL80211_IFTYPE_AP:
 		skb_queue_purge(&sdata->skb_queue);
 	}
 
-- 
2.1.2

