Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lugor.de ([212.112.242.222]:46356 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752627AbXBKNRo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 08:17:44 -0500
From: "Hesse, Christian" <mail@earthworm.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Date: Sun, 11 Feb 2007 14:17:33 +0100
Cc: James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
References: <45CCE3CA.4050904@linux.intel.com> <200702101424.00156.mail@earthworm.de> <1171155323.5573.7.camel@dv>
In-Reply-To: <1171155323.5573.7.camel@dv>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2520377.Wqasgr7Fmf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702111417.38336.mail@earthworm.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2520377.Wqasgr7Fmf
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 11 February 2007 01:55, Pavel Roskin wrote:
> Hello!
>
> [I'm trimming the cc: a little bit]
>
> On Sat, 2007-02-10 at 14:23 +0100, Hesse, Christian wrote:
> > On Friday 09 February 2007 22:12, James Ketrenos wrote:
> > > We are pleased to announce the availability of a new driver for the
> > > Intel PRO/Wireless 3945ABG Network Connection adapter.
> >
> > Wow, great news on this rainy saturday! ;-)
> >
> > The driver works perfectly, I'm writing this mail via wireless link.
> > However there are two things to note:
> >
> > The driver generates two network devices. The second one is for
> > promicious mode? Is there any chance to disable the interface? ifrename
> > renamed the wrong one to wlan0 and I had to tell my system to use eth1
> > for the wireless connection.
>
> I think one of the devices is wmaster0.  It's better that you just
> ignore it.  The effort is already underway to make that interface
> hidden.
>
> In the meantime, you can use the "arp" condition in /etc/iftab.
> Ethernet is 1 (that includes the original wlan0), IEEE 802.11 is 801
> (that's the master devices and devices in monitor mode).  For example:
>
> wifi* arp 801
> eth* arp 1

I decided to drop the iftab thing and replace it with udev rules. The=20
following rules do the expected renaming:

KERNEL=3D=3D"eth*", SYSFS{address}=3D=3D"00:13:77:04:a7:77", NAME=3D"eth0"
KERNEL=3D=3D"eth*", SYSFS{address}=3D=3D"00:00:f0:41:20:07:e8:49", SYSFS{ty=
pe}=3D=3D"24",=20
NAME=3D"fw0"
KERNEL=3D=3D"eth*", SYSFS{address}=3D=3D"00:13:02:0f:56:a2", SYSFS{type}=3D=
=3D"1",=20
NAME=3D"wlan0"

> > Second problem is that I can't unload the module. I get the message
> > "FATAL: Module iwlwifi is in use." even if both interfaces are down.
>
> I cannot reproduce this problem.  Please see the output of "lsmod" and
> the kernel log for possible oopses.

lsmod shows a use count of 4294967295 (2^32 - 1), no oopses or the like. Th=
is=20
is reproducable all the time.
=2D-=20
Regards,
Chris

--nextPart2520377.Wqasgr7Fmf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFzxdylZfG2c8gdSURAnYjAJwLPVZllNeHKRJlbk3yGI+Q/BWk6QCfbEck
6NV9/FlFcjjAFcF9UrqqEAM=
=lGal
-----END PGP SIGNATURE-----

--nextPart2520377.Wqasgr7Fmf--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
