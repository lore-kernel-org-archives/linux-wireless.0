Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:25820 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759939Ab2J3SFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 14:05:16 -0400
Date: Tue, 30 Oct 2012 21:04:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ar5523: make buffer size variable unsigned
Message-ID: <20121030180425.GA17127@elgon.mountain> (sfid-20121030_190523_847310_5A8D23F3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A negative buffer size doesn't make sense and it breaks this check in
ar5523_get_max_rxsz():

	if (!ar->rxbufsz || ar->rxbufsz > AR5523_SANE_RXBUFSZ) { ...

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.h b/drivers/net/wireless/ath/ar5523/ar5523.h
index 6086ba3..00c6fd3 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.h
+++ b/drivers/net/wireless/ath/ar5523/ar5523.h
@@ -122,7 +122,7 @@ struct ar5523 {
 
 	struct work_struct	rx_refill_work;
 
-	int			rxbufsz;
+	unsigned int		rxbufsz;
 	u8			serial[16];
 
 	struct ieee80211_channel channels[14];
