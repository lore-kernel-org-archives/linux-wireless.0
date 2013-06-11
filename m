Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:54525 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3FKOSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 10:18:17 -0400
Date: Tue, 11 Jun 2013 16:18:12 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFC 0/4] add master channel switch announcement support
Message-ID: <20130611141811.GA9490@pandem0nium> (sfid-20130611_161820_248312_935112B8)
References: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1368439778.8300.20.camel@jlt4.sipsolutions.net>
 <20130514092734.GA16426@pandem0nium>
 <1370953885.8356.38.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
In-Reply-To: <1370953885.8356.38.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > > >  * could other drivers (next to ath9k) work with this API?
> > >=20
> > > Probably not easily. Any TI folks reading this?
> >=20
> > I was thinking about adding another callback function or option for tha=
t for drivers
> > who do the channel switch internally. Then we would only need mac80211 =
to adapt.
> >=20
> > Would that help, or what would be problematic?
>=20
> I don't really know. If you look at what we do in managed mode now, some
> drivers will do the switching and report back when done.
>=20

OK, maybe we should leave that open to people who implement that feature for
their respective drivers.

> > Yeah, that would be an alternative. I've been inspired by IEEE 802.11-2=
012/6.3.17
> > (MLME-CHANNELSWITCH) originally. :)
> > I think your suggestion is good for AP where we control the beacon. For=
 IBSS it
> > would be a little different: when a channel switch is triggered, usersp=
ace does
> > not know the beacon (and will not set it). Therefore, we could only acc=
ept the
> > change IEs and skip the "after-switch-beacon" IEs (these would be re-ge=
nerated
> > internally) in IBSS mode. I guess it would be similar for mesh.
>=20
> Yeah, agree, IBSS/mesh modes are somewhat different here, userspace
> doesn't really know the channel is switching at all, does it?

IBSS/Mesh does not process CSA so far. When we do, we should switch the cha=
nnel
and inform userspace by using an event (the same way it is done for station=
, I think).

What I'm concered about is to initiate a channel switch from userspace. Thi=
s will be
required for IBSS-DFS: when a radar is detected and this event is sent to u=
serspace, it
must react by initiating a channel switch.

My plan was to use the same "channel switch" command, just without the CSA-=
IE and
after-change IEs (see the new PATCH series). The rest would be pretty simil=
ar to the
AP-operation: add CSA IEs, switch channel, create a new beacon for the new =
channel and
set it. Only that this would be done in kernel space instead of userspace.

Cheers,
	Simon

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlG3MaMACgkQrzg/fFk7axYs+ACfX911TUQtzNqaE/IBWQeLJPR3
pl4An23QsKBpvYnfi3IFqUXLS3fNyREN
=C6H5
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
