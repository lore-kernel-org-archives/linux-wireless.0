Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52452 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbcDTRFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 13:05:19 -0400
Message-ID: <1461171915.17112.7.camel@decadent.org.uk> (sfid-20160420_190523_576134_E6CFB6DA)
Subject: Re: RSS configuration in iwlwifi
From: Ben Hutchings <ben@decadent.org.uk>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"Sharon, Sara" <sara.sharon@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 20 Apr 2016 18:05:15 +0100
In-Reply-To: <1461169379.19157.7.camel@intel.com>
References: <1461164882.28559.61.camel@decadent.org.uk>
	 <1461166207.19157.1.camel@intel.com>
	 <1461167278.28559.63.camel@decadent.org.uk>
	 <1461169379.19157.7.camel@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WIKsRtBD16oHnmtNsN3N"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WIKsRtBD16oHnmtNsN3N
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-04-20 at 16:22 +0000, Grumbach, Emmanuel wrote:
> On Wed, 2016-04-20 at 16:47 +0100, Ben Hutchings wrote:
> >=20
> > On Wed, 2016-04-20 at 15:30 +0000, Grumbach, Emmanuel wrote:
> > >=20
> > > Hi Ben,
> > >=20
> > >=20
> > > Thanks for looking at our code.
> > >=20
> > >=20
> > > On Wed, 2016-04-20 at 16:08 +0100, Ben Hutchings wrote:
> > > >=20
> > > >=20
> > > > I'm not sure if you were aware, but there is a standard API for
> > > > configuring RSS in network drivers, part of ethtool_ops.=C2=A0=C2=
=A0I think
> > > > iwlwifi should implement that rather than a driver-specific
> > > > debugfs
> > > > interface.
> > > >=20
> > > You are right, this is why Sara made this commit:
> > >=20
> > > commit 854d773e4ab5869200004af4ca5d851730849903
> > > Author: Sara Sharon <sara.sharon@intel.com>
> > > Date:=C2=A0=C2=A0=C2=A0Tue Mar 22 15:55:58 2016 +0200
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: improve RSS configuration
> > > =C2=A0=C2=A0=C2=A0=C2=A0
> > > =C2=A0=C2=A0=C2=A0=C2=A0Improve current RSS configuration:
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* Use netdev_rss_key instead of keeping=
 a local copy.
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* Configure also UDP hashing to have UD=
P traffic spread across
> > > queues.
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Do not direct RSS traffic to our fallba=
ck queue.
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Sara Sharon <sara.sharon@intel=
.com>
> > > =C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Emmanuel Grumbach <emmanuel.gr=
umbach@intel.com>
> > That doesn't really address what I said.=C2=A0=C2=A0Yes, it's using the=
 common
> > RSS key, but it's not implementing the ethtool operations to get and
> > set the indirection table and the types of flow hashing that are
> > enabled.
> >=20
> Hm.. I think that setting the indirection table is a problem in our
> case because the PN check is done in the driver. The PN check is the
> way WiFi addresses the replay attack, and since the PN check relies on
> per-cpu variables, we cannot *safely* allow users to modify the
> indirection table while traffic is flowing.

I see. =C2=A0You could make this work when the interface is down and return
-EBUSY if the interface is up.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.
--=-WIKsRtBD16oHnmtNsN3N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXF7bLAAoJEOe/yOyVhhEJf1AQAM+BQ8L9Jy6/UnPdXXf/vTx0
S86wI5sI3XUpdaYa9kZxKqGsZ9qQpA2SnMXTPEXPR06chYMxUPf8rqHocHpcrfme
YpLIBgqd11Csi5kFAHc2GXxoB7lWgsdbkGhbyGn7nh5pC2xKzJkOoXhZH3izqL0n
/sYS/pBX1TtO98IMhpogB3U8D111ylp3n7ATYpENMd17gV4khVwuiSQNz34YACef
te50sQFllcLsOJ3d0OEyByXi9KzPpvExQVN9VfS3YM2dV3Pbr4Dtmki8dr7P5ESW
QTjmp879Gnwk4LKlzoj7byiT2p4umf3MbbTOxxx4tqVF9m286BRmLRmQ37AkLeLA
bP80OW3Vp6WXLvLGTVUWlEsHk3MGcBglJ+RugWanOCf2LfM0lHhUYj8q2S7CAvKG
wYPSAd/++sX19B7VokVLUQL6nos/gT2Cx9oPnMp4+TEUm7CmnyLVnEyS5FMdd3NJ
RBBdpBx8GaV/tg2cKN3DDodW6knLJSJB55CtoZ/4UsOnUpcojAWmJw0cHCB7HT5+
SfFDZEW0LLkX8AZfgvCgs8qInws3HmuSbK0NXLpsZvUjHjSDRbPbAm2KuX4GlwDR
71FGeNAiQ+Q9XYh+U7HIkrd4nqhaIONbNQ7cVvTASm9JNLFuwWDoKtjbE9GAtoH4
Nww6UUpd6ShwaarJy5Y6
=ZMpN
-----END PGP SIGNATURE-----

--=-WIKsRtBD16oHnmtNsN3N--
