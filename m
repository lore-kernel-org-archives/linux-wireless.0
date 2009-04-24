Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585AbZDXNhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 09:37:31 -0400
Subject: [PATCH] mac80211_hwsim: fix bogus warning
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Fri, 24 Apr 2009 15:13:54 +0200
Message-Id: <1240578835.18031.35.camel@johannes.local> (sfid-20090424_153735_449647_41752625)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A typo slipped into my patch to configure beacon intervals
properly -- this warning is supposed to trigger when the
beacon interval is zero, not non-zero.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-04-24 14:46:43.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-04-24 14:46:46.000000000 +0200
@@ -619,7 +619,7 @@ static void mac80211_hwsim_bss_info_chan
 		printk(KERN_DEBUG "  %s: BCNINT: %d\n",
 		       wiphy_name(hw->wiphy), info->beacon_int);
 		data->beacon_int = 1024 * info->beacon_int / 1000 * HZ / 1000;
-		if (WARN_ON(data->beacon_int))
+		if (WARN_ON(!data->beacon_int))
 			data->beacon_int = 1;
 	}
 


