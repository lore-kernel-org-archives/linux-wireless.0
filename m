Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbZFQPn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 11:43:58 -0400
Subject: [PATCH (temporary)] net: export __dev_addr_sync/__dev_addr_unsync
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 17:43:30 +0200
Message-Id: <1245253410.31588.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For mac80211, with the master netdev removal, we need to be
able to sync a multicast address list onto another list that
is not tracked within a netdev, so we need access to the
functions doing that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This is a temporary patch, to live in wireless-testing for testing the
mac80211 patch that depends on it, until Jiri Pirko refactors the code
for handling multicast lists and we can rebase this and the mac80211
mdev removal over his work.

 net/core/dev.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/core/dev.c	2009-06-17 01:20:04.000000000 +0200
+++ wireless-testing/net/core/dev.c	2009-06-17 01:20:24.000000000 +0200
@@ -3585,6 +3585,7 @@ int __dev_addr_sync(struct dev_addr_list
 	}
 	return err;
 }
+EXPORT_SYMBOL_GPL(__dev_addr_sync);
 
 void __dev_addr_unsync(struct dev_addr_list **to, int *to_count,
 		       struct dev_addr_list **from, int *from_count)
@@ -3604,6 +3605,7 @@ void __dev_addr_unsync(struct dev_addr_l
 		da = next;
 	}
 }
+EXPORT_SYMBOL_GPL(__dev_addr_unsync);
 
 /**
  *	dev_unicast_sync - Synchronize device's unicast list to another device


