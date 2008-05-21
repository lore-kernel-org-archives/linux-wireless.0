Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbYEUPJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 11:09:17 -0400
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <hschaa@suse.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Bruno Randolf <bruno@thinktube.com>
In-Reply-To: <1ba2fa240805210750x5112a8c3lea2f493f59a50b79@mail.gmail.com> (sfid-20080521_165053_580040_04763B33)
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de>
	 <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>
	 <1ba2fa240805210347w375b571djc922f814fa9f521f@mail.gmail.com>
	 <20080521135451.GA3545@tuxdriver.com>
	 <1ba2fa240805210750x5112a8c3lea2f493f59a50b79@mail.gmail.com>
	 (sfid-20080521_165053_580040_04763B33)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-n+ADgkQF6q48M+Zov3wa"
Date: Wed, 21 May 2008 17:08:09 +0200
Message-Id: <1211382489.13667.11.camel@johannes.berg> (sfid-20080521_170920_712934_E942A2F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-n+ADgkQF6q48M+Zov3wa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> static void ieee80211_rx_bss_put(struct net_device *dev,
>                                  struct ieee80211_sta_bss *bss)
> {
>         struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
>=20
>         local_bh_disable();
>         if (!atomic_dec_and_lock(&bss->users, &local->sta_bss_lock)) {
>                 local_bh_enable();
>                 return;
>         }
>=20
> ---- don't we miss  local_bh_enable(); here or spin_unlock_bh takes
> care of this ---
>=20
>=20
>         __ieee80211_rx_bss_hash_del(dev, bss);
>         list_del(&bss->list);
>         spin_unlock_bh(&local->sta_bss_lock);

spin_unlock_bh takes care of it. The local_bh_disable() +
atomic_dec_and_lock() is like spin_lock_bh() + atomic_dec() just with
different atomicity guarantees.

johannes

--=-n+ADgkQF6q48M+Zov3wa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDQ62KVg1VMiehFYAQIzKQ//SH7DhUCLkIqpMv2ugAQkiX+h1OxgKswd
ig27gNxqO01mZyT07bW2cfWi9vbXrsBEFmoyEXnH2Yu3rA3IU17MFVlqUyl0wRun
7itW9eMN9pq097rvPN0A78nk8q2t3VpdZ2zEOf9L2/2sb7ZIQDBu8zWhEPKJRftp
MVQQ2PiI0SsW1e9DD0uLEDVQoOKolW9RRtM1P2LHN+t609Jt/YTuVBCr9eF0CwhB
h3EBCMP50J+fDAkJrbTt+hBcVOvelA6PzjDpzDlGsnWbm/LOMu6+TdfCjFcadArS
HYt2XwVEey2mTJmZWvdkMGKzlgOF7trKywl7ufwKqwWGCw6SnhX2FycFUVdx0gsA
mLGxpbWzpJWaCKJR7/T+h9a8mx2e9A5zBeYCyiavIGZ39u/BeBhZPsHJHK1RVskl
feqEGh98vbMeTG2ZyCG3de7iRvpJhdGgmUUquGtIw5WeU/IGrugcXgMa747tpBmb
OMB97AdxDxWwUao9tBSn/gZEHxB+VjZro7Ye+okfdfxJldMsUwuQgQgHN99PPUrA
azfC2gs80ezPTGWnQa+ADT+32Q1OkOirmeC1OzVKWdXZEVFBh1Q7Ub2JQQDoRbWm
XMKNqg2jJCPfAp64fO52FnQXGsRVfGgBndWXXsDR6ieE+1BG31wGE5uS+aH4ckXE
4FsKrK867Pg=
=xviv
-----END PGP SIGNATURE-----

--=-n+ADgkQF6q48M+Zov3wa--

