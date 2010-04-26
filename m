Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:43922 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab0DZJuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 05:50:01 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3Q9mMQf032439
	for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 04:50:01 -0500
Received: from localhost.localdomain (trdhcp21581.nmp.nokia.com [172.22.215.81])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3Q9njF0016299
	for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 12:49:46 +0300
From: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 1/1] mac80211: Disable cfg80211 assoc timeout warning
Date: Mon, 26 Apr 2010 12:49:27 +0300
Message-Id: <1272275367-7532-1-git-send-email-ext-saravanan.dhanabal@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While the association response is queued and yet to be
processed, if the interface goes down, ieee80211_stop
marks work queue items as IEEE80211_WORK_ABORT. This
creates assoc timeout warnings which are actually caused
by if down. Those warnings could be avoided, since they
are not beacuse of association response.

This patch disables assoc timeout warnings if interface is
not running.

Signed-off-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
---
 net/wireless/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 0855f0d..a3ab86c 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -337,7 +337,7 @@ void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr)
 		}
 	}
 
-	WARN_ON(!done);
+	WARN_ON(netif_running(dev) && !done);
 
 	wdev_unlock(wdev);
 }
-- 
1.7.0

