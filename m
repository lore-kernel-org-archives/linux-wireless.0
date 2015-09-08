Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36475 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbbIHROX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 13:14:23 -0400
Received: by igcrk20 with SMTP id rk20so79738269igc.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 10:14:22 -0700 (PDT)
Date: Tue, 8 Sep 2015 13:14:06 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Jesse Jones <jjones@cococorp.com>
Cc: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: mesh - always do every discovery retry
Message-ID: <20150908171406.GE18335@localhost> (sfid-20150908_191426_644588_0CB5D315)
References: <CAEFj986a0b9r4qia-CFXsm_aiD8P5gLeJJqxS2NYcSjKcspLNw@mail.gmail.com>
 <4bd697c41f2bb66593c849246bde7b00@mail.gmail.com>
 <CAEFj9878gNnDViLYh+TW6GPUvJBbSn4Y=tDBmdp3NwBHymqxRg@mail.gmail.com>
 <b193de6c0b11af0193414a217f0ea56b@mail.gmail.com>
 <CAEFj986Jt-1rymgARCvDe+2Tb1R0PqsDfSELC7WbAXfkC+9xPw@mail.gmail.com>
 <fff70f4adca53a929cda056a21f4d3ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fff70f4adca53a929cda056a21f4d3ad@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 26, 2015 at 01:05:06PM -0700, Jesse Jones wrote:
> > > My big worry is that we will select bad paths. And this *will* happen.
> > > I've seen it many times. And if it does happen the effects are not
> > > theoretical; they are by definition bad. We *have* selected a bad path
> > > after all. And when we select a bad path it will be very apparent to
> > > end users. Bandwidth will be lower than it should be and loss may go up
> > > as
> > well.
> >
> > Agreed with your point. How about adding nl80211 command for this?
> 
> I'm not keen on the idea. I still think it's the right thing to do and I
> don't much like the idea of having to turn it on. And it will become an even
> better idea if we don't refresh as often (eventually I'll send a patch for
> that though I think I may have to massage what we're using now).

At the very least I think this is a change in semantics around
dot11MeshHWMPmaxPREQretries -- the intent as far as I know is to limit
total attempts to determine whether target is reachable at all, and I
don't think there is enough evidence in the standard to support the
other interpretation.  In my opinion it's also somewhat confusing that a 'max'
parameter is used as a 'min'.

I could also see some users wanting different behavior here depending on
node density.

So, at the risk of having too many knobs, could we perhaps add another
tunable for this, call it min_preq_attempts or something, and fix it to the
interval [1, dot11MeshHWMPmaxPREQretries]?  My preference would be to
maintain the default value of 1.

-- 
Bob Copeland %% http://bobcopeland.com/
