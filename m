Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46785 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaC1JBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 05:01:32 -0400
Date: Fri, 28 Mar 2014 12:01:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Fariya <fariyaf@gmail.com>
Cc: kbuild@01.org, linux-wireless@vger.kernel.org
Subject: Re: [kbuild-all] [wireless-next:master 316/316]
 drivers/net/wireless/rsi/rsi_91x_debugfs.c:296 rsi_init_dbgfs() error:
 potential null dereference 'dev_dbgfs'. (kzalloc returns null)
Message-ID: <20140328090126.GC7045@mwanda> (sfid-20140328_100138_405255_B5953A7C)
References: <53275729.QHDAYltTUiN7HGNZ%fengguang.wu@intel.com>
 <20140327154507.GA27177@mwanda>
 <20140327160105.GU7045@mwanda>
 <CAG+h2qigvA+yfPt9iRv6eZCLppwFznuZ=Hdk5Yxr-EB_9WTQig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG+h2qigvA+yfPt9iRv6eZCLppwFznuZ=Hdk5Yxr-EB_9WTQig@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 28, 2014 at 07:51:25AM +0530, Fariya wrote:
> Hi Dan,
> 
> Do I need to re-send the whole of the driver again? Considering the driver
> is a part of wireless-next, shall I check-out the wireless-next git repo
> and create a patch for the mentioned fixes and send it across?

The latter.  Do it on top of wireles-next.

> 
> > *The code for this one is:         transfer = min_t(int, count, 4096); It's
> > complaining because "tranfers" is u8, but the cast to int always makes me
> > worry negative values.  In this case, count is not user controlled so it's
> > safe.  But that's a common security problem you should be aware of.  It's
> > better to cast it to an unsigned value.*
> 
> >Shall I typecast the return value of min_t to u8?

No.  That would do a truncate to 8 bits before the compare.  Cast it to
u32 first.

regards,
dan carpenter

