Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZKDJbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 04:31:35 -0500
Subject: Re: iwlwifi connection troubles, maybe aggregation related
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
In-Reply-To: <cb0375e10911031538n62fe7473x4dd41329b9264b5c@mail.gmail.com>
References: <cb0375e10911031538n62fe7473x4dd41329b9264b5c@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-teQeZP8aKrRVnOo8Fetq"
Date: Wed, 04 Nov 2009 10:30:17 +0100
Message-ID: <1257327017.28469.76.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-teQeZP8aKrRVnOo8Fetq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-03 at 18:38 -0500, Andrew Lutomirski wrote:

> iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =3D 00:21:d8:49:4a:52 tid =3D=
 0

> Turning on or off power management and fiddling with
> no_sleep_autoadjust makes no difference.  Setting tx_agg_tid_enable to
> zero in debugfs while the connection was working seemed to make it a
> little more reliable (it lasted long enough to do "git pull" but not
> much longer).
>=20
> After running "iw dev wlan0 disconnect" a few times, I start to get
> errors like this:
>=20
> [18078.209635] iwlagn 0000:03:00.0: SENSITIVITY_CMD failed
> [18078.313461] iwlagn 0000:03:00.0: No space for Tx
> [18078.313467] iwlagn 0000:03:00.0: Error sending SENSITIVITY_CMD:
> enqueue_hcmd failed: -28
> [18078.313470] iwlagn 0000:03:00.0: SENSITIVITY_CMD failed
> [18078.522409] iwlagn 0000:03:00.0: No space for Tx
> [18078.522414] iwlagn 0000:03:00.0: Error sending SENSITIVITY_CMD:
> enqueue_hcmd failed: -28

Sounds like the firmware messes up ...

Maybe as a first workaround you could modprobe iwlagn with
11n_disable=3D1. But I don't know at this point what the problem could be.

johannes

--=-teQeZP8aKrRVnOo8Fetq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK8UmkAAoJEODzc/N7+Qmav88P/27mVtPrzz43wK79kQVvcVLj
LtTwhy4QDlMCjG6RWyftrkPLSV2C5OqP2pzBmn5BoUnVkyI5v42ecKxipl+/PeM5
VrqYkqY9IOEG/ffKxviSyzT/kStTFBYcnl1ZexrkW2DFKSJTDwIo5rh7TpSldp0E
3xVm9cPHCJFBW+y7HqX1ZeL/1TdD13u2FANoTK7e9olh50dBQQaAJti1w3EJU7kI
TMZ+cA5A1cxS21wLzr2aihaZnMnIKp+UdRJzfZwT0wJE33nw1cW0ALI3VmFWqbXn
Atf4xmVFrbmfIiN3gdnQvIdewXpItpgBYlLo6tpIfeYVyw1hxF4OOn4PslI+vwnF
qh5UUfbsBok/ajSt9U0VXSuV4NyrjClim1ZFChYcbbBYp0LbtdnLz0Pb1NcJRDyI
urVxrToYz+TLd32hOAQhlTYatdv0JZyh0rBgyNzTRz8CYlYy/MJ7yis+ujBZf9//
luccuUAiOjFYlTTAWpz5D+bngciuWJLhcCDL2irNnzq2o88Hdx8ClO0qC5t1l2ts
iYhRDjDoCa1GWmF0yQNcXpP43ioorbe8N4TNY9A2KRAkeAZoiI98YzUiR/WLMkIu
V7ftZetRnnwZY/QhbgR+DQMrzQuXAz2rP962ZIpH06AFbfS/LT/kmt9yj8WUNe5f
l3pqlP9uGFWVUsPueHni
=jBhg
-----END PGP SIGNATURE-----

--=-teQeZP8aKrRVnOo8Fetq--

