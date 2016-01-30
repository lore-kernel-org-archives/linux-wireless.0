Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41601 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368AbcA3OjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 09:39:19 -0500
Date: Sat, 30 Jan 2016 17:39:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Arnd Bergmann <arnd@arndb.de>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mac80211: free sinfo on error path
Message-ID: <20160130143906.GD3462@mwanda> (sfid-20160130_153924_252765_68D41BA6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a missing kfree(sinfo) on error in sta_info_insert_finish().

Fixes: 5fe74014172d ('mac80211: avoid excessive stack usage in sta_info')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6c198e6..1502efb 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -562,6 +562,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
  out_err:
 	mutex_unlock(&local->sta_mtx);
 	rcu_read_lock();
+	kfree(sinfo);
 	return err;
 }
 
