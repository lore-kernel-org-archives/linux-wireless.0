Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:53713 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab1JRHZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 03:25:41 -0400
Date: Tue, 18 Oct 2011 10:22:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] rndis_wlan: add range check in del_key()
Message-ID: <20111018072201.GC25814@longonot.mountain> (sfid-20111018_092546_107135_F7DDD9BD)
References: <20111018064729.GQ27732@elgon.mountain>
 <1318920887.3958.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1318920887.3958.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 18, 2011 at 08:54:47AM +0200, Johannes Berg wrote:
> On Tue, 2011-10-18 at 09:47 +0300, Dan Carpenter wrote:
> > Wifi drivers can have up to 6 keys but the rndis_wlan only has 4 so
> > it needs to have its own checks to make sure we don't go out of
> > bounds.  The add_key() function already checks but I added some
> > checks to del_key() and set_default_key().
> 
> Semantically, that shouldn't be possible unless it advertises support
> for WLAN_CIPHER_SUITE_AES_CMAC. Is there a bug in those checks?
> 

You know I'm a newbie at this networking...  I obviously had no idea
about WLAN_CIPHER_SUITE_AES_CMAC until you mentioned it.  I just
looked at the other implementations of del_key() etc and they checked
it.  Monkey see, monkey do.

My concern when I wrote this patch was places like __cfg80211_clear_ibss()
which just do:

	for (i = 0; i < 6; i++)
		rdev->ops->del_key(wdev->wiphy, dev, i, false, NULL);

That's what triggers the Smatch warning as well.  But as I said, I'm
quite a newbie at this code.

regards,
dan carpenter
