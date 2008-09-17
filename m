Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:13059 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbYIQWOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 18:14:40 -0400
Received: by mu-out-0910.google.com with SMTP id g7so2517303muf.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2008 15:14:37 -0700 (PDT)
Message-ID: <1ba2fa240809171514y72b070d0t775702ea48360331@mail.gmail.com> (sfid-20080918_001444_488164_BED522F5)
Date: Thu, 18 Sep 2008 01:14:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [RFC] Redesigning aggregation on mac80211
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <200809162005.30002.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43e72e890809151203p213fae37ia3bd6871c3bfe2c2@mail.gmail.com>
	 <200809162005.30002.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 16, 2008 at 9:05 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
>> We're considering redesigning how aggregation works on mac80211 to
>> ensure its vendor neutral and to remove as much as redundant code in
>> drivers. We'd like some feedback from people and driver developers,
>> even those who haven't *yet* posted their new shiny 11n drivers, like
>> Marvell or Ralink driver developers.
>
> Well technically speaking there are 2 Ralink drivers in the Kernel already
> which *should* support aggregation (rt61 and rt73).
>
> I'm sorry I have not read the entire thread on the new aggregation support
> yet, but I'll write what I know from rt61/rt73/rt2800 here anyway. :)
>
>> Ivo, are you familiar yet with how aggregation works on Ralink
>> hardware? Does the new 11n hardware require firmware? Specifically
>> we're curious about how the hardware queues are managed.
>
> Ralink defines 4 queues, 1 Management queue (can be abused as regular TX queue)
> and a Beacon queue.
>
> There is no such thing as seperate aggregation queues, as soon as the device
> wants to perform aggregation it grabs a normal entry from the TX queue,
> and assignes all frames to it.
>
> rt61: 5 addresses can be provided for Aggrated frames, I am not sure
> if the first is a header only frame or not.
> rt73: Not sure what should be done
> rt2800: 2 addresses can be provided, where the first is a header/descriptor
> only address. In the second address frames can be provided.

> Because the aggregated frame is created directly into a TX entry, no other
> frames should go through that queue until the aggregated frame has been
> completed.
>

What type of aggregation is this? AMSDU or AMPDU? In AMPDU you need
somehow handle
out of order resend of the packets.  rt61 and rt2800 looks more like
AMSDU (Not sure) we don't support that in iwlwifi TX side of it yet,
it just doesn't outperform AMPDU aggregation.
Tomas


> I'm afraid that is currently all the information I got at this time,
> It is only a little, but I never got around to fully look into the aggregation support,
> although I definately want it implemented in the drivers to increase the
> performance a bit. :)

Need to find out what kind of aggregation the cards support. For TX
AMSDU we need add more code into mac80211, the AMSDU sub frames have
14 bytes (eth) headers.

Thanks
Tomas
