Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:51193 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab3ENJ1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 May 2013 05:27:41 -0400
Date: Tue, 14 May 2013 11:27:34 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFC 0/4] add master channel switch announcement support
Message-ID: <20130514092734.GA16426@pandem0nium> (sfid-20130514_112746_399775_7A710602)
References: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1368439778.8300.20.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
In-Reply-To: <1368439778.8300.20.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Johannes,

thanks for your review!

On Mon, May 13, 2013 at 12:09:38PM +0200, Johannes Berg wrote:
> On Mon, 2013-05-06 at 21:13 +0200, Simon Wunderlich wrote:
> > This is an early RFC of a possible channel switch announcement infrastr=
ucture.
> > It adds CSA/ECSA handling support for AP. This is required for DFS oper=
ation
> > (e.g. Wi-Fi Alliance requires this for 802.11h certification). This wil=
l also
> > be required for IBSS-DFS later.
> >=20
> > I'd like to discuss if this design approach is going in the right direc=
tion.
> > What is currently working:
> >=20
> >  * channels are announced by adding IEs (CSA and Extended CSA) in beaco=
ns
> >  * after some (configurable) time, the channel is switched
> >  * with the channel switch, CSA/ECSA IEs are removed and channel inform=
ation
> >    is updated.
> >  * Userspace calls a new command NL80211_CMD_CHANNEL_SWITCH along with =
channel info
> >    (freq + width), whether traffic should be blocked and timing informa=
tion
> >  * it currently works for me [TM] on my ath9k based machine
>=20
> I don't really like your approach of building all the IEs in the kernel.
> There are some things, like the country-after-switch in the CSA wrapper
> (introduced in 11ac), that would be really awkward this way.

Hmm ... OK. I have not checked 802.11ac yet (actually I don't have access t=
o the
drafts anyway). So what we have to expect is changing the country after the=
 switch,
or also other new things?

> >  * We already have NL80211_CMD_CH_SWITCH_NOTIFY which is only used for =
notification.
> >    Maybe we can rename that and re-use it instead of adding a new comma=
nd
> >    NL80211_CMD_CHANNEL_SWITCH?
>=20
> Sure, I don't really care though.
>=20
OK, will try to merge that then. Seems cleaner than having multiple channel=
 switch
commands in the API.

> >  * could other drivers (next to ath9k) work with this API?
>=20
> Probably not easily. Any TI folks reading this?

I was thinking about adding another callback function or option for that fo=
r drivers
who do the channel switch internally. Then we would only need mac80211 to a=
dapt.

Would that help, or what would be problematic?
>=20
>=20
> Anyway I think it'd be better to try to provide
>  (a) the "during-switch IEs", maybe with an offset to the counter so
> mac80211,
>      driver or the device itself can count down
>  (b) the "after-switch beacon" IEs (and maybe probe response for
o> offload)

Yeah, that would be an alternative. I've been inspired by IEEE 802.11-2012/=
6.3.17
(MLME-CHANNELSWITCH) originally. :)
I think your suggestion is good for AP where we control the beacon. For IBS=
S it
would be a little different: when a channel switch is triggered, userspace =
does
not know the beacon (and will not set it). Therefore, we could only accept =
the
change IEs and skip the "after-switch-beacon" IEs (these would be re-genera=
ted
internally) in IBSS mode. I guess it would be similar for mesh.

What do you think?

Cheers,
	Simon

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlGSA4YACgkQrzg/fFk7axbAkQCgu8lzU3na/1+shidXosrpMx4D
37IAn24g99YbH9cK8DxhnqZ72wKV/Zax
=S6KM
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
