Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38258 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2IGQ1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:04 -0400
Received: by eaac11 with SMTP id c11so984780eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 09:27:03 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] p54: connect to 11w protected networks
Date: Fri, 7 Sep 2012 18:26:58 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <1346622538.10113.3.camel@jlt4.sipsolutions.net> <201209071810.18821.chunkeey@googlemail.com> <1347034503.4256.31.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347034503.4256.31.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201209071826.59089.chunkeey@googlemail.com> (sfid-20120907_182711_771159_7560E22E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 September 2012 18:15:03 you wrote:
> On Fri, 2012-09-07 at 18:10 +0200, Christian Lamparter wrote:
> > On Friday 07 September 2012 17:55:42 Johannes Berg wrote:
> > > On Fri, 2012-09-07 at 17:47 +0200, Christian Lamparter wrote:
> > > > Won't this totally disable the crypto offload
> > > > capabilities in AP mode?
> > > 
> > > Yes, though we could add an nl80211 attribute that
> > > allows hostapd to tell us, and then if it did tell
> > > us we could know and do the right thing here.
> > 
> > if we want to do the right thing here, then I guess
> > we should go for another alternative: a rxkey manager
> > of some sorts. So, we delete keys from the firmware
> > context once MFP comes into the game.
> 
> That's kinda what I do though, the flag tells you
> (at key installation) whether MFP will be used or
> not. It's just that in the AP case, mac80211 doesn't
> actually know.

Oh no, I mean dynamic reconfiguration of the firmware's
keycache during runtime. But for this, we would need
a way to tell mac80211 when driver wants to delete a key
from the hw/fw cache and when there is room for another
one (Didn't you had a patch for the "we have a empty slot
in the rxkey cache we are not using" case some time ago?
However in this case, we want to tell mac80211 what "exact"
key (by MAC of the peer and key index) we want.)

Of course, I'm well aware of the "amount of work" and the
problems associated with removing and readding keys during
runtime without causing races (or just minor races).

Regards,
        Chr

---
Sorry!
