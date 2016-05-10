Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43589 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbcEJTVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 15:21:40 -0400
Date: Tue, 10 May 2016 22:21:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Simon Kelley <simon@thekelleys.org.uk>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] atmel: potential underflow in atmel_set_freq()
Message-ID: <20160510192117.GC30712@mwanda> (sfid-20160510_212201_080473_AF797CEB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch complains that we cap the upper bound of "fwrq->m" but not the
lower bound.  I don't know if it can actually happen but it's simple
enough to check for negatives.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index 8f8f37f..bf2e9a0 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -2275,7 +2275,7 @@ static int atmel_set_freq(struct net_device *dev,
 		fwrq->m = ieee80211_frequency_to_channel(f);
 	}
 	/* Setting by channel number */
-	if ((fwrq->m > 1000) || (fwrq->e > 0))
+	if (fwrq->m < 0 || fwrq->m > 1000 || fwrq->e > 0)
 		rc = -EOPNOTSUPP;
 	else {
 		int channel = fwrq->m;
