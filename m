Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbZFKJ5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 05:57:03 -0400
Subject: Re: [RFT 2/3] ath9k: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <mcgrof@gmail.com>
In-Reply-To: <20090611065203.GC10126@vasanth-laptop>
References: <20090602111027.460530075@sipsolutions.net>
	 <20090602111112.191915040@sipsolutions.net>
	 <20090610132015.GA10126@vasanth-laptop>
	 <1244644712.26814.6.camel@johannes.local>
	 <20090611065203.GC10126@vasanth-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mu+K5ChXWk9+6/aucDke"
Date: Thu, 11 Jun 2009 11:57:41 +0200
Message-Id: <1244714262.4706.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mu+K5ChXWk9+6/aucDke
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-11 at 12:22 +0530, Vasanthakumar Thiagarajan wrote:

> > > One more issue is, when rfkill is enabled before
> > > reboot, I could not bring up the interface when the rfkill is turned
> > > off after reboot.=20
> >=20
> > Sounds like the driver doesn't initialise properly.
>=20
> I dont think this one is driver specific as this happens
> only when module is loaded at boot time. I works fine after ath9k
> is reloaded.

That's strange. I don't see anything in the core that would behave
differently between those two paths.

> > need to move ath_start_rfkill_poll() to ath_attach(), could you please
> > try that?
>=20
> We do hw reset during radio enable/disable, this needs current
> channel to be configured but i'm not sure if we need to do all these
> during attach time.

Well, the thing is that currently ath_start_rfkill_poll() will never be
called until you try bringing the interface up, afaict?

johannes

--=-mu+K5ChXWk9+6/aucDke
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMNUQAAoJEODzc/N7+QmaN7MP/jdlUkgXGX6Yk0ki1S1dwOPo
z22v2mrkYP/hjQWEnckeqo65Wqkuh+sIGPdgAmzgZr/szdOBocDU6tLj2NWUBBin
70X06ym+2NksxPoJTwTC2dENJ+ZvgsM4thd2CB095KQIOeCjEkG4IWtUos8zkWHt
8v6Jhk7zLeFEiO25jdF40hOAkjI1Uj7rsOyp3JDuymM7Zn5KIewtHG2zzFLVtvMF
ayOPZG6+3CowfZWajqZ2h1ZdNmv9ZUutyFJKHMbVNVHdyJiaKtD/lItF4b0toTpB
z9mGhfxt+wcb0PMBHDnmwp02W7frpp6b9uobeP2Zw9c4eSTev8DKi6CVS4Z3ZWkM
ibeyC+xHOlBvMSHhPM6fOX2cZpWgDnQqs2gRM1hcvTlPR5DFMo3w+gcmC2c93BQq
dkdPvKz2dM7gAeeD73XfvnAOyX7m6ggqJt6oE4USEwWXOHBFArWahtbwSsc6cXmf
aNdxNw7qsI98C9QG6WQWU9IfyRlXJAVW/1Zja8L7ruvIMnjP5kITyQSVPkiF1a6l
bsrOCMLRoBCUdwJH+ECvevtVymnX0xHZvU/tL3IL0NvS2r+YcsjtYNFMV2hRTqP9
qWew1s2TNpA+itIvyn4b27OCXjPlxYCtmgdjuifE1jjQbDVI7Tk6nlbULuwkS1ZM
bZivy3Rmu9TVvkVno8iX
=0kmx
-----END PGP SIGNATURE-----

--=-mu+K5ChXWk9+6/aucDke--

