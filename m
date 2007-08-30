Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440AbXH3PXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 11:23:15 -0400
Subject: [PATCH] mac80211: ignore key index on pairwise key (WEP only)
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Volker Braun <volker.braun@physik.hu-berlin.de>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 17:24:23 +0200
Message-Id: <1188487463.3978.45.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Volker Braun <vbraun@physics.upenn.edu>

Work-around for broken APs that use a non-zero key index for WEP
pairwise keys. With this patch, WEP encryption only is exempt from
providing a zero key index.

Signed-off-by: Volker Braun <volker.braun@physik.hu-berlin.de>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211_ioctl.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-30 14:35:32.912051253 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-30 14:35:37.972051253 +0200
@@ -416,17 +416,23 @@ static int ieee80211_set_encryption(stru
 
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


