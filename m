Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34891 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbbBYSOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 13:14:47 -0500
Received: by iecrl12 with SMTP id rl12so7280326iec.2
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 10:14:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150225144723.GA6903@w1.fi>
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
	<20150225144723.GA6903@w1.fi>
Date: Wed, 25 Feb 2015 10:14:45 -0800
Message-ID: <CA+55aFyvhgFMRAg2ftuN_cykGs_3-Oyabhi_N6S-J1daVFFRzw@mail.gmail.com> (sfid-20150225_191452_785422_5373E6C3)
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jouni Malinen <j@w1.fi>
Cc: Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2015 at 6:47 AM, Jouni Malinen <j@w1.fi> wrote:
>
> There may be something else wrong (say, some kind of interference), but
> there is no way we can assume normal users to be able to fix such
> issues. If we make EAPOL frames go through more robustly, the connection
> can be established in more cases and this can result in relatively
> functional network connection and rate control can handle the less
> critical data frames through whatever means to get optimal throughput
> from the network. As such, I do think we do need to "paper over" this
> for EAPOL frames.

While I realize that people may disagree about the exact details of
how to fix this in the long run, may I suggest that in the meantime we
at least get the two workaround patches applied?

I'm talking about the two from Jouni - the "don't encrypt EAPOL
frames" one, and the one-liner that makes all EAPOL frames go at the
lowest data rate.

Even if "lowest data rate" is ridiculously low, and even if that might
disturb other things going on on the same channel at the same time,
those authentication packets shouldn't be so common as to be a
problem.  No?

Jouni has a few packet dumps for me, and he's stumped as to what
exactly is going on, but those two patches (well, the one-liner "low
data rate EAPOL" in particular, it seems) do seem to make my
connections go through reliably.

And it seems that other drivers already are working around the EAPOL
issue in similar ways, judging by the comments about iwlwifi.

Last time I had connection issues with this laptop, nothing ended up
happening in the end, and I had people pipe up saying they had had
similar problems. I'd hate for the same "nothing" to happen this time
just because people aren't 100% sure what the final right thing is to
do. So I'd really like people to apply the simple workarounds for now
because clearly something is badly wrong, and *if* there is some
better resolution later, that's fine.

I'll happily test patches. It seems to be pretty repeatable for me,
even if that "pretty repeatable" seems to be very much about the
laptop being in one very particular place (it's right next to another
AP, there's random other electronics around, since it's on my messy
desk etc). So I wouldn't be at all surprised by horribly interference.
And the AP is supposed to be ceiling- or wall-mounted, but because I'm
just testing things out it's just sitting on a table in the next room,
so for all I know it's in the *exact* worst position for the antennas
etc etc.

So I'm sure I can improve reception of my laptop, but that's not the
point. The point is that bad wireless networks aren't so unusual, and
right now things clearly don't work as well as they could.

Does anybody hate Jouni's two patches *so* much that they can
articulate *why* it would be wrong to apply them as interim patches?
And if so, do you have better patches for me to try? Because if not..

                                 Linus
