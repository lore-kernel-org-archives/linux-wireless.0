Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:36112 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbcBQGXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 01:23:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAHqTa-1kBz3WouxUyNBMemY-Gp0y5v8CR6G_6K2hf8nRB9r7Fg@mail.gmail.com>
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
 <1455658091-28262-1-git-send-email-apenwarr@gmail.com> <1455660329.2723.16.camel@sipsolutions.net>
 <CAHqTa-1kBz3WouxUyNBMemY-Gp0y5v8CR6G_6K2hf8nRB9r7Fg@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 17 Feb 2016 11:53:32 +0530
Message-ID: <CABPxzYJ6zt32b-U0KPuJRSo144Z=pBngieMv8sBaAHBJSnAKVA@mail.gmail.com> (sfid-20160217_072428_965929_65F1BD51)
Subject: Re: ath9k(?): AP stops sending traffic to iPhone 4S until another
 802.11n-capable STA joins
To: Avery Pennarun <apenwarr@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2016 at 10:02 AM, Avery Pennarun <apenwarr@gmail.com> wrote:
>
> On Tue, Feb 16, 2016 at 5:05 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2016-02-16 at 16:28 -0500, Avery Pennarun wrote:
> >> Changing default_agg_timeout to zero (as it is on most non-ath9k
> >> drivers) makes the problem pretty much go away.  However, I think
> >> it's because I'm just dodging the code path that triggers a race
> >> condition.
> >
> > That does seem likely. Perhaps you could reproduce it while running
> > mac80211 tracing? There should be a fair amount of information about
> > aggregation and queue stops in there, though as you note queue stops
> > aren't really happening, only aggregation related things. Perhaps the
> > tracepoints for that aren't quite sufficient.
>
> So far that hasn't seemed to help, although maybe you can read traces
> better than I can.  The big problem is that the actual queue doesn't
> seem to have stopped; it might be an ath9k bug.
>
> >> Notes:
> >>
> >> - I'm using exactly the same ath9k driver (currently 20150525, but
> >> we've   tried newer ones with no difference) on two totally different
> >> platforms: a dual-core mindspeed c2k host CPU (ARMv7) with separate
> >> ath9k, and a single-core QCA9531 (MIPS) with on-chip ath9k.
> >>
> >> - I've been unable to trigger the problem on the QCA9531, but I have
> >> on MIPS.
> >
> > That's ... not what I would have expected, especially since the MIPS is
> > single core. That makes the races stranger than expected.
>
> Oops, typo.  The QCA9531 *is* MIPS.  The one where it triggers is the
> dual-core ARM.
>
> >> The aggregation code is... a little hairy.  Does anyone have any
> >> guesses where I might look for the race condition?  Or better still,
> >> a patch I can try?
> >
> > I'm not aware of any race conditions in the code right now :)
>
> Aw.  That would have made it a lot easier!


>From a quick glance of symptoms, i think the below patch is worth a
try, even though
i don't see you are doing any background scans for which this applies.

https://patchwork.kernel.org/patch/8015321/
