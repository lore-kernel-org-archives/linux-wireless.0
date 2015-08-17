Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:34479 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbbHQSAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 14:00:05 -0400
MIME-Version: 1.0
In-Reply-To: <20150817174707.GE5610@mwanda>
References: <CAE_Gge0m4KRC7UJntqnsXPeO9HZ7dg9UexLAi__2EN+ouGGw9w@mail.gmail.com>
 <cover.1439827537.git.raphael.beamonte@gmail.com> <4feb986f253ce20790cafabbf2262c0cc1f2be92.1439827537.git.raphael.beamonte@gmail.com>
 <20150817174707.GE5610@mwanda>
From: =?UTF-8?Q?Rapha=C3=ABl_Beamonte?= <raphael.beamonte@gmail.com>
Date: Mon, 17 Aug 2015 13:59:44 -0400
Message-ID: <CAE_Gge0BYV2Zf2HiP_xf4a5pdjv81x-L_+TEFLVdRR3yi9Ph1w@mail.gmail.com> (sfid-20150817_200036_391626_76C96DEE)
Subject: Re: [PATCH 4/5] staging: wilc1000: use pr_* instead of printk
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-08-17 13:47 GMT-04:00 Dan Carpenter <dan.carpenter@oracle.com>:
>> -                             printk("[Sendconfigpkt]Get Timed out\n");
>> +                             pr_debug("[Sendconfigpkt]Get Timed out\n");
>
>
> Possibly pr_err()?

Yep. My mistake. I'll do the same for Set Timed Out also!

>> -                     printk("DBG [%s: %d]", __func__, __LINE__);     \
>> -                     printk(__VA_ARGS__);                            \
>> +                     pr_debug("DBG [%s: %d]", __func__, __LINE__);   \
>> +                     pr_debug(__VA_ARGS__);                          \
>
> This is a behavior change, I think.  pr_debug() needs to be turned on?

Yes... I didn't pay attention to that! pr_debug needs -DDEBUG in the makefile.
Should I use pr_info here? Or just acknowledge the behavior change for
the moment,
as the next aim is probably, as you said, to remove all the local
debug code? (it is
actually part of the TODO of this driver... So I could just work on that next.)

I'll include your other log level advices and send a new version.
Thanks for your
reviewing time!
