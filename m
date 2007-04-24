Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3009 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423096AbXDXUwe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2007 16:52:34 -0400
Date: Tue, 24 Apr 2007 16:28:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] cfg80211: update comment for locking
Message-ID: <20070424202856.GH22681@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a comment that was part of my rtnl locking patch for
cfg80211 but which I forgot for the merge.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/net/cfg80211.h |    4 ++++
 1 file changed, 4 insertions(+)

--- net-2.6.22.orig/include/net/cfg80211.h	2007-04-24 11:20:47.538813880 +0200
+++ net-2.6.22/include/net/cfg80211.h	2007-04-24 11:21:26.388813880 +0200
@@ -23,6 +23,10 @@ struct wiphy;
  * All callbacks except where otherwise noted should return 0
  * on success or a negative error code.
  *
+ * All operations are currently invoked under rtnl for consistency with the
+ * wireless extensions but this is subject to reevaluation as soon as this
+ * code is used more widely and we have a first user without wext.
+ *
  * @add_virtual_intf: create a new virtual interface with the given name
  *
  * @del_virtual_intf: remove the virtual interface determined by ifindex.

-- 
John W. Linville
linville@tuxdriver.com
