Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:34477 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1DOXUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 19:20:30 -0400
Date: Fri, 15 Apr 2011 16:20:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linville@tuxdriver.com
Subject: [PATCH -next] mac80211: fix debugfs printk format warning
Message-Id: <20110415162005.eba5e8f3.randy.dunlap@oracle.com>
In-Reply-To: <20110415142852.1c745499.sfr@canb.auug.org.au>
References: <20110415142852.1c745499.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printf() format warning (tm_year is long int):

net/mac80211/debugfs_sta.c:113: warning: format '%d' expects type 'int', but argument 4 has type 'long int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/mac80211/debugfs_sta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110415.orig/net/mac80211/debugfs_sta.c
+++ linux-next-20110415/net/mac80211/debugfs_sta.c
@@ -108,7 +108,7 @@ static ssize_t sta_connected_time_read(s
 	result.tm_year -= 70;
 	result.tm_mday -= 1;
 	res = scnprintf(buf, sizeof(buf),
-		"years  - %d\nmonths - %d\ndays   - %d\nclock  - %d:%d:%d\n\n",
+		"years  - %ld\nmonths - %d\ndays   - %d\nclock  - %d:%d:%d\n\n",
 			result.tm_year, result.tm_mon, result.tm_mday,
 			result.tm_hour, result.tm_min, result.tm_sec);
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
