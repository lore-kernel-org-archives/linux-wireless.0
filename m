Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:39725 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3BBWP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2013 17:15:56 -0500
Date: Sat, 2 Feb 2013 23:15:44 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 2/3] mac80211: add radar detection command/event
Message-ID: <20130202221544.GA22363@pandem0nium> (sfid-20130202_231600_462098_F4B717AC)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359643448.8415.62.camel@jlt4.sipsolutions.net>
 <20130131163126.GB1387@pandem0nium>
 <1359650902.8415.93.camel@jlt4.sipsolutions.net>
 <20130131174758.GC2018@pandem0nium>
 <1359712620.8528.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
In-Reply-To: <1359712620.8528.5.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 01, 2013 at 10:57:00AM +0100, Johannes Berg wrote:
> On Thu, 2013-01-31 at 18:47 +0100, Simon Wunderlich wrote:
>=20
> > > > What I've tried:
> > > >  * configure 2 SSIDs in hostapd, start it
> > > >  * both wlan0 and wlan0-1 got created
> > > >  * only wlan0 comes up, wlan0-1 was rejected because of missing cha=
nnel combinations
> > > >  * now I've injected a radar - which should be sent to wlan0 and wl=
an0-1
> > > >  * wlan0 could send the event, but wlan0-1 had no bss configured an=
d therefore no chandef
> > > >=20
> > > > I can change this comment to "may happen to devices which have curr=
ently no BSS configured",
> > > > maybe that it is not so confusing ...
> > >=20
> > > Not sure I understand, how would the radar detected event come to an
> > > interface that doesn't really exist for the driver?
> >=20
> > wlan0-1 exists and was created, but no AP was ever started - because ho=
stapd tried
> > to start the AP on a DFS channel when wlan0 was already active, and tha=
nks to our
> > interface combinations this is not allowed. Therefore, the vif.bss_conf=
=2Echandef is empty.
> >=20
> > The interface does exist for the driver (interface add succeeded), but =
start_ap failed,
> > so it is a virgin AP interface.
> >=20
> > I think this behaviour is correct like that ...
>=20
> So ... starting the AP failed because it was a different channel, it was
> added to the driver because multiple AP interfaces were allowed but the
> specific channel wasn't allowed (in addition) when it was started? But I
> still don't see why that interface should get an event since it doesn't
> even have a channel yet, except maybe preset_chan which is really only
> for backward compatibility reasons?
>=20
> What am I missing? Where does the event on wlan0-1 come from anyway?

In the (dummy) ath9k part I'm handling the radar by simply sending radar ev=
ents
to all ieee80211_vifs which are registered on this phy - regardless their
status, if they are up or not. That's why both wlan0 and wlan0-1 get the
event in my example. Of course, sending the event to wlan0-1 is pretty
useless in my case, but we should better check. :)

Cheers,
	Simon
>=20

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlENkBAACgkQrzg/fFk7axaP5QCg7Sp6CZgjqQA6GnltlijC8D4L
BooAniLh40bGag3XhYy9sIpBJoujmbfE
=hSmJ
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
