Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab2F0HAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 03:00:17 -0400
Message-ID: <1340780404.4485.4.camel@jlt3.sipsolutions.net> (sfid-20120627_090022_306140_01401312)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Eliad Peller <eliad@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 27 Jun 2012 09:00:04 +0200
In-Reply-To: <CA+XVXffxvMxTOL-qM-5CBDwYgd+9_fOMMqbZ3mweAZimtLTuwg@mail.gmail.com> (sfid-20120626_201859_317667_68726DDE)
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
	 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
	 <1340707305.14634.9.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
	 <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com>
	 <1340716233.14634.31.camel@jlt3.sipsolutions.net>
	 <CA+XVXffxvMxTOL-qM-5CBDwYgd+9_fOMMqbZ3mweAZimtLTuwg@mail.gmail.com>
	 (sfid-20120626_201859_317667_68726DDE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 21:18 +0300, Arik Nemtsov wrote:

> > And now this is just why it won't work even if we start from a clean
> > slate -- I haven't even talked about the backward compatibility aspect,
> > running an old supplicant on a driver that expects a ROC. Remember that
> > the driver need not give the virtual interface *any* channel time on the
> > right channel before needed, so if there's something going on on another
> > channel with multi-channel, that vif would never be able to authenticate
> > with an old supplicant.
> 
> Well that's a given, if we're introducing new features into hostap to
> support multi channel.

No, not really -- I'm going to want to rely on this mechanism even for
the single-channel case in our driver, everything else would be more
like a collection of hacks :-)

> > I could also mention how this is a stupid userspace API, you're now
> > requiring to call one thing before another call is valid, but then the
> > other call is only very briefly valid? If we really wanted ROC, we
> > should embed the time for it into the auth/assoc request, I'd say.
> 
> I think all these examples are because of our different definitions
> for ROC. If ROC is a recommendation, then we just start the ROC before
> starting the connection, and end it after the last EAPOL.
> If channel management is implemented in SW, what you're saying is a
> must. But the FW can abstract these details. Maybe we should do this
> similar to SW/HW scan in mac80211?

Well, I understand your point, but I don't think it's that simple. If,
as you say, we define this to be a recommendation, then we will require
device support for this. You may have that, but with what we're
currently seeing from our firmware I don't think it's possible to
implement it as a recommendation. Even if I could get it somehow
implemented in our device and/or the driver, we'd still be making more
assumptions than I'd want to make for this.

> > Thinking about that though -- what for connect() calls? Whole new can of
> > worms ...
> 
> Not sure what you mean here.

nl80211 connect call, where the driver is managing both auth/assoc,
sometimes even BSS selection.


> > Yes, but it would need this patch and a change to hostapd to add the
> > station when it sends the first auth frame:
> > http://johannes.sipsolutions.net/patches/kernel/all/LATEST/005-nl80211-full-sta-state.patch
> 
> Ah this is useful on another level as well. Today we have a hack in
> the driver to identify the auth-frame reply and add the STA to FW
> temporarily :)

Yes, I know. It's also useful to address a few other races, it just
needs a hostapd implementation. Want to work on it? :-)


johannes

