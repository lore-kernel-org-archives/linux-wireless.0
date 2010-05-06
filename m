Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:39206 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab0EFSUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 14:20:44 -0400
Received: by pzk42 with SMTP id 42so114491pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 11:20:44 -0700 (PDT)
Message-ID: <4BE30879.4020008@lwfinger.net>
Date: Thu, 06 May 2010 13:20:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: seno <senada@t-online.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL 8187b - naughty behaviour
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com> <4BB7660A.3030900@lwfinger.net> <loom.20100506T185847-345@post.gmane.org>
In-Reply-To: <loom.20100506T185847-345@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/2010 12:36 PM, seno wrote:
> Hi Larry,
> 
> I'm running Mandriva 2010 x86_64 (2.6.31.13) and have a 8187b chipset installed:
> 
> 0bda:8189 Realtek Semiconductor Corp. RTL8187B Wireless 802.11g 54Mbps Network 
> Adapter
> 
> As many other linux users report, this chipset is supported but offers only 
> limited performance, especially compared to results when using windows.
> 
> Some time ago I connected to a Linksys wrt 54 GL router with Linksys firmware 
> and recently I installed DD-wrt on that router, but perfomance remaind at the 
> same (poor) level; meaning there must be something wrong with the rtl8187 linux 
> modul.
> 
> Right now the router is ~10 meters away and iwconfig wlan0 output is
> 
> IEEE 802.11bg ESSID:"xxx"  
>           Mode:Managed  Frequency:2.412 GHz  Access Point: 00:14:BF:4A:ED:F9   
>           Bit Rate=18 Mb/s   Tx-Power=27 dBm   
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:xxxx-xxxx-xxxx-xxxx-xxxx-xxxx-xxxx-xxxx [3]
>           Power Management:off
>           Link Quality=70/70  Signal level=-33 dBm  
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> Right after booting, I can reach a wireless download rate of ~ 10mbit/s (I have 
> 10 mbit cable internet). After a while, it seems that the wireless rate drops 
> to 1 mbit/s although iwconfig wlan0 stills shows a bit rate of 11 or 18 mbit/s.
> That means, I get stuck at a download speed of ~ 130 K/s  -unless I come closer 
> to the router, 1 meter ie, then the wireless speed goes up again.
> 
> The router status shows 
> 
> 	Wireless Packet Info
> 	Received (RX)
> 	45915806 OK, 10 errors  
> 	Transmitted (TX)
> 	81142592 OK, 746 errors 
> 
> If the machine with the 8187b chip is connected, I get a lot of TX errors on 
> the router. 
> 
> While linux shows good connection quality, the router indicates a bad signal 
> quality:
> 
> 	Signal	Noise	SNR	Signal Quality
> 	-74	-94	20	24%
> 
> -I installed the latest package from linux wireless, driver loaded but for some 
> reason it was not able to connect to a wpa2 network (iwconfig wlan0 never shot 
> enc key), so I uninstalled that again.
> -I booted a Mandirva 2010.0 x86 live cd to see if the problem is the same on 32 
> bit system, and yes, it is.
> -I found a 'newer' driver rtl8187B_linux_26.1056.1112.2009.release.tar.gz on 
> ubuntu forum - compiled, installed but for any reason driver did not load 
> correctly and something ooopsed (I blacklisted rtl8187 and set r8187 as alias 
> for wlan0).
> 
> Any idea what I could do to get some better performance with the 8187b chipset?

I do not understand the poor performance. I have a device with the
rtl8187b chip - USB IDs 0bda:8187. That is an ID for an rtl8187, but it
does have the B chip. I use tcpperf to measure the transmit speed. At 2
m from the AP with an indicated signal of -17 dBm, my throughput is 13
Mb/s. At 10 m with a signal of -49 dBm, the transmit speed is 3.5 Mb/s.
On the download using speedtest.net, I got 11.3 Mb/s at 2 m, and 2.64 at
10 m. I got 0.49 Mb/s upload at both distances as that is the speed of
my line.

What happens if you use iwconfig to force a particular rate? At what
setting is your throughput maximized. I don't think there is a problem
with the rate setting mechanism, but that would test it.

Larry
