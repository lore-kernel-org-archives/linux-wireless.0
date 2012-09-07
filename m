Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2IGRIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 13:08:36 -0400
Message-ID: <1347037745.4256.37.camel@jlt4.sipsolutions.net> (sfid-20120907_190840_355951_AEB493EB)
Subject: Re: [PATCH v2] p54: connect to 11w protected networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Date: Fri, 07 Sep 2012 19:09:05 +0200
In-Reply-To: <201209071901.59705.chunkeey@googlemail.com> (sfid-20120907_190207_971998_7DE5E0BF)
References: <1346622538.10113.3.camel@jlt4.sipsolutions.net>
	 <201209071825.13588.chunkeey@googlemail.com>
	 <1347035277.4256.33.camel@jlt4.sipsolutions.net>
	 <201209071901.59705.chunkeey@googlemail.com>
	 (sfid-20120907_190207_971998_7DE5E0BF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-07 at 19:01 +0200, Christian Lamparter wrote:

> > > Oh no, I mean dynamic reconfiguration of the firmware's
> > > keycache during runtime. 
> > 
> > Right right, but for MFP that doesn't help since in AP mode
> > we don't know whether to expect encrypted management frames
> > or not.
> 
> Hmpf, don't we set the CMAC key in this case? 

Hmm, I guess we would have that, and actually ... we know MFP will be
used for the *station* so we should in fact know this already. I'll need
to revise my patch. D'oh.

> (Note: I haven't
> seen much/any of the 11w spec, as 802.11-2012 is AFAICT still not
> available for _free_). 

Hm. Well it was published March 29th, so it should be available in 3
weeks if they hold their promise ...

> However, my thinking is/was that when
> mac80211 tries to upload the CMAC key, return -EOPNOTSUPP and 
> we kick the ccm per-station key, so the firmware won't try to
> decrypt incoming (mgmt and data) frames with this combination
> anymore.

CMAC keys aren't per-station, so we'd have to remove them all or
something? But I think we already know about MFP for the station when we
set the key, I'll check this.
 
> > > But for this, we would need
> > > a way to tell mac80211 when driver wants to delete a key
> > > from the hw/fw cache and when there is room for another
> > > one (Didn't you had a patch for the "we have a empty slot
> > > in the rxkey cache we are not using" case some time ago?
> > > However in this case, we want to tell mac80211 what "exact"
> > > key (by MAC of the peer and key index) we want.)
> > 
> > I had a patch for the opposite: please remove this key, I can't
> > handle it any more. Adding a new one in that case couldn't be
> > done.
> Ah well, that's too bad. Altough, I thought you removed
> it because its prone to cause rx/tx races?!

No, just because it was unused. Adding a new key could also be
implemented, or you could iterate the keys in some way maybe.

> > > Of course, I'm well aware of the "amount of work" and the
> > > problems associated with removing and readding keys during
> > > runtime without causing races (or just minor races).
> > 
> > Actually that's not too difficult, the bigger difficulty is
> > actually knowing which key to re-upload I think.
> Well, the firmware reports a "CACHE MISS" status in every
> encrypted rx frame if no key was found in the rxkey cache.
> 
> Of course, being a cache, we can make some sort of LRU 
> (not sure about the size, but rxkey cache * 2 would be
> a start) and keep track of the rx key usage. This way
> when a "rxkey" becomes more popular it will be detected
> and "replace" a rxkey that is no longer active... and
> so on.

Right. Seems pretty simple really, but I guess the devil is in the
details :-)

Anyway I'll revise that patch (after dinner) and see if MFP flag is set
correctly, if so then we can just use that.

johannes

