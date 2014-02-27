Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35150 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaB0QE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:04:58 -0500
Message-ID: <1393517094.4648.3.camel@jlt4.sipsolutions.net> (sfid-20140227_170502_188216_4653623F)
Subject: Re: pci-half-mini 7260 Wireless AC support 3.13
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Nelson <tim.l.nelson@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Feb 2014 17:04:54 +0100
In-Reply-To: <CAOAOC6a96e5MrEOVY=KXirhUU-rJRv2hgz5B0so9SkWYMpoDfw@mail.gmail.com> (sfid-20140227_161437_552680_8A64D0B7)
References: <CAOAOC6a96e5MrEOVY=KXirhUU-rJRv2hgz5B0so9SkWYMpoDfw@mail.gmail.com>
	 (sfid-20140227_161437_552680_8A64D0B7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-27 at 10:14 -0500, Tim Nelson wrote:
> I am currently running a mainline ubuntu 3.13.5 lowlatency kernel with
> the lastest intel firmware:
> 
> iwlwifi-7260-ucode-22.15.8.0.tgz
> 
> Linux nix-tn 3.13.5-031305-lowlatency #201402221823 SMP PREEMPT Sat
> Feb 22 23:51:31 UTC 2014 i686 i686 i686 GNU/Linux
> 
> I am unable to connect to the wireless AC radios on my 3702
> Lightweight AP that is connected to a Cisco 5508 controller.  On the
> controller, I do see clients hitting the AC radios on the SSID.  I am
> only connecting to the A/N radio however at 5ghz.
> 
> Is AC truly supported currently?  I heard the patches for it would be
> applied in 3.13 but when I do a iwconfig wlan0 I only see:
> wlan0     IEEE 802.11abgn
> 
> This leads me to believe that it's not actually supported yet.

11ac is definitely supported, since long before 3.13 in fact, though
11ac TX rates were only added later.

> However, this could be something aesthetic with iwconfig.

It's just the thing iwconfig reads not having been updated in forever...

What kind of problem did you run into? We recently saw this bug pop up
which might be what you're seeing:
https://bugzilla.kernel.org/show_bug.cgi?id=70881
There's a fix for that on the way.

johannes

