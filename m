Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:44446 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab0EWQW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 May 2010 12:22:59 -0400
Date: Sun, 23 May 2010 19:22:40 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] Silence debug prints when using adhoc mode
Message-ID: <20100523162240.GZ19669@nalle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is flooded to syslog quite a few times when connecting to another
Linux box in adhoc mode. Syslog files fill up the disk fast:

$ dmesg | tail -10
[ 1986.772018] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[ 1986.776149] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[ 1986.780076] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[ 1986.784020] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[ 1986.788149] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[ 1986.792108] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[ 1986.796070] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[ 1986.800018] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[ 1986.804186] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[ 1986.808072] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)

Tested on a Thinkpad T60 with Intel Corporation PRO/Wireless 3945ABG [Golan]
Network Connection (rev 02) running vanilla 2.6.34 kernel.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 net/mac80211/ibss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e2976da..eab174f 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -478,8 +478,10 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 	if (ifibss->fixed_channel)
 		return;
 
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->name);
+#endif
 
 	ieee80211_request_internal_scan(sdata, ifibss->ssid, ifibss->ssid_len);
 }
-- 
1.7.1

