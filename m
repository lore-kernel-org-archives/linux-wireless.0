Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933935AbXC1JMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:12:39 -0400
Subject: [PATCH] mac80211: use is_broadcast_ether_addr
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 23:52:39 +0200
Message-Id: <1175032359.5151.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change a whole bunch of places to use is_broadcast_ether_addr.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211_ioctl.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-03-27 23:50:18.051396904 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-03-27 23:51:03.501396904 +0200
@@ -410,9 +410,7 @@ static int ieee80211_ioctl_get_info_sta(
 	struct ieee80211_hw_mode *mode;
 	struct sta_info *sta;
 
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
+	if (is_broadcast_ether_addr(param->sta_addr)) {
 		struct net_device_stats *stats;
 
 		stats = ieee80211_dev_stats(local->mdev);
@@ -531,9 +529,7 @@ static int ieee80211_set_encryption(stru
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sta_addr[0] == 0xff && sta_addr[1] == 0xff &&
-	    sta_addr[2] == 0xff && sta_addr[3] == 0xff &&
-	    sta_addr[4] == 0xff && sta_addr[5] == 0xff) {
+	if (is_broadcast_ether_addr(sta_addr)) {
 		sta = NULL;
 		if (idx >= NUM_DEFAULT_KEYS) {
 			printk(KERN_DEBUG "%s: set_encrypt - invalid idx=%d\n",
@@ -799,9 +795,7 @@ static int ieee80211_ioctl_get_encryptio
 	if (max_key_len < 0)
 		return -EINVAL;
 
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
+	if (is_broadcast_ether_addr(param->sta_addr)) {
 		sta = NULL;
 		if (param->u.crypt.idx >= NUM_DEFAULT_KEYS) {
 			param->u.crypt.idx = sdata->default_key ?
@@ -903,9 +897,7 @@ static int ieee80211_ioctl_wpa_trigger(s
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
+	if (is_broadcast_ether_addr(param->sta_addr)) {
 		local->wpa_trigger = param->u.wpa_trigger.trigger;
 		return 0;
 	}


