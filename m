Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29061 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968864AbXFHREi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 13:04:38 -0400
Date: Sat, 9 Jun 2007 01:03:55 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/6] mac80211: fix 1-bit bitfield to unsigned
Message-ID: <20070608170355.GA17262@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 17 of these pairs of sparse warnings since it's difficult for a 1-bit
bitfield to have both a value bit and a sign bit.

net/mac80211/sta_info.h:105:16: error: dubious bitfield without explicit
`signed' or `unsigned'
net/mac80211/sta_info.h:107:15: error: dubious bitfield without explicit
`signed' or `unsigned'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/sta_info.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 3eb3649..1179c32 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
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
-- 
1.5.0.rc2.g73a2
