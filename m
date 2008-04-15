Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbYDOKfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 06:35:54 -0400
Subject: Re: mac80211 hardware encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200804142307.48550.IvDoorn@gmail.com> (sfid-20080414_220504_656620_F1A81F75)
References: <200804051931.58895.IvDoorn@gmail.com>
	 <200804141827.50991.IvDoorn@gmail.com>
	 <1ba2fa240804141139ua5f6f26k6920001ceb59443e@mail.gmail.com>
	 <200804142307.48550.IvDoorn@gmail.com>
	 (sfid-20080414_220504_656620_F1A81F75)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VoytJAqNg5HWJOvKcQYu"
Date: Tue, 15 Apr 2008 12:35:41 +0200
Message-Id: <1208255742.3502.5.camel@johannes.berg> (sfid-20080415_113558_962499_87B6645E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VoytJAqNg5HWJOvKcQYu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Not sure what was intention for hw_key_idx but currently there are assi=
gnment
> > from key->conf.keyidx to hw_key_idx and visa versa.  keyidx is used
> > for 802.11 key index [1..4]
> > So it's quit risky to use it for something else
>=20
> That souds like a bug in mac80211 then. hw_key_idx is for internal use fo=
r the driver,
> and mac80211 should never expect the driver to set it to a particular val=
ue.

Yeah, that'd be a bug, and I can't find any such assignment. In fact,
mac80211 doesn't contain any assignment to hw_key_idx or to a 1-4
key_idx from hw_key_idx. Never mind the fact that the tx_control member
could be called hw_key_idx as well...

In any case, for the problem at hand, I wouldn't mind increasing
hw_key_idx to a u16 all the way through, or pass the key_conf pointer
instead.

johannes

--=-VoytJAqNg5HWJOvKcQYu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIUAwUASASE/KVg1VMiehFYAQL+/Q/4jdU2E0FmBluS+VBYyXYE+IQDvWh2SnM6
1seIUTPy6BdCLYUZVCjOW9pIllx4mndKqipElPeo6rY7iOSI+OjxCaBkxrFQHV6W
ZomwvY5uV9uuRV+CiG5Q+FHo2s/rX8z6ig7hoq2WmAU3hVOmS/vMLHXD3spe++Ux
Q5vc/CZXSwsU4vpnkmRkKVlx1+6xIswKQTqYBx7sQKPbe/DxFiKQL0z9GMtonPMM
eIi1I67ehrh70FbTTbOIO9GR2T9QJpBJzmwDFLHqtF0bwkepPXAwI9CCEq89FzBo
zbfOzvlNE67sZjxI0ErqeGKx0zy1X9JS/x70c1H8RjLFUIQN8LKTXNM/PXPQxkMH
cdEAs+Mb4SBzyfL9tIcgUT9RtavRIoUV+XaScWr4cpfHnGD1d2pM4mF6ksnG9xOX
/z2wLu9mK4vFOnYoSTKhoNgScX7fktoIvlUhQzxtYs5mbuhjkDhOjsYKOggJaxAt
BHh05WlC0bOy5W0gSmWWE6f1GvepEmK9thGD1Zycuml6b0RgrrnRhkGwzL6irQ5Y
zpsTguN690eQKrtua72186QjpqdLl2EPc1wFBjr+xeutvdmstRnj35QSUDamTL7X
X+kBfflrrp2DQDMa6ECn7R9uUmhdOzYLSpRw2E9Q9uTUmaO+d8WTxY5XCidxaroM
5CCLN3B9cA==
=XTK4
-----END PGP SIGNATURE-----

--=-VoytJAqNg5HWJOvKcQYu--

