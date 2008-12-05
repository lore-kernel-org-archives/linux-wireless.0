Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:39356 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbYLEIeM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 03:34:12 -0500
From: Henning Rogge <rogge@fgan.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Fri, 5 Dec 2008 09:34:01 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Henning Rogge <hrogge@googlemail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <20081204211201.GL5970@tesla> <1228425635.5692.49.camel@johannes.berg>
In-Reply-To: <1228425635.5692.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2440225.nfRT7tEdzl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812050934.07182.rogge@fgan.de> (sfid-20081205_093416_568222_90402BF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2440225.nfRT7tEdzl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Thursday 04 December 2008 22:20:35 schrieb Johannes Berg:
> On Thu, 2008-12-04 at 13:12 -0800, Luis R. Rodriguez wrote:
> > It seems that's the case for ath9k, at least Jouni had pointed out to m=
e.
>
> They cannot, we don't even have that in the API.
Ath9k has it's ***_ratetable which contains a line of data for each=20
transmission range. 20/40Mhz and guard interval is already contained in thi=
s=20
table (encoded in "phy" variable). Just the MCS number is missing.

And I think the intel driver has the necessary data too. If I understand th=
e=20
iwl5000 driver, it pushes the rate index (even for 802.11n) through=20
ieee80211_rx_status into mac80211.

> > > then we also don't need the values for the number of streams since
> > > those are perfect multiples (1x, 2x, 3x, 4x for up to 4 streams).
> >
> > Well if you have the MCS index and HT mode you get the # of streams. Not
> > sure I understood the perfect multiple stuff.
>
> Right, but you don't need to store a bitrate for MCS 0, 8, 16 and 24,
> the latter three can just use the first multiplied by 2, 3 and 4
> respectively.
When I looked at the table in the wiki I noticed it cannot be created just =
by=20
a little bit arithmetric ? Maybe someone can look at the 802.11 draft if we=
=20
don't need the tables at all but just use a formula ? If yes we could remov=
e=20
them from kernelspace and just add a macro for calculating the rate into a=
=20
userspace-accessable header file.

> > > Just had another idea. Since we'll end up duplicating these for TX and
> > > RX (ultimately we'll need RX_BITRATE_40_MHZ/MCS/SGI etc too) we should
> > > actually do this differently:
> > >
> > >  1) define NL80211_STA_INFO_RATE,
> > >  2) define NL80211_RATE_INFO_BITRATE/40/MCS/SGI
> > >
> > > and then nest the bitrate information into the STA_INFO_RATE, just li=
ke
> > > station flags are nested etc. That way the RATE_INFO things could also
> > > be used elsewhere.
> >
> > So we'll have to add an enum then too to distinguish which rate this is
> > for.
>
> No, we know that based on what "container" attribute it's contained in,
> in netlink.
So it's possible to define a substructure in the station info in nl80211 ?=
=20
Sounds like a nice way to construct the tx/rx rate.

I will see if I get a "v6" patch ready during the weekend.

Henning

*************************************************
Diplom Informatiker Henning Rogge
=46orschungsgesellschaft f=FCr
Angewandte Naturwissenschaften e. V. (FGAN)=20
Neuenahrer Str. 20, 53343 Wachtberg, Germany
Tel.: 0049 (0)228 9435-961
=46ax: 0049 (0)228 9435-685
E-Mail: rogge@fgan.de
Web: www.fgan.de
************************************************
Sitz der Gesellschaft: Bonn
Registergericht: Amtsgericht Bonn VR 2530
Vorstand: Dr. rer. nat. Ralf Dornhaus (Vors.), Prof. Dr. Joachim Ender=20
(Stellv.)


--nextPart2440225.nfRT7tEdzl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAkk453kACgkQRIfGfFXsz+BPFQCeKsi3WISDkIDa2PNeIihDLIoJ
9OMAmJj5e4Np5fc/JS9udcvhZyt3ap8=
=5+NI
-----END PGP SIGNATURE-----

--nextPart2440225.nfRT7tEdzl--
