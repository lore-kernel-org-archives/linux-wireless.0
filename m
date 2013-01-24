Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30639 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3AXGk0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 01:40:26 -0500
Date: Thu, 24 Jan 2013 09:40:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] cfg80211: off by one in ieee80211_bss()
Message-ID: <20130124064000.GB5611@elgon.mountain> (sfid-20130124_074031_332291_1EF1988E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do a:

	sprintf(buf, " Last beacon: %ums ago",
		elapsed_jiffies_msecs(bss->ts));

elapsed_jiffies_msecs() can return a 10 digit number so "buf" needs to
be 31 characters long.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 01592d7..45f1618 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1358,7 +1358,7 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 						  &iwe, IW_EV_UINT_LEN);
 	}
 
-	buf = kmalloc(30, GFP_ATOMIC);
+	buf = kmalloc(31, GFP_ATOMIC);
 	if (buf) {
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = IWEVCUSTOM;
