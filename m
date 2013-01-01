Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40653 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab3AAPTA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jan 2013 10:19:00 -0500
Message-ID: <50E2FE5E.6040300@openwrt.org> (sfid-20130101_161915_446334_E9865545)
Date: Tue, 01 Jan 2013 16:18:54 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
	Cedric VONCKEN <cedric.voncken@acksys.fr>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] ATH9K: infinite loop in Tasklet
References: <773DB8A82AB6A046AE0195C68612A31901412125@sbs2003.acksys.local> <CAD2nsn1UyObSBrpAq+oJOm+Q1PuC=Y9J0cFH3aC3LkPei6QZYw@mail.gmail.com> <CAJ-VmomdWE2d3qUzgOR0=pnoKzeJpFG1rOT1XH3gTB-dtosuVg@mail.gmail.com>
In-Reply-To: <CAJ-VmomdWE2d3qUzgOR0=pnoKzeJpFG1rOT1XH3gTB-dtosuVg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-01-01 5:20 AM, Adrian Chadd wrote:
> On 30 December 2012 06:19, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>> On Tue, Dec 11, 2012 at 3:31 PM, Cedric VONCKEN
>> <cedric.voncken@acksys.fr> wrote:
>>>         Any suggestion to fix correctly this issue ?
>>
>> having a count to break out from the loop is bit hacky. I would
>> suggest to enable as many prints and see
>> why the infinite loop counts(ofcourse you can have a loop count to
>> figure out and break the loop).
> 
> IMHO both need to be done. It's possible that it's taking way too long
> to handle frames in the driver layer. The ath/ath9k driver layer
> assumes that it can dequeue frames from the hardware FASTER than it
> can queue those frames to the network stack layer. If the latter falls
> behind (or both, really) then you can hit this condition.
> 
> FWIW, I've done this in FreeBSD's ath(4) driver in both the TX and RX
> path, to ensure that I give the tasklets all a fair crack at being
> scheduled.
I think the best way to properly fix this issue is to implement NAPI
support (which mac80211 already supports).

- Felix

