Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbYHTX6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2008 19:58:45 -0400
Message-Id: <200808202356.m7KNuuZg006355@imap1.linux-foundation.org> (sfid-20080821_015853_519852_FC6368E8)
Subject: [patch 2/3] net/ieee80211: adjust error handling
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	julia@diku.dk, Larry.Finger@lwfinger.net, jbenc@suse.cz,
	jketreno@linux.intel.com, yi.zhu@intel.com
From: akpm@linux-foundation.org
Date: Wed, 20 Aug 2008 16:56:56 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Converts a test in error handling code to a sequence of labels.

The semantic match that found the problem is:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E,E1,E2;
@@

E = alloc_etherdev(...)
... when != E = E1
if (...) { ... free_netdev(E); ... return ...; }
... when != E = E2
(
  if (...)
   {
   ... when != free_netdev(E);
   return dev; }
|
* if (...)
   {
   ... when != free_netdev(E);
   return ...; }
|
register_netdev(E)
)

// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Ketrenos <jketreno@linux.intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ieee80211/ieee80211_module.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN net/ieee80211/ieee80211_module.c~net-ieee80211-adjust-error-handling net/ieee80211/ieee80211_module.c
--- a/net/ieee80211/ieee80211_module.c~net-ieee80211-adjust-error-handling
+++ a/net/ieee80211/ieee80211_module.c
@@ -157,7 +157,7 @@ struct net_device *alloc_ieee80211(int s
 	err = ieee80211_networks_allocate(ieee);
 	if (err) {
 		IEEE80211_ERROR("Unable to allocate beacon storage: %d\n", err);
-		goto failed;
+		goto failed_free_netdev;
 	}
 	ieee80211_networks_initialize(ieee);
 
@@ -193,9 +193,9 @@ struct net_device *alloc_ieee80211(int s
 
 	return dev;
 
-      failed:
-	if (dev)
-		free_netdev(dev);
+failed_free_netdev:
+	free_netdev(dev);
+failed:
 	return NULL;
 }
 
_
