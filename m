Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbZBPJzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 04:55:21 -0500
Subject: Re: [PATCH 09/10] cfg80211: move regulatory hints to workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902160148n5a383a96t8e20dc4bc9d10687@mail.gmail.com> (sfid-20090216_104802_517071_54509B27)
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-10-git-send-email-lrodriguez@atheros.com>
	 <1234696212.4219.60.camel@johannes.local>
	 <43e72e890902160148n5a383a96t8e20dc4bc9d10687@mail.gmail.com>
	 (sfid-20090216_104802_517071_54509B27)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ODSqZx85Ccf1QlsIwoh+"
Date: Mon, 16 Feb 2009 10:55:13 +0100
Message-Id: <1234778113.4219.117.camel@johannes.local> (sfid-20090216_105525_497123_4F8480BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ODSqZx85Ccf1QlsIwoh+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-16 at 01:48 -0800, Luis R. Rodriguez wrote:

> > Are you sure the mutex order reg_mutex --> cfg80211_mutex is a good
> > idea? Is there a need for two locks at all?
>=20
> I think so. So reg_mutex would prevent any new requests to be added
> into the queue, that's the only thing that mutex protects. Once you
> are sure you have no one adding requests to the queue you then need to
> ensure no one is processing a regulatory request and hence the
> cfg80211_mutex.
>=20
> We need to protect the queue from additions to the queue from having
> the workqueue process it.

Maybe just use a spinlock for the list, and do the loop manually like in
mac80211/key.c then?

        spin_lock(&todo_lock);
        while (!list_empty(&todo_list)) {
                key =3D list_first_entry(&todo_list, struct ieee80211_key, =
todo);
                list_del_init(&key->todo);
		spin_unlock(&todo_lock);
........
		spin_lock(&todo_lock);
	}
	spin_unlock(&todo_lock);

johannes

--=-ODSqZx85Ccf1QlsIwoh+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmTf+AAoJEKVg1VMiehFY3FYP/jJXgXsUR9shdWJB7zZSQArA
EiH5Ot3uch73OQEQZpR1OFfs5JsoFNaNaZt3wqLe6rGRtmN/2/Sjk0ZMLARr8Jhb
jlAjLBUlQDseNpzeEBxwjOFrtoERggpCTOU53T4KDIWxGbOyjzENT19GiQIWP7WD
URPs8dSfaSLdzbBggFZ5ZncMOw4d/7d1u2pHWKofyLSwaBWAO/yizkbvZhq4XXby
/A0H0lp4T6wYrvpfP4T2y2H+M01iPIXjmPwTI4hVUp8jhalLtt/TrvZNSDazYBMK
/SW6Uda9R94GhSBn7J7JKWLdFUf8snWY91P+VGnTR4eS+S6wVsQ+1A3dTQet4PEh
37MkcrA0Y0POU1LkdYRt0hoGn+LXXeuiCfeMqH9lH4xgMpKnRkQJmF52BiW8LiiV
xLVGOmg4+3vUEc7HzjHoJwJ169mmRDjdVLfEo/Po4Pj/X9TtWLABi9U4xmgzYOCx
/Npd7JALtGSKrRpgujyY2ZD/ZsoJeH5Uoh5dW/cnJizPiz2l4IJo0Ul5oHYKgO9v
HetolwpzhM8RgdTWXliIwfzciDDEx0ZqDO2L8sDRyE29NtkeFSrfmY1xdAzK3H83
UtTq3FudWJCnF2NwhfNZvSDTJxcYT4XydeMkiV6dafRXkpn8ExqcUfJavopFG76z
ZKkIbnJzNWyzLYYFwxCw
=zsTn
-----END PGP SIGNATURE-----

--=-ODSqZx85Ccf1QlsIwoh+--

