Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:53749 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbbBZFzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 00:55:12 -0500
Received: by mail-ig0-f181.google.com with SMTP id hn18so12052228igb.2
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 21:55:11 -0800 (PST)
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
Date: Wed, 25 Feb 2015 21:55:11 -0800
Message-ID: <CA+55aFxE7_RXc1hBo+e=iCj4KpeMev_WphH+tDHXnYC4HE5YvQ@mail.gmail.com> (sfid-20150226_065516_998654_B9A020B4)
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

On Wed, Feb 25, 2015 at 10:14 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm talking about the two from Jouni - the "don't encrypt EAPOL
> frames" one, and the one-liner that makes all EAPOL frames go at the
> lowest data rate.

So I just found out and confirmed that this is not Atheros-specific in
any way - it looks like it's simply the UniFi AP that does not like
high-data-rate authentification frames at all.

Because it looks like the brcmsmac driver has *exactly* the same
behavior with this AP (in an Apple Macbook air). I assume brcmsmac
uses the net/80211/tx.c logic too.

And Jouni's one-liner fixes that one too, although as usual, maybe
there is some testing noise, and I screwed something up. This time I
only did the one-liner, so that's the critical one.

It's interesting to note how nothing else has been unhappy with that
network (admittedly it's been mainly android devices and a HP printer
that I've tested), so it looks like everybody else does low-rate
authentication packets anyway.

So this actually looks like a Ubiquiti UniFi AP bug to me, but it also
looks like presumably everybody else does low-rate initial packets,
and our kernel 802.11 layer should just follow suit. The whole
robustness principle and "be conservative in what you send, and
liberal in what you accept" etc.

                        Linus
