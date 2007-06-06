Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:27546 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935229AbXFFWD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2007 18:03:56 -0400
Date: Wed, 6 Jun 2007 15:02:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: akpm <akpm@linux-foundation.org>, jbenc@suse.cz,
	flamingice@sourmilk.net
Subject: [PATCH -mm] mac80211: fix 1-bit bitfield to unsigned
Message-Id: <20070606150254.de49d627.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix 17 of these pairs of sparse warnings since it's difficult for a 1-bit
bitfield to have both a value bit and a sign bit.

net/mac80211/sta_info.h:105:16: error: dubious bitfield without explicit `signed' or `unsigned'
net/mac80211/sta_info.h:107:15: error: dubious bitfield without explicit `signed' or `unsigned'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/mac80211/sta_info.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.22-rc4-mm1.orig/net/mac80211/sta_info.h
+++ linux-2.6.22-rc4-mm1/net/mac80211/sta_info.h
@@ -102,9 +102,9 @@ struct sta_info {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	int debugfs_registered;
 #endif
-	int assoc_ap:1; /* whether this is an AP that we are
-			 * associated with as a client */
-	int dls_sta:1; /* whether this stations is a DLS peer of us */
+	unsigned int assoc_ap:1; /* whether this is an AP that we are
+				  * associated with as a client */
+	unsigned int dls_sta:1; /* whether this stations is a DLS peer of us */
 
 #define DLS_STATUS_OK		0
 #define DLS_STATUS_NOLINK	1
