Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:61358 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753700AbYGIP10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:27:26 -0400
Message-ID: <4874D8DD.3020803@lwfinger.net> (sfid-20080709_172730_825682_7ABDB792)
Date: Wed, 09 Jul 2008 10:27:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Monnier <monnier@iro.umontreal.ca>
CC: linux-wireless@vger.kernel.org
Subject: Re: Slow b43 with 2.6.25.9 on an asus wl-700ge home-router
References: <jwvlk0bsjk7.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
In-Reply-To: <jwvlk0bsjk7.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan Monnier wrote:
> I finally started to use the b43 driver on my home-router and am happy
> to have it working at all (with WPA), but I notice that the speed is
> pretty terrible: I cannot seem to get more than 100KB/s out of it (I
> use it as a personal web proxy, so it ends up slowing down my
> web-surfing :-( ).
> 
> Originally "iwconfig" told me that the bit rate was 2Mb/s (and even
> that should allow me to get a bit more than 100KB/s).
> After "iwconfig wlan0 rate 54M", the result is the same (except that
> "iwconfig" tells me the bit rate is 54Mb/s).
> 
> More specifically, iwconfig tells me things like:
> 
> wlan0     IEEE 802.11  ESSID:"test"  
>           Mode:Managed  Frequency:2.457 GHz  Access Point: 00:10:30:C0:50:50   
>           Bit Rate=54 Mb/s   Tx-Power=27 dBm   
>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
>           Link Quality=95/100  Signal level:-54 dBm  Noise level=-63 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> which seems to indicate that the reception is indeed good.
> Any idea what I might want to check?
> 
> I did notice that my dmesg says things like
> "received packet with  own address as source address".  This seems
> related to my use of bridging, but:
> 1 - I have no bridging loop (actually I unplugged all ethernet cables,
>     so the only active network interface in the bridge is wlan0).
> 2 - taking wlan0 out of the bridge eliminates those messages, but
>     doesn't improve the bandwidth.
> 
> Any idea what might be going on?

What model is your card? Please post the output of 'dmesg | grep b43'.

With the current versions of mac80211, the rate-setting mechanism is very good. 
If you force a high rate, i.e. with 'iwconfig ... 54M', you run the risk of 
increasing your error rate causing many more retransmits, and might reduce the 
throughput. That may not be happening here, but I wonder why the rate capped at 
2M. Incidentally, the quality numbers for my BCM4312 located about 2m from the 
AP are "Link Quality=93/100  Signal level:-37 dBm  Noise level=-71 dBm". My Link 
Quality is lower than yours, but S/N is much better - not that any of those 
numbers have much validity. My transmit throughput is consistently over 2 Mbs, 
but I'm not bridging. Roughly 6 months ago, I did set up routing, but that was 
using iptables, not a formal bridge device. That configuration had full speed.

If you shut down the bridge, what speed do you get?

Larry


Larry
