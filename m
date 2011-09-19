Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f170.google.com ([74.125.82.170]:64470 "EHLO
	mail-wy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab1ISCfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 22:35:25 -0400
Received: by wyg8 with SMTP id 8so8515769wyg.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 19:35:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109160036.19908.chunkeey@googlemail.com>
References: <CAJ8GFOgNRAr7LvnO8f0Y8uvkQdwhz7uUXRQ6BXomjO05RiiYjg@mail.gmail.com>
	<201109141932.02929.chunkeey@googlemail.com>
	<CAJ8GFOg-sac_+5xn95rJkkxcUgXttUdC=qUtQ_qcw+pYrcpNuA@mail.gmail.com>
	<201109160036.19908.chunkeey@googlemail.com>
Date: Sun, 18 Sep 2011 21:32:14 -0500
Message-ID: <CAJ8GFOjhTWbwhszHKGe5ewG060X77rSBUcWQy-9bSC9GF=FE+Q@mail.gmail.com> (sfid-20110919_043533_180022_79D8BD9C)
Subject: Re: Latency and connection problems with a carl9170-based AP
From: Harshal Chhaya <harshal@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 15, 2011 at 5:36 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Thursday, September 15, 2011 11:37:58 PM Harshal Chhaya wrote:
>> On Wed, Sep 14, 2011 at 12:32 PM, Christian Lamparter
>> <chunkeey@googlemail.com> wrote:
>> > On Wednesday, September 14, 2011 01:19:59 PM Harshal Chhaya wrote:
>> >> Most of the disconnects seem to be caused by beacons that update the
>> >> TIM IE but not the overall length. The result is a corrupted RSN IE
>> >> (e.g. the IE length says 20 bytes but the IE is only 19 bytes in size)
>> >> which causes the clients to disconnect. This problem lasts for only
>> >> one beacon (i.e. the next beacon has the right size) but it is enough
>> >> to cause the clients to disconnect. Is there a way to fix this?
>>> Now that is really interesting. Do you know if the TIM IE is generated
>>> properly by ieee80211_beacon_add_tim in net/mac80211/tx.c?
>>
>> I don't know if TIM IE is valid but a change in size of this IE causes
>> the problem. Do you need more details or packet captures or something
>> else to understand the problem better?
> There's a 6 ms window between the TBTT event and beacon xmit. Most x86
> [which have a USB port] and all AMD64 are fast enough to react in time.
> Do you think you can check if your embedded system is fast enough?

I did not know about the 6ms constraint. Thanks for that detail. Where
do I  add debug prints (i.e which function in which file) to confirm
that my platform meets the 6ms requirement?

Also, does the host wait for the TBTT event before processing the next
beacon? I am not clear on the beacon xmit path and would very much
appreciate some details on who (carl9170/mac80211/hostapd) is
responsible for which part of the beacon creation and transmission so
I can debug appropriately.

> An alternative approach we could reorder the TIM IE within the beacon
> and put it at the end. This step reduces the delta between the old
> and new beacon and prevents the corruption.

I can try this too if you can tell me which function controls this.


>> >> Another problem when power save is enabled is the large and
>> >> unpredictable latency. I understand how enabling power save can
>> >> increase latency but my ping times go from 3-4 ms without power save
>> >> to a wide range of 3 ms - 3 s after I enable power save. I am trying
>> >> smaller beacon intervals to reduce this latency but even at a beacon
>> >> interval of 25ms, I get ping times of up to ~400 ms. How do I reduce
>> >> this wide variation in latency.
>> > What's the listen interval of your stations?
>> > Maybe max_listen_interval=1 in hostapd.conf helps.
>>
>> The listen interval on the clients is 1. It's as if the beacon doesn't
>> have the right TIM bit set or the device is missing beacons. I will
>> narrow down my test set to a single client and capture the packets to
>> understand the interaction better.
> ok, understood.
>
> Regards,
>        Chr
>


Thanks,
- Harshal
