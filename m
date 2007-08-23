Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbXHWQuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 12:50:10 -0400
Message-Id: <20070823164524.424586000@sipsolutions.net>
References: <20070823164500.998912000@sipsolutions.net>
Date: Thu, 23 Aug 2007 18:45:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Volker Braun <volker.braun@physik.hu-berlin.de>
Subject: [RFC 08/11] mac80211: ignore key index on pairwise key (WEP only)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Work-around for broken APs that use a non-zero key index for WEP
pairwise keys. With this patch, WEP encryption only is exempt from
providing a zero key index.

Signed-off-by: Volker Braun <volker.braun@physik.hu-berlin.de>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211_ioctl.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-23 18:38:37.961897709 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-23 18:38:44.581897709 +0200
@@ -385,17 +385,23 @@ static int ieee80211_set_encryption(stru
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	if (idx < 0 || idx >= NUM_DEFAULT_KEYS) {
+		printk(KERN_DEBUG "%s: set_encrypt - invalid idx=%d\n",
+		       dev->name, idx);
+		return -EINVAL;
+	}
+
 	if (is_broadcast_ether_addr(sta_addr)) {
 		sta = NULL;
-		if (idx >= NUM_DEFAULT_KEYS) {
-			printk(KERN_DEBUG "%s: set_encrypt - invalid idx=%d\n",
-			       dev->name, idx);
-			return -EINVAL;
-		}
 		key = sdata->keys[idx];
 	} else {
 		set_tx_key = 0;
-		if (idx != 0) {
+		/*
+		 * According to the standard, the key index of a pairwise
+		 * key must be zero. However, some AP are broken when it
+		 * comes to WEP key indices, so we work around this.
+		 */
+		if (idx != 0 && alg != ALG_WEP) {
 			printk(KERN_DEBUG "%s: set_encrypt - non-zero idx for "
 			       "individual key\n", dev->name);
 			return -EINVAL;

-- 

