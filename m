Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbXKUPJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 10:09:37 -0500
Subject: RE: [PATCH] mac80211: hardware scan rework (V2)
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
In-Reply-To: <1195579307.3389.52.camel@localhost.localdomain>
References: <119553601948-git-send-email-yi.zhu@intel.com>
	 <1195566632.10920.39.camel@johannes.berg>
	 <33E1C72C74DBE747B7B59C1740F74437027F30D4@orsmsx417.amr.corp.intel.com>
	 <1195579307.3389.52.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eJ9TRIcbHS5QUwvv7rmd"
Date: Wed, 21 Nov 2007 16:10:43 +0100
Message-Id: <1195657843.12000.15.camel@johannes.berg> (sfid-20071121_150943_791836_20C50E65)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eJ9TRIcbHS5QUwvv7rmd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-11-20 at 12:21 -0500, Dan Williams wrote:

> > Johannes
> > The firmware will go back to the old setting, the ones before scan, onc=
e
> > done scanning by it self. The calls by mac80211 after scan complete to
> > set channel will be ignored by the iwl driver if we still tuned to the
> > same channel, iwl wont call firmware on the same setting, it has to be =
a
> > change to call down to firmware. I need to check what happen if user
> > change channel during scan, this call might be necessary in this case.
>=20
> I'd expect that either (a) the scan gets canceled and then the channel
> change happens, or (b) the channel change gets queued and happens
> immediately after the scan completes.  (b) is probably the easier thing
> to do here unless the ucode has a cancel-scan command, but then you have
> to wait until the scan is actually canceled anyway, which sort of
> implies (b) too.  So maybe just do (b) and be done with it :)

mac80211 software scanning will do (b) so I expect the driver to handle
the configuration callback and queue the channel switch to after the
ucode finishes scanning.

johannes

--=-eJ9TRIcbHS5QUwvv7rmd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0RKcqVg1VMiehFYAQJVEQ/+KpIOL2AtRSM0kOqrpjpZD99gLKK0UgPd
XLkC4MnaVbkHDMCha3rFZAWUKNKxV2rGZKIeqeCdfB8FjPnf3hGUlIhs1ee0h1Xe
UHmYhMvMlbrrl19WKyxmAIMWGkHDydDwlSrzN2UpDzA83tmA2NiOP8IbFHCJvd4Z
FD0GHFsrBMmTM+sM3TIZuQD3kXjvktjB7wQtwiiAdQSAxRB4Piq7lRIpYw3t8s/q
9tnNi0L75xMeq3dzyQh+SVwYT6fC4QXe0VV4TkJP49anCS377KPMySlMjK7FYj1k
KGLKPtTH80RwvHElW8I2+oSf+qbajp0U0v2jTKcuml0j6o0J26H9VxMNCZAxiSaB
F7OzMZJ2SXchUd+U9AZZVh3KWEITWt4XLeTEEr4bOEM3MRTEtZmo9Qyuv+VyR02T
pXkGq+341x5wZA38H1xJ1MIRiD9STpdsz3989T3QqmlgOSjGGlDmat1jl8IxfpUS
ckUFXDDUNg7A6M4Oh/GgNIGL1N3LOshhSeirHR57OSFz7jLwOBmJxKUG0bskg1rT
oSETDFdumEB62aA+2ltQakOCFkNyAOlQQfs36Lum1nMzQgW+rx+0JmLWbor/vNqN
BgkvmfZE7P7/g1RxLSOHVh6nQJ70JXHKGJrYJm+vLs8+hwLbmjpsPe/Rzw7DKDF6
4i/MilRzIwc=
=vwgT
-----END PGP SIGNATURE-----

--=-eJ9TRIcbHS5QUwvv7rmd--

