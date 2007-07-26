Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:58442 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbXGZRzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 13:55:47 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] mac80211: revert some GFP_ATOMIC -> GFP_KERNEL changes
Date: Thu, 26 Jul 2007 10:53:44 -0700
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>,
	andy@warmcat.com
Message-Id: <200707261053.44771.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

Some of the allocations made with GFP_ATOMIC really were necessary.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211_sta.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 8296c0c..c9fc9a3 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -3911,7 +3911,7 @@ ieee80211_sta_scan_result(struct net_device *dev,
 
 	if (bss) {
 		char *buf;
-		buf = kmalloc(30, GFP_KERNEL);
+		buf = kmalloc(30, GFP_ATOMIC);
 		if (buf) {
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVCUSTOM;
@@ -3929,7 +3929,7 @@ ieee80211_sta_scan_result(struct net_device *dev,
 		if (!(local->scan_flags & IEEE80211_SCAN_EXTRA_INFO))
 			break;
 
-		buf = kmalloc(100, GFP_KERNEL);
+		buf = kmalloc(100, GFP_ATOMIC);
 		if (!buf)
 			break;
 

