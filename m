Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60156 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYK1WSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 17:18:17 -0500
Subject: Re: [RFC v3 4/4] mac80211: move dynamic_ps_timeout to hw.conf
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227901784-5325-5-git-send-email-kalle.valo@nokia.com> (sfid-20081128_205007_938345_E176B04D)
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	 <1227901784-5325-5-git-send-email-kalle.valo@nokia.com>
	 (sfid-20081128_205007_938345_E176B04D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mNtdaaaPFcuY72jEJ4zq"
Date: Fri, 28 Nov 2008 23:18:13 +0100
Message-Id: <1227910693.3543.7.camel@johannes.berg> (sfid-20081128_231820_095097_A2D0A7DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mNtdaaaPFcuY72jEJ4zq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-28 at 21:49 +0200, Kalle Valo wrote:
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
> ---
>  include/net/mac80211.h     |    1 +
>  net/mac80211/ieee80211_i.h |    1 -
>  net/mac80211/mlme.c        |    4 ++--
>  net/mac80211/tx.c          |    4 ++--
>  net/mac80211/wext.c        |    8 ++++----
>  5 files changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 53a0dc5..aae8991 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -560,6 +560,7 @@ struct ieee80211_conf {
> =20
>  	u16 listen_interval;
>  	bool radio_enabled;
> +	int dynamic_ps_timeout;

Same here, add documentation please; also, I think you need to call the
hw_config call when this changes so drivers can upload the new value to
the firmware or whatever? Which drivers actually will end up using it
and how?

johannes

--=-mNtdaaaPFcuY72jEJ4zq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJMG4iAAoJEKVg1VMiehFYnZIP/3pyMRrplpEybcT7np8OwMcz
hBQouzpp0BolMqRuslOsjKssF2FiQq90n9JPY06fb3rDGVl9oZg2gK2wVNkjCQdG
UZZdt2tfumFhqbKZsoqG8J/pmIEnBGqAxAW76MfAU7K8dN/JXEmnErWsemWxbLOb
dDSHH9aGJdEMVck2DudJOWM5LIFHZs82yikD9aMWhg7xLFkaTI7bDqQtVBoBnF3Y
JAuQcN7US/586uZbC8ir7uowV12s6bK1NxP2CBudI/vROEranIIEwB/lrXXJ7wYb
Kfj28Dbo7NvNOsF4t7ze4MNDjq5X4EkA8uXSmir79AB//D9Mj86X9Y3fZm3ZdkGe
iDMUOYEYZWL8sfOYcEqftg6pXRR+slP7XEZA6R3bpcyxqewwF3Lfjk+l2fyBUWE+
B0hMXQgMgVXVQ1gWBZpgM47IgLwDFlo9LcsvpH+YI/BVFpAyX//F8ZRgqaJe1x3K
+LhyIxE6MQjqmAw41W3J+ymgI3JwFo3AOCxuDewjcQO5UywWDxeEDGOZlpXuCeJ4
6fHfhn44TNAj31kHKXdpfhQETskFIx5Isv2ue0EmSCfrkDhlGltV4qRWOT3vlJ93
dEnx0vfcUPJ6bZtGGnQZLfB5cRM2TdKLyjK+NM53fsJRu7dRO4o2m3stuALx+Iok
2rlOmu1SiqazqXALRKd6
=Sm41
-----END PGP SIGNATURE-----

--=-mNtdaaaPFcuY72jEJ4zq--

