Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbYGOIhv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 04:37:51 -0400
Subject: Re: [PATCH 1/1] mac80211: add direct probe before association
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807150131w4a08ae6dhae7bab8ab6adbde7@mail.gmail.com> (sfid-20080715_103129_337219_1CFDD59C)
References: <1216076865-9826-1-git-send-email-tomas.winkler@intel.com>
	 <1216109902.23746.27.camel@johannes.berg>
	 <1ba2fa240807150131w4a08ae6dhae7bab8ab6adbde7@mail.gmail.com>
	 (sfid-20080715_103129_337219_1CFDD59C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-g1ajA+KvUGLGe+EktfZC"
Date: Tue, 15 Jul 2008 10:37:45 +0200
Message-Id: <1216111065.3535.3.camel@johannes.berg> (sfid-20080715_103754_654883_0334BCCA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-g1ajA+KvUGLGe+EktfZC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-15 at 11:31 +0300, Tomas Winkler wrote:
> On Tue, Jul 15, 2008 at 11:18 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> +     ifsta->direct_probe_tries++;
> >> +     if (ifsta->direct_probe_tries > IEEE80211_AUTH_MAX_TRIES) {
> >> +             printk(KERN_DEBUG "%s: direct probe to AP %s timed out\n=
",
> >> +                    dev->name, print_mac(mac, ifsta->bssid));
> >> +             ifsta->state =3D IEEE80211_DISABLED;
> >> +             return;
> >> +     }
> >> +
> >> +     printk(KERN_DEBUG "%s: direct probe to AP %s try %d\n",
> >> +                     dev->name, print_mac(mac, ifsta->bssid),
> >> +                     ifsta->direct_probe_tries);
> >
> > I just removed all the log flooding. Don't add it back please.
>=20
> Right, will resubmit.

Actually, it looks like I kept those for association because I decided
that we weren't printing them too much. It might be much nicer to send
them all as wireless events though, thoughts?

johannes

--=-g1ajA+KvUGLGe+EktfZC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIfGHWAAoJEKVg1VMiehFYMpMP/iviuplV59C1IFkRrdvBQSao
+WHfJ9Zxw8xNVwwoP+a8nLw2OpWdMYXVfMjIGJgsmBAjCZ9TBDS262fINJbzp2Xv
5HswV6c69z7PixXx+pWI70SaHjB/xSco3PE0cYV3eEpKyDwu9p+OMN58E0zloa3o
xvB6Kz1H8OzapOI3c5W2QUqexDyYoLyMp87fnlca46Kv7wnnv0xODO9lBlj2nTDb
AJmeRMnJ7uDWhg4XCAZx2dxU+XGUoqNu6j9lE9HyOdd8eZgHBs76Y/bMgxZhlJ6O
yCNkq0j1oU8xD+VQjqsR6i9PEG/sznQjUHexkgRqv10ULCpdj+mL15dQCGJlNi3X
WLdxO/vWmGTFfa/bTzYrYPF6WFVqzyvzUEiwXOxD+DBXkA5Jmofb5GJFrB9W61u9
IeVX32hLeM0K6cq950RIhBpyAczyo/Nf/28dAFzodWkvIFdY1xR5+ug3Ty21cZs8
sMvAaXP1WvsAIm7SLAvErwNM8QCOEIbeqzeEVBXgR2r4QWX98PDeUnGUqznM0LEM
zLgmePK3SYbSGr+LKovdT/Kkhzi3yQGVeqU63Su7vmHz253HxXNaKWOfOhxbmP4i
YIl86miCHilN1Z5MWfEkqpyE0G/lV1TdPzmHayHFHhJyXO/ZjOYTLlmGbViLT8LY
/K/EGaM+/HbD2S28in7x
=K2r5
-----END PGP SIGNATURE-----

--=-g1ajA+KvUGLGe+EktfZC--

