Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbZCXHiP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 03:38:15 -0400
Subject: Re: [BUG] rtl8187, cfg80211 - unable to handle kernel NULL pointer
 dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Martin Capitanio <martin@capitanio.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, herton@mandriva.com.br,
	linux-wireless@vger.kernel.org
In-Reply-To: <49C862D2.7050501@lwfinger.net>
References: <1237849455.16745.41.camel@marvin>
	 <43e72e890903231610k54ba0f15hf1e3146290c7d67a@mail.gmail.com>
	 <1237859527.5714.60.camel@marvin>  <49C862D2.7050501@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-djR8T/Gknxp1eJGTPDYA"
Date: Tue, 24 Mar 2009 08:38:01 +0100
Message-Id: <1237880281.6147.22.camel@johannes.local> (sfid-20090324_083819_927710_A0C2659F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-djR8T/Gknxp1eJGTPDYA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-23 at 23:34 -0500, Larry Finger wrote:

> commit 59fe3ee33bdb7e8dd0584271382fb94880f68002
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Sat Mar 21 17:08:43 2009 +0100
>=20
>     mac80211: remove mixed-cell and userspace MLME code
>=20
>     Neither can currently be set from userspace, so there's no
>     regression potential, and neither will be supported from
>     userspace since the new userspace APIs allow the SME, which
>     is in userspace, to control all we need.
>=20
>     Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>

Ouch. I suck. And the problem is blindingly obvious:


+       if (sdata->vif.type !=3D NL80211_IFTYPE_ADHOC)
+               return ieee80211_ibss_rx_mgmt(sdata, rx->skb, rx->status);

needs to be =3D=3D of course!

johannes

--=-djR8T/Gknxp1eJGTPDYA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyI3QAAoJEKVg1VMiehFYDXAQALT01C38ShUCgOlHndNWnmzH
Lq/agrvufVW21/vDJ2TrdJuRR81gKLit1WpDJ1d8ak3wiztr/Kt9iVGW1IRQdnut
I5cHd53yeoOOpC0ZhPhCF4vnRPRkjNKC0SHrZ0NJstLqztrKstDkCv5wt+Oo2HNM
5e127hYC4LVwRvNkL9X+R2zBHK5NdbvfsgRAkk5MLf7sqtdkfxtUa+Mc1MNaBpUw
LTTw9+odF7o38ZUAF6Eo06fKAWwybgER+hV+ht55JC06qjCxKDHoXyxvl/qkwQ0N
Afd2YdhUJoaJVuPFt11cSOmrKoZn2KvAl+g4zPxEqqkpPNdQ2KmZJd9skwLjWJEX
CU5g1oOoli8BmoNtlmgHyIBV8U1YqFVu8qUJhNx5X8ntss7HnfNg9tVtyQheJuEm
KBksS1yg6ItHA3QH4h/16GPSjnTuExXabUAv00T0w2eONmH2wkmKQJM2jeNbItrq
zhxl/kCtYYeFavC9pHRblefSZmFzIwyEzKwRAdjmHWVYXa/ozFt2xCpsN96h1N3n
OkwiPpq5QIza1IjSD6GPWmebK0J4OBt+dc+qGO2eHYRMH9qpwP8Rb7g7R3cMSTyH
MJDKh1L2W0Hnx8fGWO1YQKWDgIv9dX7DercUccH2enw6hE7YaapfecfRHpBJPjr1
vgIyAACDku/OOWtAlLIy
=DYck
-----END PGP SIGNATURE-----

--=-djR8T/Gknxp1eJGTPDYA--

