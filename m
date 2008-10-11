Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYJKAnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 20:43:43 -0400
Subject: Re: [PATCH] mac80211: move bss_conf into vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810101732y610b4cc8g1b914b2c8eb726e5@mail.gmail.com> (sfid-20081011_023226_199069_C0202D5B)
References: <1223682711.29811.7.camel@johannes.berg>
	 <1ba2fa240810101732y610b4cc8g1b914b2c8eb726e5@mail.gmail.com>
	 (sfid-20081011_023226_199069_C0202D5B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Cd51HZb8Uca7i+nnGEf+"
Date: Sat, 11 Oct 2008 02:43:40 +0200
Message-Id: <1223685820.29811.23.camel@johannes.berg> (sfid-20081011_024348_141321_591C4102)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Cd51HZb8Uca7i+nnGEf+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-11 at 02:32 +0200, Tomas Winkler wrote:
> On Sat, Oct 11, 2008 at 1:51 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Move bss_conf into the vif struct so that drivers can
> > access it during ->tx without having to store it in
> > the private data or similar. No driver updates because
> > this is only for when they want to start using it.
>=20
> What protection should driver take to be sure it won't be changed underne=
ath ?
> With prive copy you know this is changed only in bss_info changed is call=
ed.

Yeah, that's true, I guess you can only access those fields there that
you can access atomically. That's actually most of the fields though.

Also, we don't actually take care about locking this structure at all
even in mac80211, something we might need to think about.=20

johannes

--=-Cd51HZb8Uca7i+nnGEf+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7/a5AAoJEKVg1VMiehFY9rIP/jdbqwmgZD34iF+LRPvDPi89
AdrrWpLUaPDNVEvMmbMk+7si5AueO0FlyCIFz4FW6X7GL7rRbkDqM0gBCCVnezEY
EE2fUlhl2dttGvMJUjzDKPB4nFiipnVNUdehjYilYWrX61QEvYdFztjRgixTUNkO
EoPSxoMXiFsNG8XB3K8HvW2GV/zSwQ7O684KXxmtXqNmN/z264f2MIDT4Z3BOfPT
ArXOM/BYqsulBz5qjmAN8c/cyzQlrUsDlEb0pp2dsjztRV/A5RB3bJwgbZu2re5N
AkOhTRG6snoMwzzg0zUkFm1VsatIYN9gbQC+VJXcfXkex2U5jjYUh5cA7mxR76cj
SOUBRztCGKuNhbYyl+VSOAJ6fvK5KA4oBaF2pco08GmrBbfhnSQWmxD0bgiB42Ze
2EMjOCsF2fTAqNAOcuYNV/EwS1Uv0Fbv64o0njmfbgdmZAHPUFb/amOvTQWj7nSj
EWG+TywQUnxmaw8WZspE1leZN69ZXgHis/Pw9Yny1VzT8/ai7KmVYyEZc7MsJS3w
C+7y3EjRVdpFF1yuG4cOlGd8ydcGlJ55nwh+nJQpoXknF7VnAtrichPTRzzD6hVH
BKzIJtUX7SYVwrMs+jD9bLCrsfZHIBfIDNIH76A3OiqJkJXFLFowYw4ru+tA++N/
RiYPO1xN0fAxeyw4Jxf6
=Mr9F
-----END PGP SIGNATURE-----

--=-Cd51HZb8Uca7i+nnGEf+--

