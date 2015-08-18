Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35926 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbbHRGK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 02:10:58 -0400
Date: Tue, 18 Aug 2015 11:40:50 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: =?iso-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCHv3] staging: wilc1000: use netdev_* instead of printk
Message-ID: <20150818061050.GG2941@sudip-pc> (sfid-20150818_081121_411494_D4A38CBB)
References: <20150817195542.GB6591@kroah.com>
 <b5c4c3dd4babd0cd4daef51626816e95c6d8ee9d.1439852779.git.raphael.beamonte@gmail.com>
 <20150818042417.GA2941@sudip-pc>
 <CAE_Gge0YiZVQi66L3dNUoMg+W-K2KyJ0EJpgeia8=TJ57094QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAE_Gge0YiZVQi66L3dNUoMg+W-K2KyJ0EJpgeia8=TJ57094QA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2015 at 01:27:31AM -0400, Raphaël Beamonte wrote:
> 2015-08-18 0:24 GMT-04:00 Sudip Mukherjee <sudipm.mukherjee@gmail.com>:
> >> +                             netdev_err("[Sendconfigpkt]Get Timed out\n");
> > This will not compile. you can not just replace printk with
> > netdev_*, you need to mention a net_device.
> 
> You're right! I'm making a lot of mistakes. It seems I called the make
> command in the wrong git tree... Thanks for catching that, and taking
> time to review!
> I just saw there isn't any netdev_debug available. Do you know the
> reason for that? Is there a replacement besides pr_debug?
netdev_dbg
> Also, it seems that in all the functions where it's another netdev
> that's available that I could use, I don't have access to the
> net_device struct. Is there a general way to get that device
> information? I saw an old lkml post talking about dev_*() functions to
> do that? Would you have some hint on the matter?
If the function is not having the net_device try to see if you can
pass it the struct as an argument. if not possible then in any way then
no other way but to use pr_*

regards
sudip
