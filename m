Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46466 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbcFCSrH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 14:47:07 -0400
Message-ID: <1464979620.2224.5.camel@sipsolutions.net> (sfid-20160603_204712_366360_49A51FA8)
Subject: Re: [PATCH] wext: Fix 32 bit iwpriv compatibility issue with 64 bit
 Kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Prasun Maiti <prasunmaiti87@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	Ujjal Roy <royujjal@gmail.com>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Date: Fri, 03 Jun 2016 20:47:00 +0200
In-Reply-To: <CAEO8o4=-oYuHuh42yfRa6kAUZ2hBmxHabU-W3V82kURg-GZv_g@mail.gmail.com> (sfid-20160603_112414_628143_FA6C3B59)
References: <1464248432-12595-1-git-send-email-prasunmaiti87@gmail.com>
	 <1464690345.3076.17.camel@sipsolutions.net>
	 <CAEO8o4=-oYuHuh42yfRa6kAUZ2hBmxHabU-W3V82kURg-GZv_g@mail.gmail.com>
	 (sfid-20160603_112414_628143_FA6C3B59)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>      diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
> index 6250b1c..50583fb 100644
> --- a/net/wireless/wext-core.c
> +++ b/net/wireless/wext-core.c
> @@ -958,8 +958,28 @@ static int wireless_process_ioctl(struct net
> *net, struct ifreq *ifr,
>             return private(dev, iwr, cmd, info, handler);
>     }
>     /* Old driver API : call driver ioctl handler */
> -   if (dev->netdev_ops->ndo_do_ioctl)
> -       return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
> +   if (dev->netdev_ops->ndo_do_ioctl) {
> +       if (info->flags & IW_REQUEST_FLAG_COMPAT) {
> +           int ret = 0;
> +           struct iwreq iwrp;
> +           struct compat_iw_point *iwp_compat =
> +               (struct compat_iw_point *) &iwr->u.data;

No need for the long cast - use (void *).

> +           strncpy(iwrp.ifr_ifrn.ifrn_name, iwr->ifr_ifrn.ifrn_name, 
> IFNAMSIZ);
> +           iwrp.u.data.pointer = compat_ptr(iwp_compat->pointer);
> +           iwrp.u.data.length = iwp_compat->length;
> +           iwrp.u.data.flags = iwp_compat->flags;

Maybe you should clear iwrp first?

> +           ret = dev->netdev_ops->ndo_do_ioctl(dev, (struct ifreq *)
> &iwrp, cmd);

Same here with the cast.

I'd blissfully forgotten how totally crufty this API is ... oh well.

> +           iwp_compat->pointer = ptr_to_compat(iwrp.u.data.pointer);
> +           iwp_compat->length = iwrp.u.data.length;
> +           iwp_compat->flags = iwrp.u.data.flags;
> +           return ret;
> +       } else {
> +           return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);





Please resend as a proper patch, with signed-off-by etc., and a commit
log explaining the problem and solution.

Thanks,
johannes
