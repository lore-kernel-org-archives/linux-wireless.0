Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:35141 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2LNJId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 04:08:33 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2589654lag.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2012 01:08:31 -0800 (PST)
Message-ID: <1355476107.10239.55.camel@rorics.office.pelagicore.net> (sfid-20121214_100839_907510_0BA69A8F)
Subject: Re: rtl8192cu in AP mode.
From: Richard =?ISO-8859-1?Q?R=F6jfors?= <richard.rojfors@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 14 Dec 2012 10:08:27 +0100
In-Reply-To: <201212131930.21029.chunkeey@googlemail.com>
References: <1355355956.2744.26.camel@asus>
	 <201212131930.21029.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 19:30 +0100, Christian Lamparter wrote:
> On Thursday, December 13, 2012 12:45:56 AM Richard Röjfors wrote:
> > I've been playing with an rtl8192 the last days, I want it to act as an
> > access point. It's connected to an ARM9 box.
> > 
> > I'm using the latest compat-wireless, with some additional patches for
> > beacon support.
> > 
> > My hostapd conf looks like this:
> > interface=wlan0
> > ssid=Test
> > driver=nl80211
> > hw_mode=b
> > channel=6
> > dtim_period=1
> > 
> > It almost works. Running hostapd and the networks shows up for my other
> > machine, which can connect to the network.
> > 
> > I also get dhcp-requests through and corresponding dhcp responses. But
> > then the oddness starts. ARP requests sent from the client is received
> > on the AP side, the IP stack returns an ARP response, and I see it
> > beeing sent by _rtl_submit_tx_urb and usb_submit_urb returns 0. But
> > nothing is received on the other end.
> > Sometimes, very rarely a response can get through, maybe 1 of 100 or so,
> > or even less.
> 
> What's your client? Does it switch to power save mode after DHCP response
> and is it an 11n client as well [same device? different device/driver -
> yes I know you haven't enabled 11n, but still.]?

I have tested with two clients, my GNU/Linux laptop. It has a intel wlan
chipset. How would I know if it switches to power save?
What I did was for instance a ping. Which repeatedly sent arp requests.
In parallel with that I send a DHCP request. I got a DHCP response but
no arp responses. So I guess my wlan chip stayed in the same power
mode? 

The other client is an android phone, which I suppose tries to save
power aggressively(?).

Both the clients support 11n.

Is there an easy way to find out regarding the power saving mode?

Btw I saw another difference on the 8192cu AP compared to other AP's
nearby. Kismet say it had a beacon time of 0, while others had non-zero.
I applied a patch I found on the list for some beacon handling.

--Richard


