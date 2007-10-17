Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:20892 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbXJQOXQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 10:23:16 -0400
Date: Wed, 17 Oct 2007 16:22:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: iwl3945 doesn't work
Message-ID: <20071017142246.GQ5043@kernel.dk> (sfid-20071017_152319_589320_A47951B8)
References: <20071017135452.GJ5043@kernel.dk> <200710171708.48654.ismail@pardus.org.tr> <20071017141111.GM5043@kernel.dk> <1192630733.10567.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1192630733.10567.37.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 17 2007, Dan Williams wrote:
> On Wed, 2007-10-17 at 16:11 +0200, Jens Axboe wrote:
> > On Wed, Oct 17 2007, Ismail D=F6nmez wrote:
> > > Wednesday 17 October 2007 Tarihinde 16:54:53 yazm????t??:
> > > > Hi,
> > > >
> > > > Seeing that iwl3945 is now merged, I decided to switch my x60 t=
o use
> > > > that instead of ipw3945. That would leave me with zero kernel
> > > > dependencies.
> > > >
> > > > Unfortunately it doesn't work. Loading the module reveals the d=
evice:
> > > >
> > > > iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection dr=
iver for
> > > > Linux, 1.1.17ks
> > > > iwl3945: Copyright(c) 2003-2007 Intel Corporation
> > > > ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> I=
RQ 21
> > > > PCI: Setting latency timer of device 0000:03:00.0 to 64
> > > > iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
> > > > iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> > > > phy0: Selected rate control algorithm 'iwl-3945-rs'
> > > >
> > > > # iwconfig wlan0
> > > > wlan0     IEEE 802.11g  ESSID:"xxxxxxxxxxxxxx"
> > > >           Mode:Managed  Channel:0  Access Point: Not-Associated
> > > >           Tx-Power=3D0 dBm
> > > >           Retry min limit:7   RTS thr:off   Fragment thr=3D2346=
 B
> > > >           Encryption key:XXXX-XXXX-XX
> > > >           Link Quality:0  Signal level:0  Noise level:0
> > > >           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid fra=
g:0
> > > >           Tx excessive retries:0  Invalid misc:0   Missed beaco=
n:0
> > > >
> > > > and iwconfig sees it, essid/enc settings are fine, but I don't =
get a
> > > > link.
> > >=20
> > > Same issue here, try iwlist wlan0 scan first and then it should w=
ork.
> >=20
> > Huh indeed, now it links fine! Thanks for the hint. Would be nice t=
o
> > have fixed, though :-)
>=20
> Odd, doesn't the driver need to do a scan _anyway_ to find the right
> BSSID to associate with if the cached scan results are more than a fe=
w
> seconds old?  Can you run '/sbin/iwevent' before trying a fresh
> association, try to associate, ensure that it has failed, and report =
the
> output?
>=20
> If you don't get something like:
>=20
> 10:17:05.117937   eth1     Scan request completed
>=20
> shown there, then there's likely a bug in the driver because it's eit=
her
> (a) not scanning before trying to associate, or (b) not sending out s=
can
> completion events after it's done a scan.

Indeed, there is now Scan request completed before I run the iwlist
scan. iwevent output:

Waiting for Wireless Events from interfaces...
16:20:27.453588   wlan0    Set Mode:Managed
16:20:27.462104   wlan0    Set Encryption key:off
16:20:27.463940   wlan0    Set Encryption key:****-****-**   Security m=
ode:open
16:20:27.466535   wlan0    Set ESSID:"kjellbergaxboe"

waiting, nothing else happens. Then run iwlist scan from another
terminal.

16:20:53.892549   wlan0    Scan request completed
16:20:54.025085   wlan0    Custom driver
event:ASSOCINFO(ReqIEs=3D000e6b6a656c6c626572676178626f65010402040b16
RespIEs=3D010482848b96dd0c00037f0201015b0002a44000)
16:20:54.025123   wlan0    New Access Point/Cell address:00:13:46:97:33=
:E2

bingo, it associates and it now works.

--=20
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
