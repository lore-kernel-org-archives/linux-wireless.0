Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:55146 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754604Ab2E3OJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 10:09:22 -0400
Message-ID: <1338386931.32113.22.camel@joe2Laptop> (sfid-20120530_163650_600330_28C8D211)
Subject: Re: [PATCH] mac80211: print info when disabling HT
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 30 May 2012 07:08:51 -0700
In-Reply-To: <1338385907.4511.22.camel@jlt3.sipsolutions.net>
References: <1338379000.4511.12.camel@jlt3.sipsolutions.net>
	 <1338385736.32113.8.camel@joe2Laptop>
	 <1338385907.4511.22.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 15:51 +0200, Johannes Berg wrote:
> On Wed, 2012-05-30 at 06:48 -0700, Joe Perches wrote:
> > On Wed, 2012-05-30 at 13:56 +0200, Johannes Berg wrote:
> > > Make mac80211 print a message when it disables
> > > HT due to the connection using WEP/TKIP or due
> > > to the AP not supporting WMM/QoS.
> > 
> > trivia: please use:
> > 	netdev_<level>(
> > not
> > 	netdev_printk(KERN_<LEVEL>, 
> > []
> > > +			netdev_printk(KERN_INFO, sdata->dev,
> > > +				      "disabling HT due to WEP/TKIP use\n");
> > 
> > 			netdev_info(sdata->dev, etc...)
> > 
> > etc...
> 
> *sigh*
> Ok. I'm curious as to what the reason is for both, and using
> netdev_printk() everywhere?

netdev_printk isn't used generally.  Other than the
netdev_<level> macros themselves, it's used only with
KERN_DEBUG to force output.

And to me, all of those netdev_level(KERN_DEBUG uses
would be better as netdev_dbg.

There are no other uses of netdev_printk except in
macros.


