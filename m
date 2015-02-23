Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:57473 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbbBWXN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 18:13:27 -0500
Date: Tue, 24 Feb 2015 01:13:23 +0200
From: Jouni Malinen <j@w1.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: AR9462 problems connecting again..
Message-ID: <20150223231323.GA31115@w1.fi> (sfid-20150224_001330_916589_D5702F49)
References: <CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
 <CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
 <CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
 <20150223171700.GA29730@w1.fi>
 <CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com>
 <20150223213050.GA23232@w1.fi>
 <CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com>
 <CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com>
 <20150223224305.GA30228@w1.fi>
 <CA+55aFzpmD+XOF4PTePgi6WnRTyXbVUQxc7kgwvmFbfG_2VoTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFzpmD+XOF4PTePgi6WnRTyXbVUQxc7kgwvmFbfG_2VoTg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2015 at 03:00:39PM -0800, Linus Torvalds wrote:
> On Mon, Feb 23, 2015 at 2:43 PM, Jouni Malinen <j@w1.fi> wrote:
> >
> > This did not get exactly supportive response when this was proposed last
> > time (Sep 2013). Anyway, for a quick test, this can be done with the
> > following one-liner:
> 
> fwiw, that one-liner seems to work fine for me.

Good to know. That seems to confirm that the issue is most likely in
some of the higher HT rates not working with that AP for some reason at
least for EAPOL frames immediately following the association. This
should really have worked since I'm pretty sure minstrel will add a
lower MCS index as a fallback rate, but maybe there are some interop
issues or just close enough to being below the required signal strength
(though, I'd find that somewhat unlikely unless there is something
messed up with the antennas etc. taken into account your description on
how close the devices are and what's between them).

> Side note: I've done the "turn off wifi and turn it back on" several
> times to test that patch, and it has worked every time. BUT I also see
> this odd behavior where the logs show that it tries to authenticate
> twice: the first time it does that "send auth to 20:9f .." thing three
> times (looks like 100ms apart), and nothing happens so it does
> "authentication with 20:9f .. timed out". Then it waits three seconds
> and tries again, and now it succeeds on the first try.
> 
> The only downside of that seems to be that it takes an extra 3s to
> connect to the network - but it does now seem to *reliably* connect -
> so it's not a big problem, but I wonder why it should be that
> repeatable. Is there some difference between the first and the second
> time it tries to authenticate?

There have been some issues in this area in the past, but it is a bit
difficult to say what could have caused it here without a wireless
capture from the operating channel of the AP. It is possible that those
Authentication frames were not actually transmitted due to some issue or
they could have even been sent out on incorrect channel, etc. That
shouldn't really happen that frequently (i.e., others should be seeing
and reporting this as well..), but it's possible something gets messed
up in channel configuration.

> Anyway, even if people don't like that particular patch, it does seem
> like *something* like that should be done.

Agreed. Just need to figure out a suitable compromise somewhere in the
middle of the minimum and close-to-maximum rates. As far as ath9k is
concerned, it would actually support four different rates for retry
series where minstrel uses only three, so it would be easy even for that
driver on its own to add a lower rate at the end if we cannot find
consensus on something more generic in mac80211. That said, I'd rather
see minstrel getting more conservative for EAPOL frames.

-- 
Jouni Malinen                                            PGP id EFC895FA
