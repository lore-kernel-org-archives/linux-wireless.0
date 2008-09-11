Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbYIKSxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 14:53:53 -0400
Subject: Re: [PATCH] mac80211: add pre- and post-scan hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1221033061.12266.10.camel@johannes.berg> (sfid-20080910_095115_515502_30A213FC)
References: <1214149401.8585.2.camel@localhost.localdomain>
	 (sfid-20080622_174624_286344_54D543FD)  <1221033061.12266.10.camel@johannes.berg>
	 (sfid-20080910_095115_515502_30A213FC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-s1x8dAYIAEMv/zVY3pwk"
Date: Thu, 11 Sep 2008 20:53:14 +0200
Message-Id: <1221159194.6986.57.camel@johannes.berg> (sfid-20080911_205357_217690_BD0E9F09)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s1x8dAYIAEMv/zVY3pwk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-10 at 09:51 +0200, Johannes Berg wrote:
> On Sun, 2008-06-22 at 11:43 -0400, Dan Williams wrote:
> > mrv8k has commands that get called before and after the scan has been
> > done to save and restore hardware state.  Add optional callbacks to
> > mac80211 to enable low-level drivers to know when the stack is about to
> > start scanning, and when it's done.
>=20
> Was just talking to Sujith about something on IRC and realised that
> maybe this is required to turn off IBSS beaconing when leaving the
> channel for a scan?

On the other hand, we should add API to turn off beaconing anyway, which
userspace might actually request. And when we do that, we can use it to
turn off IBSS beaconing.

The beaconing API in total is a bit strange, we tell the driver when the
beacon changes and it can then request one, but we never tell it when to
start/stop beaconing, which means that currently your driver has to
figure to start out beaconing on the first beacon change, and then
cannot possibly stop again... We can return NULL from the beacon get
function but that could be an error condition too...

I think we just need to add start/stop beacon bits, and then we can use
them around a scan too, thoughts?

johannes

--=-s1x8dAYIAEMv/zVY3pwk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyWkWAAoJEKVg1VMiehFYE4cP/jauvSLxkc20M1YUmcLG2WAP
ZXlFT5OvBrc+slMX4dWgm4XTs3SKcNLxo5oK27gyRoGK4BKsFC6Ybx07IScnMy0x
1z7TmJF4wkFms4tflRbG2hNZjtR88Xal57COsPYv/yJ4TSxraZStul/uKwlWOEjG
KrqBbP/mEsblt6PLeZkrFnbGccD/63nYXsgRDO+zz7nxw0EbOVBcdJZLnGm4CkhD
UKfLuxUtJkDSPdoaFLpc5eDu+D4hMHSc8S0j25IzNDqqo1vvkLppIszAPAAEewlZ
LBPhDPuwTNW8ef7rntIRp2u1oAk1vXr0rkfgTFbFZNYGHvr17iw9dIWXrrDWL7rL
eWolUlDJrlNloX8JD0jfSdLh3VT9ot2zHX6n6R3GM7VTFTDaBEWaWv05dGZmm01k
P8QgRfVL2cOvWCtzYUuzNfakUDwZY1fKoc4xHfRS1LQa/yZO9oh6TWDIYUWFU36v
OFs1h5NKQF9wRTyHXX/LIVBVnL2zV+ASUOZ7IrDyqN05LKydG0sgFsGbAqij6Nbk
GOoCfKpBk4i3hn2P96hC7w0u/F6YeLWQ2QUepWJoLSomo9whddORw/WFyMM42wuL
lFBkQ1a9rmL+l0Sg1mdrm1KJeqUxJX3Hr+NGQoZ0uHJzLZc5J780frNNdwm66dJS
jD7U37I4M9HP8n4HeWlt
=GWgi
-----END PGP SIGNATURE-----

--=-s1x8dAYIAEMv/zVY3pwk--

