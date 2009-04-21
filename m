Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58700 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbZDUIzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 04:55:47 -0400
Subject: [PATCH] rndis_wlan: make some symbols static
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 10:55:10 +0200
Message-Id: <1240304110.17388.9.camel@johannes.local> (sfid-20090421_105551_484867_B5CDE7F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sparse complains, correctly, about these:

drivers/net/wireless/rndis_wlan.c:418:21: warning: symbol 'rndis_config_ops' was not declared. Should it be static?
drivers/net/wireless/rndis_wlan.c:423:6: warning: symbol 'rndis_wiphy_privid' was not declared. Should it be static?

Fix that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/rndis_wlan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/rndis_wlan.c	2009-04-21 10:53:35.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rndis_wlan.c	2009-04-21 10:53:47.000000000 +0200
@@ -415,12 +415,12 @@ static int rndis_change_virtual_intf(str
 static int rndis_scan(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_scan_request *request);
 
-struct cfg80211_ops rndis_config_ops = {
+static struct cfg80211_ops rndis_config_ops = {
 	.change_virtual_intf = rndis_change_virtual_intf,
 	.scan = rndis_scan,
 };
 
-void *rndis_wiphy_privid = &rndis_wiphy_privid;
+static void *rndis_wiphy_privid = &rndis_wiphy_privid;
 
 static const int bcm4320_power_output[4] = { 25, 50, 75, 100 };
 


