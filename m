Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3H3MXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 08:23:12 -0400
Message-ID: <1377865387.16256.15.camel@jlt4.sipsolutions.net> (sfid-20130830_142315_831568_B0D31E57)
Subject: Re: [PATCH] cfg80211: fix potential deadlock regression
From: Johannes Berg <johannes@sipsolutions.net>
To: mbizon@freebox.fr
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Aug 2013 14:23:07 +0200
In-Reply-To: <1377719389.559.9.camel@sakura.staff.proxad.net>
References: <1370377370-23055-1-git-send-email-johannes@sipsolutions.net>
	 <1377719389.559.9.camel@sakura.staff.proxad.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-08-28 at 21:49 +0200, Maxime Bizon wrote:
> On Tue, 2013-06-04 at 22:22 +0200, Johannes Berg wrote:
>  
> > -	rtnl_lock();
> >  
> >  	res = device_add(&rdev->wiphy.dev);
> > +	if (res)
> > +		return res;
> 
> I just ran across a regression caused by this commit

Sorry, yeah ... this was the locking cleanups, we did get this right
before ...

> I'm again getting uevent notifications for wireless devices that are not
> yet properly registered (ENODEV on NL80211 when using sysfs phy id)
> 
> I originally  fixed the bug by taking the cfg80211 mutex across the
> whole registration:

[...]

Yeah, but then I got rid of the cfg80211_mutex :)

> It does not seem we can reverse the rfkill_register() and device_add()
> because wiphy dev is a parent of rfkill dev.
> 
> any idea to fix this ?

I think this should be OK:
http://p.sipsolutions.net/28cf9ed446845440.txt, can you try?

johannes

