Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZA0Jw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 04:52:27 -0500
Subject: Re: [RFC/RFT 7/7] mac80211: fix aggregation timer lockups
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	Sujith.Manoharan@atheros.com
In-Reply-To: <1ba2fa240901270141y7361d332p7a0423e105afaec3@mail.gmail.com> (sfid-20090127_104143_179901_EAA30897)
References: <20090126184740.036240879@sipsolutions.net>
	 <20090126184925.913285565@sipsolutions.net>
	 <1ba2fa240901270141y7361d332p7a0423e105afaec3@mail.gmail.com>
	 (sfid-20090127_104143_179901_EAA30897)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jGd2nywQ2NIi9WlkBzvB"
Date: Tue, 27 Jan 2009 10:52:22 +0100
Message-Id: <1233049942.4012.21.camel@johannes.local> (sfid-20090127_105232_134109_D968BBD0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jGd2nywQ2NIi9WlkBzvB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 11:41 +0200, Tomas Winkler wrote:
> On Mon, Jan 26, 2009 at 8:47 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > As far as I can tell, there are possible lockups because both the RX
> > session_timer and TX addba_resp_timer are del_timer_sync'ed under
> > the sta spinlock which both timer functions take. Additionally, the
> > TX agg code seems to leak memory when TX aggregation is not disabled
> > before the sta_info is freed.
>=20
> Funny,  it was your deed to replaced the two locks with one. Woudn;t
> be better just put it back?

Not sure. The problem here seems to be that ever since the agg
structures are dynamically allocated (my pushing, I know) we need to
protect sta->ampdu_mlme.tid_tx[i]/sta->ampdu_mlme.tid_rx[i] with the
corresponding spinlock. Hence, if you look at my earlier patch closely,
it didn't actually introduce this problem, it just shifted it from one
lock to another.

johannes

--=-jGd2nywQ2NIi9WlkBzvB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJftlTAAoJEKVg1VMiehFYquwQAKNDjsHiB/nsfLFYJoI4jZbn
oeIeSfpCsAg/TnPfS/RssVTrEKy7MdhoPt3viJCF9p689PG8FZBxsY4i3XOYj+Hm
GsjC8sXDB1xPJ628z8olIhfbPDtFoNYigj5q56sBqHQqzQFfRVtytOor5HR0OrQM
qlXg3SxxIGJ8dX20kmyC29Fv7nX7Q95iolCnSePdNsp8Rm8ug0P+DxwCL1PbMoex
CpQ6WWeVi/Ungzi2RxomP+zYacVOFrVO4p7TlmEslyxruU6v+YC4UMLiQQtw4jyX
LyaFdtw513q/CWkh3ri2mTY51IAXQYQcpjPSMYcHF4Xv+sRvOd4NIlhdiy13Eol4
mjFIfzOKOFr+RGChjmp8LsZ0tZuEcxsFTGfzDtgGWWQhNoN/B1qG/pe7SpqNM8oD
GdIEK+maHul/Omt4TzDM0o4WmNOT1il9jQGUVRavi5XzLgdrZ0BwAgEwrVQcALrt
sO5t9SNmaQeKg/OFahjif8RtjzuXhg9w855LyaPiPLCk5wfhr4b6aoVmZC8xb5ON
a40m4UNcScVumXSeMU/1JA1tnmlgVVKU6XP3aftlTdQxboKmx5o952/bd1pzLmuu
GXWgFQN2GhpXOroU+BS3bAAF2LupW1Gv5eOwBiDFBro3FE15Y8dYNXBTcp1OHwJj
dPcVoLOS5hv9fv6P6JPO
=+ESm
-----END PGP SIGNATURE-----

--=-jGd2nywQ2NIi9WlkBzvB--

