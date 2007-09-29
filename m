Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbXI2M0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 08:26:21 -0400
Subject: userspace mlme configuration (was: Kernelspace --> Userspace MLME  move and related items)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1191066581.22960.55.camel@johannes.berg>
References: <43e72e890709281725n6a8ffe0bq487f32796a7e1cf2@mail.gmail.com>
	 <1191066581.22960.55.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i0h2/WatCjrZurKuVUSR"
Date: Sat, 29 Sep 2007 14:27:38 +0200
Message-Id: <1191068858.22960.75.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-i0h2/WatCjrZurKuVUSR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ok, here are my thoughts on why alternative one is best. To recap, these
are the alternatives I see when configuring the userspace MLME (copied
from the wiki as I just wrote it there):

  Userspace MLME configuration (alternative 1)
                   nl80211                     nl80211
    { nm | iw } -------------> { cfg80211 } -------------> { umlme }

  Userspace MLME configuration (alternative 2)
                   nl80211
    { nm | iw } -------------> { umlme }

  Userspace MLME configuration (alternative 3)
                  socket (*)
    { nm | iw } -------------> { umlme }


Currently, we have alternative three being used by nm and wpa_cli to
configure wpa_supplicant via the control socket.

As I said before, I favour alternative one, for the following reasons:

1) it is transparent

Alternative one means that the userspace tools do not need to know
whether a userspace MLME is used or not. It is completely transparent,
the regular command line tools can be used, tools that need to scan with
certain parameters can just request a scan via the regular mechanism and
expect results.

2) it helps us define the interfaces

With more processing power becoming available in smaller form factors
and more MLME features required by new networked appliances like
cameras, washing machines etc., I expect that full-mac chipsets will
start to become more common again. Especially mesh-networking like used
in the XO may be a push for this. However, it is not clear that
everybody will have drivers for such hardware. Defining the full
interface to the MLME in terms of nl80211 even when most of the MLME is
implemented in userspace allows us to experiment with the full MLME
interface even though we don't always have full-MAC chipsets or drivers
available to experiment with.

3) it is UMLME-agnostic

The current control socket implemented in wpa_supplicant was designed
specifically for wpa_supplicant and much more for the actual WPA
features than all the MLME features. I don't want to say that it is
ill-defined or badly documented, neither seems to be the case, but I do
think that it being defined for wpa_supplicant could be a stumbling
block when you want to implement it within another UMLME.

4) it can support wext

Since we go through the kernel, we can introduce a thunking layer that
makes wext->nl80211 conversions for the userspace MLME and the other way
around for the results. This requires some work and also requires making
wext not take the RTNL so a userspace MLME can't block the RTNL, but is
certainly possible and makes the userspace MLME even transparent to
legacy tools.


Arguments two and three really speak for both alternatives one and two,
while one and four are unique to alternative one.

johannes

--=-i0h2/WatCjrZurKuVUSR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARv5EuaVg1VMiehFYAQK/Mw/9FABjHQzPRx6SENSX4WR5fdTV0nj9YXtA
VP+JO8GaVtd1eLJvScXSBKjc9z/hPiEKeorAQy8WEvwpKO27Z0zE4uw3Q6qeJvsL
duT5cl+woGxdUSQunhF/1VxEa1bZh9QYN/hQDK7uvIqGcT2E1fgoeWnu57Hp6z1E
1aLiTpQ8RT78v3Vi3SR0EdNRh/+o0rJsBXvHhv3EOSlYT+bteDRlgw0adToqwMBg
wRTrF4MB4AdlzuJKpX5jLBhbukuzUy8SnVmmq3nvlEvLW0v6QbVtZSKy+Ue5qtwN
f73zudR8+Msp/y81YNfeS79/kZYWMN8P3BiepHE/ys6TqfzeHDZ3D856gKcX1/Rp
Z14+Gu7AN7Nd0FBvrYA45JPXXqAsWtT2atTZjsRLs9w56WRyErDrKY+N/+kIHSAQ
1uaOiu/rHcevIf9i/S9WkNhtod+CyYZBaANEfsRorAwEJjZ3F/vq931VBwzFhX6p
Nuju6+Ezo+N5+tEYNgxK5CO6j4jYtI5C0kyCxjiffmCRwea/DZfsx9qYZVKF4EqA
UK20qAhd/Q1KAoKeD7SVlzX63Y4HAT5GjKvbZ8lfkK4vFbATNsPpubIcKqDT5/Am
QcjfapwpTz93DMDyAI/parrbv0fcK//TQCU4EOsrEKO8beLogscVLyM0UBShQfu8
Gve7tITC9wE=
=epLa
-----END PGP SIGNATURE-----

--=-i0h2/WatCjrZurKuVUSR--

