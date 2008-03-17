Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbYCQPEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 11:04:21 -0400
Subject: Re: [ipw3945-devel] [PATCH 2/5] mac80211: allows driver to request
	a Phase 1 RX key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240803170745x4d70cc0esd4b49ebf85d68267@mail.gmail.com> (sfid-20080317_144516_552179_BB94A419)
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-3-git-send-email-reinette.chatre@intel.com>
	 <1205608293.15910.53.camel@johannes.berg>
	 <1ba2fa240803161704r36b5df43q33c953d698b88590@mail.gmail.com>
	 <1205753998.1614.34.camel@johannes.berg>
	 <1ba2fa240803170603g58cd5378n4e8e58b62c41c37c@mail.gmail.com>
	 <1205759599.1614.69.camel@johannes.berg>
	 <1ba2fa240803170745x4d70cc0esd4b49ebf85d68267@mail.gmail.com>
	 (sfid-20080317_144516_552179_BB94A419)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vHDz1x1mX4QV5fpwmkdc"
Date: Mon, 17 Mar 2008 16:04:07 +0100
Message-Id: <1205766247.1614.111.camel@johannes.berg> (sfid-20080317_150435_977113_9383C5EA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vHDz1x1mX4QV5fpwmkdc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> This is only in RX side. Each AC (access category) queue transmit in
> it's own rate. For example VO trasmitts more packets then BE. So you
> might get into case in receive site that VO packets are already on
> wraparound side while BE are still using 'old' phase1.
> Best remedy is to keep phase1 per each AC.
>=20
> >  but I think this is not too important as
> >  non-matching will just be done in software.
>=20
> Correct, this should happen only for short period of time that ph1
> doesn't match for each AC queue.

Right, in software we can keep a phase1 per AC but we don't need to in
hardware since that's just the optimisation.

> >  However, bcom firmware wants
> >  to have just the phase 1 key, and as far as I can tell the driver can'=
t,
> >  even with your patches, obtain a phase 1 key for TX.
>=20
> Not sure these cases are symmetric. You have to have phase1 ready in
> HW before you transmit the packet
> Phase1 need to be adhered to a packet that causes wraparound unlike RX
> that you can fall back to SW decryption
> In TX there is no way back.

Good point. So then for Broadcom we actually need to update phase1 in
hardware when it changes on TX and not bother with RX at all, we'll fall
back to software in that case.

> >  > >  How about instead we add a new "update_tkip_key()" callback that =
takes
> >  > >  exactly the required parameters? It should also give the
> >  > >  hardware-key-index so that the driver has less work to do.
> >  >
> >  > It's viable but I actually prefer not opening too many interfaces.
> >  > Please give me some more detailed sketch how do you see that and we
> >  > sure get to some acceptable solution.
> >
> >  Yes, I would prefer not having that many interfaces as well, but I don=
't
> >  think shoehorning it into the set_key() callback is a good idea becaus=
e
> >   (a) you add fields to the key conf structure that are only used for
> >      the tkip stuff and only valid in some calls
> >   (b) the patch breaks the set_key() interface's symmetry
> >
> >  A new callback update_tkip_key could look like this:
> >
> >  void update_tkip_phase1key(hw, keyconf, iv32, p1key)
>=20
> What about
> enum tkip_update_flags {
>    TKIP_PH1_TX_KEY
>    TKIP_PH1_RX_KEY
>    TKIP_PH2_TX_KEY
>    TKIP_PH2_RX_KEY -- actually no need for any driver.
> }
>   update_tkip_key(hw, keyconf , iv32,  flag, key)
>=20
> But I'm not sure about this... see above/belove
>=20
> >  The =EF=BB=BFIEEE80211_KEY_FLAG_TKIP_PHASE1_VALID flag would go away, =
and the
> >  new callback would be invoked right from where the phase1 key is
> >  calculated.
>=20
> Sure again I'm not sure this is symmetric - For TX it would be safer
> to do pull mode otherwise it can get out of sync.

True. Hence, since phase2rx is not really useful, we don't actually need
any sort of update flags when we do the TX keys in pull mode, which I
prefer anyway.

> >  I'm not exactly sure whether one needs a phase1 key for RX and one for
> >  TX right now, but if so a direction flag should be added?
>=20
> Phase1 for TX and RX are not the same, again because of the simple
> reasone that number of transmitted and received packet is not the
> same.

Hm, right. But if we go for pull mode for TX, we only need to have push
mode for the phase1 rx key when that changes, no?

johannes

--=-vHDz1x1mX4QV5fpwmkdc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR96IZaVg1VMiehFYAQJ5ORAAntYeRYTaB3AOP1dedGR2TyVaqcVhTnDT
qTUwadGaHDEJG0+PLLTZeM5GGFTUdj7LwthlTSHS6Y8TiCJcQo/pwsgL2b3p7hBS
bPDNm2dxieKO0l0zcn5resBpEOToB/PMV6wf/NiwSCme+xnCWpImGRpWdgZ9xpEs
67PQEXC4tt8ZWvTz6BEoMfrSteBQaNGobqxRwG4uYRSGQ3ZrkBKUwhHb9MtPBajh
EqsQZk8Dz8EXyObgWznFTMJ1AIQ/85O0XQzDF08bPkWe27EFEXGABEB1P5slohIv
i90+CZntMugxb0SGtBrM/kAdYHEtMbjtEc+RbsnM1gVf5PFvZVR6K8zk7Ix8TcZX
W5mT9eBrLn9tP2eZC31x5GXPqc4iaw41o/6bTPns/1EGg0+dSm3AW3m5qEhqJQBR
LO/GmilTgdzqBX62MTCKTu/ChrY6fgg8/xHY/H1CEkXybL4d/nXYbrYdLO6W9Qlo
UKPoTWkO6IY4NFIWc5BMHDSVK1bYsLihj8HU5H0OH2Q2MG18W2AfUcU7mXCgTMkf
MwXV0NF3F1qxLQQGQHI2wg64EpU7iB5LJSHqTcD73todxXEizYm/jbV3RLQzdE28
Ibqmjf2EBHMu6BY55voKnyOxeei94MJtFtgDZDhNk3JZFh/Xkf/3R0FnLOiZ+D+N
e4FnN0J+M/0=
=pGpi
-----END PGP SIGNATURE-----

--=-vHDz1x1mX4QV5fpwmkdc--

