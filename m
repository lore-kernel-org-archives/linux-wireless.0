Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33974 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab1DHNIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 09:08:38 -0400
Received: by bwz15 with SMTP id 15so2817568bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 06:08:37 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [RFT] p54: implement multicast + arp req PS filter
Date: Fri, 8 Apr 2011 15:08:27 +0200
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <201104020058.17232.chunkeey@googlemail.com> <201104080328.53801.jcmvbkbc@gmail.com>
In-Reply-To: <201104080328.53801.jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104081508.27822.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Friday 08 April 2011 01:28:52 Max Filippov wrote:
> I used for tests the following cell:
> 
> wlan1     Scan completed :
>           Cell 01 - Address: 00:22:15:1C:09:D1
>                     Channel:11
>                     Frequency:2.462 GHz (Channel 11)
>                     Quality=67/70  Signal level=-43 dBm  
>                     Encryption key:on
>                     ESSID:"test"
>	[...]
> Is it suitable?
certainly, in fact any configuration should do.

> I guess that to do e.g. ARP filtering firmware must
> be able to decipher incoming packets.
> How can I make sure that it does?
As long as the module parameter nohwcrypt is left untouched, 
the firmware should be able to decipher incoming frame on
its own. [we setup the rxkeys in p54_set_key]

> So, I associated with that AP and obtained an IP address.
Just a question, that popped into my head: "Have you enabled PS?
either with "iw dev wlanX set power_save on" or
?iwconfig wlanX power on?, because the filters may be restricted
to PSM.

> Regarding ARP filtering I tried the following test:
> - ping station from the outside to see if ARPs for its IP pass through;
> - ping non-existing IP in the same network from the outside to see
>   if other ARPs pass through.
> 
> To test multicast filtering I tried to ping several multicast addresses
> from the outside.
sounds about right. 

> I see that although ARP filter was set (I added printfs to both
> branches above), all ARP requests pass through:
 
> (none):~# ./tcpdump -i wlan0 -nn -s0 arp
hmm, what about "-p"? I think that the interface should not be in
promisc mode since it might change the result.
 
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on wlan0, link-type EN10MB (Ethernet), capture size 65535 bytes
> 00:01:33.715332 arp who-has 192.168.4.33 tell 192.168.4.138
> 00:01:33.716644 arp reply 192.168.4.33 is-at 00:1d:6e:9b:ee:0d
>
> (none):~# ./tcpdump -i wlan0 -nn -s0 -e icmp
on a second thought, maybe we should take tcpdump out of
the equation all together and dump the raw data coming
from the device when PSM is enabled.

(for my usb device, I've used usbmon. But I don't know
if there's something similar for spi/sdio?)
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on wlan0, link-type EN10MB (Ethernet), capture size 65535 bytes
> 00:22:23.855499 00:21:00:38:5e:d9 > 01:00:5e:00:00:01, ethertype IPv4 (0x0800), length 98: 192.168.4.138 > 224.0.0.1: ICMP echo request, id 11114, seq 1, length 64
> 00:22:24.856842 00:21:00:38:5e:d9 > 01:00:5e:00:00:01, ethertype IPv4 (0x0800), length 98: 192.168.4.138 > 224.0.0.1: ICMP echo request, id 11114, seq 2, length 64

> Do you have any other tests in mind that I could run?
> By the way, I see that ARP filter does not apply to the station
> in IBSS or mesh mode. Is that intended?
Really? No that's not intended, is this a shortcoming of the driver or
of the stack?

Regards,
	Christian
