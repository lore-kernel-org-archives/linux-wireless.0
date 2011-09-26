Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:57721 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab1IZIRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 04:17:05 -0400
Date: Mon, 26 Sep 2011 09:30:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] wl3501_cs: min_t() cast truncates high bits
Message-ID: <20110926063040.GE11832@elgon.mountain> (sfid-20110926_101711_920668_B3BB1CCE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wrqu->encoding.length comes from the network administrator.  It's
size u16.  We want to limit "tocopy" to the smallest value of either
"len_keys", "wrqu->encoding.length" or 100.  But because .length
gets cast from u16 to u8 we might use a random, smaller value than
the was desired.  It's probably not very serious, but we may as well
fix it.

Btw, this is from code auditing and not from testing.  I don't know
if this affects anyone in real life.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 6bc7c92..98fbf54 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1781,7 +1781,7 @@ static int wl3501_get_encode(struct net_device *dev,
 				  keys, len_keys);
 	if (rc)
 		goto out;
-	tocopy = min_t(u8, len_keys, wrqu->encoding.length);
+	tocopy = min_t(u16, len_keys, wrqu->encoding.length);
 	tocopy = min_t(u8, tocopy, 100);
 	wrqu->encoding.length = tocopy;
 	memcpy(extra, keys, tocopy);
