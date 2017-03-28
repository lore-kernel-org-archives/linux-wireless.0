Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60552 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751350AbdC1O03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 10:26:29 -0400
Message-ID: <1490711151.18052.2.camel@sipsolutions.net> (sfid-20170328_162640_735726_1BE8446E)
Subject: Re: [PATCH for-4.11 2/2] cfg80211: check rdev resume callback only
 for registered wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Daniel J Blueman <daniel@quora.org>
Date: Tue, 28 Mar 2017 16:25:51 +0200
In-Reply-To: <0ad46312-df78-4d80-8526-1a33e1e86acf@broadcom.com> (sfid-20170328_161314_259929_C61D537D)
References: <1490688691-20100-1-git-send-email-arend.vanspriel@broadcom.com>
         <1490688691-20100-3-git-send-email-arend.vanspriel@broadcom.com>
         <1490704473.18052.1.camel@sipsolutions.net>
         <0ad46312-df78-4d80-8526-1a33e1e86acf@broadcom.com>
         (sfid-20170328_161314_259929_C61D537D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > -	if (rdev->ops->resume) {
> > > -		rtnl_lock();
> > > -		if (rdev->wiphy.registered)
> > > -			ret = rdev_resume(rdev);
> > > -		rtnl_unlock();
> > > -	}
> > > +	rtnl_lock();
> > > +	if (rdev->wiphy.registered && rdev->ops->resume)
> > > +		ret = rdev_resume(rdev);
> > > +	rtnl_unlock();
> > 
> > Hmm? Commit message seems ... old perhaps?
> 
> Hmmm, why? Before the patch rdev->ops was accessed before checking
> rdev->wiphy.registered. When rdev->wiphy.registers is false we no
> longer access rdev->ops after the patch. So a driver doing a
> wiphy_unregister() can safely kfree() the callback struct after it.

Oh, right. Looks like I misinterpreted things.

johannes
