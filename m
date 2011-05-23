Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:54844 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310Ab1EWGHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 02:07:10 -0400
Received: by mail-bw0-f47.google.com with SMTP id 5so6812803bwz.34
        for <linux-wireless@vger.kernel.org>; Sun, 22 May 2011 23:07:08 -0700 (PDT)
Date: Mon, 23 May 2011 09:07:02 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Eliad Peller <eliad@wizery.com>, Felipe Balbi <balbi@ti.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/PATCH 03/13] net: wl12xx: remove some unnecessary prints
Message-ID: <20110523060659.GB3095@legolas.emea.dhcp.ti.com> (sfid-20110523_080720_448846_A391D600)
Reply-To: balbi@ti.com
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
 <1305321990-22041-4-git-send-email-balbi@ti.com>
 <BANLkTinPipSVdsH5cTb24HKex_h7pOwpAg@mail.gmail.com>
 <BANLkTi=LKE_wWKxcN0+Unkcqv-tLOKqDXw@mail.gmail.com>
 <1306085440.12586.1696.camel@cumari>
 <BANLkTimf8+hLym2RHGeG1r=7EOj91c3Uzg@mail.gmail.com>
 <1306128773.12586.1704.camel@cumari>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
In-Reply-To: <1306128773.12586.1704.camel@cumari>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 23, 2011 at 08:32:53AM +0300, Luciano Coelho wrote:
> > >> > in fact, i find these prints pretty useful.
> > >> > does changing wl1271_notice to wl1271_debug(DEBUG_MAC80211) will s=
olve
> > >> > the "nosiness"?
> > >> > (i use DEBUG_MAC80211 rather than DEBUG_SDIO, as DEBUG_SDIO is rea=
lly
> > >> > *very* noisy)
> > >> >
> > >> > (i'll send it as a new patch as the original patch was already app=
lied)
> > >> >
> > >> > Eliad.
> > >> >
> > >>
> > >> err... s/nosiness/noisiness/
> > >
> > > I think these are pretty useless.  You can see whether the driver is
> > > loaded or not by lsmod'ing.  You can also use ftrace to get the same
> > > stuff, if you want to know whether the driver is loaded or not offlin=
e.
> > > Or what is the scenario where you think this is useful?
> > >
> > i was thinking about a simple offline log analysis, where it's pretty
> > useful to know when the wl12xx_sdio was insmod'ed/rmmod'ed.

It's quite weird statement IMHO. Drivers will load either if you
modprobe by hand of a device is created and matches a driver, in which
case udev will load it for you. In both cases, either you know driver is
loaded because you manually loaded it or, if you're connected to web, or
ifconfig -a shows something, or you can ping around etc...

Besides, if the driver doesn't load because e.g. it failed to allocate
memory, you should get a failure report on dmesg.

The best way to handle this is to be as silent as possible on the
working case and only bother people on failures ;-)

> > i haven't tried ftrace yet. i'll give it a look.
> > anyway, the whole wl12xx driver is full of similar logs that get
> > called multiple times, so i don't see the real advantage of removing 2
> > prints that get called only once.
>=20
> Yeah, the driver is full of useless logs.  That's why I'm going to
> rework it.  My idea is to use more standard tracing (nobody needs to
> learn wl12xx debug bitmask and how to set it), using ftrace and friends.

you can also play around with dynamic printk ;-) You use standard
dev_dbg() macros but can enable disable those by line, file, module, or
some simple regexes.

> > > I'm reworking the whole way our traces are handled, so I don't think
> > > reintroducing them is a good thing.
> >=20
> > ok. so i'll just wait for your rework :)
>=20
> It may still take a bit of time, because it's not my highest priority
> right now and the changes are quite intrusive (in the sense that they
> will touch every file), but when it's ready, I think it's going to be
> cool, you'll be able to use trace-cmd, kernelshark etc.

that's neat. I should do the same for musb ;-)

--=20
balbi

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2fmDAAoJEAv8Txj19kN1e6sH/02DZcGg4cnwPZGzmTTedN83
DK6bSEfkIOXN3hKD6/PgaWoNRwH7wl/8+qIQ2/GjPlFxYFTFIO1AHhPHy39fpI0M
/fqZ5iZXNYhZGFxeQl/3y51+l3S7j9gvfl7H7Y8bGP02f3/5e/2gsSfmVYl+GhzH
EKe6QdPYNunmCWWT70eBeu9p745V9VC+dzfgPZ8DkYyWrIjK3DjBxi1Gpi6IYvo1
VYPeyGT7thX9TssES/P8mzglSPqmdKoYoqIp5OnzRMBTd+phyxB0GV2PthjBp54v
HqIPd7vPZECLBrY6BWz5k47QoCPj5XX7BhAOKPYNnIKetXGB69QOlG2Kpwwd7v0=
=dxjE
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
