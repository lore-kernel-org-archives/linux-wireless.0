Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:51340 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab3E1KoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 06:44:05 -0400
Date: Tue, 28 May 2013 12:43:57 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFC 0/4] add master channel switch announcement support
Message-ID: <20130528104357.GB13489@pandem0nium> (sfid-20130528_124409_507772_8195C4D0)
References: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1368439778.8300.20.camel@jlt4.sipsolutions.net>
 <20130514092734.GA16426@pandem0nium>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
In-Reply-To: <20130514092734.GA16426@pandem0nium>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey,

On Tue, May 14, 2013 at 11:27:34AM +0200, Simon Wunderlich wrote:
> > > [....]
> >=20
> > I don't really like your approach of building all the IEs in the kernel.
> > There are some things, like the country-after-switch in the CSA wrapper
> > (introduced in 11ac), that would be really awkward this way.
>=20
> Hmm ... OK. I have not checked 802.11ac yet (actually I don't have access=
 to the
> drafts anyway). So what we have to expect is changing the country after t=
he switch,
> or also other new things?
>=20
> > >  * We already have NL80211_CMD_CH_SWITCH_NOTIFY which is only used fo=
r notification.
> > >    Maybe we can rename that and re-use it instead of adding a new com=
mand
> > >    NL80211_CMD_CHANNEL_SWITCH?
> >=20
> > Sure, I don't really care though.
> >=20
> OK, will try to merge that then. Seems cleaner than having multiple chann=
el switch
> commands in the API.
>=20
> > >  * could other drivers (next to ath9k) work with this API?
> >=20
> > Probably not easily. Any TI folks reading this?
>=20
> I was thinking about adding another callback function or option for that =
for drivers
> who do the channel switch internally. Then we would only need mac80211 to=
 adapt.
>=20
> Would that help, or what would be problematic?
> >=20
> >=20
> > Anyway I think it'd be better to try to provide
> >  (a) the "during-switch IEs", maybe with an offset to the counter so
> > mac80211,
> >      driver or the device itself can count down
> >  (b) the "after-switch beacon" IEs (and maybe probe response for
> o> offload)
>=20
> Yeah, that would be an alternative. I've been inspired by IEEE 802.11-201=
2/6.3.17
> (MLME-CHANNELSWITCH) originally. :)
> I think your suggestion is good for AP where we control the beacon. For I=
BSS it
> would be a little different: when a channel switch is triggered, userspac=
e does
> not know the beacon (and will not set it). Therefore, we could only accep=
t the
> change IEs and skip the "after-switch-beacon" IEs (these would be re-gene=
rated
> internally) in IBSS mode. I guess it would be similar for mesh.
>=20
> What do you think?

I'd like to bump this issue again - if we agree on that this solution could=
 work
for IBSS and possibly other modes I'd like to prepare the patchset implemen=
ting that.
This is required for IBSS-DFS later after all ...

Thanks,
	Simon

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGkim0ACgkQrzg/fFk7axbMHQCeOKJHK6PzrBZu8cFwkxqdmMqF
ZHMAoJvwjm0v5lLNalXAgstCUGqO6q+g
=6cf+
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
