Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:53426 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXFCWG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2007 18:06:57 -0400
Date: Mon, 4 Jun 2007 00:06:51 +0200
From: David Lamparter <lists@diac24.net>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] cfg80211: fix signed macaddress in sysfs
Message-ID: <20070603220651.GA22070@charon.n2.diac24.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix signedness mixup making mac addresses show up strangely
(like 00:11:22:33:44:ffffffaa) in /sys/class/ieee80211/*/macaddress.

Signed-off-by: David Lamparter <equinox@diac24.net>
---

 net/wireless/sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 7844be4..374d16d 100644
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
