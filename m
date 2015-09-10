Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35589 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbbIJJEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 05:04:53 -0400
Received: by pacfv12 with SMTP id fv12so38214715pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 02:04:53 -0700 (PDT)
From: Hiroaki KAWAI <hiroaki.kawai@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Hiroaki KAWAI <hiroaki.kawai@gmail.com>
Subject: [PATCH] carl9170: fix bad rssi reading
Date: Thu, 10 Sep 2015 18:04:45 +0000
Message-Id: <1441908285-606-1-git-send-email-hiroaki.kawai@gmail.com> (sfid-20150910_110457_247921_519D7E63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix rssi calculation error which was introduced in otus to ar9170
porting.

Signed-off-by: Hiroaki KAWAI <hiroaki.kawai@gmail.com>
---
 drivers/net/wireless/ath/carl9170/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 924135b..d66533c 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -453,7 +453,7 @@ static void carl9170_rx_phy_status(struct ar9170 *ar,
 	/* post-process RSSI */
 	for (i = 0; i < 7; i++)
 		if (phy->rssi[i] & 0x80)
-			phy->rssi[i] = ((phy->rssi[i] & 0x7f) + 1) & 0x7f;
+			phy->rssi[i] = ((~phy->rssi[i] & 0x7f) + 1) & 0x7f;
 
 	/* TODO: we could do something with phy_errors */
 	status->signal = ar->noise[0] + phy->rssi_combined;
-- 
2.5.1

