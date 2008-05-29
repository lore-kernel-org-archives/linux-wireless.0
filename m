Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbYE2KvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 06:51:06 -0400
Subject: Re: [PATCH 38/43] mac80211: allow disable FAT in specific
	configurations
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240805290339y77256fb7r296118775d3e85a8@mail.gmail.com> (sfid-20080529_123914_945886_982345AA)
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-34-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-36-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-37-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-38-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-39-git-send-email-yi.zhu@intel.com>
	 <1212053870.16917.39.camel@johannes.berg>
	 <1ba2fa240805290258of0559a0t183128d3f9889eae@mail.gmail.com>
	 <1212055950.16917.53.camel@johannes.berg>
	 <1ba2fa240805290339y77256fb7r296118775d3e85a8@mail.gmail.com>
	 (sfid-20080529_123914_945886_982345AA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RzPV3ZNQi2KgIFLsqUXe"
Date: Thu, 29 May 2008 12:49:44 +0200
Message-Id: <1212058184.16917.57.camel@johannes.berg> (sfid-20080529_125110_540313_AA7C19F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RzPV3ZNQi2KgIFLsqUXe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> > It seems to me that (12, -1) would be pretty much the same as (8, +1=
) as
> >> > far as regulatory is concerned.
> >>
> >> Yes, just beacons will flows on 12 and not on 8 so from protocol point
> >> this is important
> >
> > Yes, but how is it important to the regulatory regulations?
>=20
> I didn't say it does.

Well the patch seemed to imply that it is, but ok, this is just how you
express things then.

> OK. Now I understand your question. The word 'band' is a bit
> overloaded.

Yeah, sorry.

>  Regulatory specs uses
> 'channel starting frequency' as for 2.4 or 5, 'channel spacing' as for
> 10 (Narrow) 20 (Wide) 40 (FAT) and
> channel set as list of channels for particular reg domain class such as 3=
6, 48.

Right.

> I'm not aware of the cases that if (Ch1, +1) is on the same band  as
> (Ch2, -1) it won't be allowed in some regulatory domain, so your DB
> would be OK. Just the protocol doesn't talk in frequencies but in
> channels.

Right.

> When matching against such database you would need to check not only
> if you can associate against
>  X-Y Mhz (40Mhz) but also if you can fall to  X (20Mhz) or Y(20MHz)
> depending if X or Y is the  primary channel.

Yeah so I can actually deduce these flags by checking "Can we go up/down
from this channel by 20 MHz and still fall into the allowed range" or
something like that.

johannes

--=-RzPV3ZNQi2KgIFLsqUXe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD6KR6Vg1VMiehFYAQLoGxAAoFM0B/p2pUhf0/9/UjbNfEmdNN0HmsPN
JSwgvQboSyPatNIn8GP+oqAXuBBu8HjvHPHRB5Qt1zadQC6PPgPsjcxVqXz6S4a0
DqA++W8YipisvS5BmenLtTx5CWg4e2LQtbWcszys7Evalr7qUvMs4oBNuAkGw8dK
VVD9ETCAjvoX7y8BlDANFud27ENsjhnP7zuoPUefOTh1gDBT6MBYFRvvPE1hzRRG
5A2a3/3D1faPvuU41j1YB+u8P2WGxZF8+hoJHp9iBHhqu05yqKeHfcK5GKKF/HUQ
63IpNu6VnF5ApWyAwHbdiJ6EZzXOxg3REIt8IIu/NPEybssI478wsEaFH2H29u9d
5plJdwXnbzKh/HvAgk3KFH0jxaRqsE58IcoilH0SUQh+9DiTBdNFxtOFWfhgVX8Q
jJ2oSLgxS0cBxug60y96uE3SfOwUb+smxJmOjVoqe8lERYgY9rkSIicM4qsIjglm
os7d4sPsE9ziP/8em+tIlQ8xtJER0B4FiPF/TiAiMS2YgQBz3DUWEeIFO/qyF6B3
a6zG64oLhv4lEP4NITbHEdp9dabKQqlEfl9V6ALg6Bu5mQQ+qa4nazn7HXGgTJ7C
vvWqTPeZCB8R5t3RDCBLMZ4ko78R9ejHNBF/HWTbmMbJbD2PGa16cvr/XsUcnbyy
96988Mpd0Z4=
=RNPO
-----END PGP SIGNATURE-----

--=-RzPV3ZNQi2KgIFLsqUXe--

