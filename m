Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34278 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYDBJJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 05:09:27 -0400
Subject: Re: mac80211: holding sta_info for non associated stations
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240804011419l1b825c7cnd02790257af9112c@mail.gmail.com> (sfid-20080401_221920_584454_405C87BE)
References: <c85cb4470803310746h36b20d0egce98f8cea3becb0b@mail.gmail.com>
	 <1207052896.5143.76.camel@johannes.berg>
	 <1ba2fa240804011419l1b825c7cnd02790257af9112c@mail.gmail.com>
	 (sfid-20080401_221920_584454_405C87BE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IKly1l/ePL1UGeYRFKO/"
Date: Wed, 02 Apr 2008 11:08:51 +0200
Message-Id: <1207127331.10910.2.camel@johannes.berg> (sfid-20080402_100933_031966_82FB0EE4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IKly1l/ePL1UGeYRFKO/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  > If i associate to a random AP "x" (what happened automatically as i
> >  > was configured by ifup scripts to do that), and then scan and
> >  > associate to my desired AP "y", i notice that AP "x" was not removed
> >  > from the mac80211 station table. Then, what happened was that during
> >  > ieee80211_stop, when we reach
> >  >
> >  > list_for_each_entry_rcu(sta, &local->sta_list, list) {
> >  >     if (sta->sdata =3D=3D sdata)
> >  >     ieee80211_sta_tear_down_BA_sessions(dev, sta->addr);
> >  > }
> >  >
> >  > we try to tear down sessions to irrelevant stations (AP "x" in my
> >  > example), which leads to bugs.
> >
> >  Why would that lead to bugs? That station was known, and there are no
> >  sessions for that AP.
>=20
> It's like freeing twice the same a pointer. On what level will you
> check that there are no BA session with this ghost  AP?

I don't see the problem. BA sessions are per-STA-info, so what's the
problem with having a STA-info linger around a bit longer maybe?

> >  There might be a problem in that we forget to remove that AP under som=
e
> >  circumstances but it shouldn't matter, we always can have multiple
> >  stations in our table.
>=20
> Not in STA mode, should be associated only to one AP at a time. (Hope
> this also cover roaming).

True, but BA sessions ought to also work in AP mode and I don't see
where the code differs.

Maybe I misunderstood the problem?

johannes

--=-IKly1l/ePL1UGeYRFKO/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/NNIqVg1VMiehFYAQL2dRAAgzJGTPS0pMj9FShBlplzKAczlvX5mTh+
/Edfkfy0/JxaVfxq3us/7AkjrUqdnRG6NYbQwN7JbM/27ut7W89kN45gLvhlL/4L
HR7Xt8miUF756eBNBy9L2ZBhr0KTJY2BfjxVl/oeJT+dnnme/wu64B+WdLmuI5an
dQl9XdAbD9pUVe8oJ+ZTYfZ63W66Zz+7TwVP6kKOt+x3NDp/ommv5F4J6AVBiRwY
SpsOkPk/+AUbziNqOzp0Mr9Q3AgzH8bXEL5MYw4y/ukRvMEMjRvTPCS+WAhfR8i5
ZlxLemqVDLFfHDt0kMkdM+JaO5Jks9B+cNA5G2oB2tXiQukZpVQD1dz31U2TdbBt
alj7fypWqqs+YJTegzwPi/zJbyuqxSogGyETon6bBtKJ+VOb6HrseFnrVI8LlUp3
f9YjqQ+fJS+KxQFL6h3LKncLg+onP4OPRBk6maTa4aJmUGhnYQdZqTBFAKmSDFTi
O3wUlKg0AM/eiIiBif2nz9aADfMONvjgkO/fuBzaLS0FrMeiYTW/QH6aHiIGx7gs
XrLEHFyqz0zGljiz62GaHy460kej1XTTVeZnOvNmowGO9xXHdhWjXOm/Hj1CbgIL
9EdJR+rQSiAuk0/o5HxuSX2EybGdT0hAcfuZs5Jaal2GB4hY05w6UNMcm6UNsTmg
Vror+1EtkdY=
=qMXf
-----END PGP SIGNATURE-----

--=-IKly1l/ePL1UGeYRFKO/--

