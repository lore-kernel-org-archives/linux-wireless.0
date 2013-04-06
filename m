Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:16148 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754235Ab3DFHee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Apr 2013 03:34:34 -0400
Date: Sat, 6 Apr 2013 09:33:09 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] cfg80211: add get_max_tp() API
Message-ID: <20130406073309.GB14463@open-mesh.com> (sfid-20130406_093438_591483_B6CB33E1)
References: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
 <CAGXE3d98a4pBG=gWKUm9A2RJRN+eic4Zi8dh4grTuqQmW3GOsg@mail.gmail.com>
 <20130405083956.GA14463@open-mesh.com>
 <1365168001.8515.28.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
In-Reply-To: <1365168001.8515.28.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, Apr 05, 2013 at 06:20:01AM -0700, Johannes Berg wrote:
> On Fri, 2013-04-05 at 10:39 +0200, Antonio Quartulli wrote:
>=20
> > In the batman-adv module (which implements a routing protocol for mesh =
networks
> > on layer 2) we are trying to switch metric from packet loss to throughp=
ut and
> > the idea is to read the estimation from the rate control component (tha=
nks to
> > the API mechanism in cfg/mac80211 this can be eventually changed later).
>=20
> While this makes some sense, going into the details of your patchset I
> find that it's overly complex.
>=20
> I think you should fix minstrel to report the best rate in
> txrc.reported_rate. This would also have the effect of not showing
> sampling attempts to userspace in the "current TX rate", which generally
> makes a lot of sense.

But the reported_rate field would just contain the index of the selected ra=
te,
not the throughput. As far as I can tell the latter is an RC private inform=
ation
(it not exported anywhere outside of the RC algorithm) and that is why I ma=
de
this API which would directly talk to minstrel and get this value.

>=20
> After doing that, reading the rate becomes a get_station_info() call or
> so.
>=20

true, but still we have the problem above..unless I alter the ieee8011_tx_r=
ate
and rate_info struct..but I don't know if this would make much sense.

> One more detail:
>=20
> int cfg80211_get_max_tp(struct wireless_dev *wdev, u8 *peer, u32 *tp)
>=20
> I really don't think that the wireless_dev should be necessary for this,
> it ought to be just a netdev IMHO.

well, yes, I can pass the struct net_dev only, even if I need the wdev to o=
btain
the cf80211_register_dev object for the ops.

> Also, the peer should be const :)

Right


Thanks.
Cheer,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRX8+1AAoJEADl0hg6qKeOSYQQAIg/vZPNmAo6xkr8tnhSqtuL
B3QH6DnG+m7DpFqgOMwwKP4ErckggM3+ZO1bEJoBy90sERTkOKO2KT12v/esNGeX
mFAP4WuA0iASJVIeC6s6kCQR/mi+ChSRnZs26uiD9hW3smshzNSQoewg7iA5R6zj
WYQpPyhiZSH22SljcEBOGIzO2jBHd7F2dEoEfaSdru1LF0PGGT3utOSjdkWLGfQs
C+ax6QqT79SnF90WKIJRrUNmJzg0aYAp07w3abvLQqFwVnczU/3JzAqNGdf9Yr8q
xkQcD8EO+IFRvdDXYkUlbmgRXK32crOoT9raLFBV7+YiWByFPr6spE2WWhDJVzcf
/TZnPdqOh3cSv63EUPJvrvRYLq/N8FgkqmWAWhR60XDHFo+MqMS+5ZjmMcerxmnM
DBws/7dT+r/MifmQzcp4YroZJPMPlSgcp8H4Jq+svcl9JL7KYa9BQN1lDae4p3zH
Yk6So/S3lCIm98tB5dj31j9tcn5TFtY/W2k8PaI3pE9/VR8tKlH1mxqaanS43gtT
5YVtoxQro8VsHsXkwUv5PzcBNka0RQdJLE137JEI/Yoc64E65KYEUa2HqJquXCly
AKMHQbhC69lNQEaLvV9iak/GkKRUfmmw/lFNTpUokwIrbsE7+uQ/dOyosKGUBmTj
rfrcmAYoFTg6g25pXcuk
=JLHq
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
