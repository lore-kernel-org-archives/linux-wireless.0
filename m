Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbYJBLQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 07:16:22 -0400
Subject: Re: [PATCH 1/2 V2] mac80211: send action frame when toggling SM PS
	mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240810020403r56d02416k60f45e9e6fb95fd8@mail.gmail.com> (sfid-20081002_130345_325234_6F0CD7F5)
References: <1222805245-31166-1-git-send-email-tomas.winkler@intel.com>
	 <1222936652.24551.30.camel@johannes.berg>
	 <1ba2fa240810020403r56d02416k60f45e9e6fb95fd8@mail.gmail.com>
	 (sfid-20081002_130345_325234_6F0CD7F5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oPShKI/DxsVfbVfFEA1k"
Date: Thu, 02 Oct 2008 13:15:49 +0200
Message-Id: <1222946149.24551.49.camel@johannes.berg> (sfid-20081002_131625_902616_7DF109B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oPShKI/DxsVfbVfFEA1k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-02 at 14:03 +0300, Tomas Winkler wrote:

> >> +static void ieee80211_send_sm_ps(struct ieee80211_sub_if_data *sdata,=
 u8 mode)
> >
> > Can we use an enum for 'mode'?
>=20
> We use spec numbers here why to invent more numbers.

Well we can also just put the spec numbers into an enum and use that
enum here. enum doesn't mean that we don't fix the numbers :)

> >> +     /* Implemented for STA only */
> >> +     if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> >> +             return;
> >
> > What about mesh, ibss, wds, ...? I see this doesn't make much sense for
> > an AP, but...?
>=20
> This is explicitly defined in spec for STA mode.

Ok. Maybe change the comment then so that it's more obvious.

> > It seems that for the second use case you're citing you've now done
> > something that might lead to bouncing back and forth because there is n=
o
> > central instance deciding on the powersave mode. You seem to be trying
> > to avoid this by introducing the two new variables sm_ps_psp_mode and
> > sm_ps_cam_mode, but this seems very strange. Is the driver supposed to
> > modify them at runtime?
>=20
> No it should be set on registration only
>=20
> What sort of policy does the driver impose on
> > them? Why is this policy driver-specific?
>=20
> Depends on radio ability rather then policy. The only policy that is
> set here is that we coupling SM PS and PS
>=20
> Why doesn't the driver just
> > inform mac80211 of the antenna status and mac80211 then decides based o=
n
> > the antenna status and the requested powersave mode which SM PS mode
> > should be activated, and then notifies the driver of that?
>=20
> Correct that's the solution, just keep in mind that driver change rx
> chain configuration upon SM PS request as well.

Yeah but you were saying it's about detecting whether MIMO is effective
or not. So I think what makes more sense is to have the driver _only_
push that information to mac80211, and then wait for mac80211 to make a
decision about the SM PS mode, and not reconfigure its chains
immediately. Therefore, it wouldn't change chain configuration when it
detects MIMO doesn't work, it would only do that when mac80211 requests
it based on the information.

> > I'd much rather see you implement this in a different way:
> >  * a HW flag that determines whether the driver can wake up with or
> >   without an RTS frame (?)
>=20
> Not enough there are 3 states you may request in SM_PS

Yes, but this is just a hardware capability which indirectly influences
the PS mode, no? So not having the wakeup-without-rts capability may
mean that SM_PS_XYZ cannot be used or whatever.

> >   - possibly interface modes (maybe no need for MIMO when in mesh etc.)
>=20
> Out of scope, HT is not enabled at all in these modes.

currently.

I'll look at more details after lunch.

johannes

--=-oPShKI/DxsVfbVfFEA1k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI5K1iAAoJEKVg1VMiehFYrREP/jTeHRBpY1Em86NU+v55ZytY
0VG8X/fNe3Afr1PpzDC3Ue9sqOBvi1hdhDuDHBrcvaZg9P5mWB5OOZE+77+Qv03C
ccGcEgbb/MWBGM9klIbgAN27cY1BFdqGsC0HAjjQcS1SPggz30Uv2jwRzrUlxEAi
YqMH3biN43vJzXqgsA38OhMwN1tW2tSG5HCzgbyIPwL31sYDOuU5S4zI3jPIRrAn
wjdu1yXXeMPC0JWJ7f3teLiW/hOz9ZTQpAQVtNm6aAki77V7mw1zyalznyWTSoqb
VLUccCubMrU57u9vfiKffg2IGnc6P32JItVyzRd573Ph69NqG8DX1wuWg2Qn4PZA
LbD5bWk73IRszEQktbuod/Uh7ijsszVDMtt55d+dyQAlze8IlRUGLmaC5mzkD762
cc8qt4b9z0fxqdiuglw0B5KicMmd2z+deKQDfa9Hbv/BMMK3wlb61NtPsJRZNFw7
0TAxgFOJ1+JPeCo0zjnz0jHB2rUf/C11YlASQKphVaR85lM0ViLojIlDZ2TMLLbN
eNCd+OnKDYH/2AWx0cafavveYIz3LUX6CPKYb0XNAaGu1MuwK91t0bYRBYTHpIYJ
ub6ax7fTpGv3Awg0cwkKgkBWprNPnMvDGc+gH5MMTQY6gHlz7aDbjUtipsBRPFWY
k4Xb+2mcISEZjvZGq2e4
=K+00
-----END PGP SIGNATURE-----

--=-oPShKI/DxsVfbVfFEA1k--

