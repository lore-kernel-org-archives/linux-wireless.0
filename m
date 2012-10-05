Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54874 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab2JEKSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 06:18:37 -0400
Message-ID: <1349432305.10584.29.camel@smile> (sfid-20121005_121855_571838_F283DE09)
Subject: Re: [PATCH] mwifiex: Using %*phD instead of print_hex_dump_bytes
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	bzhao@marvell.com
Date: Fri, 05 Oct 2012 13:18:25 +0300
In-Reply-To: <20121005101058.GE12229@aemeltch-MOBL1>
References: <1349342161-27008-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 <1349368379.2008.16.camel@joe-AO722> <1349419996.10584.5.camel@smile>
	 <20121005101058.GE12229@aemeltch-MOBL1>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-05 at 13:11 +0300, Andrei Emeltchenko wrote: 
> On Fri, Oct 05, 2012 at 09:53:16AM +0300, Andy Shevchenko wrote:
> > On Thu, 2012-10-04 at 09:32 -0700, Joe Perches wrote: 

> > > When the number of bytes is fixed, it might be nicer
> > > to use a format like "%<num>ph" so that the function
> > > argument stack doesn't have the width pushed but it's
> > > fixed in the format.
> > > 
> > > This case would definitely not work well though as it's
> > > a #define rather than a simple number and I think
> > > using "%" stringize(some_define) "ph" is not nice.
> > > 
> > > Maybe this case argues more for always using "%*ph".
> > > At least that's easily greppable.


> > I checked briefly the code and found that the constant is heavily used
> > as a definition for the length of static byte arrays. So, in that case
> > probably better to use %*ph, but apply sizeof(cool_var) instead of
> > putting constant there.
> 
> I did not touch logic that print buffer, the buffer might have lots of
> data (even significantly more then you may want to print to logs) so
> using sizeof is not the best idea in these cases.
Then you probably need to decide how much you would like to print
exactly and put that constant directly to the %*ph (instead of
asterisk), like %5ph. Otherwise it's unclear what DBG_CMD_NUM stands
for.



-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
