Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646AbYBTS21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:28:27 -0500
Subject: Re: sending ARP triggers BUG
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <D936D925018D154694D8A362EEB0892003ABCBD2@orsmsx416.amr.corp.intel.com>
References: <D936D925018D154694D8A362EEB0892003ABCBD2@orsmsx416.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R76oEgpaGIUZGQ9+jLUc"
Date: Wed, 20 Feb 2008 01:56:08 +0100
Message-Id: <1203468968.10983.13.camel@johannes.berg> (sfid-20080220_182849_400764_D720615C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-R76oEgpaGIUZGQ9+jLUc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I recently started seeing the BUG below. ieee80211_subif_start_xmit
> calls pskb_expand_head, but this function BUGs because the skb is
> shared. So far I have only seen this with arp messages ... I don't know
> the significance of this fact.

Interestingly, I'm starting to see skb problems as well, in AP mode only
however, namely I get lots of

[ 4340.665679] SKB BUG: Invalid truesize (240) len=3D73, sizeof(sk_buff)=3D=
176

Anybody have an idea how to debug that? It looks like 'len' is one too
large, but I've also seen messages where it was two too large or one to
small.

johannes

--=-R76oEgpaGIUZGQ9+jLUc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7t6p6Vg1VMiehFYAQJLWA/+IlgY/eXFhlhQL3LV1HAF3+4+JG93NwaD
mjdSkm4BHOtIQU4uUbRlY9mkFw5FW1JilWPRc2MX/VKBaYV6+xKPxSZzKXuTAQL+
0Us0PiCmzhWvlO5MIiCztqLtbXqPmFs3XiONVpCRWBr7NAK/oDp8JJEhRTofYPIi
LLhT4rmqfLYEBnv3f7RYRzT8HeAmJNnXHcsDF6gtUYc+77HxqZXKbzIA7L0oR8pQ
eAftLmpf62y3rbi4ayo1qjNzWPqZnzZv0dgjWKOvQFG/v328Benel916/rEi9+cS
62n3l2uVsOZKiEROl9C0oFShxuwNj7Kr3dcV+Rz1UO9KAnml9sGaTJHeQWjk1ewW
fwte7UYESVbcDhTsuDhXfnVz5LOPs+AZYxZLdhvuns4FmBHSkQV3xPVShZdXuwDD
PZj9M2XM1cvV0/EqMnh1VjAszhm30jVwKoUfXwiAtwvDxvIL5SI+zG1jCY8Ng4lh
bq7W6nWQ53zgIYkBD2KO9sa3f8+Hlee7Jcg9lgCHlhFJZoh63p2G8nmEH/EdteQ6
7fFo62uQsAOAWzxHvgQOi/RY4ISfiqSPNsCLJfLQumVh/CvaINi8wTDHlcphtC31
0BCXYDUkQGPfr4LDRqXZyLUPsT4npQdoMfdBrhmm07S3N1GOxo8lsY9lXEuCN9NM
d54P6b0kBtM=
=AqdJ
-----END PGP SIGNATURE-----

--=-R76oEgpaGIUZGQ9+jLUc--

