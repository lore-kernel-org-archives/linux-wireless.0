Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaBKNvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 08:51:16 -0500
Message-ID: <1392126667.4128.32.camel@jlt4.sipsolutions.net> (sfid-20140211_145119_814208_F3872179)
Subject: Re: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 11 Feb 2014 14:51:07 +0100
In-Reply-To: <CA+BoTQ=5v7OvUrBBRrArPnd7n5jKkUHMuDhU0tRL5caF-J+BiA@mail.gmail.com> (sfid-20140205_153703_534859_ECA738FF)
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-3-git-send-email-michal.kazior@tieto.com>
	 <1391434913.4488.24.camel@jlt4.sipsolutions.net>
	 <1391508433.26522.61.camel@porter.coelho.fi>
	 <CA+BoTQngW4Ycuv0H=ba5KWs2qDcqPQtKJWp-9XEwdqQv+Xu6CA@mail.gmail.com>
	 <1391585999.16723.7.camel@porter.coelho.fi>
	 <CA+BoTQkXjAYR0H4nHxagYz3Kn5atWJ048UUY1=gPrW77Gvqp+Q@mail.gmail.com>
	 <1391602306.16723.57.camel@porter.coelho.fi>
	 <CA+BoTQ=5v7OvUrBBRrArPnd7n5jKkUHMuDhU0tRL5caF-J+BiA@mail.gmail.com>
	 (sfid-20140205_153703_534859_ECA738FF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-05 at 15:37 +0100, Michal Kazior wrote:

> If the decision must be made at the beginning and you want mac80211 to
> start STA CSA then GO-follow-STA is impossible.
> 
> What could work here is single-command-multi-interface channel switch
> IF you make STA CSA a userspace thing.
> 
> If you want to keep STA CSA not a userspace thing you cannot make any
> decision at the start in cfg80211 and you must move the decision to
> the driver itself (or firmware, actually). In that case cfg80211
> remains highly reactive and you cannot guarantee interface combination
> state consistency at all times because driver may be incapable of
> notifying cfg80211 in a sane way about interface state changes (e.g.
> due to firmware design/ HW limitation/ cfg80211 locking issues/
> synchronization).

In the case of full-MAC drivers we pretty much have to assume that they
will correctly enforce their own interface combinations in the firmware
anyway, we can't even check in connect() today, so that doesn't seem
like a big issue.

I don't see how this all makes it impossible though, it seems you could
still do:

 1) receive CSA from AP on STA interface
 2) reserve a 'temporary' channel context that doesn't count towards the
limits,
    since it'll be switched
 3) notify cfg80211/userspace of the pending switch
 4) when the time comes to do the switch, do a final capability check,
and
    disconnect from the AP instead if it fails

If you have an GO-follows-STA scenario you'd have userspace react:

 3a) notify cfg80211/userspace of the pending switch
 3b) userspace starts (matching) CSA for the GO interface
 3c) mac80211 matches that up with the STA interface switch and its
temporary
     channel context [and this is the only tricky part]
 4) when the time comes to do the switch, hand all the involved
interfaces to
    cfg80211 for the final capability check, which should now not fail
unless
    userspace specified only one of two GO interfaces or so

johannes

