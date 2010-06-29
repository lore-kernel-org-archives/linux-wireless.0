Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60506 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752354Ab0F2JRL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 05:17:11 -0400
From: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
To: Jason Andryuk <jandryuk@gmail.com>
Subject: Re: [PATCH 0/2] at76c50x-usb.c: Fix broken authentication process
Date: Tue, 29 Jun 2010 11:17:46 +0200
Cc: kalle.valo@iki.fi, linux-wireless@vger.kernel.org
References: <201006221651.24853.Sebastian.Smolorz@gmx.de> <201006281747.00128.Sebastian.Smolorz@gmx.de> <AANLkTilyntO2L8LPOd_1BO73PLiDQBNbOv3e10gXI0N8@mail.gmail.com>
In-Reply-To: <AANLkTilyntO2L8LPOd_1BO73PLiDQBNbOv3e10gXI0N8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201006291117.46947.Sebastian.Smolorz@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk wrote:
> On Mon, Jun 28, 2010 at 11:46 AM, Sebastian Smolorz
> 
> <Sebastian.Smolorz@gmx.de> wrote:
> > Jason Andryuk wrote:
> >> On Tue, Jun 22, 2010 at 10:51 AM, Sebastian Smolorz
> > 
> > It does but I must admit that I did not test the direct probing, only
> > the authentication.
> > 
> > Which kernel version did you patch?
> 
> I used John Linville's wireless-testing tag master-2010-06-24
> (2.6.35-rc3).  Your patches were included in the tree.

OK.

> > The problem is that when probed directly, no (real) bssid is coded in
> > the frame, only the multicast address. So with a frame of type
> > IEEE80211_STYPE_PROBE_REQ we have no chance to decode the bssid because
> > mac80211 doesn't give us the needed information. I think in the case of
> > direct probing we are lost, only the authentication works with the
> > patch I sent. Another solution would be to change mac80211 but that
> > would be a special solution for just one driver. It's questionable if
> > this is a viable way. On the other hand it would be great to have a
> > working driver again.
> 
> How do you bypass the direct probe and go immediately to
> authentication?  NetworkManager/mac80211 tries the direct probe before
> authentication.  Without a probe response, mac80211 does not progress
> to the actual authentication.

I have one computer on which authentication is always processed without any 
preliminary direct probe. I tried that several times and with another 
wireless stick, too. On my laptop, the direct probe is processed first but I 
use the following workaround:

modprobe at76c50x-usb
iwconfig wlan0 essid <ESSID>
ifconfig wlan0 <IP>
ifconfig wlan0 down
ifconfig wlan0 <IP>
ifconfig wlan0 down
ifconfig wlan0 <IP>

So for me it's necessary to set the IP three times before the interface 
works. After the first time the direct probe is processed and fails. After 
the second time authentication is tried - but now the direct probe 
responses. After the third time, finally, the authentication is successful.

I know, this is very ugly, but maybe a feasible workaround for you, too.

-- 
Sebastian
