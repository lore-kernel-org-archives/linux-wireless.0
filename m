Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39440 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1FUE0C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 00:26:02 -0400
Received: by iwn6 with SMTP id 6so1760243iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 21:26:01 -0700 (PDT)
Message-ID: <4E001D55.50503@lwfinger.net> (sfid-20110621_062611_799227_344BFD10)
Date: Mon, 20 Jun 2011 23:25:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Peter Chubb <peter@chubb.wattle.id.au>
CC: linux-wireless@vger.kernel.org
Subject: Re: State of rtl8192CU driver?
References: <w4hb7ohfo5.wl%peter@chubb.wattle.id.au>	<4DFB6004.1060006@lwfinger.net>	<w44o3l9w74.wl%peter@chubb.wattle.id.au>	<4DFFC1D9.8030803@lwfinger.net> <w4liwv6f47.wl%peter@chubb.wattle.id.au>
In-Reply-To: <w4liwv6f47.wl%peter@chubb.wattle.id.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/20/2011 10:24 PM, Peter Chubb wrote:
>>>>>> "Larry" == Larry Finger<Larry.Finger@lwfinger.net>  writes:
>
> Larry>  Peter, I found a problem with rtl8192cu since the 3.0-rcX
> Larry>  merge. Please go to
> Larry>  https://bugzilla.kernel.org/show_bug.cgi?id=38012 and try the
> Larry>  patch found there.
>
> Thanks.  I applied the patch and tried the result.
>
> With the patch applied, transmissions  work.  From an adjacent
> machine I can see the DHCP requests and router solicitations coming
> from the rtl8192cu using wireshark.
>
> However, reply packets are not received by the USB dongle ---
> wireshark on the machine with the dongle installed sees no packets
> coming in after the initial key exchange, only the packets going out.
>
> There's nothing in dmesg output to show the problem, and downing and
> then upping the interface results in failure to associate --- the
> authentication attempt times out.
>
> rtl8192cu: MAC address: 00:e0:4c:04:91:9c
> rtl8192cu: Board Type 0
> rtl8192cu: rx_max_size 15360, rx_urb_num 8, in_ep 1
> ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
> usbcore: registered new interface driver rtl8192cu
> udevd[1715]: renamed network interface wlan1 to wlan2
> rtl8192cu: MAC auto ON okay!
> rtl8192cu: Tx queue select: 0x05
> rtl8192c: Loading firmware file rtlwifi/rtl8192cufw.bin
> ADDRCONF(NETDEV_UP): wlan2: link is not ready
> wlan2: authenticate with 00:1e:2a:28:32:09 (try 1)
> wlan2: authenticated
> wlan2: associate with 00:1e:2a:28:32:09 (try 1)
> wlan2: RX AssocResp from 00:1e:2a:28:32:09 (capab=0x411 status=0 aid=1)
> wlan2: associated
> ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
> wlan2: deauthenticating from 00:1e:2a:28:32:09 by local choice (reason=3)
> wlan2: authenticate with 00:1e:2a:28:32:09 (try 1)
> wlan2: no IPv6 routers present
> wlan2: authenticate with 00:1e:2a:28:32:09 (try 2)
> wlan2: authenticate with 00:1e:2a:28:32:09 (try 3)
> wlan2: authentication with 00:1e:2a:28:32:09 timed out

What do you get for an md5sum for the firmware? I get
finger@larrylap:~> md5sum /lib/firmware/rtlwifi/rtl8192cufw.bin
943e9b714a926e630b8152d7aad91d2e  /lib/firmware/rtlwifi/rtl8192cufw.bin

Other than that, I have no explanation for what you see. I can connect with mine 
using WEP, WPA and WPA2 encryption. It also connects with an 802.11n AP using 40 
MHz channels.

The only difference between your system and mine is that I am using the 
wireless-testing tree, not the mainline tree, but I just checked the sources. 
The only differences were the most recent commits.

Larry

