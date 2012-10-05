Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:60495 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab2JEKJy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 06:09:54 -0400
Date: Fri, 5 Oct 2012 13:11:00 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	bzhao@marvell.com
Subject: Re: [PATCH] mwifiex: Using %*phD instead of print_hex_dump_bytes
Message-ID: <20121005101058.GE12229@aemeltch-MOBL1> (sfid-20121005_120957_444459_FBF74F19)
References: <1349342161-27008-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1349368379.2008.16.camel@joe-AO722>
 <1349419996.10584.5.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349419996.10584.5.camel@smile>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andy,

On Fri, Oct 05, 2012 at 09:53:16AM +0300, Andy Shevchenko wrote:
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

Please send patch fixing this. This is unrelated to the patch in
question.

> I checked briefly the code and found that the constant is heavily used
> as a definition for the length of static byte arrays. So, in that case
> probably better to use %*ph, but apply sizeof(cool_var) instead of
> putting constant there.

I did not touch logic that print buffer, the buffer might have lots of
data (even significantly more then you may want to print to logs) so
using sizeof is not the best idea in these cases.

Best regards 
Andrei Emeltchenko 

