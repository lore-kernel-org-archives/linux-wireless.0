Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:54672 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149Ab0J1IQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 04:16:11 -0400
Message-ID: <4CC93148.7090308@web.de>
Date: Thu, 28 Oct 2010 10:16:08 +0200
From: Lee <lee-in-berlin@web.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
References: <4CC0D0F6.4080507@web.de> <4CC33E83.4020505@web.de> <201010260740.47692.helmut.schaa@googlemail.com>
In-Reply-To: <201010260740.47692.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/10/10 07:40, Helmut Schaa wrote:
> Hi,
> 
> Am Samstag 23 Oktober 2010 schrieb Lee:
>> On 22/10/10 01:47, Lee wrote:
>>> The test case is as follows: I have eth0 and wlan0 (the interface to an
>>> rt37usb device) in a bridge lan0. I have a properly configured hostapd. When I
>>> try to connect with a client to my hostapd AP, I can successfully
>>> authenticate, but all further packets don't reach the interface of the AP.
>>>
>>> However, I can see broadcast packets *from* the AP on my client, but not the
>>> other way round (DHCP requests from client to AP). To make sure the bug was
>>> not specific to broadcast packets, I manually set an IP on my client and tried
>>> to ping the AP, but those packets didn't come through, either.
> 
> [...]
> 
>> I checked vanilla 2.6.36, the bug is still there. Is this a known bug? Does
>> anyone care to give me some hints? Are any details needed?
> 
> Please try to create a monitor interface on the rt73usb AP after setting it up:
> 
> # iw dev wlan0 interface add mon0 type monitor
> 
> and run a tcpdump on that (with XX:...:XX replaced by the MAC address of
> your client):
> 
> # tcpdump -i mon0 "ether src XX:XX:XX:XX:XX:XX"
> 
> Do you see any frames from your specific client?
> 
> Helmut

Yes. I can see this:
# tcpdump -i mon0 "ether host 00:1F:3B:79:41:6F"
10:09:31.193127 1.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Probe Request () [1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 Mbit][|802.11]
10:09:31.193360 1.0 Mb/s [bit 15] Probe Response (<MY_AP>) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH: 11, PRIVACY[|802.11]
10:09:40.952828 1.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Probe Request () [1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 Mbit][|802.11]
10:09:40.952986 1.0 Mb/s [bit 15] Probe Response (<MY_AP>) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH: 11, PRIVACY[|802.11]
10:09:40.963821 1.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Probe Request (<MY_AP>) [1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 Mbit][|802.11]
10:09:40.963906 1.0 Mb/s [bit 15] Probe Response (<MY_AP>) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH: 11, PRIVACY[|802.11]
10:09:42.739932 1.0 Mb/s 2462 MHz 11b -78dB signal antenna 1 [bit 14] Authentication (Open System)-1: Succesful
10:09:42.740120 1.0 Mb/s [bit 15] Authentication (Open System)-2: 
10:09:42.742538 1.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Assoc Request (<MY_AP>) [1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 Mbit][|802.11]
10:09:42.742726 1.0 Mb/s [bit 15] Assoc Response AID(2) : PRIVACY : Succesful[|802.11]
10:09:42.744261 1.0 Mb/s [bit 15] EAPOL key (3) v2, len 95
10:09:42.771053 1.0 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] 
10:09:42.788163 1.0 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] IP6 :: > ff02::16: HBH ICMP6, multicast listener report v2, 1 group record(s), length 28
10:09:42.844416 1.0 Mb/s [bit 15] EAPOL key (3) v2, len 95
10:09:42.849396 1.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] EAPOL key (3) v1, len 117
10:09:42.849864 1.0 Mb/s [bit 15] EAPOL key (3) v2, len 207
10:09:42.854022 1.0 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] EAPOL key (3) v1, len 95
10:09:42.893532 1.0 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] Data IV:  1 Pad 20 KeyID 0
10:09:42.987625 1.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] 
10:09:43.079505 1.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] 
10:09:43.358335 1.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV:  2 Pad 20 KeyID 0
10:09:44.198308 1.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV:  3 Pad 20 KeyID 0
10:09:44.359547 1.0 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] Data IV:  4 Pad 20 KeyID 0
10:09:44.377797 2.0 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] Data IV:  5 Pad 20 KeyID 0
10:09:44.425039 2.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV:  6 Pad 20 KeyID 0
10:09:44.446283 1.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV:  7 Pad 20 KeyID 0
10:09:44.692999 2.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV:  8 Pad 20 KeyID 0
10:09:44.943957 2.0 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] Data IV:  9 Pad 20 KeyID 0
10:09:45.004451 2.0 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] Data IV:  a Pad 20 KeyID 0
10:09:45.144803 2.0 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] Data IV:  b Pad 20 KeyID 0
10:09:45.458125 2.0 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] Data IV:  c Pad 20 KeyID 0
10:09:45.997789 2.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV:  d Pad 20 KeyID 0
10:09:46.177139 5.5 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV:  e Pad 20 KeyID 0
10:09:47.491055 5.5 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] Data IV:  f Pad 20 KeyID 0
10:09:48.210438 5.5 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] Data IV: 10 Pad 20 KeyID 0
10:09:48.367412 5.5 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV: 11 Pad 20 KeyID 0
10:09:50.769904 2.0 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] 
10:09:50.861516 2.0 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] 
10:09:51.007367 5.5 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] Data IV: 12 Pad 20 KeyID 0
10:09:52.377411 5.5 Mb/s 2462 MHz 11b -74dB signal antenna 1 [bit 14] Data IV: 13 Pad 20 KeyID 0
10:10:03.013402 5.5 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV: 14 Pad 20 KeyID 0

However, on wlan0 I don't see anything beyond the EAPOL packets.
Temporarily turning off WPA encryption let me successfully connect to my AP.

Lee
