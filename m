Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35299 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbZDCJYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 05:24:03 -0400
Subject: Re: [PATCH 4/5] cfg80211: check allowed channel type upon
 userspace requests
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1238711166-2208-5-git-send-email-lrodriguez@atheros.com>
References: <1238711166-2208-1-git-send-email-lrodriguez@atheros.com>
	 <1238711166-2208-5-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QFGJdNLX+zcJ3PaoLnwY"
Date: Fri, 03 Apr 2009 11:23:27 +0200
Message-Id: <1238750607.27712.14.camel@johannes.local> (sfid-20090403_112406_038181_B96DE74B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QFGJdNLX+zcJ3PaoLnwY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 18:26 -0400, Luis R. Rodriguez wrote:

> @@ -457,6 +457,24 @@ static int nl80211_set_wiphy(struct sk_buff *skb, st=
ruct genl_info *info)
>  		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED)
>  			goto bad_res;
> =20
> +		if (channel_type =3D=3D NL80211_CHAN_HT40MINUS ||
> +		    channel_type =3D=3D NL80211_CHAN_HT40PLUS)
> +			if (chan->flags & IEEE80211_CHAN_NO_HT40)
> +				goto bad_res;
> +
> +		if (channel_type =3D=3D NL80211_CHAN_HT40MINUS &&
> +		    (chan->flags & IEEE80211_CHAN_NO_HT40MINUS))
> +			goto bad_res;
> +		else if (channel_type =3D=3D NL80211_CHAN_HT40PLUS &&
> +			 (chan->flags & IEEE80211_CHAN_NO_HT40PLUS))
> +			goto bad_res;
> +
> +		/*
> +		 * At this point we know if that if HT40 was requested
> +		 * we are allowed to use it and the extension channel
> +		 * exists.
> +		 */
> +
>  		if (channel_type =3D=3D NL80211_CHAN_HT40MINUS)
>  			sec_freq =3D freq - 20;
>  		else if (channel_type =3D=3D NL80211_CHAN_HT40PLUS)

And here you should remove the code below this where we still see the
first three lines.

johannes

--=-QFGJdNLX+zcJ3PaoLnwY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1dWNAAoJEKVg1VMiehFYMscP+wXwUatyDRo6bd8vd8yXGOCw
gOwYGcOE8MCCsaeUnt19xxrtCCEbK24uHzusFC0BKL7QVsVsXCFaV4uclmMUvruA
lze08zDQxTd8NVT+JYr6nAn4SthATZce9MZ8liAAtUkimSfXMSjBTLt0hmjNj7wg
2bLl+DpH1Xwmil2UQj5spfglo8HH08/jUk1Xyf4XTqr1fyPb2NJzqncI1p5x3LDG
fY8wPGElYHt5jEwXuJA6V34iT9fHXRyyb93mxYG59WcEdvKQOw587vOrNW+htHNA
Ej3jIfbnwLZ7RF5/q1J+tWsMs6zuB4EDGVcATPnM8ynTmjxzMG1YcYZlW7JsDuyZ
s6hJPAvITWJgdPVxxN4vWrgVdVxYh13NLkCfK0/zk/cPRkKg+Dol8u4Wj0/4oSVX
6uZqC81ubMGnid4IqJIVOt1WC6plVZWDClJjpdFU/HyfJcge2SKuWjGzlZXk6o2w
mKBOaR7EVyqmSysnwzxNpgj+2RRREMLUPXHwbKRBejVfe6YksSLds9LY7VSlldYF
gZQuQqqy3kTDtqOKI2gu9GFup46NKGpa8rwab2c3Y0VFi5devDitGbtQU8J5DaY7
tg8snL4RJl2mUH0NFpIwV9BEm6c+KHtv1o0F50SK8WWe1FGzbG1YfOnbUq1s9OFN
O0yo0rwS1/M4ijLktj3X
=RZQr
-----END PGP SIGNATURE-----

--=-QFGJdNLX+zcJ3PaoLnwY--

