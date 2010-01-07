Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0AGG5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 01:57:31 -0500
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Backlund <tmb@mandriva.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4B451A68.5020102@mandriva.org>
References: <1262710858.28653.5.camel@johannes.local>
	 <4B450004.9050601@mandriva.org> <1262814684.4437.0.camel@johannes.local>
	 <4B4508A5.8050501@openwrt.org> <4B45110E.9010603@mandriva.org>
	 <4B451A68.5020102@mandriva.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eCxxlS2PG7Bp4w1VzkqV"
Date: Thu, 07 Jan 2010 07:57:25 +0100
Message-ID: <1262847445.3414.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eCxxlS2PG7Bp4w1VzkqV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-01-07 at 01:19 +0200, Thomas Backlund wrote:

> >> net/mac80211/wme.c: I funktion "ieee80211_select_queue":
> >> net/mac80211/wme.c:99: varning: skickar argument 1 till
> "sta_info_get"
> >> fr?n inkompatibel pekartyp
> >> net/mac80211/sta_info.h:408: anm: "struct ieee80211_local *"
> >> f?rv?ntades men argumentet har typ "struct ieee80211_sub_if_data *"
> >
>=20
> As I cant get it from any log, and dont have a camera available right=20
> now, I just wrote some lines to paper wich confirms the breakage in
> the=20
> above build error...
>=20
> The trace shows:
>=20
> RIP: sta_info_get

Well as the message tells you, sta_info_get needs a local argument in
your tree, rather than 'sdata', so you can just do 'sdata->local'
there ...... It doesn't need any particular fixups, just a bit of merge
resolving ...

johannes

--=-eCxxlS2PG7Bp4w1VzkqV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLRYXQAAoJEODzc/N7+QmaoqYQAIQ69jnQZsQPmf9F4vryPe8c
Z62Z7rlCLHWK92y3kMJ44N/sYofTuwDSz4HHlDKNgIIKB1EmfFeILRiHKjgQZ9T1
13ytyvm11bnxe8LZv3hVAcbh7dQM29uVPZWSsuX7VNn3Rfxu5/k/t/jRL7ZqIPwG
93e1bzti2Wozc5IdS020cebZ+5Q/4RlV6FBUZ3FN2mG+h9wwUGobzCjhWW4Wl3Ne
APMCZaT3RV8R2O4J3devy19jqqUl8jAP3PINKDzE34+/KHI/98Y7Nm68CEOGzQm9
Qtzqd023sdvZ8nn3V93YXIbcUQXq9mOdZaDzsClTfkoZ7xl+c/1DU18Med/fkxeI
tjzcDlm7qCnZqcyImT/TRo0rPYP+exUuUnxq1+paPP0kW/KJGP05+BhgcYmDyO4Z
rfGqk0CEqGfSMWnTsADbnJUUa8QgncpPJc7POaNQsMvqZUZgoGBaljaY2YeRersq
YaLhNYJW2O/rZEbLy0PCMlYrJ9Fsk0yElgLe9pSuQ/Os/amkBxqDebaDDFkWUDaG
A1beC4UsmeSs+grrM8pt0R1/8P/mN5f2vnQlTZyXeWDGHcpnMEhrfTkcWmzzaOPY
+KwUY0GElJJ19A95r0Fn+4UOXk/LuC/rsOfup+EFEdl/IiqXNLKek8kSZE9cqUfp
HPEociRuqcVU8wRSmbuN
=fRW5
-----END PGP SIGNATURE-----

--=-eCxxlS2PG7Bp4w1VzkqV--

