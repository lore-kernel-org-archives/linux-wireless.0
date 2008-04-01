Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbYDAM2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:28:24 -0400
Subject: Re: mac80211: holding sta_info for non associated stations
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <c85cb4470803310746h36b20d0egce98f8cea3becb0b@mail.gmail.com> (sfid-20080331_154705_823745_A1E01497)
References: <c85cb4470803310746h36b20d0egce98f8cea3becb0b@mail.gmail.com>
	 (sfid-20080331_154705_823745_A1E01497)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gnbMGK/uHQmh8cX3rawt"
Date: Tue, 01 Apr 2008 14:28:16 +0200
Message-Id: <1207052896.5143.76.camel@johannes.berg> (sfid-20080401_132827_754827_34641ADE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gnbMGK/uHQmh8cX3rawt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> If i associate to a random AP "x" (what happened automatically as i
> was configured by ifup scripts to do that), and then scan and
> associate to my desired AP "y", i notice that AP "x" was not removed
> from the mac80211 station table. Then, what happened was that during
> ieee80211_stop, when we reach
>=20
> list_for_each_entry_rcu(sta, &local->sta_list, list) {
>     if (sta->sdata =3D=3D sdata)
>     ieee80211_sta_tear_down_BA_sessions(dev, sta->addr);
> }
>=20
> we try to tear down sessions to irrelevant stations (AP "x" in my
> example), which leads to bugs.

Why would that lead to bugs? That station was known, and there are no
sessions for that AP.

> did i miss something, or is there really a problem in the state
> machine in the described scenario?

There might be a problem in that we forget to remove that AP under some
circumstances but it shouldn't matter, we always can have multiple
stations in our table.

johannes

--=-gnbMGK/uHQmh8cX3rawt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/IqX6Vg1VMiehFYAQJrXA/9FzhjLpSGGEq4mBfCWd+z8545/X8ZZZjB
d/7PNm/RhcsmT95h0yA2avKM0IcMj0agABqJeQ0tecw9QyC13U06jeH6FH//P9KJ
n20dUn6HzkkvvdtpSaPBtLjlgg9mUQch041k5b2Z3vf39nJ1TXI9JP+UgMXaq6OZ
VP/sbuLgBZfbKsVuZYFj/+TjZcAIvqXglyfhfIMR7y2pt23pUb6XDDzE8snLT73o
zMp+ULj90BcUZ3oRFhltud+w6mZYdx62UIE9HgYyYMtfaW1LA7mRumMVbboSvGx7
z5l44cpWfNxvqYF04qW0GZxLimJCje8uctvwiEe7v9i3YDjLgGT1YS/AQfYd1ZCD
jdnvQDkLjKalgu5KoaxRSgPfpJgH38vVTM8sdaLhnJQzGyftmz7cw8kJbKA/1LZT
Cpyrp4asHuPKlRmhPUFXCsxhRD7SyZmVbKQLmv3+SPfBTZneoxEATDMfyvrclhWj
vy37LZ2uZzBHltRO0XvP7upM5B8cqFSip0zV/q6DKhA7EPGs1pI8wpswvtyaliQl
AmFmmv6etqfNXaXWGxOmaKu2mMbd9cRAWKsq/JXxemX5Vh8MI6TNP2fb49HV0W4V
kWXw4T/u6/BJZPhh7BTn8LOAeA7DfabZPzzauAV0uQxTd5Hnuvm/BHrIZhJkeqJc
1j+AUKibFAM=
=8Xi0
-----END PGP SIGNATURE-----

--=-gnbMGK/uHQmh8cX3rawt--

