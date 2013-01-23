Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:42208 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3AWM5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 07:57:49 -0500
Date: Wed, 23 Jan 2013 13:57:42 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 0/6] Add DFS master ability
Message-ID: <20130123125742.GD23989@pandem0nium> (sfid-20130123_135752_937409_C352943B)
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1358378574.15012.62.camel@jlt4.sipsolutions.net>
 <20130117142125.GF19552@pandem0nium>
 <1358546933.7922.49.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZARJHfwaSJQLOEUz"
In-Reply-To: <1358546933.7922.49.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ZARJHfwaSJQLOEUz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 18, 2013 at 11:08:53PM +0100, Johannes Berg wrote:
> Hi,
>=20
> > As stated before: "available until ..." time is not neccessary as far
> > as I know. Also the channel must stay available when AP stops operation,
> > I'll change that.
>=20
> Yeah, I checked the documents myself now ... strange, but hey. Radars
> are fixed installations and mostly active continually, so I guess they
> figured it was no big deal.
>=20
Yup. There was this "24 hours disconnect" problem many users complained abo=
ut.
Some vendors ignored it, some actually implemented to be quiet for 1 minute
after using a channel for 24 hours. It's a good thing that this requirement
was removed. :)

> > >  * radar detection finished:
> > >    - driver: call mac80211 with result (radar detected or not)
> > >    - mac80211: free up channel context (probably needs workqueue!)
> > >                pass result to cfg80211
> > >    - cfg80211: clear wdev radar detect chandef
> > >                if OK to use: store availability in channel struct
> > >                send result to userspace
> >=20
> > Right now we only have the event for radar detect (i.e. detection
> > failed).
> >=20
> > We could add a timer to mark the channel available after the CAC time,
> > if no radar has been detected in this time. Don't know if mac80211 or
> > cfg80211 would be the best place for this, but I think the driver is not
> > - this timer must be shared over various drivers after all.
>=20
> Fair point. It seems likely though that full-MAC chips, if they
> implement this at all, would have the timer in firmware. Therefore,
> providing API for "radar detected" and "channel is usable" would make
> more sense? The timer would then go into mac80211.
>=20
> Later, if we modify the regdb format/API, we could also pass the minimum
> time from there. That way, if it ever gets changed and we want to rely
> on regdb info, we could.
>=20

OK, will look into that.

> > >  * start AP:
> > >    - cfg80211: check channel availability
> > >    - cfg80211/mac80211/driver? - enable radar detection while operati=
ng
> >=20
> > mac80211 can instruct the driver to use radar detection while operating.
> > E.g. pass it in sdata->vis.bss_conf ?
>=20
> I would say in the chanctx, i.e. struct ieee80211_chanctx_conf. Since
> not all drivers implement that yet, also struct ieee80211_conf. See how
> local->_oper_channel gets set in mac80211/chan.c. This information would
> be similar, the "master" information would be in the chandef, copied to
> local/local->hw.conf.
>=20

OK.

> > >  * AP channel switch:
> > >    - if due to radar, mark channel as not clear
> > OK - in AP case, we would have got the radar event anyway so the channel
> > would already be marked "not clear". In IBSS however, that is possible
> > (another station may have asked us to switch channel because of radar).
>=20
> Oh, I wasn't even considering that -- don't care what you do there,
> although it makes sense. OTOH, we would detect the radar ourselves, so
> it doesn't really matter?
>=20

It might happen that a radar is detected on one device but not on the other.
Think of a longshot operated with IBSS or a big mesh network. The other par=
ticipants
of the IBSS will have to switch channels as well - and the same channel wou=
ld
be good. :)

Anyway, the IBSS case is special and we can handle it later.

Cheers,
	Simon

--ZARJHfwaSJQLOEUz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD/3kYACgkQrzg/fFk7axYGEQCg7vK1z72xR93SPEsLyi7k/fp8
y6YAoMYYN4Dd5/RFEQC8tDgu3GxnL0fG
=Xtau
-----END PGP SIGNATURE-----

--ZARJHfwaSJQLOEUz--
