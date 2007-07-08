Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50121
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbXGHSTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 14:19:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: Arrested Development
Date: Sun, 8 Jul 2007 20:18:22 +0200
Cc: Andy Green <andy@warmcat.com>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <468DE699.9040708@warmcat.com> <46910F3F.8010201@warmcat.com> <20070708181524.GA12389@deine-taler.de>
In-Reply-To: <20070708181524.GA12389@deine-taler.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707082018.23045.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 July 2007 20:15:24 Ulrich Kunitz wrote:
> On 07-07-08 17:22 Andy Green wrote:
> 
> > I rebooted into the new kernel and did this only
> > 
> > # iwconfig wlan0 mode monitor
> > # ifconfig wlan0 up
> > # iwconfig wlan0 channel 6
> > # tcpdump -i wlan0
> > 
> > But all I could see were beacons, this is despite I am ssh-d into that
> > box over the same channel 6 network with WPA and should surely be seeing
> > the encrypted packets?
> 
> I assume you were connected over a different interface. It appears
> that the code, which enables the reception of all packets hasn't
> been called or is wrong. Currently you will see only packets that
> are sent to the interface. Promiscous mode is also interesting,
> but shouldn't have any importance in monitor mode, which the
> iwconfig manual describes as passing all packets on the frequency.
> 
> > Then I decided to start wpa_supplicant (this
> > is an FC6 box so it was service wpa_supplicant start) and I got this oops:
> > 
> > ...
> > EIP is at zd_mac_config_interface+0xc/0x35 [zd1211rw_mac80211]
> > ...
> 
> I believe Jon Smirl reported the same bug. But I didn't quite
> understand how to provoke it.

I think it's the NULL pointer dereference of the mac address pointer,
if there's only a monitor interface. The address pointer can be NULL.

-- 
Greetings Michael.
