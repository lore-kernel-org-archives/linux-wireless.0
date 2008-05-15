Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbYEOLMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 07:12:10 -0400
Subject: Re: [PATCH 5/5] mac80211: move TX info into skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <20080515105948.820956000@sipsolutions.net> (sfid-20080515_130617_846236_C0B1654B)
References: <20080515105524.359863000@sipsolutions.net>
	 <20080515105948.820956000@sipsolutions.net>
	 (sfid-20080515_130617_846236_C0B1654B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K2LaMpAE1m43JvCi39sV"
Date: Thu, 15 May 2008 13:11:07 +0200
Message-Id: <1210849867.8709.0.camel@johannes.berg> (sfid-20080515_131214_527012_0D6E560D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K2LaMpAE1m43JvCi39sV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-15 at 12:55 +0200, Johannes Berg wrote:
> plain text document attachment (019-mac80211-tx-info-skb-cb.patch)
> This patch converts mac80211 and all drivers to have transmit
> information and status in skb->cb rather than allocating extra
> memory for it and copying all the data around. To make it fit,
> a union is used where only data that is necessary for all steps
> is kept outside of the union.
>=20
> A number of fixes were done by Ivo, as well as the rt2x00 part
> of this patch.

I mangled it a bit though so you may want to check it, mac80211 now sets
REQ_TX_STATUS so you can use that for status reporting, but you can't
use it for queue kicking at least not in the future when mac80211 might
not set it on all frames.

johannes

--=-K2LaMpAE1m43JvCi39sV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCwaSqVg1VMiehFYAQIfug//RLcD7cH34g3EyPV5LT47xXtOBPTiTj46
gHCWuZh8pHHwDOks1t5T4tNLCgizpCIBRdGbRy/rCrGf4Q6wO7yjRlHZG5R3WOPi
Tffr7ob/UgO1ORHx2x9ytx/ldro/7NLblIi6ZL0dI+QqQVLBLaB2PF3vVPczBQGp
NlPxtGfxit5+svP/phU3rzaj+uRSlLbm/9YYqY6zX31oWi5rDjr7saQlkLqjBSaX
GNFGCdiF09Y1EDx1sB8oJwvjafmjaoG/2s/FTJe2dSeQ4RtUQgk3d1E6YNQVG/2N
wfPnBMHQq8UnnRdv/EIiRKB/3fftCMOHxDrZEkeAP9UOPDrj1e/AFOUdtUdY9b2Q
ecxF6dTAiJ6Ba/d7ppQ1rR2zSww0n6pQ4SVwDaMO0WEvch/ky3fJpWEV7eRxZm/7
gYwsfyoBAxEJ/6I0ekct3iQ7IjYNqlQ/5BfkF8H1NUWt+nXve3rFVE54M6nhI66I
94ZqW05O4hJL0BzA14bbhVFjr6cjuXyR2+Jg0ZjuBqYihm3G5r/3Uvkz4LKDgLBP
db5oR9J6Jb5V66l+0+vBu8raXHBhFXN1RqBNssrDPEaWg+n4M+17maYOMpUAVfsD
eNvARt64LQy13dTMHI+fgPRX3YYFopmkcIuW0ndcRsH7kD/7ssdvcEWQVBjY5LKL
UPh23RerEYc=
=q9+u
-----END PGP SIGNATURE-----

--=-K2LaMpAE1m43JvCi39sV--

