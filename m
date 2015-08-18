Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:35754 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbbHRF1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 01:27:51 -0400
MIME-Version: 1.0
In-Reply-To: <20150818042417.GA2941@sudip-pc>
References: <20150817195542.GB6591@kroah.com> <b5c4c3dd4babd0cd4daef51626816e95c6d8ee9d.1439852779.git.raphael.beamonte@gmail.com>
 <20150818042417.GA2941@sudip-pc>
From: =?UTF-8?Q?Rapha=C3=ABl_Beamonte?= <raphael.beamonte@gmail.com>
Date: Tue, 18 Aug 2015 01:27:31 -0400
Message-ID: <CAE_Gge0YiZVQi66L3dNUoMg+W-K2KyJ0EJpgeia8=TJ57094QA@mail.gmail.com> (sfid-20150818_072810_872010_9488A2F4)
Subject: Re: [PATCHv3] staging: wilc1000: use netdev_* instead of printk
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-08-18 0:24 GMT-04:00 Sudip Mukherjee <sudipm.mukherjee@gmail.com>:
>> +                             netdev_err("[Sendconfigpkt]Get Timed out\n");
> This will not compile. you can not just replace printk with
> netdev_*, you need to mention a net_device.

You're right! I'm making a lot of mistakes. It seems I called the make
command in the wrong git tree... Thanks for catching that, and taking
time to review!
I just saw there isn't any netdev_debug available. Do you know the
reason for that? Is there a replacement besides pr_debug?
Also, it seems that in all the functions where it's another netdev
that's available that I could use, I don't have access to the
net_device struct. Is there a general way to get that device
information? I saw an old lkml post talking about dev_*() functions to
do that? Would you have some hint on the matter?

Thanks a lot!
Raphaël
