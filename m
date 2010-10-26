Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:39585 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759834Ab0JZLDf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 07:03:35 -0400
Date: Tue, 26 Oct 2010 13:03:32 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Lee <lee-in-berlin@web.de>, linux-wireless@vger.kernel.org
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
Message-ID: <20101026110332.GA3982@sig21.net>
References: <4CC0D0F6.4080507@web.de>
 <4CC33E83.4020505@web.de>
 <201010260740.47692.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201010260740.47692.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 26, 2010 at 07:40:47AM +0200, Helmut Schaa wrote:
> 
> Please try to create a monitor interface on the rt73usb AP after setting it up:
> 
> # iw dev wlan0 interface add mon0 type monitor
> 
> and run a tcpdump on that (with XX:...:XX replaced by the MAC address of
> your client):

ip link set up dev mon0

> # tcpdump -i mon0 "ether src XX:XX:XX:XX:XX:XX"
> 
> Do you see any frames from your specific client?

On the client I run:

zzz:~# ping 172.28.120.1
PING 172.28.120.1 (172.28.120.1) 56(84) bytes of data.
>From 172.28.120.2 icmp_seq=1 Destination Host Unreachable
>From 172.28.120.2 icmp_seq=2 Destination Host Unreachable
>From 172.28.120.2 icmp_seq=3 Destination Host Unreachable

On AP I get:

# tcpdump -i mon0 "ether src 00:15:61:xx:xx:xx"
tcpdump: WARNING: mon0: no IPv4 address assigned
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on mon0, link-type IEEE802_11_RADIO (802.11 plus radiotap header), capture size 65535 bytes
00:02:51.398953 48.0 Mb/s 2447 MHz 11g -46dB signal antenna 1 [bit 14] Data IV: 56 Pad 20 KeyID 0
00:02:51.497845 48.0 Mb/s 2447 MHz 11g -46dB signal antenna 1 [bit 14] 
00:02:52.415053 48.0 Mb/s 2447 MHz 11g -46dB signal antenna 1 [bit 14] Data IV: 57 Pad 20 KeyID 0
00:02:53.414897 48.0 Mb/s 2447 MHz 11g -46dB signal antenna 1 [bit 14] 
00:02:53.415135 48.0 Mb/s 2447 MHz 11g -46dB signal antenna 1 [bit 14] Data IV: 58 Pad 20 KeyID 0
00:02:53.513661 48.0 Mb/s 2447 MHz 11g -44dB signal antenna 1 [bit 14] 
00:02:54.415042 48.0 Mb/s 2447 MHz 11g -44dB signal antenna 1 [bit 14] Data IV: 59 Pad 20 KeyID 0
00:02:54.415671 36.0 Mb/s 2447 MHz 11g -44dB signal antenna 1 [bit 14] Data IV: 59 Pad 20 KeyID 0
00:02:54.513572 48.0 Mb/s 2447 MHz 11g -44dB signal antenna 1 [bit 14] 
00:02:55.430725 48.0 Mb/s 2447 MHz 11g -46dB signal antenna 1 [bit 14] Data IV: 5a Pad 20 KeyID 0
00:02:56.430702 48.0 Mb/s 2447 MHz 11g -46dB signal antenna 1 [bit 14] 
00:02:56.430942 48.0 Mb/s 2447 MHz 11g -46dB signal antenna 1 [bit 14] Data IV: 5b Pad 20 KeyID 0
00:02:56.529433 48.0 Mb/s 2447 MHz 11g -46dB signal antenna 1 [bit 14] 
00:02:57.249028 1.0 Mb/s 2447 MHz 11b -44dB signal antenna 1 [bit 14] Probe Request (foo) [1.0 2.0 5.5 11.0 6.0 9.0 12.0 18.0 Mbit][|802.11]
00:02:57.350169 48.0 Mb/s 2447 MHz 11g -44dB signal antenna 1 [bit 14] 
00:02:57.350402 24.0 Mb/s 2447 MHz 11g -44dB signal antenna 1 [bit 14] 
00:02:57.350582 18.0 Mb/s 2447 MHz 11g -42dB signal antenna 1 [bit 14] 
...


(The client is sending ARP requests but not getting answer:
zzz:~# tcpdump -p -i wlan0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlan0, link-type EN10MB (Ethernet), capture size 65535 bytes
13:00:35.740957 ARP, Request who-has 172.28.120.1 tell 172.28.120.2, length 28
13:00:36.740924 ARP, Request who-has 172.28.120.1 tell 172.28.120.2, length 28
13:00:37.740926 ARP, Request who-has 172.28.120.1 tell 172.28.120.2, length 28
)

The station is using rt3070 usb dongle, AP is D-Link DWL-G122 rt73usb dongle.


Johannes
