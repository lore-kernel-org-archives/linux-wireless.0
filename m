Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:52652 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbZHNRbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 13:31:06 -0400
Received: by ey-out-2122.google.com with SMTP id 22so352475eye.37
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 10:31:07 -0700 (PDT)
Message-ID: <4A859F52.1000608@gmail.com>
Date: Fri, 14 Aug 2009 18:30:58 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Spare warnings - wireless drivers
References: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
In-Reply-To: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Orinoco:
> 
>   CHECK   drivers/net/wireless/orinoco/wext.c
> drivers/net/wireless/orinoco/wext.c:1294:9: warning: context imbalance
> in 'orinoco_ioctl_setibssport' - unexpected unlock

Thanks for the heads up.

I've been staring at setibssport for 5 minutes, and can't see the
alleged imbalance. False positive?

I can't see why sparse picked on setibssport either - half the other
functions in that file do exactly the same.


Dave.

---
PS. since it's short, the full function is:

static int orinoco_ioctl_setibssport(struct net_device *dev,
				     struct iw_request_info *info,
				     void *wrqu,
				     char *extra)
{
	struct orinoco_private *priv = ndev_priv(dev);
	int val = *((int *) extra);
	unsigned long flags;

	if (orinoco_lock(priv, &flags) != 0)
		return -EBUSY;

	priv->ibss_port = val ;

	/* Actually update the mode we are using */
	set_port_type(priv);

	orinoco_unlock(priv, &flags);
	return -EINPROGRESS;		/* Call commit handler */
}

... and there's no (un)locking in set_port_type
