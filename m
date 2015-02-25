Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:57789 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752833AbbBYOr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 09:47:27 -0500
Date: Wed, 25 Feb 2015 16:47:23 +0200
From: Jouni Malinen <j@w1.fi>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Thomas =?utf-8?B?SMO8aG4=?= <thomas@net.t-labs.tu-berlin.de>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
Message-ID: <20150225144723.GA6903@w1.fi> (sfid-20150225_154731_316474_8B4605C7)
References: <CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com>
 <CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com>
 <20150223224305.GA30228@w1.fi>
 <21739.50662.902775.901924@gargle.gargle.HOWL>
 <CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com>
 <CAA_e5Z5PqfcYss9fADFewBTgnxrYMy5U6XbRz-J5doEyKgugTg@mail.gmail.com>
 <20150224102611.GA30806@w1.fi>
 <80AA1103-EBCD-4C18-A950-B03FF516E5AC@net.t-labs.tu-berlin.de>
 <20150224181454.GA30859@w1.fi>
 <54ED56D8.9030806@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54ED56D8.9030806@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2015 at 06:00:08PM +1300, Felix Fietkau wrote:
> Minstrel_ht does *NOT* use mrr[3], nor should it. For normal data
> packets, a little packet loss under tough conditions is good, otherwise
> we risk lots of wasted airtime and bufferbloat.

I agree for normal data packets, but EAPOL frames are not really normal
data packet even though they happen to be transmitted as Data frames.
EAPOL frames are rare enough to not wast much airtime (and recovery from
an issue would anyway use way more airtime) and bufferbloat is
irrelevant for EAPOL frames. For EAPOL frames, little packet loss is not
good. Especially for EAPOL-Key msg 4/4, the only recovery option in many
cases is to reassociate with the AP and start from scratch.

> > That mrr[3]:= basic_rate is the part I was really asking for as far as
> > EAPOL frames are concerned.
> I don't think we need that. If we just exclude EAPOL from both probing
> and aggregation, it should be safe. While it's connecting, that leaves
> in low rates in the retry chain anyway.

Not low enough IMHO. EAPOL is a special case and needs to be addressed
as such. It is special for at least two reasons: being very early in the
association (well, the very _first_ Data frames using rate control) and
being critical for maintaining the connection (AP will disconnect if it
does not reply response).

What happens now is way too optimistic:
- one try at MCS 2 followed by four tries at MCS 0 for EAPOL-Key msg 2/4
- one try at MCS 9 (or so) followed by four tries at MCS 0 for EAPOL-Key
  msg 4/4 (this being the most critical frame in the connection sequence
  due to not having a good recovery mechanism)

Dropping probing from these would allow one more attempt at the first
rate and I guess it would also drop the first rate to somewhat lower.

I'm fine with using these MCS rates as the first option, but I do think
that we have to add one more rate to the end (or change the 3rd rate if
that is easier for implementation) to be non-MCS and I think one of the
basic rates (say, 6 Mbps on 5 GHz and maybe 2 or 5.5 Mbps on 2.4 GHz)
with number of tries (say, 4).

There have been way too many cases reported where "strange issues" with
4-way exchange (those EAPOL-Key frames) result in connection failing.
While not all of these can be explained with the TX rate, I'm pretty
sure large portion of these issues are indeed caused by too optimistic
TX rate selection. Such policies may be acceptable for other Data
frames, but not for EAPOL.

> If it still fails often enough to be noticeable under normal conditions,
> there must be something seriously wrong outside of rate control, and we
> should not paper over it with a crude band-aid workaround.

There may be something else wrong (say, some kind of interference), but
there is no way we can assume normal users to be able to fix such
issues. If we make EAPOL frames go through more robustly, the connection
can be established in more cases and this can result in relatively
functional network connection and rate control can handle the less
critical data frames through whatever means to get optimal throughput
from the network. As such, I do think we do need to "paper over" this
for EAPOL frames.

-- 
Jouni Malinen                                            PGP id EFC895FA
