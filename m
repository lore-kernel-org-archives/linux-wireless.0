Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41065 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab3DMWII (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Apr 2013 18:08:08 -0400
Message-ID: <5169D740.7070206@openwrt.org> (sfid-20130414_000812_384652_94A5720A)
Date: Sun, 14 Apr 2013 00:08:00 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Jonas Gorski <jogo@openwrt.org>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [RFC/RFT] mwl8k: don't expose non-standard rates
References: <1365849071-2389-1-git-send-email-jogo@openwrt.org> <CAJ-VmokacZUw1Wru_0w1XaVRoZWP6nOMcdKo=1yhP-C9rbifHg@mail.gmail.com> <1365869899.1089.0.camel@jlt4.sipsolutions.net> <CAJ-Vmo=bwcxRHB2vESVAy-3_svM+7dDj3o5D=bWgAedMV0ZsBA@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=bwcxRHB2vESVAy-3_svM+7dDj3o5D=bWgAedMV0ZsBA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-13 8:59 PM, Adrian Chadd wrote:
> On 13 April 2013 09:18, Johannes Berg <johannes@sipsolutions.net> wrote:
> 
>>> Are these "turbo" mode rates? ie, 40MHz wide channels with pre-11n
>>> rates on them?
>>
>> 22 actually *is* a standard rate, it's just that almost nobody
>> implements it.
> 
> Well, is it the 20mhz rate or a 40mhz turbo rate?
> 
>> The original problem seems a bit strange though, seems those should just
>> not be marked basic?
> 
> Again, if its a custom rate for 11a/11g 40MHz static turbo style
> configurations, it should only be exposed when the AP is running in
> that particular mode.
> 
> And yes, if the hardware does support it, then it should really only
> not be configured for basic rates. That way mwl8k<->mwl8k hardware can
> take advantage of it when those stations are talking to each other.
> 
> (Yeah, I come from a world where FreeBSD users still want to run
> Turbo/Static-40MHz operation with things like fast frames and turbo
> rates.. damned legacy hardware. :-)
I really don't think this is a 40 MHz thing, the driver does not seem to
have any concept of a non-standard legacy 40 MHz mode. I think they
simply added different modulation for the 72 MBit/s rate.
Keeping this rate doesn't even make sense for mwl8k<->mwl8k, as it's a
non-standard legacy rate, whereas the device can do much better with
plain 802.11n :)

- Felix
