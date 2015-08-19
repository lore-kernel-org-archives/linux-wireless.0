Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38480 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbbHSQhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 12:37:37 -0400
Received: by wicja10 with SMTP id ja10so13458212wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 09:37:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439983495.2089.7.camel@sipsolutions.net>
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
 <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com> <1439983495.2089.7.camel@sipsolutions.net>
From: Allan Matthew <allanm84@gmail.com>
Date: Wed, 19 Aug 2015 09:37:16 -0700
Message-ID: <CAEnVuW18e15hOjoMYRstjgu2cr5BFAtVHThAyZGqpMAdFUQrpQ@mail.gmail.com> (sfid-20150819_183740_141773_D951549A)
Subject: Re: set channel from radiotap headers during injection
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you Johannes,

It seems like the functionality for this (maybe not the monitor mode)
must be available in order to support the multiple 802.11p channels in
the 5.8ghz band.

It sounds like what you are proposing is to create a non-monitor vif,
select its channel, bitrate, bandwidth and then use the MAC address to
select it as the transmitting interface.  Is that correct?  I'm
guessing I could do this with raw sockets and prepend the ieee80211
header (but not the radiotap header)?

Thanks for the help!

On Wed, Aug 19, 2015 at 4:24 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2015-08-14 at 14:39 -0700, Allan Matthew wrote:
>> Anyone have any thoughts on this?
>>
>> Is it possible with channel context enabled somehow?
>>
>
> I don't think it's possible - per-packet configuration would have to be
> basically instantaneous (cannot sleep etc.) and setting the channel is
> necessarily a much longer operation.
>
> If your device supports channel contexts, you might be able to *pick*
> the channel you want to inject on, but you could probably achieve that
> through the existing MAC address selection that picks an interface.
> It's also not clear how monitor + chanctx would work at all, since
> monitor expects to be on the channel all the time.
>
> You could possibly select other parameters like the bitrate, but the
> channel width - especially 5/10 MHz - doesn't seem feasible.
>
> johannes
