Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:47324 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbbBXWum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 17:50:42 -0500
Received: by mail-ig0-f172.google.com with SMTP id l13so30872181iga.5
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 14:50:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <655DCF68-95EE-47F6-82D3-45F6E0999161@net.t-labs.tu-berlin.de>
References: <CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com>
	<20150223213050.GA23232@w1.fi>
	<CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com>
	<CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com>
	<20150223224305.GA30228@w1.fi>
	<21739.50662.902775.901924@gargle.gargle.HOWL>
	<CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com>
	<CAA_e5Z5PqfcYss9fADFewBTgnxrYMy5U6XbRz-J5doEyKgugTg@mail.gmail.com>
	<20150224102611.GA30806@w1.fi>
	<80AA1103-EBCD-4C18-A950-B03FF516E5AC@net.t-labs.tu-berlin.de>
	<20150224181454.GA30859@w1.fi>
	<655DCF68-95EE-47F6-82D3-45F6E0999161@net.t-labs.tu-berlin.de>
Date: Tue, 24 Feb 2015 14:50:41 -0800
Message-ID: <CAJ-Vmomaz00eyLW5Roqg-V8dU6577APMu9FBnszRb+aMsHX8Jw@mail.gmail.com> (sfid-20150224_235046_001505_9C83D1D9)
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
From: Adrian Chadd <adrian@freebsd.org>
To: =?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>
Cc: Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I thought about doing this for rate probing with FreeBSD's sample rate
algorithm, but after actually having to use the damned thing in noisy
environments I realised that it just wasn't worth the effort to
optimise rate control selection whilst doing EAPOL frames.

If we did more useful software retransmission at lower rates then
sure, one could just be much more conservative about the rates and
retry a few times at a lower rate. However, since that isn't the case
and we only get three or so attempts at EAPOL exchange - once a second
- before an AP decides we're no good, I figured I'd just skip anything
other than the lowest basic rates for the frame exchange and make it
associate quicker.

I had the same problem with DHCP - initial DHCP leases were failing
because the rate control code started high/medium and didn't degrade
quickly enough before the next round of DHCP attempts. DHCP backs off
even more aggressively, so failing that initial DHCP was quite
expensive.



-adrian
