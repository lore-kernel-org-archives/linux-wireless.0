Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2E3OVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 10:21:37 -0400
Message-ID: <1338387486.4511.24.camel@jlt3.sipsolutions.net> (sfid-20120530_163651_137653_1B52D771)
Subject: Re: [PATCH] mac80211: print info when disabling HT
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 30 May 2012 16:18:06 +0200
In-Reply-To: <1338386931.32113.22.camel@joe2Laptop>
References: <1338379000.4511.12.camel@jlt3.sipsolutions.net>
	 <1338385736.32113.8.camel@joe2Laptop>
	 <1338385907.4511.22.camel@jlt3.sipsolutions.net>
	 <1338386931.32113.22.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 07:08 -0700, Joe Perches wrote:
> On Wed, 2012-05-30 at 15:51 +0200, Johannes Berg wrote:
> > On Wed, 2012-05-30 at 06:48 -0700, Joe Perches wrote:
> > > On Wed, 2012-05-30 at 13:56 +0200, Johannes Berg wrote:
> > > > Make mac80211 print a message when it disables
> > > > HT due to the connection using WEP/TKIP or due
> > > > to the AP not supporting WMM/QoS.
> > > 
> > > trivia: please use:
> > > 	netdev_<level>(
> > > not
> > > 	netdev_printk(KERN_<LEVEL>, 
> > > []
> > > > +			netdev_printk(KERN_INFO, sdata->dev,
> > > > +				      "disabling HT due to WEP/TKIP use\n");
> > > 
> > > 			netdev_info(sdata->dev, etc...)
> > > 
> > > etc...
> > 
> > *sigh*
> > Ok. I'm curious as to what the reason is for both, and using
> > netdev_printk() everywhere?
> 
> netdev_printk isn't used generally.  Other than the
> netdev_<level> macros themselves, it's used only with
> KERN_DEBUG to force output.
> 
> And to me, all of those netdev_level(KERN_DEBUG uses
> would be better as netdev_dbg.
> 
> There are no other uses of netdev_printk except in
> macros.

Oh, I guess I was looking at an old tree since I was preparing the patch
against wireless-testing. Thanks for the explanation.

johannes

