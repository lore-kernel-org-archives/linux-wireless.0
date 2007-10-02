Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:3205 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbXJBT6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 15:58:04 -0400
Subject: [PATCH] - trivial - Correct printk with PFX before KERN_ in
	drivers/net/wireless/bcm43xx/bcm43xx_wx.c
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Stefano Brivio <st3@riseup.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jeff Garzik <jgarzik@pobox.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain
Date: Tue, 02 Oct 2007 12:57:11 -0700
Message-Id: <1191355031.29929.2.camel@localhost> (sfid-20071002_205812_741565_5881E4EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c b/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
index d6d9413..6acfdc4 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
@@ -444,7 +444,7 @@ static int bcm43xx_wx_set_xmitpower(struct net_device *net_dev,
 	u16 maxpower;
 
 	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM) {
-		printk(PFX KERN_ERR "TX power not in dBm.\n");
+		printk(KERN_ERR PFX "TX power not in dBm.\n");
 		return -EOPNOTSUPP;
 	}
 


