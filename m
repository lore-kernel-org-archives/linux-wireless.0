Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51221 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279Ab0FGHwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 03:52:35 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Add netif state checking to ieee80211_ifa_changed
Date: Mon,  7 Jun 2010 10:52:12 +0300
Message-Id: <1275897132-10932-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's a window for ieee80211_ifa_changed() to get called whilst the
managed mode mutex has not been initialized when opening and stopping the
interface. Currently this causes a kernel BUG like the following:

[  132.460013] kernel BUG at /home/wifi/iwlwifi-2.6/net/mac80211/main.c:380!
[  132.460013] invalid opcode: 0000 [#1] SMP

The mutex is initialized during open(), hence once netif_running() is true,
the mutex should be valid. Fix by adding a netif_running() check to the
function.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5706156..88b671a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -359,6 +359,9 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_managed *ifmgd;
 
+	if (!netif_running(ndev))
+		return NOTIFY_DONE;
+
 	/* Make sure it's our interface that got changed */
 	if (!wdev)
 		return NOTIFY_DONE;
-- 
1.6.3.3

