Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbXJQOTT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 10:19:19 -0400
Subject: Re: iwl3945 doesn't work
From: Dan Williams <dcbw@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ismail =?ISO-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20071017141111.GM5043@kernel.dk>
References: <20071017135452.GJ5043@kernel.dk>
	 <200710171708.48654.ismail@pardus.org.tr> <20071017141111.GM5043@kernel.dk>
Content-Type: text/plain; charset=utf-8
Date: Wed, 17 Oct 2007 10:18:53 -0400
Message-Id: <1192630733.10567.37.camel@localhost.localdomain> (sfid-20071017_151929_188807_30E8C2C6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-10-17 at 16:11 +0200, Jens Axboe wrote:
> On Wed, Oct 17 2007, Ismail D=C3=B6nmez wrote:
> > Wednesday 17 October 2007 Tarihinde 16:54:53 yazm????t??:
> > > Hi,
> > >
> > > Seeing that iwl3945 is now merged, I decided to switch my x60 to =
use
> > > that instead of ipw3945. That would leave me with zero kernel
> > > dependencies.
> > >
> > > Unfortunately it doesn't work. Loading the module reveals the dev=
ice:
> > >
> > > iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driv=
er for
> > > Linux, 1.1.17ks
> > > iwl3945: Copyright(c) 2003-2007 Intel Corporation
> > > ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ=
 21
> > > PCI: Setting latency timer of device 0000:03:00.0 to 64
> > > iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
> > > iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> > > phy0: Selected rate control algorithm 'iwl-3945-rs'
> > >
> > > # iwconfig wlan0
> > > wlan0     IEEE 802.11g  ESSID:"xxxxxxxxxxxxxx"
> > >           Mode:Managed  Channel:0  Access Point: Not-Associated
> > >           Tx-Power=3D0 dBm
> > >           Retry min limit:7   RTS thr:off   Fragment thr=3D2346 B
> > >           Encryption key:XXXX-XXXX-XX
> > >           Link Quality:0  Signal level:0  Noise level:0
> > >           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:=
0
> > >           Tx excessive retries:0  Invalid misc:0   Missed beacon:=
0
> > >
> > > and iwconfig sees it, essid/enc settings are fine, but I don't ge=
t a
> > > link.
> >=20
> > Same issue here, try iwlist wlan0 scan first and then it should wor=
k.
>=20
> Huh indeed, now it links fine! Thanks for the hint. Would be nice to
> have fixed, though :-)

Odd, doesn't the driver need to do a scan _anyway_ to find the right
BSSID to associate with if the cached scan results are more than a few
seconds old?  Can you run '/sbin/iwevent' before trying a fresh
association, try to associate, ensure that it has failed, and report th=
e
output?

If you don't get something like:

10:17:05.117937   eth1     Scan request completed

shown there, then there's likely a bug in the driver because it's eithe=
r
(a) not scanning before trying to associate, or (b) not sending out sca=
n
completion events after it's done a scan.

Dan


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
