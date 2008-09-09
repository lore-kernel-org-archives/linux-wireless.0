Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbYIILB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 07:01:56 -0400
Subject: Re: HT action frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Ron Rindjunsky <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240809090353o1ab1340ck82a9208dd364587a@mail.gmail.com> (sfid-20080909_125320_013382_134F778C)
References: <1220883730.31304.60.camel@johannes.berg>
	 <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com>
	 <1220950358.31304.112.camel@johannes.berg>
	 <1ba2fa240809090241g2604e3ddhfd39359fd8eb0f8b@mail.gmail.com>
	 <1220953379.31304.124.camel@johannes.berg>
	 <1ba2fa240809090252u44c5a016m98845379ac213df9@mail.gmail.com>
	 <1220954146.31304.127.camel@johannes.berg>
	 <1ba2fa240809090321w4d2f3780g32e9507fac45f95e@mail.gmail.com>
	 <1220955934.31304.133.camel@johannes.berg>
	 <1220956032.31304.135.camel@johannes.berg>
	 <1ba2fa240809090353o1ab1340ck82a9208dd364587a@mail.gmail.com>
	 (sfid-20080909_125320_013382_134F778C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1Trryl4ZFhhteTmzJvDq"
Date: Tue, 09 Sep 2008 13:01:49 +0200
Message-Id: <1220958109.31304.153.camel@johannes.berg> (sfid-20080909_130159_755464_34E4D68B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1Trryl4ZFhhteTmzJvDq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-09 at 13:53 +0300, Tomas Winkler wrote:

> In basic AP mode everything can be handled by hostapd. There are no
> performance sensitive management task, therefore the original mac80211
> flow  didn't rout management frames withing mac80211 mlme.  But I see
> benefit of keeping for example BA handshake, BAR, and MS/MIMO PS (not
> implemented yet)  inside mac. BA session requires knowledge of
> sequence counters, BAR handles reordering buffer. MS-PS requires
> knowledge of number or rx chains. It will expose too much guts to the
> users space.

I think it boils down to the policy. Should hostapd have influence on
accepting a BA session or not? The cost of making it have influence
would be high in terms of code because it needs new API for all kinds of
things, take for example all the sta_rx_agg_session_timer_expired code
etc which we'd have to reimplement in hostapd and have new API for it.

I cannot think of a good reason why we should have hostapd involved, so
I'm wary of adding all the code everywhere when making it work as-is
would just require a bit of code-shuffling.

> > In fact, what if we're in STA mode with userspace MLME? Do we want to
> > handle all that in userspace then? This doesn't seem sensible to me.
>=20
> Also in this case I would leave this particular features + 11h
> (channel switch, TPC) inside mac80211.

Right, TPC and channel switch is STA-mode-only anyway though.

johannes

--=-1Trryl4ZFhhteTmzJvDq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxleaAAoJEKVg1VMiehFYOUsQAIbV+qqOFb2pv8x6w9ssIX2F
vtke8987flPQGqea4cMAuzGvKF3N48k/SQC3KSQRvvdRVYCVTNBV9QdnWLc90f5c
CNhvQ+58szu9lJ4Y7VWyo99l6jVxDIPIy2tDKidXCyXmE1F/ndiwd1gzVaK6ZcpU
enmLexErSAc/gbD9RWWmZZRKqjUvkOYN9JoBBFfcwTON+itKSkjO1a2nl4bUgKeP
Xbfg8q4VugzmRzxtab1uL5QgKZ5mGIZcFUSMxiMgZDfu6jLFR3x9gla74IhF+Ayo
OPnVHC+YTSxDS342fV9zFyHQ0rsoenVWjEbezm0QusCzmJARI92SQV107m4rBYWc
SOugnz4csj8faIKv2BngWzOCWod4gNsMeL9Be5JlIV3jrypDXEGUy7lySh69BE1e
nCY86N5vyilzTEJfcN4Yw9q9YLbFeftutviLsWDP6b4B/g240rL6Y8PE+mSTSdHd
dC05S1m57h0s+Ffnxpmb44eJ8TSMZW7avwA880vdHbaWK9TBpiXGIO/ah1yVqmNo
1CRXE9pSamSSWI3+wLaLO1VrbJ+jKj7gXCWJ2eMDEVTjQ8/tp+0GaLPKkUVm+Wjj
GygKbq+2MYgeuKNx5I4rXU036Bbhrm3cpssBrWW5f3Lfe2dUkwGVAZ2rlkiocnpq
BpcR/BuoU57soFiDDNhI
=BNzz
-----END PGP SIGNATURE-----

--=-1Trryl4ZFhhteTmzJvDq--

