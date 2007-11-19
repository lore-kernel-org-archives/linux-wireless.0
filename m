Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbXKSPZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 10:25:59 -0500
Subject: Re: [PATCH 06/14] mac80211: adding 802.11n essential A-MSDU
	Rxcapability
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Winkler, Tomas" <tomas.winkler@intel.com>, flamingice@sourmilk.net
In-Reply-To: <20071119001933.GD8672@jm.kir.nu>
References: <1879838866982C46A9CB3D56BA49ADEB04008798@hasmsx411.ger.corp.intel.com>
	 <1194885942.5229.62.camel@johannes.berg>  <20071119001933.GD8672@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jEGCTI1Nc3robbtEJ9fG"
Date: Mon, 19 Nov 2007 16:27:16 +0100
Message-Id: <1195486036.8642.34.camel@johannes.berg> (sfid-20071119_152601_922655_FCFA5A3D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jEGCTI1Nc3robbtEJ9fG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This was assuming that there were never frames that would need special
> handling in the aggregate (i.e., need for special PAE or
> unencrypted/encrypted processing). Since the aggregate was encrypted as
> a single unit, the drop_unencrypted was not an issue. Same was, in
> practice, true for most of PAE processing. I don't think the initial
> EAPOL handshake is an issue, but at least in theory, there could be an
> EAPOL re-authentication happening at some point and if EAPOL frames
> require special processing, this would need to be taken into account.

Hmm. Management frames cannot be aggregated and EAPOL shouldn't need
special processing, but getting all this code into one block so the
compiler can optimise it is better nonetheless imho.

> Please note that data frame handling requires support for four addresses
> and plain 802.3 header would not be sufficient without some additional
> meta data. I would assume this to be doable, but some of the
> functionality will need to moved around to handle the 802.11 specific
> things first (like WDS interface selection) and then pass some meta data
> in addition to the frame.=20

Not sure about this. We do interface selection before the RX handlers
(well, we currently loop, but that can and ought to be improved). Hence,
at the point where we reframe the frame to 802.3 we no longer need any
extra data, do we?

> As long as the issues with encrypted vs. unencrypted frames can be
> resolved for both TX and RX in a way that handles the 802.1X and WPA
> cases, it should be fine passing EAPOL frames as normal data frames.=20

Well for TX we've already solved this with the monitor mode injection.
For RX, I'm not exactly sure about how things need to work. Can you
explain the 802.1X/WPA/dynamic WEP cases?

> In
> addition, bridging code should be told not to bridge this ethertype if
> that has not been done yet.

That should be easy enough to check/do.

johannes

--=-jEGCTI1Nc3robbtEJ9fG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0GrU6Vg1VMiehFYAQJWBQ//cPGITbEYKpy9AKWbQmkAfjDRztbKuAaY
lBAHYzc06tjI5OWv+u1W80OlMjXeHPBb2SYL4aAFEFXHd2g6PPn3hkxbJUbNvS05
eG4AwHiYWNJFbmgkKlFk33o6ky6JiSdCLuZakquVMRwdi2eW4IhILwMbUdZKdJKi
YyZOS8eNB1dy8723n+ICN7Jhm0YUdXycWSQjLKYRj4MTdc7Lu9yxkMYmHLSbczq4
qpKvZAqLd6vyO2SnDtQ99NQfFuIBFtcEvI62nfGAqk6oj0QNxhxDgx1HgtQS9XgL
eOALRs2IJb+XZc25gYcUBSnVRitHQBGh1jkRMw7bjV5se/Ma4UxPuLOonlDqEI4Q
kJL/on1t+7b17+5NfCOB+OBhvSueqz86rbagGuNC1tufFnSzsKSHIfEQi4B35LeR
/GVQSL0m+mE4x5I0TyWftssYcmR0iEpf+IjQEXVpwRFYVRgy6dyt9XOPGr8JNYPT
YxWUeDORHLIVryLQ97lGTISpVUPoGRxJriQEDqjiRPrdx4DzmW+kJXm3mV6JvSac
ABSLqV0k6OBtdzEqZYcVaj2L7ht6vpXtVJdOffM81I/U2mT3ifTy43KqN06+bWjI
0wDDQX9ZNoQOemOgzsgqZSdBevc1rj6AekJXIFf3vv4/nopPT7+pYjo0bLFoi/Yy
TIwQmHvVzp0=
=b9gO
-----END PGP SIGNATURE-----

--=-jEGCTI1Nc3robbtEJ9fG--

