Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2814 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912AbXFLByr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 21:54:47 -0400
Date: Mon, 11 Jun 2007 21:17:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] cfg80211: fix signed macaddress in sysfs
Message-ID: <20070612011716.GD20422@tuxdriver.com>
References: <20070612011616.GC20422@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070612011616.GC20422@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Lamparter <lists@diac24.net>

Fix signedness mixup making mac addresses show up strangely
(like 00:11:22:33:44:ffffffaa) in /sys/class/ieee80211/*/macaddress.

Signed-off-by: David Lamparter <equinox@diac24.net>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 3ebae14..88aaacd 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -33,7 +33,7 @@ static ssize_t _show_permaddr(struct device *dev,
 			      struct device_attribute *attr,
 			      char *buf)
 {
-	char *addr = dev_to_rdev(dev)->wiphy.perm_addr;
+	unsigned char *addr = dev_to_rdev(dev)->wiphy.perm_addr;
 
 	return sprintf(buf, "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
 		       addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
-- 
1.5.0.6

-- 
John W. Linville
linville@tuxdriver.com
