Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41020 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753037AbdC2Geg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 02:34:36 -0400
Message-ID: <1490769272.18052.5.camel@sipsolutions.net> (sfid-20170329_083444_109777_82B0E68D)
Subject: Re: [PATCH for-4.11 2/2] cfg80211: check rdev resume callback only
 for registered wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Daniel J Blueman <daniel@quora.org>
Date: Wed, 29 Mar 2017 08:34:32 +0200
In-Reply-To: <d2985a7e-5d11-284d-25f8-c4a255c24da6@broadcom.com> (sfid-20170328_164650_762503_FA0E6B53)
References: <1490688691-20100-1-git-send-email-arend.vanspriel@broadcom.com>
         <1490688691-20100-3-git-send-email-arend.vanspriel@broadcom.com>
         <1490704473.18052.1.camel@sipsolutions.net>
         <0ad46312-df78-4d80-8526-1a33e1e86acf@broadcom.com>
         <1490711151.18052.2.camel@sipsolutions.net>
         <d2985a7e-5d11-284d-25f8-c4a255c24da6@broadcom.com>
         (sfid-20170328_164650_762503_FA0E6B53)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-03-28 at 16:46 +0200, Arend Van Spriel wrote:
> 
> On 28-3-2017 16:25, Johannes Berg wrote:
> > 
> > > > > -	if (rdev->ops->resume) {
> > > > > -		rtnl_lock();
> > > > > -		if (rdev->wiphy.registered)
> > > > > -			ret = rdev_resume(rdev);
> > > > > -		rtnl_unlock();
> > > > > -	}
> > > > > +	rtnl_lock();
> > > > > +	if (rdev->wiphy.registered && rdev->ops->resume)
> > > > > +		ret = rdev_resume(rdev);
> > > > > +	rtnl_unlock();
> > > > 
> > > > Hmm? Commit message seems ... old perhaps?
> > > 
> > > Hmmm, why? Before the patch rdev->ops was accessed before
> > > checking
> > > rdev->wiphy.registered. When rdev->wiphy.registers is false we no
> > > longer access rdev->ops after the patch. So a driver doing a
> > > wiphy_unregister() can safely kfree() the callback struct after
> > > it.
> > 
> > Oh, right. Looks like I misinterpreted things.
> 
> So apparently my choice of words was poor. Do you want me to
> rephrase?

Nah, don't worry. When I apply it I'll re-read and see if I just
confused myself or if it makes sense to reword a bit.

johannes
