Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:44083 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbXB0NaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 08:30:10 -0500
Message-ID: <45E4325E.9020306@warmcat.com>
Date: Tue, 27 Feb 2007 13:30:06 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] Penumbra - Enabling unencrypted broadcasts alongside	normal
  traffic
References: <45E41A9E.2020908@warmcat.com> <1172581143.3870.259.camel@johannes.berg>
In-Reply-To: <1172581143.3870.259.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

Hi -

Thanks for your comments.

> Just a few comments. I'll leave aside the issues with 802.11 here hoping
> you've thought about that. There are issues with admission control and
> similar things, for example.

No I didn't consider these elements, because in effect the broadcasts 
are no different from uncontrolled traffic from another network on the 
same channel.

> First, allow me to comment on some things from other sources:
> 
>> The payload is protected using a 255:223 Reed-Solomon? Forward Error
>> Correction coding. This is capable to correct any 16 symbol errors
>> over each 223 bytes of payload. To maximize the benefit of this
>> protection, bulk data packets are limited to 213 bytes of actual
>> payload (and a 10-byte header), giving a 255 byte encoded packet
>> payload so each fragment fits inside a single error correction coding
>> cycle. The Reed-Solomon? coding also means there is no need for a
>> payload CRC.
> 
> 802.11 frames are always protected by a 32-bit CRC and will be discarded
> by hardware (in most cases) if that doesn't match. This is unnecessary
> overhead.

That's right that some devices are hiding frames with failed CRCs, but 
it isn't true of all of them.  In the case where they aren't hiding the 
broken frames, the Reed-Solomon coding allows the broadcast to be 
recovered in many cases.  One of the bits on the first byte of the 
packet is reserved to show if the sending station has ever seen a broken 
packet being received, so a responding station can decide whether to use 
the ECC or not in reply.

In the case where a broadcasting station has decided to "use the 
airtime", it makes sense to try to recover the packet if possible since 
the airtime was already blocked.  I found that typical errors were runs 
of bits getting trashed, the R-S coding can recover up to 16 bytes of 
damage in such runs.  The benefit of it is greater as the number of 
listeners in range increases, or the bitrate used for the transmission 
decreases (and the potentially lost airtime therefore goes up).

>> The unencrypted broadcast packets are indicated by having a "Magic MAC" 
>> address in their IEEE80211 Header Addr<n> fields.  The Magic MAC for 
>> Penumbra is 13:22:33:44:55:66 (the IEEE had something to say about our 
>> original choice of 11:22.. :-O ).
> 
> How about registering a OUI or getting someone to donate a MAC address
> instead of using a locally administered one?

I contacted the IEEE about it some weeks ago, their response was 
basically to tell me not to use the 11: space but this locally 
administered one.  They did not respond to my requests for a donation of 
one measly MAC address, although I did not exhaust all the contacts 
there yet.  I can't afford to register a OUI myself, but I have a 
customer with an allocation that can probably spare one.  An advantage 
of using locally administered though is that the LSByte of the MAC could 
be overloaded to indicate other broadcast protocols using the same 
technique, if only the first 5 bytes of the MAC are matched.

>>   - Userspace transmits by creating a PF_PACKET / SOCK_RAW socket and 
>> prepending an Ethernet header with the Magic MAC in it and send()ing it. 
> 
> I don't see why you couldn't use the packet injection stuff we'll be
> needing anyway for userspace MLME.

Well that would be fine :-)  The current implementation is just what I 
could make work in a reasonable way with the old 80211 stack and then I 
ported it to the new one.

The old 80211 stack method uses a kernel module that hooks the 
hard_start_xmit() for network interfaces that have wireless extensions 
on them, using the network interface notification API in Linux.  I chose 
to come at it like that because this is similar to the method that I 
hope will work on Windows.

>>   - The wireless driver gets the packet for transmission, recognizes the 
>> Magic MAC, disables retries and sets the transmission rate (currently 
>> fixed 54Mbps, but this will change) and transmits the packet as a broadcast
> 
> You'd be able to control these parameters then.

Sounds good!  Does this exist yet?  How does one use it?

>>   - When an incoming packet is seen with the magic MAC it has a fake 
>> fixed Ethernet, IP and UDP header prepended to it.  IP and UDP checksums 
>> are inserted so the packet is clean.  The packet always looks like it is 
>> coming from UDP 0.0.0.0:61441 (port 0xF001) and is directed to 
>> 255.255.255.255:61442 (port 0xF002).  The packet is subject to iptables 
>> rules as usual.
> 
> Similarly, why not have userspace use a monitor interface directly?

The answer is again because the old stack did not offer the concept of a 
logical Monitor action on the same device that is associated as INFRA. 
But allowing "out of the box" operation is critical so I will try this 
method also.  I saw it mentioned that you can create these by writing 
down /sys.

>> To get any kind of widespread use, the capability 
>> needs to be already available in stock kernels and drivers so that the 
>> user only needs to open iptables and run a userspace daemon rather than 
>> patch his wireless drivers and stack.
> 
> I don't think that once we have packet injection in place for userspace
> MLME (well, we even have it now) you'll need to do any modifications at
> all. You'll just need to do more stuff in userspace. I also don't see
> why iptables should see these packets that are explicitly not IP. In
> fact, I think such packets should not be seen by the networking stack at
> all.

Well this is a perfectly fine solution for me if the need for all my 
patches should evaporate and things "just work" for endusers, so I am 
interested about the state of the injection stuff.

-Andy
