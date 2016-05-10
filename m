Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26326 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbcEJTV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 15:21:27 -0400
Date: Tue, 10 May 2016 22:20:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Felipe Balbi <felipe.balbi@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] airo: prevent potential underflow in airo_set_freq()
Message-ID: <20160510192037.GB30712@mwanda> (sfid-20160510_212235_800106_89C82B92)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure if this can underflow but Smatch complains.  It seems
harmless to add a check for negatives.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 55456f7..ca3cd21 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -5794,7 +5794,7 @@ static int airo_set_freq(struct net_device *dev,
 		fwrq->m = ieee80211_frequency_to_channel(f);
 	}
 	/* Setting by channel number */
-	if((fwrq->m > 1000) || (fwrq->e > 0))
+	if (fwrq->m < 0 || fwrq->m > 1000 || fwrq->e > 0)
 		rc = -EOPNOTSUPP;
 	else {
 		int channel = fwrq->m;
