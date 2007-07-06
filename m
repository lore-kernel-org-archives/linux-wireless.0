Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.231]:16516 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbXGFMeD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 08:34:03 -0400
Received: by nz-out-0506.google.com with SMTP id s18so185770nze
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2007 05:34:02 -0700 (PDT)
Message-ID: <9e4733910707060533y3bd3b4a5v5f0441f0d6e76377@mail.gmail.com>
Date: Fri, 6 Jul 2007 08:33:56 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: Multiple interfaces in mac80211
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200707052154.24976.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
	 <1ba2fa240707050530q2d165232raa73455397546c62@mail.gmail.com>
	 <9e4733910707050632m794944b5nb9ac9393b05dfa75@mail.gmail.com>
	 <200707052154.24976.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/6/07, Michael Wu <flamingice@sourmilk.net> wrote:
> On Thursday 05 July 2007 06:32, Jon Smirl wrote:
> > I'm debugging this because I've been trying for two days without
> > success to get monitor mode to work. I have the adapter in promisc
> > mode and the interface in monitor mode.  I can see directed and
> > broadcast traffic with tcpdump, but not directed traffic for other
> > nodes.
> >
> Outgoing packets from the wireless adapter are not reported unless you have
> Johannes' radiotap patches. Is that what you're talking about?

No, At the interface I am only seeing incoming packets that are to my
mac address or a multicast address. It is like the interface is not in
promiscous mode, but ifconfig shows PROMISC set.

Packets to other mac addresses are arriving at the receiver and I can
trace them up to ieee80211_rx_monitor and onto netif_rx. Something in
the higher level networking code is filtering out these promiscuous
packets; but I don't know what was is doing it. It's not iptables
which it isn't loaded.

My ethernet adapters work fine in promiscuous mode.  I have the same
wireless PROMISC problem on both ralink and zd1211 adapters.

Using the wireless-dev tree and wireless_tools.29. Wireless interface
is in monitor mode.I'm using tcpdump -i wlan0 -v to to look for the
packets.

wlan0     Link encap:UNSPEC  HWaddr
00-15-E9-2D-76-57-00-00-00-00-00-00-00-00-00-00
          UP BROADCAST RUNNING PROMISC MULTICAST  MTU:1500  Metric:1
          RX packets:135 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:11610 (11.3 KiB)  TX bytes:0 (0.0 b)

wlan0     IEEE 802.11g  Mode:Monitor  Frequency:2.457 GHz
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

-- 
Jon Smirl
jonsmirl@gmail.com
