Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45813 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760106Ab0FQOik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 10:38:40 -0400
Received: by fxm10 with SMTP id 10so1654391fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 07:38:38 -0700 (PDT)
Message-ID: <4C1A336B.9040708@googlemail.com>
Date: Thu, 17 Jun 2010 16:38:35 +0200
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Subject: Re: "ressource temporarily unavailable" on 2.4 GHz, not on 5GHz
References: <4C18DA3D.1030303@googlemail.com> <AANLkTimtZBRfkAOnz2vPXp71Z03DfPQniY2qFHCsgI44@mail.gmail.com> <4C1A1175.7010708@googlemail.com>
In-Reply-To: <4C1A1175.7010708@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Okay, let's say, we have a crowded medium, lots of clients transmitting
traffic and therefore we have backoff times of around 50ms. Let's say,
we have such a backoff only ONCE(just for theoretical discussion) -
transmission of this packet would take at least 50ms. With the amount of
data I want to transmit in my example program, I am running at around
3,2 kbps, which is not that much(I send out 800 bytes each 2ms -> 800
bytes/2ms = 400 bytes/ms * 8 = 3,2 kbps). Now for 50ms there can be no
transmission due to the backoff time. The buffer of the wireless card -
or the buffer of the socket, I do not exactly know - gets filled 25
times with 800 byte-packets. That's in total 25 * 800 byte = 10000 byte.
So in this scenario, I would at least need a buffer 10kbyte of size. The
buffer of the socket should be sufficient, since an SO_SNDBUF call gives
114688 of size. That should be sufficient. Anyway, Wright and Stevens
(TCP/IP Illustrated Volume 2, Chapter 16.7 - "Unreliable Protocol
Buffering") state:

"With unreliable protocols (e.g. UDP), no data is ever stored in the
send buffer and no ACK is ever expected. Each message is passed
immediately to the protocol where it is queued for transmission on the
appropriate network device".

This tells me, that the driver buffer seems to be too small for this
frequency of packets (every 2ms) with this size (800 bytes), if I work
on a band, that is loaded with backoff times due to carrier sense
multiple access(CSMA). Is there a way to increase its size for ath5k?

Kind regards,
Dennis

Dennis Borgmann schrieb:
> Hey guys!
>
> I just reproduced the error with a transmit frequency of 4ms and dmesg
> doesn't show up with any new output. I will append dmesg to this mail
> anyway.
>
> Apart from that, I will go ahead and search for handling EAGAIN.
>
> Kind regards,
> Dennis
>
>
> Bob Copeland schrieb:
>   
>> On Wed, Jun 16, 2010 at 10:05 AM, Dennis Borgmann
>> <dennis.borgmann@googlemail.com> wrote:
>>   
>>     
>>> Hello wireless-list!
>>> Hello hostapd-list!
>>>
>>> I am using ath5k with hostapd-0.6.9 on a debian running kernel 2.6.34
>>> and I am observing a "ressource temporarily unavailable" - error code 11
>>>     
>>>       
>> [...]
>>   
>>     
>>> What could be the problem? Is this due to backoff-times in 2.4 GHz, that
>>> don't occur on 5 GHz? Or could this be a bug?
>>>     
>>>       
>> Does dmesg report any error (e.g. no available txbuf)?
>>
>> My guess is you have more frequent successful delivery in 5 GHz than in
>> ISM band so you aren't running out of send buffers somewhere in the stack.
>>
>> Of course, your program should expect and handle EAGAIN if you are
>> using MSG_DONTWAIT.
>>
>>   
>>     
>
>   

