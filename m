Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34681 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbbHSTAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 15:00:45 -0400
Received: by wicne3 with SMTP id ne3so134693091wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 12:00:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440007745.2089.11.camel@sipsolutions.net>
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
 <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com>
 <1439983495.2089.7.camel@sipsolutions.net> <CAEnVuW18e15hOjoMYRstjgu2cr5BFAtVHThAyZGqpMAdFUQrpQ@mail.gmail.com>
 <1440007745.2089.11.camel@sipsolutions.net>
From: Allan Matthew <allanm84@gmail.com>
Date: Wed, 19 Aug 2015 12:00:24 -0700
Message-ID: <CAEnVuW0m5jPMcQnC4inVF+8xubZbuyM-faP6Lebz26jvb4s-XA@mail.gmail.com> (sfid-20150819_210048_796525_4C3D1A1D)
Subject: Re: set channel from radiotap headers during injection
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The idea is this:

I operate an AP on one channel that talks to some set of devices.

On another "channel" (maybe just different BW) I use packet injection
to send data to and from a separate device.

The bitrate to the 2nd device (on the 2nd channel) is much lower than
that of the AP, and I'd like to get longer range out of it.  The idea
is that I use narrower bandwidth and fixed, low bitrates with control
over the retries to get really tight control over that link.

Thats the idea, anyway...

On Wed, Aug 19, 2015 at 11:09 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2015-08-19 at 09:37 -0700, Allan Matthew wrote:
>
>> It seems like the functionality for this (maybe not the monitor mode)
>> must be available in order to support the multiple 802.11p channels
>> in the 5.8ghz band.
>
> Not sure - I haven't looked at WAVE/11p in a long time, but the code we
> have certainly assumes that the channel configuration is fixed, i.e.
> only done once when "joining" the network.
>
>> It sounds like what you are proposing is to create a non-monitor vif,
>> select its channel, bitrate, bandwidth and then use the MAC address
>> to
>> select it as the transmitting interface.  Is that correct?  I'm
>> guessing I could do this with raw sockets and prepend the ieee80211
>> header (but not the radiotap header)?
>>
>
> No - radiotap injection has code to select the interfaces. So if you
> have hardware that's capable of, say, having two AP interfaces on
> different channels, then injection would select the channel by
> selecting the interface. However, this isn't really a good way of
> handling this either.
>
> If you can be more specific what this would be used for, perhaps kernel
> modifications would be appropriate to support it more correctly (rather
> than relying on injection.)
>
> johannes
