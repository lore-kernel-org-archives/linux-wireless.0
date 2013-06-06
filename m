Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35875 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab3FFHnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 03:43:41 -0400
Date: Thu, 6 Jun 2013 10:43:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] cw1200: read beyond end of array in debug code
Message-ID: <20130606074300.GB12953@debian> (sfid-20130606_094347_726349_C45AB56B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has only one caller and rates[] is an array with
IEEE80211_TX_MAX_RATES (4) elements.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/cw1200/txrx.c b/drivers/net/wireless/cw1200/txrx.c
index 0e40890..a254747 100644
--- a/drivers/net/wireless/cw1200/txrx.c
+++ b/drivers/net/wireless/cw1200/txrx.c
@@ -190,13 +190,12 @@ static void tx_policy_build(const struct cw1200_common *priv,
 		policy->retry_count += retries;
 	}
 
-	pr_debug("[TX policy] Policy (%zu): %d:%d, %d:%d, %d:%d, %d:%d, %d:%d\n",
+	pr_debug("[TX policy] Policy (%zu): %d:%d, %d:%d, %d:%d, %d:%d\n",
 		 count,
 		 rates[0].idx, rates[0].count,
 		 rates[1].idx, rates[1].count,
 		 rates[2].idx, rates[2].count,
-		 rates[3].idx, rates[3].count,
-		 rates[4].idx, rates[4].count);
+		 rates[3].idx, rates[3].count);
 }
 
 static inline bool tx_policy_is_equal(const struct tx_policy *wanted,
