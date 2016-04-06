Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36307 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbcDFRji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 13:39:38 -0400
Received: by mail-oi0-f45.google.com with SMTP id y204so67423131oie.3
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 10:39:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459927276.17504.6.camel@sipsolutions.net>
References: <1458898052-20601-1-git-send-email-michal.kazior@tieto.com>
	<1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	<1459420104-31554-2-git-send-email-michal.kazior@tieto.com>
	<1459864656.18188.60.camel@sipsolutions.net>
	<CAA93jw4Swv9aOr=ZKoKeQyp9f1HnYJtiY7a1Lw2Ri89XjGiORQ@mail.gmail.com>
	<1459927276.17504.6.camel@sipsolutions.net>
Date: Wed, 6 Apr 2016 10:39:37 -0700
Message-ID: <CAA93jw5mTMndywTH7GRqKMPr24UhxN8m0i0ri4dXa4ZdCULEoQ@mail.gmail.com> (sfid-20160406_193947_301584_ED1D5C06)
Subject: Re: [PATCHv2 1/2] mac80211: implement fair queuing per txq
From: Dave Taht <dave.taht@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 6, 2016 at 12:21 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> [removing other lists since they spam me with moderation bounces]

I have added your email address be accepted to the codel,
make-wifi-fast lists. My apologies for the bounces.

The people on those lists generally do not have the time to tackle the
volume of traffic on linux-wireless.

>> The hope had been the original codel.h would have been reusable,
>> which is not the case at present.
>
> So what's the strategy for making it happen?

Strategy? to meander towards a result that gives low latency to all
stations, no matter their bandwidth, on several chipsets.

The holy grail from my viewpoint is to get airtime fairness, better
mac utilization, slow stations not starving fast ones, more stations
servicable, and so on, and my focus has generally been on having an
architecture that applied equally to APs and clients. Getting clients
alone to have a queuing latency reduction of these orders of magnitude
on uploads at low rates would be a huge win, but not the holy grail.

It was really nice to have michal's proof of concept(s) show up and
show fq_codel-like benefits at both low and high speeds on wifi, but
it is clear more architectural rework is required to fit the theory
into the reality.

> Unless there is one, I
> don't see the point in making the code more complicated than it already
> has to be anyway.

+1.

Next steps were - get toke's and my testbeds up - avery/tim/myself to
keep hammering at the ath9k - michal exploring dql - jonathon poking
at it with cake-like ideas - and anyone else that cares to join in on
finally fixing bufferbloat on wifi.

and maybe put together a videoconference in 2-3 weeks or so with where
we are stuck at (felix will be off vacation, too, I think). There are
still multiple points where we all talk past each other.

Me, for example, am overly fixated on having a per station queue to
start with (which in the case of a client is two stations - one
multicast/mgtmt frames and regular traffic) and not dealing with tids
until much later in the process. Unfortunately it seems the hook is
very late in the process.
>
> johannes
