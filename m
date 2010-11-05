Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:55340 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab0KEOOo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 10:14:44 -0400
Subject: Re: [RFC 01/15] nl80211: add periodic scan commands
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288885334.3659.0.camel@jlt3.sipsolutions.net>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288612336-2830-2-git-send-email-luciano.coelho@nokia.com>
	 <1288885334.3659.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 16:14:17 +0200
Message-ID: <1288966457.1849.25.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-04 at 16:42 +0100, ext Johannes Berg wrote:
> On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:
> 
> > +	rtnl_lock();
> > +
> > +	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
> > +	if (err)
> > +		goto out_rtnl;
> > +
> > +	if (!netif_running(dev)) {
> > +		err = -ENETDOWN;
> > +		goto out;
> > +	}
> 
> ahem. we have infrastructure for this now.

Yeah, I noticed this.  My implementation was originally done so far in
the past that this wasn't available then.  I hadn't bothered changing it
yet, but I'll do it now.


> 
> > +		.doit = nl80211_start_periodic,
> 
> > +		.doit = nl80211_stop_periodic,
> 
> > +void nl80211_send_periodic(struct cfg80211_registered_device *rdev,
> > +			   struct net_device *netdev, u32 cmd);
> 
> I think you should add _scan to all these names.

I had _scan in all the names, but they got way too long and I couldn't
find a better way to do it shorter.  But since you seem to prefer the
longer version with _scan, I'll change it back.

-- 
Cheers,
Luca.

