Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59954 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2IGRCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 13:02:08 -0400
Received: by eekc1 with SMTP id c1so1311841eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 10:02:07 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] p54: connect to 11w protected networks
Date: Fri, 7 Sep 2012 19:01:59 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <1346622538.10113.3.camel@jlt4.sipsolutions.net> <201209071825.13588.chunkeey@googlemail.com> <1347035277.4256.33.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347035277.4256.33.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201209071901.59705.chunkeey@googlemail.com> (sfid-20120907_190228_216560_74597E5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 September 2012 18:27:57 Johannes Berg wrote:
> On Fri, 2012-09-07 at 18:25 +0200, Christian Lamparter wrote:
> 
> > > > if we want to do the right thing here, then I guess
> > > > we should go for another alternative: a rxkey manager
> > > > of some sorts. So, we delete keys from the firmware
> > > > context once MFP comes into the game.
> > > 
> > > That's kinda what I do though, the flag tells you
> > > (at key installation) whether MFP will be used or
> > > not. It's just that in the AP case, mac80211 doesn't
> > > actually know.
> > 
> > Oh no, I mean dynamic reconfiguration of the firmware's
> > keycache during runtime. 
> 
> Right right, but for MFP that doesn't help since in AP mode
> we don't know whether to expect encrypted management frames
> or not.

Hmpf, don't we set the CMAC key in this case? (Note: I haven't
seen much/any of the 11w spec, as 802.11-2012 is AFAICT still not
available for _free_). However, my thinking is/was that when
mac80211 tries to upload the CMAC key, return -EOPNOTSUPP and 
we kick the ccm per-station key, so the firmware won't try to
decrypt incoming (mgmt and data) frames with this combination
anymore.
 
> > But for this, we would need
> > a way to tell mac80211 when driver wants to delete a key
> > from the hw/fw cache and when there is room for another
> > one (Didn't you had a patch for the "we have a empty slot
> > in the rxkey cache we are not using" case some time ago?
> > However in this case, we want to tell mac80211 what "exact"
> > key (by MAC of the peer and key index) we want.)
> 
> I had a patch for the opposite: please remove this key, I can't
> handle it any more. Adding a new one in that case couldn't be
> done.
Ah well, that's too bad. Altough, I thought you removed
it because its prone to cause rx/tx races?!

> > Of course, I'm well aware of the "amount of work" and the
> > problems associated with removing and readding keys during
> > runtime without causing races (or just minor races).
> 
> Actually that's not too difficult, the bigger difficulty is
> actually knowing which key to re-upload I think.
Well, the firmware reports a "CACHE MISS" status in every
encrypted rx frame if no key was found in the rxkey cache.

Of course, being a cache, we can make some sort of LRU 
(not sure about the size, but rxkey cache * 2 would be
a start) and keep track of the rx key usage. This way
when a "rxkey" becomes more popular it will be detected
and "replace" a rxkey that is no longer active... and
so on.

Regards,
	Chr
