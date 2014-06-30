Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52965 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaF3QTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 12:19:10 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so8240730wes.5
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 09:19:09 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 4/7] rtl8180: fix incorrect TX retry.
Date: Mon, 30 Jun 2014 18:18:55 +0200
Message-Id: <1404145135-16076-1-git-send-email-andrea.merello@gmail.com> (sfid-20140630_181917_397533_39A11905)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HW is programmed with wrong retry count value for TX:

Mac80211 passes to driver the number of times the TX should be attempted.
The HW, instead, wants the number of time the TX should be retried if it fails
the first time (assuming we have to TX it at least one time).

This patch correct this.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 8a64bc1..4f4fcf8 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -542,7 +542,7 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 
 	entry->flags2 = info->control.rates[1].idx >= 0 ?
 		ieee80211_get_alt_retry_rate(dev, info, 0)->bitrate << 4 : 0;
-	entry->retry_limit = info->control.rates[0].count;
+	entry->retry_limit = info->control.rates[0].count - 1;
 
 	/* We must be sure that tx_flags is written last because the HW
 	 * looks at it to check if the rest of data is valid or not
-- 
1.9.1

