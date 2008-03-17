Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39076 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbYCQTUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 15:20:13 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240803171212s36f85306i6f47ed9fa725b90@mail.gmail.com> (sfid-20080317_191251_421046_BB6B7D42)
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
	 <1205751455.1614.25.camel@johannes.berg>
	 <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com>
	 <1205758276.1614.45.camel@johannes.berg>
	 <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com>
	 <1205761758.1614.79.camel@johannes.berg>
	 <1ba2fa240803171212s36f85306i6f47ed9fa725b90@mail.gmail.com>
	 (sfid-20080317_191251_421046_BB6B7D42)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZIY+T2OnGoNhjBIV34Jr"
Date: Mon, 17 Mar 2008 20:19:53 +0100
Message-Id: <1205781593.16475.20.camel@johannes.berg> (sfid-20080317_192045_196263_2DAC7C4C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZIY+T2OnGoNhjBIV34Jr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-03-17 at 21:12 +0200, Tomas Winkler wrote:
> >  >
> >  > Isn't if on integer faster then comparing 6 bytes?
> >
> >  Probably. Does it matter though? Setting keys isn't going to be
> >  performance critical in any way.
>=20
> Yes but at least you do IF on something that is real not hacking with add=
ress.

True. Does it matter much though? I'm open to changing it but don't
think it matters too much.

> >  > >  Is that really done though? I mean, does wpa_supplicant not also =
use
> >  > >  encodeext for WEP keys?
> >  > >
> >  > Unfortunately yes.
> >
> >  So that doesn't really help us either way, no?
>=20
> What is happening in case of static WEP is that IW_AUTH_CIPHER_NONE
> IW_ENCODE_ALG_WEP are set.
> Which is enough.

Indeed, that should be enough.

> You need only one unicast key for pairwise key.  4 keys are used only
> for static WEP key.
> For pairwise/dynamic WEP and TKIP you use key index in the packet but
> it changes only when supplicant change the key it self. You don't have
> the key alive in driver.

No, that's not true, due to rekeying concerns you actually can have more
than one group key at the same time in the driver/hardware.

> BSS defines security setting which  defined by key management for
> pairwise and group key + cipher method for both .
> You can run multiple SSIDs over single single BSSID. This is done
> using VLANs

Actually, we don't support that in mac80211. And the way I understand
VLANs they are simply done by negotiating different group keys with
different groups of stations each forming a VLAN.

> So you can maintain multiple security settings in for one
> AP.  However this is not possible when using static WEP since the key
> is global and the key is not attached to any address.
>=20
> There are more details into it I'm sorry if I'm not 100 clear here.
> The bottom line is that you don't need more 4 WEP keys both in AP and
> station mod. Same you need to maintain only one pairwise key for
> station both in AP and STA mode. In AP mode you need to maintain also
> one group key for each station because of the case of multiple SSIDs.

Except the group keys don't really matter for an AP since they're TX
only, which is why we add them with a zeroed MAC address and can only
select them for TX.

> Nop. Still you  can have <WEP, WEP>  for <pairwise,group key> valid
> setting - This is not static key. The two keys may differ. Under your
> assumption the group key will override pairwise key

Hm, ok. So I suppose the only way to determine "static" right now would
be to check that no pairwise keys are configured at all.

johannes

--=-ZIY+T2OnGoNhjBIV34Jr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR97EWKVg1VMiehFYAQIgbQ/+IqIhEtS4mafZD5Qg7xGLN+e7fUBucLYG
MhX//bDJU9+ejqViSlthiNl5SsT2yMPaUHK4svTyv2g+R9O7fRmuSfVOBR0SmJPY
KApfbT+S1r74hYJDxrPbCx9JNt+qKjNkkID4wOb59TtjnbsnePGAOM/nYm/Fz2o7
ZgakXhVKJdcjWXa45c0m3BsC5b+hulSm8fxtr/MD2098cvlEs0qxGBCacx5YkClC
lNcSHe0RByPSqYjuKuQfPIpN2E3eRcnwTvDw1vXL6T4nzMhvO5+tRxblC3eieuFk
91MsyJHpL7oDxIN3JAKD6gNg5ZWAwryb/puyTaomE2raCMaiGxdUePB9bux7k4SE
10V/QRsIMo6d1I6N5Of2YyzhMdSTAncvpDldHaEqDw3MVqs8Nchsw7Ycx+CnPqYO
8JvHe+e6jIAPxH00Gvi9B9kvcA/OQTk00e3+4I13Cjjy5LeDWCRamE2txXdy2zq/
pLbqh4cfIUi597fzwtsrcJWLIFsjm+0HBS2f/sZWEVOi/8mJn6VnvvMZrm0DHNU1
jz0qsqeuFWyZPnGa9ogKFGJuCt72Vh5VMt/TV+/3Y2clD5mUkdjnKI+SfAwt99mB
AqixfHro6gbbbj17zOpdq93bRu4dJepRnts/YABEytfDCDwBISIiorisLNTBt2ok
mqteOLChBMw=
=d7eL
-----END PGP SIGNATURE-----

--=-ZIY+T2OnGoNhjBIV34Jr--

