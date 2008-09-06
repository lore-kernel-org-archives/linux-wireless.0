Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYIFXej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 19:34:39 -0400
Subject: Re: [RFC PATCH 1/3] mac80211: restructure disassoc/deauth flows
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809061624n2ec9537n6f280c5ef6641181@mail.gmail.com> (sfid-20080907_012434_987506_58CE68B5)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
	 <1220739930.21016.6.camel@johannes.berg>
	 <1ba2fa240809061532s4f8e08c1xe59f99768ce440c0@mail.gmail.com>
	 <1220740939.21016.19.camel@johannes.berg>
	 <1ba2fa240809061624n2ec9537n6f280c5ef6641181@mail.gmail.com>
	 (sfid-20080907_012434_987506_58CE68B5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LSXIIzcIOBDbgflXjFGS"
Date: Sun, 07 Sep 2008 01:34:31 +0200
Message-Id: <1220744071.21016.25.camel@johannes.berg> (sfid-20080907_013442_579479_458772D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LSXIIzcIOBDbgflXjFGS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-07 at 02:24 +0300, Tomas Winkler wrote:
> On Sun, Sep 7, 2008 at 1:42 AM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > On Sun, 2008-09-07 at 01:32 +0300, Tomas Winkler wrote:
> >> On Sun, Sep 7, 2008 at 1:25 AM, Johannes Berg <johannes@sipsolutions.n=
et> wrote:
> >> >
> >> >>
> >> >> +static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *s=
data,
> >> >> +                                  struct ieee80211_if_sta *ifsta, =
int deauth,
> >> >> +                                  int self_disconnected, u16 reaso=
n)
> >> >
> >> > I think you should use bool for those two (deauth, self)
> >>
> >> I'm thinking rather using some enum values just for readability
> >> foo(DEAUTH, ORIGIN_SELF) vs foo(tree,true)
> >> foo(DISASSOC, ORIGIN_PEER)  vs foo(false, false)
> >
> > That works too, sure, though seems a little overkill, the function is
> > called what, three times? Anyway, whatever you prefer, I just don't lik=
e
> > bare "int" as a bool.
>=20
> Do u think it is sane using IEEE80211_STYPE_DISASSOC and
> IEEE80211_STYPE_DEAUTH for this?

Dunno, were you thinking of unifying ieee80211_send_disassoc and
ieee80211_send_deauth into a single function? That might be worthwhile
anyway, the frames are identical...

johannes

--=-LSXIIzcIOBDbgflXjFGS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwxOEAAoJEKVg1VMiehFYoUYP/1ROHSrAcyXdK6BoNRWH78cI
OkBtsBUwmEXKpACXlFQA54GHQioGETrHE1p4SONulS0qHWYW8Utewjqp184LlLCg
JTxrAOp37N4eRO1MOIqR3C1d/qnWHnphskGHEtsUjTjCXyLFKyDtfQtRKKgHYC8M
mL4eFojX4/RtwLgbg0CYqdvvjGJAHnlJmayYSF+aLiAjkhuMjvZEdYYO3V7jrZOY
7NqV6cp7MXKHnURZhVeIR699WQUBe8gmIDUqWWjEQ7WcQkhFads6a2xnQNh1JCgF
wgVt0BK9Q0euXXE/B+LfGO64IJqUUfM0a2B4qRF04VcEtxNPivKMWNXKdXOqTps5
yUUaSomp9A5h5qO0OBZU8ZM9UidVd3rzD7Xy6xpIvaDrDp8ZZPHELgK8lheuSNMe
oiY8e3T9+TmyA0BeLBfYBSQw66CKBfgXBtaz//dOonnlzjaAq+KUc1aMoPufj38J
7R4d/1o7ANkUYBTxmkMPge16jjNVmbXtuMF1LZh/dTwsYN19rktq2xn599fmdxes
NVuRIcV1Fg1K4xI9CZZADIBEpqIq6BPdhdq6id7A3gJ4zbBDuDfI4/9R7OGJZeo8
5yl9gogdAyoHMLr0uMtA5MtfHIyOIjW4mswDXUXDDP7xtyg/HQMVIIyTEiyqcZPv
xx3LXMEtHCUlGf2Nj/z7
=uY6e
-----END PGP SIGNATURE-----

--=-LSXIIzcIOBDbgflXjFGS--

