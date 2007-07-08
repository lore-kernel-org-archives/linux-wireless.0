Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:58531 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbXGHSPZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 14:15:25 -0400
Date: Sun, 8 Jul 2007 20:15:24 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Andy Green <andy@warmcat.com>
Cc: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Arrested Development
Message-ID: <20070708181524.GA12389@deine-taler.de>
References: <468DE699.9040708@warmcat.com> <468E48AF.10109@gentoo.org> <468E5C33.2000102@warmcat.com> <20070708140054.GA28113@deine-taler.de> <46910F3F.8010201@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46910F3F.8010201@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-07-08 17:22 Andy Green wrote:

> I rebooted into the new kernel and did this only
> 
> # iwconfig wlan0 mode monitor
> # ifconfig wlan0 up
> # iwconfig wlan0 channel 6
> # tcpdump -i wlan0
> 
> But all I could see were beacons, this is despite I am ssh-d into that
> box over the same channel 6 network with WPA and should surely be seeing
> the encrypted packets?

I assume you were connected over a different interface. It appears
that the code, which enables the reception of all packets hasn't
been called or is wrong. Currently you will see only packets that
are sent to the interface. Promiscous mode is also interesting,
but shouldn't have any importance in monitor mode, which the
iwconfig manual describes as passing all packets on the frequency.

> Then I decided to start wpa_supplicant (this
> is an FC6 box so it was service wpa_supplicant start) and I got this oops:
> 
> ...
> EIP is at zd_mac_config_interface+0xc/0x35 [zd1211rw_mac80211]
> ...

I believe Jon Smirl reported the same bug. But I didn't quite
understand how to provoke it.

Cheers,

Uli

-- 
Uli Kunitz
