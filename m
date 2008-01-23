Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:56152 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYAWUbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 15:31:18 -0500
Received: by fk-out-0910.google.com with SMTP id z23so2318075fkz.5
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2008 12:31:14 -0800 (PST)
Message-ID: <4797A3EE.7070902@gmail.com> (sfid-20080123_203122_698864_5D17D163)
Date: Wed, 23 Jan 2008 22:30:38 +0200
From: "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>
MIME-Version: 1.0
To: jt@hpl.hp.com
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] WEXT: Correct the size of the buffer to be copied to
 user-space in standard GET WE ioctls.
References: <4793935F.2000102@gmail.com> <43e72e890801201104o5d2e395du558037179156e80b@mail.gmail.com> <20080122181402.GB11873@bougret.hpl.hp.com>
In-Reply-To: <20080122181402.GB11873@bougret.hpl.hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jean Tourrilhes wrote:
>

[skiped]

>>> diff --git a/net/wireless/wext.c b/net/wireless/wext.c
>>> index 47e80cc..c6ce59b 100644
>>> --- a/net/wireless/wext.c
>>> +++ b/net/wireless/wext.c
>>> @@ -866,8 +866,7 @@ static int ioctl_standard_call(struct net_device *  dev,
>>>                         }
>>>
>>>                         err = copy_to_user(iwr->u.data.pointer, extra,
>>> -                                          iwr->u.data.length *
>>> -                                          descr->token_size);
>>> +                                          extra_size);
>>>                         if (err)
>>>                                 ret =  -EFAULT;
>>>                 }
> 
> 	Your patch is not right either, because you could leak kernel
> space memory to user space, which is not good either. And it's clearly
> suboptimal as many time we only fill a tiny amount of that buffer.
> 	What you have is a driver bug.

Yeah, it was bug in a driver.

> 
> 	Let's look at what happens in details...
> --------------------------------------------------------
> 		extra_size = descr->max_tokens * descr->token_size;
> 		extra = kzalloc(extra_size, GFP_KERNEL);
> 		ret = handler(dev, &info, &(iwr->u), extra);
> 			err = copy_to_user(iwr->u.data.pointer, extra,
> 					   iwr->u.data.length *
> 					   descr->token_size);
> --------------------------------------------------------
> 
> 	Now, let's check a typical handler :
> --------------------------------------------------------
> static int ieee80211_ioctl_giwrange(struct net_device *dev,
> 				 struct iw_request_info *info,
> 				 struct iw_point *data, char *extra)
> {
> 	data->length = sizeof(struct iw_range);
> --------------------------------------------------------
> 
> 	And lastly, the definition for the ioctl :
> ---------------------------------------------
> 	[SIOCGIWRANGE	- SIOCIWFIRST] = {
> 		.header_type	= IW_HEADER_TYPE_POINT,
> 		.token_size	= 1,
> 		.max_tokens	= sizeof(struct iw_range),
> 		.flags		= IW_DESCR_FLAG_DUMP,
> 	},
> ---------------------------------------------
> 
> 	What's happening is that the *driver* sets the actual amount
> of data he wrote in iwr->u.data.length in the handler (see
> above). There is no way to guess how much data the driver returns, and
> we don't want to push more data in user space because we would leak
> kernel buffer (security risk).

Actually, the buffer is zeroed by kzalloc(), so only 0s would be leaked :)

> 	(Note: we also check that we don't overrun the userspace
> buffer).
> 
> 	Now, what's obviously missing is that we don't double check
> that the driver returns valid data in iwr->u.data.length. If the
> driver screws up, everything falls apart. But, there are many other
> ways the driver could screw up, and we won't be able to catch
> everything.
> 	I've also seen this fail when the driver and the kernel have
> not been compiled with the same version of Wireless Extensions, but
> that's shooting yourself in the foot.
> 

Thanks for the thorough explanation and sorry for the noise.

> 	Could you point out which driver is responsible for that ?

It is an out-of-tree driver in development of which I'm somewhat involved.

