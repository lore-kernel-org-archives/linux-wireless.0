Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35487 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbcFFOea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 10:34:30 -0400
Received: by mail-pa0-f66.google.com with SMTP id gp3so11955192pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2016 07:34:25 -0700 (PDT)
From: Prasun Maiti <prasunmaiti87@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	Ujjal Roy <royujjal@gmail.com>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Subject: [PATCH] wext: Fix 32 bit iwpriv compatibility issue with 64 bit Kernel
Date: Mon,  6 Jun 2016 20:04:19 +0530
Message-Id: <1465223659-11530-1-git-send-email-prasunmaiti87@gmail.com> (sfid-20160606_163435_275621_781F2C12)
In-Reply-To: <1464690345.3076.17.camel@sipsolutions.net>
References: <1464690345.3076.17.camel@sipsolutions.net>
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
 net/wireless/wext-core.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 6250b1c..a96dcc6 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -958,8 +958,28 @@ static int wireless_process_ioctl(struct net *net, struct ifreq *ifr,
 			return private(dev, iwr, cmd, info, handler);
 	}
 	/* Old driver API : call driver ioctl handler */
-	if (dev->netdev_ops->ndo_do_ioctl)
-		return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
+	if (dev->netdev_ops->ndo_do_ioctl) {
+#ifdef CONFIG_COMPAT
+		if (info->flags & IW_REQUEST_FLAG_COMPAT) {
+			int ret = 0;
+			struct iwreq iwr_lcl;
+			struct compat_iw_point *iwp_compat = (void *) &iwr->u.data;
+
+			memcpy(&iwr_lcl, iwr, sizeof(struct iwreq));
+			iwr_lcl.u.data.pointer = compat_ptr(iwp_compat->pointer);
+			iwr_lcl.u.data.length = iwp_compat->length;
+			iwr_lcl.u.data.flags = iwp_compat->flags;
+
+			ret = dev->netdev_ops->ndo_do_ioctl(dev, (void *) &iwr_lcl, cmd);
+
+			iwp_compat->pointer = ptr_to_compat(iwr_lcl.u.data.pointer);
+			iwp_compat->length = iwr_lcl.u.data.length;
+			iwp_compat->flags = iwr_lcl.u.data.flags;
+			return ret;
+		} else
+#endif
+			return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
+	}
 	return -EOPNOTSUPP;
 }

--
1.9.1

