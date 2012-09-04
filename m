Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:44284 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab2IDRVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 13:21:13 -0400
Date: Tue, 4 Sep 2012 10:20:57 -0700
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211: support P2P Device abstraction
Message-ID: <20120904172057.GB19410@mwanda> (sfid-20120904_192116_370111_5CCA1636)
References: <20120904161319.GA11494@elgon.mountain>
 <1346775525.3737.36.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1346775525.3737.36.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 04, 2012 at 06:18:45PM +0200, Johannes Berg wrote:
> Hi Dan,
> 
> > The patch f142c6b906da: "mac80211: support P2P Device abstraction" 
> > from Jun 18, 2012, leads to the following Smatch complaint:
> > 
> > net/mac80211/iface.c:1168 ieee80211_setup_sdata()
> > 	 error: we previously assumed 'sdata->dev' could be null (see line 1134)
> > 
> > net/mac80211/iface.c
> >   1133		/* only monitor/p2p-device differ */
> >   1134		if (sdata->dev) {
> >                     ^^^^^^^^^^
> > New test.
> > 
> >   1135			sdata->dev->netdev_ops = &ieee80211_dataif_ops;
> >   1136			sdata->dev->type = ARPHRD_ETHER;
> >   1137		}
> > 
> > [snip]
> > 
> >   1167		case NL80211_IFTYPE_MONITOR:
> >   1168			sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
> >                         ^^^^^^^^^^^^
> > Old dereference.
> 
> Thanks. I'm aware of the warning (I run smatch), but sdata->dev can only
> be NULL in "case NL80211_IFTYPE_P2P_DEVICE", so adding an extra check in
> the monitor case didn't seem worthwhile.
> 
> It might have been better to use sdata->vif.type != P2P_DEVICE in the
> new test I guess, but then it wouldn't be extensible to new interface
> types like Bluetooth AMP.

Gar.  This was my bad.  I didn't realize the warning was so old.  I
try to only send the automatic emails for new warnings.  I have been
meaning to fix the bug in my script for a while now but this time
I will really do that.

regards,
dan carpenter

