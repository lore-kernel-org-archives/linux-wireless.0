Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36844 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbcEZHkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2016 03:40:45 -0400
Received: by mail-pf0-f194.google.com with SMTP id g132so1368592pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2016 00:40:45 -0700 (PDT)
From: Prasun Maiti <prasunmaiti87@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	Ujjal Roy <royujjal@gmail.com>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Subject: [PATCH] wext: Fix 32 bit iwpriv compatibility issue with 64 bit Kernel
Date: Thu, 26 May 2016 13:10:32 +0530
Message-Id: <1464248432-12595-1-git-send-email-prasunmaiti87@gmail.com> (sfid-20160526_094100_383531_600FB398)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwpriv app uses iw_point structure to send data to Kernel. The iw_point
structure holds a pointer. For compatibility Kernel converts the pointer
as required for WEXT IOCTLs (SIOCIWFIRST to SIOCIWLAST). Some drivers
may use iw_handler_def.private_args to populate iwpriv commands instead
of iw_handler_def.private. For those case, the IOCTLs from
SIOCIWFIRSTPRIV to SIOCIWLASTPRIV will follow the path ndo_do_ioctl().
Accordingly when the filled up iw_point structure comes from 32 bit
iwpriv to 64 bit Kernel, Kernel will not convert the pointer and sends
it to driver. So, the driver may get the invalid data.

The pointer conversion for the IOCTLs (SIOCIWFIRSTPRIV to
SIOCIWLASTPRIV), which follow the path ndo_do_ioctl(), is mandatory.
This patch adds pointer conversion from 32 bit to 64 bit and vice versa,
if the ioctl comes from 32 bit iwpriv to 64 bit Kernel.

Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Tested-by: Dibyajyoti Ghosh <dibyajyotig@gmail.com>
---
 net/wireless/wext-core.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -955,8 +955,30 @@ static int wireless_process_ioctl(struct net *net, struct ifreq *ifr,
 			return private(dev, iwr, cmd, info, handler);
 	}
 	/* Old driver API : call driver ioctl handler */
-	if (dev->netdev_ops->ndo_do_ioctl)
-		return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
+	if (dev->netdev_ops->ndo_do_ioctl) {
+		if ((info->flags & IW_REQUEST_FLAG_COMPAT) &&
+				(cmd >= SIOCIWFIRSTPRIV && cmd <= SIOCIWLASTPRIV)) {
+			int ret = 0;
+			struct compat_iw_point *iwp_compat = (struct compat_iw_point *) &iwr->u.data;
+			struct iw_point *iwp = &iwr->u.data;
+			__u16 length = iwp_compat->length, flags = iwp_compat->flags;
+
+			iwp->pointer = compat_ptr(iwp_compat->pointer);
+			iwp->length = length;
+			iwp->flags = flags;
+
+			ret = dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
+
+			length = iwp->length;
+			flags = iwp->flags;
+			iwp_compat->pointer = ptr_to_compat(iwp->pointer);
+			iwp_compat->length = length;
+			iwp_compat->flags = flags;
+			return ret;
+		} else {
+			return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
+		}
+	}
 	return -EOPNOTSUPP;
 }

--
1.9.1

