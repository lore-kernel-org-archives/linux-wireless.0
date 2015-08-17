Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33922 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbHQSG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 14:06:56 -0400
Date: Mon, 17 Aug 2015 21:06:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?iso-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] staging: wilc1000: use pr_* instead of printk
Message-ID: <20150817180657.GF5610@mwanda> (sfid-20150817_200744_587370_5F774FB2)
References: <CAE_Gge0m4KRC7UJntqnsXPeO9HZ7dg9UexLAi__2EN+ouGGw9w@mail.gmail.com>
 <cover.1439827537.git.raphael.beamonte@gmail.com>
 <4feb986f253ce20790cafabbf2262c0cc1f2be92.1439827537.git.raphael.beamonte@gmail.com>
 <20150817174707.GE5610@mwanda>
 <CAE_Gge0BYV2Zf2HiP_xf4a5pdjv81x-L_+TEFLVdRR3yi9Ph1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAE_Gge0BYV2Zf2HiP_xf4a5pdjv81x-L_+TEFLVdRR3yi9Ph1w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2015 at 01:59:44PM -0400, Raphaël Beamonte wrote:
> 2015-08-17 13:47 GMT-04:00 Dan Carpenter <dan.carpenter@oracle.com>:
> >> -                             printk("[Sendconfigpkt]Get Timed out\n");
> >> +                             pr_debug("[Sendconfigpkt]Get Timed out\n");
> >
> >
> > Possibly pr_err()?
> 
> Yep. My mistake. I'll do the same for Set Timed Out also!
> 
> >> -                     printk("DBG [%s: %d]", __func__, __LINE__);     \
> >> -                     printk(__VA_ARGS__);                            \
> >> +                     pr_debug("DBG [%s: %d]", __func__, __LINE__);   \
> >> +                     pr_debug(__VA_ARGS__);                          \
> >
> > This is a behavior change, I think.  pr_debug() needs to be turned on?
> 
> Yes... I didn't pay attention to that! pr_debug needs -DDEBUG in the makefile.
> Should I use pr_info here? Or just acknowledge the behavior change for
> the moment,
> as the next aim is probably, as you said, to remove all the local
> debug code? (it is
> actually part of the TODO of this driver... So I could just work on that next.)

I would probably just do the rest and leave this part as-is since you're
planning to redo it all anyway.  I guess just do stuff which is obvious
and hopefully more and more stuff will become obvious as you go along.
This is a lazy answer but I don't want to think about this driver very
hard...  :P

Also always try to order your patches from least controversial to most
controversial.  It makes it easier to redo things or sometimes Greg
applies the first part of a patch series.

regards,
dan carpenter

