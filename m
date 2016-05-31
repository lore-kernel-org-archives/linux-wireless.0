Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40609 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbcEaKZv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 06:25:51 -0400
Message-ID: <1464690345.3076.17.camel@sipsolutions.net> (sfid-20160531_122554_428016_EFE75DF1)
Subject: Re: [PATCH] wext: Fix 32 bit iwpriv compatibility issue with 64 bit
 Kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Prasun Maiti <prasunmaiti87@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	Ujjal Roy <royujjal@gmail.com>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Date: Tue, 31 May 2016 12:25:45 +0200
In-Reply-To: <1464248432-12595-1-git-send-email-prasunmaiti87@gmail.com> (sfid-20160526_094047_190562_9918B3AC)
References: <1464248432-12595-1-git-send-email-prasunmaiti87@gmail.com>
	 (sfid-20160526_094047_190562_9918B3AC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I must say, this is a bit of a surprise - where is iwpriv actually
still relevant? What driver could this possibly matter for?

Anyway ...

> +	if (dev->netdev_ops->ndo_do_ioctl) {
> +		if ((info->flags & IW_REQUEST_FLAG_COMPAT) &&
> +				(cmd >= SIOCIWFIRSTPRIV && cmd <=
> SIOCIWLASTPRIV)) {

This has coding style issues, obviously.

Also, handling the non-compat case would allow you to return and reduce
indentation by one in the large code block that handles the compat.

> +			int ret = 0;
> +			struct compat_iw_point *iwp_compat = (struct compat_iw_point *) &iwr->u.data;
> +			struct iw_point *iwp = &iwr->u.data;
> +			__u16 length = iwp_compat->length, flags = iwp_compat->flags;
> +
> +			iwp->pointer = compat_ptr(iwp_compat->pointer);
> +			iwp->length = length;
> +			iwp->flags = flags;
> +
> +			ret = dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
> +
> +			length = iwp->length;
> +			flags = iwp->flags;
> +			iwp_compat->pointer = ptr_to_compat(iwp->pointer);
> +			iwp_compat->length = length;
> +			iwp_compat->flags = flags;

Why don't you just put another ifr/iwr on the stack, and use that to
pass things to the driver? This modify-in-place of 'iwp', which
requires loading all the variables first, seems very awkward to me.


johannes
