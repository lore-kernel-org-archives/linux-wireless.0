Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58866 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab1JEWiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 18:38:17 -0400
Received: by qyk30 with SMTP id 30so4885630qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 15:38:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomWYUtd84APvEg7mKC-sevT3UVaX2qKBn3KiVriPZybgQ@mail.gmail.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
 <201110041538.12885.chunkeey@googlemail.com> <4E8B157F.2080203@neratec.com>
 <201110041642.54453.chunkeey@googlemail.com> <CAJ-VmomWYUtd84APvEg7mKC-sevT3UVaX2qKBn3KiVriPZybgQ@mail.gmail.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 5 Oct 2011 15:37:57 -0700
Message-ID: <CAB=NE6UrQSt4HrTi+D_XL6t8+2JKBWZbzCYJ0vk8WtsN0w05sQ@mail.gmail.com> (sfid-20111006_003821_651579_0876B2C8)
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
To: Adrian Chadd <adrian@freebsd.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 4, 2011 at 7:50 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> Also whilst I'm at it, "SPECTRUM_MANAGEMENT" is a very broad flag to set.
>
> For example: you may not want to do DFS on the AR5416 NICs because (as
> documented in the open hal and earlier ath9k bits) there isn't support
> for radar pulses on the ext channel. So even if you had a successful
> DFS algorithm for this NIC, you'd have to somehow tell the DFS
> machinery that HT40+DFS channels aren't supported but HT20+DFS
> channels are.

Good point. I simply rather start out with the best possible DFS
support on Linux and go with the best hardware we have instead of
dealing with old hardware. Think about the support issues that can
come up with supporting the above. I rather simply not deal with it as
I also do not care about Turbo crap. Let legacy crap die.

> But then, the AR5416 supports per-packet TPC, so you could use it in
> STA mode perfectly fine and it'd support that part of spectrum
> management. Since you get per-frame RSSI of RX'ed frames, you can
> support the spectrum power histogram IE.

TPC is not implemented even in a lot of proprietary code bases,
although TPC is part of 802.11h its requirements are me by statically
reducing the maximum EIRP by 3 dB in frequency bands requiring TPC in
consideration for interference with satellites. In my latest
evaluation of TPC the only thing we want to do is simply enable the
option to explicitly state the max delta on power in consideration for
TPC in such a way that *if* TPC is implemented we can reduce the
reduction. But given that this is hardware specific and vendor
specific and not many people implement it right now I frankly don't
care too much about it. DFS is a bigger aspect.

  Luis
