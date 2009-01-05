Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from suva.vyatta.com ([76.74.103.44]:50356 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZAEU5X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 15:57:23 -0500
Message-Id: <20090105201514.442703045@vyatta.com> (sfid-20090105_215726_953826_AD257FAC)
References: <20090105201442.749889072@vyatta.com>
Date: Mon, 05 Jan 2009 12:14:45 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>, linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] wireless: convert wireless ioctl to net_device_ops
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/net/wireless/wext.c	2009-01-05 08:40:34.045826527 -0800
+++ b/net/wireless/wext.c	2009-01-05 09:33:27.362505126 -0800
@@ -1055,8 +1055,8 @@ static int wireless_process_ioctl(struct
 			return private(dev, iwr, cmd, info, handler);
 	}
 	/* Old driver API : call driver ioctl handler */
-	if (dev->do_ioctl)
-		return dev->do_ioctl(dev, ifr, cmd);
+	if (dev->netdev_ops->ndo_do_ioctl)
+		return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
 	return -EOPNOTSUPP;
 }
 

-- 

