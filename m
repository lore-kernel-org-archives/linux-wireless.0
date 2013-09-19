Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63852 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab3ISPsl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 11:48:41 -0400
Received: from [192.168.2.102] ([79.218.127.198]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LbuIK-1VoLiq3dTQ-00jLDP for
 <linux-wireless@vger.kernel.org>; Thu, 19 Sep 2013 17:48:37 +0200
Message-ID: <523B1CD1.1050207@rempel-privat.de> (sfid-20130919_174845_939795_F3C421B9)
Date: Thu, 19 Sep 2013 17:48:33 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: James Hogan <jhogan22.liberty@gmail.com>
CC: Sujith Manoharan <sujith@msujith.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k WPA2-PEAP MSCHAPV2 Connectivity issue
References: <522B7D97.2010409@gmail.com> <21035.64671.831349.345777@gargle.gargle.HOWL> <522CAF8E.8000006@gmail.com> <21037.48871.472273.313308@gargle.gargle.HOWL> <CAOpc7mHajHfUc1YOuNv8RcuqY3Lw50XbSLBNueDF3vW2Q0YS_A@mail.gmail.com> <522FC154.10100@gmail.com> <21039.52508.810448.90944@gargle.gargle.HOWL> <523B11E0.4070504@gmail.com>
In-Reply-To: <523B11E0.4070504@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 19.09.2013 17:01, schrieb James Hogan:
> I think I have stumbled on to the real issue. I'm sorry if I have been
> wasting your time at all. Apparently, the network is having problems
> with all wireless-n mode cards.
> The network doesn't like how wireless-n is roaming to the different AP's
> and is registering as me disconnecting when the wireless card tries to
> connect to roam to the other AP.
> It's not just ath9k though, Ra-Link and other cards are having these
> issues as well. Is there a way to disable or to make it possible to
> disable the wireless-n mode of the card and just
> use wireless abg? On a note, I noticed when I passed to the command line
> "iw event -r" that at about the time my card would scan, that is when I
> would stop receiving service even though
> my cards never registered as being disconnected. After the scan, the
> card just continues to reissue scans. Sometimes however, it will try to
> reconnect me to the network.  I was talking to one of the IT employees
> in my class today and he said that they have been having this issue with
> all of the newer higher-end cards.
>
> This is the scan output:
> wlan0 (phy #0): scan started
> wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447
> 2452 2457 2462 2467 2472 5180 5200 5220 5240 5260 5280 5300 5320 5745
> 5765 5785 5805 5825, ""

At the scan time the card will switch channel and will stop to receive 
packets. Normally it will do lots of jumps. For example, if you 
connected on channel 2437, it will jump like: 2437->2412; 2412->2437; 
2437->2417; ... and so on. Jump back to primer channel is needed to 
check if there is some thing new to receive or send.
In case of dualband hardware, the scan will be extra long. Because there 
is more channels and some hardware need longer to switch between 2G and 5G.
Next problem is bus delay. In case if you use usb adapter a channel 
switch may take terribly long time. Mostly it depends on usb host 
controller on other usb related bugs. Currently I fight with one of this 
problems. In my case, with unoptimised driver, usb wifi adapter need 
1second!!!! to change a channel. It mean 26seconds for scan on one band 
adapter and almost 40 sends on dualband.

May be we should try to do less intensive scan with bigger delays 
between channel switches?

-- 
Regards,
Oleksij
