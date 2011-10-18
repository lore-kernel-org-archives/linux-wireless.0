Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1JRHdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 03:33:24 -0400
Subject: Re: [patch] rndis_wlan: add range check in del_key()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20111018072201.GC25814@longonot.mountain>
References: <20111018064729.GQ27732@elgon.mountain>
	 <1318920887.3958.0.camel@jlt3.sipsolutions.net>
	 <20111018072201.GC25814@longonot.mountain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 09:33:00 +0200
Message-ID: <1318923180.3958.2.camel@jlt3.sipsolutions.net> (sfid-20111018_093329_862868_0D2077A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-18 at 10:22 +0300, Dan Carpenter wrote:
> On Tue, Oct 18, 2011 at 08:54:47AM +0200, Johannes Berg wrote:
> > On Tue, 2011-10-18 at 09:47 +0300, Dan Carpenter wrote:
> > > Wifi drivers can have up to 6 keys but the rndis_wlan only has 4 so
> > > it needs to have its own checks to make sure we don't go out of
> > > bounds.  The add_key() function already checks but I added some
> > > checks to del_key() and set_default_key().
> > 
> > Semantically, that shouldn't be possible unless it advertises support
> > for WLAN_CIPHER_SUITE_AES_CMAC. Is there a bug in those checks?
> > 
> 
> You know I'm a newbie at this networking...  I obviously had no idea
> about WLAN_CIPHER_SUITE_AES_CMAC until you mentioned it.  I just
> looked at the other implementations of del_key() etc and they checked
> it.  Monkey see, monkey do.
> 
> My concern when I wrote this patch was places like __cfg80211_clear_ibss()
> which just do:
> 
> 	for (i = 0; i < 6; i++)
> 		rdev->ops->del_key(wdev->wiphy, dev, i, false, NULL);
> 
> That's what triggers the Smatch warning as well.  But as I said, I'm
> quite a newbie at this code.

Ah ok, I didn't know they didn't check. That's reasonable, thanks!

I was just thinking that we wouldn't have keys 4/5 w/o CMAC to start
with, but it makes some sense that the code would just try to clear all
keys.

johannes

