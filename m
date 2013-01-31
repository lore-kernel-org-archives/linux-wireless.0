Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:35024 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab3AaQbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 11:31:36 -0500
Date: Thu, 31 Jan 2013 17:31:26 +0100
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
Message-ID: <20130131163126.GB1387@pandem0nium> (sfid-20130131_173140_013390_48C33ABE)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359643448.8415.62.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
In-Reply-To: <1359643448.8415.62.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 03:44:08PM +0100, Johannes Berg wrote:
> On Tue, 2013-01-29 at 13:21 +0100, Simon Wunderlich wrote:
>=20
> > +void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
> > +				    struct ieee80211_chanctx *chanctx)
> > +{
> > +	struct ieee80211_sub_if_data *sdata;
> > +	bool radar_enabled =3D false;
> > +
> > +	lockdep_assert_held(&local->chanctx_mtx);
> > +
> > +	rcu_read_lock();
> > +	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > +		if (sdata->radar_required)
> > +			radar_enabled =3D true;
>=20
> I guess you could break here.=20

yes, OK.

> Technically though I'm not sure this is
> right, since it should only iterate interfaces on this chanctx. OTOH,
> multiple channel contexts aren't (currently?) allowed anyway.

I wonder of multiple channel contexts ever make sense for the DFS case.
If they do, we would have to change this anyway to detect radars on
one channel but (maybe) not on the other ... Anyway, I would leave that
to future strategists. ;)

>=20
> > +	chanctx->conf.radar_enabled =3D radar_enabled;
> > +	local->radar_detect_enabled =3D chanctx->conf.radar_enabled;
>=20
> What's the reason for "local->radar_detect_enabled"?

Interaction checking with ROC and scan.
>=20
> Btw, do we also make the driver responsible for turning off any
> powersave when radar detection is enabled? I guess so?
>=20
> > @@ -817,6 +817,15 @@ static void ieee80211_do_stop(struct ieee80211_sub=
_if_data *sdata,
> > =20
> >  	cancel_work_sync(&sdata->recalc_smps);
> > =20
> > +	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
> > +
> > +	/* only inform about abort cac if it was started before. */
> > +	if (sdata->wdev.cac_started) {
>=20
> I'm not entirely sure we should use the wdev data here, OTOH it seems
> safe, so why not.
>=20

If you don't mind, it's easier like that ... ;)

> > +void ieee80211_dfs_cac_timer_work(struct work_struct *work)
> > +{
> > +	struct delayed_work *delayed_work =3D
> > +		container_of(work, struct delayed_work, work);
> > +	struct ieee80211_sub_if_data *sdata =3D
> > +		container_of(delayed_work, struct ieee80211_sub_if_data,
> > +			     dfs_cac_timer_work);
> > +
> > +	rtnl_lock();
>=20
> what part requires rtnl?
>=20
ieee80211_vif_release_channel() calls __ieee80211_vif_release_channel()
and has ASSERT_RTNL() before parsing the AP VLAN list.

cfg80211_radar_event() probably doesn't need it ... I should remove it
=66rom the rtnl lock, I guess?

> > +void ieee80211_radar_detected(struct ieee80211_vif *vif, gfp_t gfp)
> > +{
> > +	struct ieee80211_sub_if_data *sdata =3D vif_to_sdata(vif);
> > +
> > +	trace_api_radar_detected(sdata);
> > +
> > +	/* may happen to devices which have been added but are not up */
> > +	if (!cfg80211_chandef_valid(&sdata->vif.bss_conf.chandef))
> > +		return;
>=20
> Huh, what does device and up have to do with that?
>=20

What I've tried:
 * configure 2 SSIDs in hostapd, start it
 * both wlan0 and wlan0-1 got created
 * only wlan0 comes up, wlan0-1 was rejected because of missing channel com=
binations
 * now I've injected a radar - which should be sent to wlan0 and wlan0-1
 * wlan0 could send the event, but wlan0-1 had no bss configured and theref=
ore no chandef

I can change this comment to "may happen to devices which have currently no=
 BSS configured",
maybe that it is not so confusing ...

> >  static bool ieee80211_can_scan(struct ieee80211_local *local,
> >  			       struct ieee80211_sub_if_data *sdata)
> >  {
> > +	if (local->radar_detect_enabled)
> > +		return false;
>=20
> Oh, ok. I guess that explains the reason for radar_detect_enabled :)

Yup. :)

Cheers,
	Simon

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEKnF4ACgkQrzg/fFk7axY88gCgvaNc6nH2qAUElueq1K6slfGU
VZMAmgKRYVqDAIdOY8IaW6jKGKYSaXaZ
=BScQ
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
