Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53157 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1KUGTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 01:19:55 -0500
Received: by vcbfk1 with SMTP id fk1so5236386vcb.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 22:19:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFtRNNz6YEVp2efHqnh0aQ8DEdWm9-ztp8vRTmdorUjf8tJs5w@mail.gmail.com>
References: <CAFtRNNz6YEVp2efHqnh0aQ8DEdWm9-ztp8vRTmdorUjf8tJs5w@mail.gmail.com>
Date: Mon, 21 Nov 2011 14:19:54 +0800
Message-ID: <CAJ-Vmon3SsyQxOxpZxiCkbTJ60j-z7sXNgGUgiyAX9+-JzFMqQ@mail.gmail.com> (sfid-20111121_071958_566981_093A0F44)
Subject: Re: A weird hw crypto bug...
From: Adrian Chadd <adrian@freebsd.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 November 2011 12:08, Nick Kossifidis <mickflemm@gmail.com> wrote:
> Some time ago we had a few reports of AR2413 cards being unable to
> encrypt packets of specific lengths.
>
> From https://bugs.launchpad.net/ubuntu/+source/linux/+bug/568090, user
> Musaraigne did some further investigation/debuging on this:
>
> "The cause of the high and unpredictable latencies is that packets are
> dropped depending on their size. According to my tests, packet sizes
> of the form
>  size = 128*k + 81 + m
> or
>  size = 128*k + 105 + m
> for any k>=2 and 0<=m<=7
>
> are dropped randomly in 90-95% of the cases. Conversely, all other
> packet sizes work fine.

That seems a bit odd. Erm, how do they fail?

* Does the hardware just plain fail at encrypting the frame?
* Does the hardware just plain fail to _TX_ the frame of that size?
(ie, if you disable crypto and take padding into account, does it
fail?)
* What about other encryption types? AES? TKIP? WEP? None? :-)
* This is a PCIe NIC, right? Are there some kind of weird bus bugs
that you're seeing with this particular NIC and this particular bus
glue?

Since Madwifi works, I wonder if FreeBSD also works. If so, there's
only a few places I'd bet you'll find weird stuff:

* how the bus is setup during attach (eg overriding PCI values);
* which crypto key slots are allocated;
* are you still doing split keys on that hardware? or are they
combined like the ar5416+ chips are?
* are you perhaps doing multi-descriptor TX frames and you've not set
the encryption bits correctly? IIRC, the enctype field needs to match
on all descriptors of a frame (eg, if your packet is a chain rather
than a single skb, you need to make sure you're copying the descriptor
fields right.)
* what about the frame and header length fields? and encryption
padding? are they all setup the same with madwifi versus ath5k?

I bet a bit of methodical poking is going to reveal this bug. I find
it rather annoying that ath5k/ath9k have lots of encryption issues but
I've not had any reports of encryption on FreeBSD failing (save where
the AP is totally lying about which keyidx a frame is encrypted with.)
It's possible that you're seeing these errors because more people are
using ath5k then FreeBSD, but still:

* does freebsd-9 (wifi) work on the same hardware?

Nick, can you find out if someone can send us one of these weird NICs?
I'll throw it into my pile-o-old-stuff-to-test and do some regression
testing with it.


Adrian
