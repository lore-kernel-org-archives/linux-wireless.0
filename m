Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZC3RqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 13:46:17 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Dirk Opfer <Dirk@opfer-online.de>,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <200903301039.52153.inaky@linux.intel.com>
References: <1238349195.24972.5.camel@johannes.local>
	 <1238406057.24972.23.camel@johannes.local>
	 <200903301039.52153.inaky@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hzeeCjb93DwlGw5NoI9Q"
Date: Mon, 30 Mar 2009 19:45:43 +0200
Message-Id: <1238435143.5970.21.camel@johannes.local> (sfid-20090330_194620_286715_11DBE4A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hzeeCjb93DwlGw5NoI9Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 10:39 -0700, Inaky Perez-Gonzalez wrote:
> On Monday 30 March 2009, Johannes Berg wrote:
> >
> >  * wimax
> >    -> need help, seems to report rfkill states to input device?
> >       don't understand
>=20
> Not really.=20
>=20
> What it does is if the device exposes a hw rfkill key, export that=20
> key as an input device, as well as using it to report the state
> change.=20
>=20
> So there are three main entry points:
>=20
> wimax_report_rfkill_hw() -- device driver report to stack
>  =20
>    device reports a change in the hw rfkill key; switch the radio to
>    whichever state AND report a key event through the input layer

But reporting the key through the input layer is wrong, afaict.

> wimax_report_rfkill_sw() -- device driver report to stack
>=20
>    device reports a change in the sw rfkill state; this is needed for
>    cases where the radio is shared amongst different technologies (wifi
>    and wimax, for example, in the case of the 5150). When you turn on
>    Wifi, WiMAX switches off (and vice versa).
>=20
>    As well, if from SW you flip it off, this gets called back but does
>    nothing as the state is updated already.

Shouldn't that be a hard block then? Or can the software turn it back on
(and consequently turn off wifi)?

> wimax_rfkill / wimax_rfkill_toggle_radio -- user interface
>=20
>    The user wants to flip the SW switch on/off

Right.

So let's go back to my first assertion:
"seems to report rfkill states to input device"

wimax_report_rfkill_hw:

        enum rfkill_state rfkill_state;

...
                input_report_key(wimax_dev->rfkill_input, KEY_WIMAX,
                                 rfkill_state);

??

I don't see why it should have an input device at all, to be honest.

johannes

--=-hzeeCjb93DwlGw5NoI9Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0QVEAAoJEKVg1VMiehFYa/8P/18isIFXPvmxwJt1AYXutG73
1XSwgvIUJUoKfyZ/irMI/Blt6EpHv7VDLsIFCcAtnBusV+NZqoxtqpBYrAsCP96l
J5FnXgudgNZ0xm3ZH47806Uk+jepBnW+YyF2H2ihKxE1qHuWXeNDt9rwxaw5I8qT
gjivDB2qC+gcbltmCMmj0CaW1Hbc1NYea85rlkvjvx50C1RLgEVpTB5+alX11A8L
a7+Ql9RvOPzN/lQNnD/F787nhiIa26Z/bFTE1W4VVuY/4wmGN++p8qeZY2YzGvLI
vQtRFJrgUdOviqYi2oxKHh0misopucG/HqgLXz+oAdYr7v4kjDdUDA7X8kfx1S6i
PPTdHuT/wVNifF1P7Yo+bl8UTdbBSlqm52/rzzSWEF664kvEWPciZrKiAiiWrwtr
58bJYIFpptnMG5/j8Q+Tj6vYXDPEy/EuzAyfUnzAIU2QRIpT1ZC7S9YxpReT9GoX
hc2ma0qm/M6qRVH9/zclCOiMEsq6V5K355cmaSMqFlMJwoF5kSc4l0DzwHO9LQxb
WqVeLtgP61gMTOVKyJAQmdyizU81BzuMieS5Q7EBQCt0Y+XcWDeb2cvvKLgDweNX
h/Fos8FqhhwVUBxteXifwDIIQEaEOWvU2qqpP3yIAvVPWlDRgebz+bXvxChZepDL
QoRqXahEWxHFfrDJR6xG
=CUdS
-----END PGP SIGNATURE-----

--=-hzeeCjb93DwlGw5NoI9Q--

