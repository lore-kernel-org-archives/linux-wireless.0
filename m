Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39412 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab1KUHwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 02:52:40 -0500
Received: by ywt32 with SMTP id 32so4381298ywt.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 23:52:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmon3SsyQxOxpZxiCkbTJ60j-z7sXNgGUgiyAX9+-JzFMqQ@mail.gmail.com>
References: <CAFtRNNz6YEVp2efHqnh0aQ8DEdWm9-ztp8vRTmdorUjf8tJs5w@mail.gmail.com>
	<CAJ-Vmon3SsyQxOxpZxiCkbTJ60j-z7sXNgGUgiyAX9+-JzFMqQ@mail.gmail.com>
Date: Mon, 21 Nov 2011 09:52:39 +0200
Message-ID: <CAFtRNNxH-7kU-Pq939aFupdOHW0ofeU7Ddqwg5pBoCu2JQp1wg@mail.gmail.com> (sfid-20111121_085244_474365_99C03578)
Subject: Re: A weird hw crypto bug...
From: Nick Kossifidis <mickflemm@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/21 Adrian Chadd <adrian@freebsd.org>:
> On 21 November 2011 12:08, Nick Kossifidis <mickflemm@gmail.com> wrote:
>> Some time ago we had a few reports of AR2413 cards being unable to
>> encrypt packets of specific lengths.
>>
>> From https://bugs.launchpad.net/ubuntu/+source/linux/+bug/568090, user
>> Musaraigne did some further investigation/debuging on this:
>>
>> "The cause of the high and unpredictable latencies is that packets are
>> dropped depending on their size. According to my tests, packet sizes
>> of the form
>>  size = 128*k + 81 + m
>> or
>>  size = 128*k + 105 + m
>> for any k>=2 and 0<=m<=7
>>
>> are dropped randomly in 90-95% of the cases. Conversely, all other
>> packet sizes work fine.
>
> That seems a bit odd. Erm, how do they fail?
>
> * Does the hardware just plain fail at encrypting the frame?
> * Does the hardware just plain fail to _TX_ the frame of that size?
> (ie, if you disable crypto and take padding into account, does it
> fail?)
> * What about other encryption types? AES? TKIP? WEP? None? :-)
> * This is a PCIe NIC, right? Are there some kind of weird bus bugs
> that you're seeing with this particular NIC and this particular bus
> glue?

This is about specific AR2413 cards made by Askey, AR2413 cards in
general work fine, I have one myself. Problem is when hw encryption is
enabled (not sure about WEP, I think I've seen a report on WEP also)
when packets of specific lengths are dropped. They work O.K. without
encryption or with sw encryption. I haven't seen any report with dumps
etc so I don't know if packers are corrupted or never transmitted etc,
it's just weird that it happens only on specific AR2413 cards, not any
AR2413 card (that means in general we handle hw encryption correctly
as it works fine on most cards, in fact right now I think that's the
only active bug we have on encryption). The way I see it it's a hw
issue found on these implementations that we don't handle. Btw AR2413
is plain pci card, only AR5424/2424/2425 are pci-e from ar5k series
(it's also AR5418 but it's handled by ath9k).

> Since Madwifi works, I wonder if FreeBSD also works. If so, there's
> only a few places I'd bet you'll find weird stuff:
>
> * how the bus is setup during attach (eg overriding PCI values);
> * which crypto key slots are allocated;
> * are you still doing split keys on that hardware? or are they
> combined like the ar5416+ chips are?

When we had crypto code inside ath5k we did what the old HAL did (via
rev. engineering), now we use the common code from the ath module, so
we do whatever ath9k does (and I think MadWiFi too). Again hw crypto
works fine, even on AR2413 cards, it's this vendor that has done
something weird that results tx failures on hw encryption. Plus I
don't know what version of MadWiFi they used or if they used hw crypto
on MadWiFi at all.

> * are you perhaps doing multi-descriptor TX frames and you've not set
> the encryption bits correctly? IIRC, the enctype field needs to match
> on all descriptors of a frame (eg, if your packet is a chain rather
> than a single skb, you need to make sure you're copying the descriptor
> fields right.)

No fast frames here or multi-descriptor stuff.

> * what about the frame and header length fields? and encryption
> padding? are they all setup the same with madwifi versus ath5k?

That would show up as most of the things you mention above on any card
since it's common code, or even on a specific chip version/revision.
Here we have this issue with a specific implementation and everything
works fine on other implementations with the same chip.

> I bet a bit of methodical poking is going to reveal this bug. I find
> it rather annoying that ath5k/ath9k have lots of encryption issues but
> I've not had any reports of encryption on FreeBSD failing (save where
> the AP is totally lying about which keyidx a frame is encrypted with.)
> It's possible that you're seeing these errors because more people are
> using ath5k then FreeBSD, but still:
>
> * does freebsd-9 (wifi) work on the same hardware?

No idea :-(

> Nick, can you find out if someone can send us one of these weird NICs?
> I'll throw it into my pile-o-old-stuff-to-test and do some regression
> testing with it.
>

Haven't found so far but I think it's clearly a hw issue (I've done
some testing on my AR2413 and it seems fine) and since we know what
packet lengths fail maybe we can create a workaround with padding etc.



-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
