Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47270 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbZFEGw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 02:52:58 -0400
Subject: Re: [PATCH 12/15] mac80211: make minstrel/pid RC use
 ieee80211_is_data(fc)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Felix Fietkau <nbd@openwrt.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@atheros.com>
In-Reply-To: <43e72e890906042334r5cb24fban1ba8cae92b9a3d8c@mail.gmail.com>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
	 <1244180502-4323-13-git-send-email-lrodriguez@atheros.com>
	 <1244183046.22576.92.camel@johannes.local>
	 <43e72e890906042334r5cb24fban1ba8cae92b9a3d8c@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-v81nBszd6V7+Jx4f6ypm"
Date: Fri, 05 Jun 2009 08:52:56 +0200
Message-Id: <1244184776.22576.95.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v81nBszd6V7+Jx4f6ypm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-04 at 23:34 -0700, Luis R. Rodriguez wrote:
> On Thu, Jun 4, 2009 at 11:24 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2009-06-05 at 01:41 -0400, Luis R. Rodriguez wrote:
> >
> >> -     u16 fc;
> >> +     __le16 fc;
> >>
> >>       if (txrc->rts)
> >>               info->control.rates[0].count =3D
> >> @@ -291,8 +291,7 @@ rate_control_pid_get_rate(void *priv, struct ieee8=
0211_sta *sta,
> >>
> >>       /* Send management frames and NO_ACK data using lowest rate. */
> >>       fc =3D le16_to_cpu(hdr->frame_control);
> >> -     if (!sta || !spinfo ||
> >> -         (fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_DATA ||
> >> +     if (!sta || !spinfo || !ieee80211_is_data(fc) ||
> >
> > you might want to run sparse on this entire patchset.
>=20
> I did, PID was not on my kconfig though, so its the only thing I
> didn't test compile.

Ok. Curious I accidentally found the only bug then :)

johannes

--=-v81nBszd6V7+Jx4f6ypm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKMDCAAoJEODzc/N7+QmaKe4QALjnd7aerrkxS5sQi9J7QqHP
UTFEw6UOl1BS8MG982gnk9EAX5EiJDx0/QhRUE+3QR70kR6EjgnNNUhPKaL9+Coq
sWA5Epjdj0zDCOph2KBR60Dqezkd5D02tXjX9FVN1zui3+eSEbKUs7XhYUZEwKa2
o/bvIXBSffn/GHooAlXLCb5yFettGGT6Q7yi+7ow+KMUybQGWD5yPyjGWi8fDJwL
MTofsJl3ytQ1zwCNT6we6HVO+r9Kr3gS1sBOXVKwOFcHYSgH0+EAqkTbQ8GZbwug
bhOTD6auaL1dRo9sHA1FFoke1YIkxPuo1qyfLx8aUxwQIq6e91fl0+RJYqgfDYK4
XMA5amAMM4ERKNaXYvnUC6FQTIfzptU80Q4xHucqVxNOwJyPjJ82XJqf3dHwMYcd
+BC3G5BkHLcQxNTjSlCOBXZYx9sdBpTINMXjUh7gAg2I6RNnlh8bW1by6HRSFvyd
FCRKm/jHs/mdCzW9qt0pGmmnKo0lBJbC75J90xZYcv2oE0JgySqXhhFG5KiP4T6Q
+DMi86xaWUvL8CDd0je119THWkGh6yGrwdd86kF2dsWrbZ0ITpuOtOUnxMZ/UK1r
nJ7L1TCTNap+V8AkpZxblupkMcZ3q9VqUe5xWon5co/5AMCSraFrMF9ROj+6rRKy
g3hPn3rkQVjpfguL3Adv
=AfIS
-----END PGP SIGNATURE-----

--=-v81nBszd6V7+Jx4f6ypm--

