Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30688 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2LBKgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 05:36:32 -0500
Date: Sun, 2 Dec 2012 13:36:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] p54: potential signedness issue in p54_parse_rssical()
Message-ID: <20121202103609.GA16078@elgon.mountain> (sfid-20121202_113659_528325_D34E3270)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"entries" is unsigned here, so it is never less than zero.  In theory,
len could be less than offset so I have added a check for that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index 1ef1bfe..d43e374 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -541,8 +541,9 @@ static int p54_parse_rssical(struct ieee80211_hw *dev,
 		entries = (len - offset) /
 			sizeof(struct pda_rssi_cal_ext_entry);
 
-		if ((len - offset) % sizeof(struct pda_rssi_cal_ext_entry) ||
-		    entries <= 0) {
+		if (len < offset ||
+		    (len - offset) % sizeof(struct pda_rssi_cal_ext_entry) ||
+		    entries == 0) {
 			wiphy_err(dev->wiphy, "invalid rssi database.\n");
 			goto err_data;
 		}
