Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52641 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbXFNJGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 05:06:10 -0400
Subject: more nl80211/iw tool code comments
From: Johannes Berg <johannes@sipsolutions.net>
To: equinox@diac24.net
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C+2XuA3GG227lxsck8fO"
Date: Wed, 13 Jun 2007 20:23:37 +0200
Message-Id: <1181759017.29767.117.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C+2XuA3GG227lxsck8fO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Just briefly looked at your iw tool. Code looks really good, very
readable and understandable :)

A few thoughts/comments:

get_phymode should probably be more strict and not accept things like
"IEEEabg" as A mode. IMHO the only valid things should be
"IEEE<space>802.11<single char>"
"802.11<single char>"
"<single char>"


get_iftype should accept "ap-vlan" which str_iftype returns, although
it's not really useful for use by hand anyway, I think.


You have

iw phy set      [ phy ] DEVICE [ CHANSPEC ] [ name NEWNAME ]

and we discussed on IRC that it might make sense to have the same for
nl80211. On the surface, that makes sense, however, it does add a
complication in that we need to either specify that you cannot combine
some attributes (which doesn't really make sense), or we need to take
quite a bit of care with atomicity; setting the channel and changing the
phy name can both fail individually but having them in one netlink
message implies that it's one transaction. I'm not sure the somewhat
cleaner API and saving one command number is worth the additional
transactional safety we need to be careful with then.

So I'd like to reverse my previously stated opinion and say that I now
think that putting these orthogonal things into different commands would
be better so that we don't run into this transaction problem.

Of course, that doesn't counter the other thing, namely that commands
could (should?) be named NL80211_CMD_WIPHY_NAME_{SET,GET,NEW} (del?) and
occur in groups etc.


Another thing: Maybe it should be possible to say "phy# 1" in addition
to "phy phy1" so that it's easier to write scripts that don't care about
concurrent phy name changes? Just a thought.




johannes

--=-C+2XuA3GG227lxsck8fO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGcDYo/ETPhpq3jKURAuh6AJ97RVQRWn/6KJ3WY8Y1z2ycXZZhiACggcB7
9SFHpjJEThq9VFSsk579JDM=
=OT84
-----END PGP SIGNATURE-----

--=-C+2XuA3GG227lxsck8fO--

