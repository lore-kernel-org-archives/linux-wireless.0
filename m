Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbXLYMvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 07:51:20 -0500
Subject: Re: [PATCH 5/8 v2] mac80211: A-MPDU Rx handling aggregation
	reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470712250335h4548d8acwfd99c6df27122300@mail.gmail.com> (sfid-20071225_113543_990110_B29D8989)
References: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
	 <11981435613464-git-send-email-ron.rindjunsky@intel.com>
	 <1198170867.16241.56.camel@johannes.berg>
	 <c85cb4470712250208y29318fb6w2d140d00c3e02933@mail.gmail.com>
	 <1198579169.4103.51.camel@johannes.berg>
	 <c85cb4470712250335h4548d8acwfd99c6df27122300@mail.gmail.com>
	 (sfid-20071225_113543_990110_B29D8989)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-msQIXDMdpd3cKW1V9fLj"
Date: Tue, 25 Dec 2007 13:51:09 +0100
Message-Id: <1198587069.4103.65.camel@johannes.berg> (sfid-20071225_125127_187060_0B0F9905)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-msQIXDMdpd3cKW1V9fLj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> what about list_for_each_entry sta inside ieee80211_stop to stop the
> session?  i tried it and it worked really well.

Sounds about right, you just need to make sure that you have the right
locks and only tear down sessions for the virtual interface that's being
stopped, not all if you have sessions on different virtual interfaces
(say on a multi-BSS AP when one BSS is stopped)

johannes

--=-msQIXDMdpd3cKW1V9fLj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3D8vKVg1VMiehFYAQLt8g/8DCsma/QWRnSZJqjfTlW5sZ75dXqlkq3H
hEzbspYBC4Nuu8tEUZDwqFzlz95IiZI6Or6vdMC6B6QdAhCXw9X1RLtR5m3i7qhv
SqmQVY9KAaoTWAncavVGadDDvAZhms9N27Ys9yFW9Dhvq88OFiTxVwxaFfVX5chp
54NIEbNRl/SG1M+ZLI8O34+k8Ey+sMNiVWhf02JZA0VfQRVtj2jOXKv7C+Q4clOQ
heK9KyJpI8qVtwAlyUfAyMT/R/h87AcnNXE2SJw2epBuXb7q28qohNEkxbDJcIGD
ug0bX6QvUBgyKpSZFy4P3MGe3sx8uDEN5EhNzLIJw4+w8trU/3za+qNnYnIBX7Zx
jcHriFNMPZ7wNpnDE91WFJRdRMblY3wk5OjQYjafVBOMH2kD3060oBh3oKHaE/qG
Go3fpKQkh/CXqfZN+rAUGRzp2LdYoVx3FGCcT2zgI5Y9HFcaCVK0GfLBtLTgbFdU
GqnZ2m6OwFvMjUxiFVKVQ3ighAbkFr/UICuA1OLu5Tg3ys5Dqyv2qXQw4ORGAdQH
+jmga17hYFgiTbsV9vOZ2R5qqZk/osaUxh3PbphSwdgBxFljrNrjgiUQ8ENWxN6Z
sp+FUPjxofkRkbPa3irgRUFWvFpTVRbGlksvs/LiKTUWqffqjJu+EAgR9jfZIfKg
csPrPwbJg84=
=/ZQ9
-----END PGP SIGNATURE-----

--=-msQIXDMdpd3cKW1V9fLj--

