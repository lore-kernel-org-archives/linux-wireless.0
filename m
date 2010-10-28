Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38215 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149Ab0J1IU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 04:20:28 -0400
Received: by qwf7 with SMTP id 7so907303qwf.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 01:20:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CC93148.7090308@web.de>
References: <4CC0D0F6.4080507@web.de>
	<4CC33E83.4020505@web.de>
	<201010260740.47692.helmut.schaa@googlemail.com>
	<4CC93148.7090308@web.de>
Date: Thu, 28 Oct 2010 10:20:27 +0200
Message-ID: <AANLkTinxK7=qrL8iEMxEQd71nE_k32aHomki3axbhp3P@mail.gmail.com>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Lee <lee-in-berlin@web.de>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> Am Samstag 23 Oktober 2010 schrieb Lee:
>>> On 22/10/10 01:47, Lee wrote:
>>>> The test case is as follows: I have eth0 and wlan0 (the interface to an
>>>> rt37usb device) in a bridge lan0. I have a properly configured hostapd. When I
>>>> try to connect with a client to my hostapd AP, I can successfully
>>>> authenticate, but all further packets don't reach the interface of the AP.
>>>>
>>>> However, I can see broadcast packets *from* the AP on my client, but not the
>>>> other way round (DHCP requests from client to AP). To make sure the bug was
>>>> not specific to broadcast packets, I manually set an IP on my client and tried
>>>> to ping the AP, but those packets didn't come through, either.
>>
>> [...]
>>
>>> I checked vanilla 2.6.36, the bug is still there. Is this a known bug? Does
>>> anyone care to give me some hints? Are any details needed?
>>
>> Please try to create a monitor interface on the rt73usb AP after setting it up:
>>
>> # iw dev wlan0 interface add mon0 type monitor
>>
>> and run a tcpdump on that (with XX:...:XX replaced by the MAC address of
>> your client):
>>
>> # tcpdump -i mon0 "ether src XX:XX:XX:XX:XX:XX"
>>
>> Do you see any frames from your specific client?
>>
>> Helmut
>
> Yes. I can see this:
> # tcpdump -i mon0 "ether host 00:1F:3B:79:41:6F"
> 10:09:31.193127 1.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Probe Request () [1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 Mbit][|802.11]

<..snip..>

> However, on wlan0 I don't see anything beyond the EAPOL packets.
> Temporarily turning off WPA encryption let me successfully connect to my AP.

And if you enable WPA, but disable Hardware encryption?
(module parameter hw_crypto=0).

Ivo
