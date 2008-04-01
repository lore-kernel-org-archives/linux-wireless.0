Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbYDAMEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:04:08 -0400
Subject: Re: FW: [ipw3945-devel] iwl3945: disassociation from AP (reason=4)
	andtimeout, a solution
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net, abertensu@yahoo.com
In-Reply-To: <1206999696.20744.2.camel@localhost.localdomain>
References: <D936D925018D154694D8A362EEB08920040FA26C@orsmsx416.amr.corp.intel.com>
	 <1206999696.20744.2.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LBVp4vPa3OhIRtomfQe8"
Date: Tue, 01 Apr 2008 14:03:54 +0200
Message-Id: <1207051434.5143.58.camel@johannes.berg> (sfid-20080401_130412_142278_F1CC6FE1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LBVp4vPa3OhIRtomfQe8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > After browsing the internet, I found a lot of people with the same
> > > problem and no solution. So, I dived into the code and found a simple
> > > solution: ignore disassociation. When a new request arrives to the
> > > wireless, a reconnection is done automatically.
>=20
> Ignoring the disassociation from the AP is suspect...  wouldn't the AP
> be releasing resources associated with the station, requiring a
> reassociate/reauth from the station?  Reason 4 seems to mean "Inactivity
> timer expired and station was disassociated".

Indeed.

> A better solution would be to queue up a reassocation worker if the AP
> kicked you off for reason 4, maybe?

It would think so, yes.

johannes

--=-LBVp4vPa3OhIRtomfQe8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/IkqaVg1VMiehFYAQLJLw//fzswL21aQNN2ctDStomw1o1A2hV07BLy
UHHASytGra3mMOJveWLrHx9jGrrILPE1vhFK6LXb2TrD3KaHZGvl6gbt/lrcUB4n
SGzwHullxBcY5bcmPoRcMnA9U3diSXqeHyy67s4bxi8arBQxqHGkow/ZJ64m8rPM
1QtdWgqVw61s6lECtW533XXOmr/DUtQwYy1tLn5bFEIPcKEHt3IuqCCqWpZag/rQ
4aTejE4n8z6fGJBxyRwL6ohJhDSMIPzfvaQwkZE3TVae9PevPxtftieGeIF8WKt9
B1FjIV5u+IbxFq9cjFBtMBWEzncSsNU7UnO39+9iPgDXsFddlgfShz9taB8hfa7p
zYgNmaaBXcnJCn3y74MPF755YGBvmefGEi8TZV+PeHefsKPI9fp4hl28xXL/lNGf
ry5acLKOiKAKxe2IG7pVAxuBWCArwkxOPtipz5EQmbi/4len+DLf4HFZ6dXA52DO
aCgjjjdz5sji67RatXusxQ5xP3fN4/2zj+LuvlxGPSXsa4nBE7+oUsf9iIQ3oPMT
zc1RZhUdTGlC63vtyU+8FmvU1q6Ox3LT9HgG4Plq7Aaemz9tXldJyUMi1Y9qccDJ
QP5LxCAD3g1IiCChyrd9lsgvn9sjSlRmFzby9JGMg7k83YTdSdzZCb6Pl6+NEwU8
caB3+iZd0l8=
=yfOn
-----END PGP SIGNATURE-----

--=-LBVp4vPa3OhIRtomfQe8--

