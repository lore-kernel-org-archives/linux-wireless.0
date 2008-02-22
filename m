Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565AbYBVOB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 09:01:28 -0500
Subject: Re: hardware/firmware powersave help, Broadcom scheme
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1203651948.3082.93.camel@debian.sh.intel.com>
References: <1203520709.17534.68.camel@johannes.berg>
	 <1203574345.3099.64.camel@debian.sh.intel.com>
	 <1203591498.17534.179.camel@johannes.berg>
	 <1203651948.3082.93.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OcCUOxDfZLryDMtabo/d"
Date: Fri, 22 Feb 2008 14:58:28 +0100
Message-Id: <1203688708.7082.22.camel@johannes.berg> (sfid-20080222_140140_436572_9A1F01D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OcCUOxDfZLryDMtabo/d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Right. This completely solves the race, there's a possible scheme
> > where
> > the host notifies the firmware of powersave status changes which will
> > still help because this can be made faster than the TX queues, but
> > still
> > leaves a small window. That was hypothetical though, I guess nobody
> > implements such a scheme.
>=20
> Maybe to your surprise, the iwlwifi firmware implemented this.=20

I thought you just said the firmware follows the powersave transitions
by itself (by looking at the frames)? In my hypothetical scheme the
driver/stack notifies the firmware about them.

> Right. Sorry if my previous "drain queue" comment is misleading, I
> actually mean "begin to send until there are no frames to the target STA
> in the h/w queues". So my "drain queue" is per DA.

Right.

> With the STA sleep -> wake state controlled by mac80211, I think we can
> avoid the hw callbacks and handle all these in mac80211. What we do is
> we add an atomic hw_pending_count in sta_info. We increase the count for
> every successfull ops->tx() and decrease it in ieee80211_tx_status
> (whatever success or fail). When mac80211 decides to switch STA state
> from sleep to wake (and send host command to firmware), it must wait
> until hw_pending_count is zero. (BTW, wait here is not accurate. We
> actually handled this asynchronously).

Hmm, yes, good point, much simpler.

johannes

--=-OcCUOxDfZLryDMtabo/d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR77VA6Vg1VMiehFYAQLCAhAAlg1Yr9yw8EnlIPyAEx4j/YsiHOLbLWtu
icaVBEe0WS4zKxTKEX6YpdQfS6D1pzmfDzEvjZiqbOV123l4H3toiWZE4Bpg1T+J
nuT4btCyVmjgxTEvhgP/vKhV4B2sHedjartxyXwbAdUq0x7fP4jx7eF9wHxWVDeR
SPVTpog4fIoqJYml23fM/esweA4y0QQ+7hFUkmJz7QjY+u2ktbH27jkuQaK+nbER
y7m2I5AF86KdNJB6+Y9Urbk3+KFRWKyT1P3NM8fbEbhFYywTxudcnymLtrcBr1ZA
sugjAQgMlUOq7jCViI8NraECMZsaB5NWIbqaz+p2OUDbHIAvZNlnFew41Gnz2H69
FRbldESLXxMG2E8Q5QTIrVHtfkWjLU55WNpd0t0/MV7kEgQCyxWtk48H1FUTrFUL
YrOXcXiykUzRIfiCscxuywIN9lYfJTs+kpLjIVulqmThUnkipt+hj7Nswp8iU9iZ
TL3n9utmoYIJ4Ak4xWmGc/G5nwjOYYKuHK3sg2EH6tEqaArZWfZsuJYqeq0DGwSh
/4z8sB+NTr2WNRYS7CQ6E5RnRbNrRCuH7yDEQcFoz3FTIth7DfPFGbspuDLDjLzC
loELwcEyyTr5qIHSIkFhFm3a4X6G5wDPccW4Q2WagixMmzbTsIl/SvgPsx4NMbfX
kKiV2tlumEE=
=29wd
-----END PGP SIGNATURE-----

--=-OcCUOxDfZLryDMtabo/d--

