Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38517 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYJUHYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 03:24:13 -0400
Subject: Re: [PATCH v2] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@Atheros.com, Jouni.Malinen@Atheros.com,
	tomasw@gmail.com
In-Reply-To: <18685.33109.976911.752462@gargle.gargle.HOWL>
References: <18685.33109.976911.752462@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F/UslIk8LJ01PMYKdxqD"
Date: Tue, 21 Oct 2008 09:24:06 +0200
Message-Id: <1224573846.27899.91.camel@johannes.berg> (sfid-20081021_092418_762763_B563548A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F/UslIk8LJ01PMYKdxqD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 12:44 +0530, Sujith wrote:
> Wireless HW without any dedicated queues for aggregation
> do not need the ampdu_queues mechanism present right now
> in mac80211. Since mac80211 is still incomplete wrt TX MQ
> changes, do not allow aggregation sessions for drivers that
> set ampdu_queues.
>=20
> This is only an interim hack until Intel fixes the requeue issue.

Looks ok to me, but I'd feel safer if you introduced a HW capability
flag that said "I can handle aggregation", and check it in
ieee80211_start_tx_ba_session. Right now, that will refuse to work when
the driver announces no ampdu queues, but you're changing that, so it
would do something even if the driver isn't prepared to handle that. Not
that it would ever be called, but it seems safer to actually encode that
capability somehow rather than relying on the RC algorithm not doing it.

> Remove is_part_ampdu from struct sk_buff, and set
> IEEE80211_TX_CTL_AMPDU
> in __ieee80211_tx_prepare() - which I think is a better place than
> ieee80211_tx_h_sequence().

agreed.

johannes

--=-F/UslIk8LJ01PMYKdxqD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/YOSAAoJEKVg1VMiehFYXzsQAK4ESxiZ7zaFT2ZHUdyrxlVF
tdN5PWNQVvsHQk4NV2q6Pj4y6BuWxpReCWpb9gWpCVlDVsTvSW9UA7jni50Sixqq
05OjZ7FFxMkObGv0UNy37BclUqWTqM3GuBFyqMe1eEpcpY1bIzqeB9i4wIHqpKo6
p4y/7Cyh+bGEPjBqvmiR8KmvGiPPlqzohgMaNLb3G4omuUS9aNpf9+eTp49nkaDV
mVflk7718Bivt4/LQJnwea2sUUuaGfrs8OjPbUG3XLWtepOyxtO0etqLEWSA4265
/IIpZdiqSU9XSTCEJDqpX6poFzF58LMvwaleTprRIcjlm12oe/JrRi9KQh+iqatL
l2GAXdxU6TnheNoz3OT6DkLGnN6oLhVA47Go0pvQnmtC4F9bZ+cICueyZUj4mVwX
3qM/jsCZ6DnfwrE299FgFdAuqEqjjFp7SCttFhDmK/S5BMGv2bK4eE48uhwCtdJ0
34KYKa95pgcSLU5whxI3hXz22IcwAkf+Nm2P+3hjJIgASl82YhymLAtiVVhcGXYw
Q9pxmJdAxaFV4MkY6bOpAXtCDnEl9FVVfC1n5t1y8LVOK57NfoylgWs0ipgRa/iH
tCPJV9YAwFucHonxNUysaNtcaaFRIoAiVbPBFbKdulQfJOodZYwVqZMZS5KwvwJo
s592LIVfAtr7LjZbOItk
=CPjE
-----END PGP SIGNATURE-----

--=-F/UslIk8LJ01PMYKdxqD--

