Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47546 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbaEHKEC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 06:04:02 -0400
Message-ID: <1399543438.9163.3.camel@jlt4.sipsolutions.net> (sfid-20140508_120406_552379_F2E33D34)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Thu, 08 May 2014 12:03:58 +0200
In-Reply-To: <1399468226.6800.25.camel@dubbel>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	 <1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	 <1399372915.4218.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	 <1399385141.4218.37.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com>
	 <1399450061.5038.10.camel@jlt4.sipsolutions.net>
	 <1399455657.6800.4.camel@dubbel>
	 <CA+BoTQmXb=_jjE4-dL8U_-8=CxRMgo4qckUKF9LizfV2W0iC7A@mail.gmail.com>
	 <1399457760.6800.7.camel@dubbel>
	 <CA+BoTQnF3pVmGumqqHbfuphXbYhAybHUMosX4kJazfHWJDE+Fw@mail.gmail.com>
	 <1399460964.10517.12.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnSJgaN=incAtW08tSqDgW2jRm1cdarMhupArGBAw7FRQ@mail.gmail.com>
	 (sfid-20140507_131912_954267_EF512364) <1399463646.10517.28.camel@jlt4.sipsolutions.net>
	 <1399464536.6800.11.camel@dubbel>
	 <1399464789.10517.29.camel@jlt4.sipsolutions.net>
	 <1399465244.6800.13.camel@dubbel>
	 <1399466312.10517.34.camel@jlt4.sipsolutions.net>
	 <1399467196.6800.22.camel@dubbel>
	 <1399467968.10517.39.camel@jlt4.sipsolutions.net>
	 <1399468226.6800.25.camel@dubbel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 16:10 +0300, Luca Coelho wrote:


> > Oh, I get it, you're thinking that there might be a situation where
> > those vif types are maybe not supported with different channels?
> > 
> > But in your example you're going from this situation:
> > 
> > chanctx1: vif1, vif2
> > 
> > to
> > 
> > chanctx2: vif1
> > chanctx3: vif2
> > 
> > 
> > The intermediate step that I proposed would give you
> > 
> > chanctx1: vif1
> > chanctx3: vif2
> > 
> > Which isn't really any different?
> 
> It could be different if the channel in chanctx1 requires radar and
> chanctx2 doesn't, couldn't it?

Yeah, I guess that'd be a counter-example...

johannes

