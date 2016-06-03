Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34792 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbcFCJYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 05:24:19 -0400
Received: by mail-oi0-f67.google.com with SMTP id e80so8318871oig.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2016 02:24:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464690345.3076.17.camel@sipsolutions.net>
References: <1464248432-12595-1-git-send-email-prasunmaiti87@gmail.com> <1464690345.3076.17.camel@sipsolutions.net>
From: Prasun Maiti <prasunmaiti87@gmail.com>
Date: Fri, 3 Jun 2016 14:54:12 +0530
Message-ID: <CAEO8o4=-oYuHuh42yfRa6kAUZ2hBmxHabU-W3V82kURg-GZv_g@mail.gmail.com> (sfid-20160603_112435_802022_40225DEF)
Subject: Re: [PATCH] wext: Fix 32 bit iwpriv compatibility issue with 64 bit Kernel
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	Ujjal Roy <royujjal@gmail.com>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

If a wireless driver uses "iw_handler_def.private_args" to populate
iwpriv command for private ioctls
but  handlers for private ioctls(iw_handler) of iw_handler_def.private
is set to NULL like "atmel" and "airo" wireless drivers.
For those case, the IOCTLs from SIOCIWFIRSTPRIV to SIOCIWLASTPRIV will
follow the path ndo_do_ioctl().
Accordingly when the filled up "iw_point" structure comes from 32 bit
iwpriv to 64 bit Kernel, Kernel will not convert the pointer and sends
it to driver. So, the driver may get the invalid data.

We have used another iwr (i.e; iwrp) to pass things to driver. Changes
are as follows. Please have look into this.

     diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 6250b1c..50583fb 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -958,8 +958,28 @@ static int wireless_process_ioctl(struct net
*net, struct ifreq *ifr,
            return private(dev, iwr, cmd, info, handler);
    }
    /* Old driver API : call driver ioctl handler */
-   if (dev->netdev_ops->ndo_do_ioctl)
-       return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
+   if (dev->netdev_ops->ndo_do_ioctl) {
+       if (info->flags & IW_REQUEST_FLAG_COMPAT) {
+           int ret = 0;
+           struct iwreq iwrp;
+           struct compat_iw_point *iwp_compat =
+               (struct compat_iw_point *) &iwr->u.data;
+
+           strncpy(iwrp.ifr_ifrn.ifrn_name, iwr->ifr_ifrn.ifrn_name, IFNAMSIZ);
+           iwrp.u.data.pointer = compat_ptr(iwp_compat->pointer);
+           iwrp.u.data.length = iwp_compat->length;
+           iwrp.u.data.flags = iwp_compat->flags;
+
+           ret = dev->netdev_ops->ndo_do_ioctl(dev, (struct ifreq *)
&iwrp, cmd);
+
+           iwp_compat->pointer = ptr_to_compat(iwrp.u.data.pointer);
+           iwp_compat->length = iwrp.u.data.length;
+           iwp_compat->flags = iwrp.u.data.flags;
+           return ret;
+       } else {
+           return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
+       }
+   }
    return -EOPNOTSUPP;
 }

Is it Ok?

Thanks,
Prasun

On Tue, May 31, 2016 at 3:55 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
> I must say, this is a bit of a surprise - where is iwpriv actually
> still relevant? What driver could this possibly matter for?
>
> Anyway ...
>
>> +     if (dev->netdev_ops->ndo_do_ioctl) {
>> +             if ((info->flags & IW_REQUEST_FLAG_COMPAT) &&
>> +                             (cmd >= SIOCIWFIRSTPRIV && cmd <=
>> SIOCIWLASTPRIV)) {
>
> This has coding style issues, obviously.
>
> Also, handling the non-compat case would allow you to return and reduce
> indentation by one in the large code block that handles the compat.
>
>> +                     int ret = 0;
>> +                     struct compat_iw_point *iwp_compat = (struct compat_iw_point *) &iwr->u.data;
>> +                     struct iw_point *iwp = &iwr->u.data;
>> +                     __u16 length = iwp_compat->length, flags = iwp_compat->flags;
>> +
>> +                     iwp->pointer = compat_ptr(iwp_compat->pointer);
>> +                     iwp->length = length;
>> +                     iwp->flags = flags;
>> +
>> +                     ret = dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
>> +
>> +                     length = iwp->length;
>> +                     flags = iwp->flags;
>> +                     iwp_compat->pointer = ptr_to_compat(iwp->pointer);
>> +                     iwp_compat->length = length;
>> +                     iwp_compat->flags = flags;
>
> Why don't you just put another ifr/iwr on the stack, and use that to
> pass things to the driver? This modify-in-place of 'iwp', which
> requires loading all the variables first, seems very awkward to me.
>
>
> johannes



-- 
Thanks,
Prasun
