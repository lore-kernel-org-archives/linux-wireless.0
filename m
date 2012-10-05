Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35138 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab2JEHAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 03:00:35 -0400
Message-ID: <1349420428.10584.8.camel@smile> (sfid-20121005_090038_777249_D92B3223)
Subject: Re: [PATCH] mwifiex: Using %*phD instead of print_hex_dump_bytes
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	linux-wireless@vger.kernel.org, bzhao@marvell.com
Date: Fri, 05 Oct 2012 10:00:28 +0300
In-Reply-To: <1349419996.10584.5.camel@smile>
References: <1349342161-27008-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 <1349368379.2008.16.camel@joe-AO722> <1349419996.10584.5.camel@smile>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-05 at 09:53 +0300, Andy Shevchenko wrote: 
> On Thu, 2012-10-04 at 09:32 -0700, Joe Perches wrote: 
> > On Thu, 2012-10-04 at 12:16 +0300, Andrei Emeltchenko wrote:
> > > From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
> > > 
> > > Make output more readable and remove unneeded function call.
> > > 
> > > ...
> > > mwifiex_sdio mmc0:0001:1: last_cmd_index = 3
> > > last_cmd_id: 00000000: 28 00 28 00 28                            (.(.(
> > > ...
> > > 
> > > would be changed to:
> > > 
> > > ...
> > > mwifiex_sdio mmc0:0001:1: last_cmd_index = 3
> > > mwifiex_sdio mmc0:0001:1: last_cmd_id: 28 00 28 00 28
> > > ...
> > 
> > (added Andy Shevchenko)
> > 
> > Hi Andrei.  That's probably a better output style too
> > as the ascii isn't likely useful.
> > 
> > One non-nit as a style issue for Andy Shevchenko:
> > 
> > > diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
> > []
> > > @@ -917,21 +917,20 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
> > []
> > > +		dev_err(adapter->dev, "last_cmd_id: %*ph\n", DBG_CMD_NUM,
> > > +			adapter->dbg.last_cmd_id);
> > > +		dev_err(adapter->dev, "last_cmd_act: %*ph\n", DBG_CMD_NUM,
> > > +			adapter->dbg.last_cmd_act);
> > 
> > When the number of bytes is fixed, it might be nicer
> > to use a format like "%<num>ph" so that the function
> > argument stack doesn't have the width pushed but it's
> > fixed in the format.
> > 
> > This case would definitely not work well though as it's
> > a #define rather than a simple number and I think
> > using "%" stringize(some_define) "ph" is not nice.
> > 
> > Maybe this case argues more for always using "%*ph".
> > At least that's easily greppable.
> > 
> > Andy?
> First of all, the current linux-next has at least two definitions of
> that constant:
> drivers/net/wireless/mwifiex/ioctl.h:175:#define DBG_CMD_NUM    5
> drivers/net/wireless/mwifiex/main.h:118:#define DBG_CMD_NUM 5
> 
> I checked briefly the code and found that the constant is heavily used
> as a definition for the length of static byte arrays. So, in that case
> probably better to use %*ph, but apply sizeof(cool_var) instead of
(int)sizeof(cool_var) of course

> putting constant there.

And one finding more: buffers are defined as u16. I'm afraid the both
previous and proposed versions are printing something interesting, like
only half of the defined data.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
