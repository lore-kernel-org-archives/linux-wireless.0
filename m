Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:42907 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbYAVSOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 13:14:05 -0500
Date: Tue, 22 Jan 2008 10:14:02 -0800
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] WEXT: Correct the size of the buffer to be copied to user-space in standard GET WE ioctls.
Message-ID: <20080122181402.GB11873@bougret.hpl.hp.com> (sfid-20080122_181412_616281_BBBA7ADF)
Reply-To: jt@hpl.hp.com
References: <4793935F.2000102@gmail.com> <43e72e890801201104o5d2e395du558037179156e80b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890801201104o5d2e395du558037179156e80b@mail.gmail.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 20, 2008 at 02:04:02PM -0500, Luis R. Rodriguez wrote:
> Adding Jean.
> 
>   Luis
> 
> On Jan 20, 2008 1:30 PM, Volodymyr G. Lukiianyk <volodymyrgl@gmail.com> wrote:
> > For the most of standard WE GET ioctls the size of the buffer to store driver's
> > response is calculated on base of the call's descriptor (.token_size and
> > .max_tokens fields) without taking into consideration the size of the buffer
> > provided by application in struct iwreq. But when the response is being copied to
> > userspace, its size is calculated from the length provided by application. This
> > can lead to kernel internal data leak into userspace, and oopses when the buffer
> > is located near the end of the available memory. To prevent these situations the
> > size used during copying is set to the same one used during allocation.
> >
> >
> > Signed-off-by: Volodymyr G Lukiianyk <volodymyrgl@gmail.com>
> > ---
> >
> > I've actually seen those oopses on the system with 32MB of memory, when 1k
> > object at address c1fffc00 was returned by the SLAB while handling request for
> > allocating 568 bytes buffer (struct iw_range). Later, copy_to_user() (instructed
> > to copy 1136 bytes, since iwlist uses 2x buffer) crashed trying to access
> > c2000000, which is beyond the bounds of available 32MB.
> >
> > The patch attached is against the Linus's tree.
> >
> >
> > diff --git a/net/wireless/wext.c b/net/wireless/wext.c
> > index 47e80cc..c6ce59b 100644
> > --- a/net/wireless/wext.c
> > +++ b/net/wireless/wext.c
> > @@ -866,8 +866,7 @@ static int ioctl_standard_call(struct net_device *  dev,
> >                         }
> >
> >                         err = copy_to_user(iwr->u.data.pointer, extra,
> > -                                          iwr->u.data.length *
> > -                                          descr->token_size);
> > +                                          extra_size);
> >                         if (err)
> >                                 ret =  -EFAULT;
> >                 }

	Your patch is not right either, because you could leak kernel
space memory to user space, which is not good either. And it's clearly
suboptimal as many time we only fill a tiny amount of that buffer.
	What you have is a driver bug.

	Let's look at what happens in details...
--------------------------------------------------------
		extra_size = descr->max_tokens * descr->token_size;
		extra = kzalloc(extra_size, GFP_KERNEL);
		ret = handler(dev, &info, &(iwr->u), extra);
			err = copy_to_user(iwr->u.data.pointer, extra,
					   iwr->u.data.length *
					   descr->token_size);
--------------------------------------------------------

	Now, let's check a typical handler :
--------------------------------------------------------
static int ieee80211_ioctl_giwrange(struct net_device *dev,
				 struct iw_request_info *info,
				 struct iw_point *data, char *extra)
{
	data->length = sizeof(struct iw_range);
--------------------------------------------------------

	And lastly, the definition for the ioctl :
---------------------------------------------
	[SIOCGIWRANGE	- SIOCIWFIRST] = {
		.header_type	= IW_HEADER_TYPE_POINT,
		.token_size	= 1,
		.max_tokens	= sizeof(struct iw_range),
		.flags		= IW_DESCR_FLAG_DUMP,
	},
---------------------------------------------

	What's happening is that the *driver* sets the actual amount
of data he wrote in iwr->u.data.length in the handler (see
above). There is no way to guess how much data the driver returns, and
we don't want to push more data in user space because we would leak
kernel buffer (security risk).
	(Note: we also check that we don't overrun the userspace
buffer).

	Now, what's obviously missing is that we don't double check
that the driver returns valid data in iwr->u.data.length. If the
driver screws up, everything falls apart. But, there are many other
ways the driver could screw up, and we won't be able to catch
everything.
	I've also seen this fail when the driver and the kernel have
not been compiled with the same version of Wireless Extensions, but
that's shooting yourself in the foot.

	Could you point out which driver is responsible for that ?

	Have fun...

	Jean

