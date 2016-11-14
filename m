Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59624 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbcKNOJT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 09:09:19 -0500
Message-ID: <1479132555.12007.6.camel@sipsolutions.net> (sfid-20161114_150922_646064_7DE3774C)
Subject: Re: [RFC] change mac80211_hwsim tx_rates to ieee80211_tx_rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2016 15:09:15 +0100
In-Reply-To: <faf081ea-18c6-8ad5-e336-aac9a79a0ce3@uni-rostock.de>
References: <dcc2ec52-abe0-3182-e7f5-d1df40fd492b@uni-rostock.de>
         <1478984929.4226.3.camel@sipsolutions.net>
         <faf081ea-18c6-8ad5-e336-aac9a79a0ce3@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I agree with that, but there exist also other code in hwsim, which is
> tightly coupled with the mac80211 API, as e.g., the usage of
> IEEE80211_TX_MAX_RATES, which already broke older versions of
> wmediumd or similar implementations. Maybe a review regarding such
> things would be good to decouple the userspace daemon from the
> special kernel version.

Agree. It'd be better if that were using nested attributes etc.
Although then again, to really decouple this we should make hwsim
behave towards wmediumd more like real hardware would, and have it pass
just a single rate to userspace, with only success/fail indication
coming back - if it fails, it could walk down the chain of rates
itself. Right now we let wmediumd do this, which is why we have all
these API internals exposed to it.

> > > but I think that will break up the communication to e.g. bob
> > > copelands
> > > wmediumd and similar simulations. I would like to have our
> > > Implementation working with mainline kernels and therefore ask
> > > how we
> > > could achieve this easily.
> > > 
> > > Obviously, we could define another field in the hwsim messages,
> > > but
> > > as bob copeland already stated, significantly more information
> > > within
> > > the netlink messages could  intensify the timing overhead of
> > > hwsim.
> > I don't think we have any other choice but add the relevant fields
> > as
> > proper attributes.
> 
> I'm totally fine with that. Nonetheless,  I would suggest to add the
> flags to "struct hwsim_tx_rate", since the flags are also tightly
> coupled to the rates and tries of a frame. To not break up things, we
> could add the flags as a separate attribute in the struct and not as
> part of the bitfield like in the original. This would be possible,
> due
> to the "__packed" flag, but I'm also unsure, whether this is a really
> good idea for a userspace API/ABI.

Changing the struct size itself would break ABI though?

johannes
