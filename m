Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZAFSQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 13:16:08 -0500
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <20090106174830.M95524@bobcopeland.com> (sfid-20090106_190313_967720_5D5E0C7C)
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <1229336057.4471.9.camel@johannes.berg>
	 <1229354532.12163.24.camel@localhost.localdomain>
	 <20081217174244.M36761@bobcopeland.com>
	 <1230064216.31228.46.camel@johannes> <20081224054951.GA32398@hash.localnet>
	 <1230102989.16960.14.camel@californication>
	 <1231260306.14565.21.camel@localhost.localdomain>
	 <20090106165434.M2397@bobcopeland.com> <1231262082.3654.5.camel@johannes>
	 <20090106172758.M47578@bobcopeland.com> <1231263802.3654.8.camel@johannes>
	 <20090106174830.M95524@bobcopeland.com>
	 (sfid-20090106_190313_967720_5D5E0C7C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ARKYV0vNb1FCu3tpSTkT"
Date: Tue, 06 Jan 2009 19:16:20 +0100
Message-Id: <1231265780.3654.13.camel@johannes> (sfid-20090106_191613_554786_71676CFB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ARKYV0vNb1FCu3tpSTkT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-06 at 13:01 -0500, Bob Copeland wrote:
> On Tue, 06 Jan 2009 18:43:22 +0100, Johannes Berg wrote
> > We should probably take the rtnl anyway though to be prepared for when
> > userspace is not suspended.. Need to think about that more though, and
> > possibly add a new "suspended" flag that makes it block all
> > configuration attempts.
>=20
> Well, luckily we do take the rtnl already, wiphy_suspend() and _resume()
> do that around the cfg ops.

Good point.

> IMHO a suspended flag would be extra complexity that we should just
> hold off on until the freezer really is getting removed.

Well, kinda a chicken-and-egg problem here, can't remove the freezer
without looking at all this, but yeah, we can defer that and put it on
the todo list.

> For now is there anything besides driver support we need to do for this
> patchset?  I guess that the drivers will actually be OK as-is too unless
> there are any that do release_firmware in ->stop(), but it will be nice
> to clean them up.

I don't see anything, drivers need to do at all. They should all be fine
with suspending when hw is stopped anyway. We can remove some driver
code though.

johannes

--=-ARKYV0vNb1FCu3tpSTkT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJY5/xAAoJEKVg1VMiehFYgHIP/RLjLwr4hZkAZlln7Ix0/4oc
626t/hp8dhsTa/jrJwY44zKuN94JqmNgm7chiaGxUt1xK8FTKPIF53R+OmXBD4ws
BPi7M4QDgCu0ib9FXhz6vuVjYwWOYv7bpJQiNlmusfGTldcn+tO3r9w3qQb6S6EU
uowfQl4Pa6b/pTqdKy6k8B5AET+zEqLZl84Wq/gj3u9EkO6H9HQglxVhUIWan8k7
0bp28U4jEzAoFBjTSvSKQfV+w98Rf/i1KySXOXtWtQ2sTNooL/1YVOgJcy3gSF1t
z0QZNS0XxApGBRCtZqydT3ke03fYWOW/ahlMee2/6OxKpgEY5EIKs3VffBb7jOpc
Z+qQmb/xOR9SuvSNI2KKuBhQ76T4NTkNMawMgblN2BP9m4Z0n8qfuamYgUMbLTnF
8zN8Eym7GFFMko1OesiojCvWuKTe9v/E/Z4u1fms4DPpAvzdnM1K+pyWSzDqaGOZ
LNgpe4pgxxg41KQdFJ5qUBNtdteN5V0jAobzt+8J6hi9oTLUTNfWE19Mr9WcydzI
i4sHqyugTYZ90TGmEyCForWlF7PAVso1AK6XXLv5nofC42r377n94YtnX4W3xv4D
Fx0T7g8Dn6jKET3flGKn4H6StDd4sloiq2YONkIzu81BRS/E5rjkG1nP3iV1fnP3
1nvPerBXscccgUxfR0me
=KNE2
-----END PGP SIGNATURE-----

--=-ARKYV0vNb1FCu3tpSTkT--

