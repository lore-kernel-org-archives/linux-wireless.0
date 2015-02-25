Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33133 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbBYUWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 15:22:36 -0500
Received: by mail-ig0-f180.google.com with SMTP id b16so9079603igk.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 12:22:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFyvhgFMRAg2ftuN_cykGs_3-Oyabhi_N6S-J1daVFFRzw@mail.gmail.com>
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
	<CA+55aFyvhgFMRAg2ftuN_cykGs_3-Oyabhi_N6S-J1daVFFRzw@mail.gmail.com>
Date: Wed, 25 Feb 2015 12:22:35 -0800
Message-ID: <CAJ-VmokL7-hL_KNx4=M6s8H6gYuKV8KaeA61qto_R=1fe8510g@mail.gmail.com> (sfid-20150225_212239_769993_E46E7766)
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
From: Adrian Chadd <adrian@freebsd.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jouni Malinen <j@w1.fi>, Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 February 2015 at 10:14, Linus Torvalds
<torvalds@linux-foundation.org> wrote:


> While I realize that people may disagree about the exact details of
> how to fix this in the long run, may I suggest that in the meantime we
> at least get the two workaround patches applied?
>
> I'm talking about the two from Jouni - the "don't encrypt EAPOL
> frames" one, and the one-liner that makes all EAPOL frames go at the
> lowest data rate.
>
> Even if "lowest data rate" is ridiculously low, and even if that might
> disturb other things going on on the same channel at the same time,
> those authentication packets shouldn't be so common as to be a
> problem.  No?
>
> Jouni has a few packet dumps for me, and he's stumped as to what
> exactly is going on, but those two patches (well, the one-liner "low
> data rate EAPOL" in particular, it seems) do seem to make my
> connections go through reliably.
>
> And it seems that other drivers already are working around the EAPOL
> issue in similar ways, judging by the comments about iwlwifi.

[snip]

> So I'm sure I can improve reception of my laptop, but that's not the
> point. The point is that bad wireless networks aren't so unusual, and
> right now things clearly don't work as well as they could.
>
> Does anybody hate Jouni's two patches *so* much that they can
> articulate *why* it would be wrong to apply them as interim patches?
> And if so, do you have better patches for me to try? Because if not..

I agree with you. I think you should just have EAPOL frames go out at
the lowest rate for now and then worry about experimenting with more
interesting ways to make EAPOL / DHCP frames cheaper. It fixes a lot
of problems in noisy areas. That hack was hiding around in various
commercial drivers I've seen, and it's been in FreeBSD for a while.

Same with DHCP traffic too - it's the second set of data frames that
the rate control code sees, and it's the primary reason I dropped the
initial sample rate down in FreeBSD so the DHCP exchange would have a
better chance of succeeding after association.



-adrian
