Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab2HBT5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 15:57:18 -0400
Message-ID: <1343937435.4471.27.camel@jlt3.sipsolutions.net> (sfid-20120802_215721_574701_A5FC912C)
Subject: Re: cfg80211_disconnected memory leak
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 02 Aug 2012 21:57:15 +0200
In-Reply-To: <CAMLZHHR6xp0qxR4Z-BP195pV2XAKm=Q8quU_2dGz4L1_zrS8LA@mail.gmail.com> (sfid-20120802_192555_814702_A04D8096)
References: <CAMLZHHQkv_fHzd89fP7bNow7eL3oX+Duzr5rS5NJfhffqwUv2g@mail.gmail.com>
	 <1343842772.4638.15.camel@jlt3.sipsolutions.net>
	 <CAMLZHHQdBHZa4NBQ3ygKJSHmKL11ERUWDAtMx0-Qh4OzSoN-SA@mail.gmail.com>
	 <1343894552.4458.4.camel@jlt3.sipsolutions.net>
	 <CAMLZHHSVediwHaw3f8s1QYNoc_xV55CEUP7wBQu_on-p8WUQJg@mail.gmail.com>
	 <1343924789.4471.26.camel@jlt3.sipsolutions.net>
	 <CAMLZHHR6xp0qxR4Z-BP195pV2XAKm=Q8quU_2dGz4L1_zrS8LA@mail.gmail.com>
	 (sfid-20120802_192555_814702_A04D8096)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-08-02 at 11:25 -0600, Daniel Drake wrote:
> On Thu, Aug 2, 2012 at 10:26 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Hmm. Then again, I think we can call cfg80211_process_wdev_events() from
> > case NETDEV_UNREGISTER though, probably after removing from the list.
> > Maybe you could try that?
> 
> That solves the issue - confirmed that kmemleak now shuts up, and with
> some added printks to confirm event creation and freeing.
> Patch coming up, titled:    cfg80211: process pending events when
> unregistering net device

Nice, thanks!

> Even if libertas isn't quite doing the right thing here, I think this
> is the right thing to do. I guess there are other situations, perhaps
> more legitimate, where we can reach this point with events in the
> queue.

Yes, I agree. I just wasn't completely sure this would be OK when I
looked first, and then started wondering why it didn't happen with
mac80211, but that doesn't send the event.

> > I'm not 100% sure about the API in this area right now though, it's been
> > a while and I never worked much with this API (rather than the mac80211
> > one with auth/assoc/disassoc/deauth.)
> 
> I think we both feel that removing it is correct. I'll test this when
> I find some free time, and if things seem OK i'll post a libertas
> patch in addition to the cfg80211 fix.

It shouldn't hurt either way, since if the event is there but we're
already disconnected we'll just ignore it, afaict.

johannes

