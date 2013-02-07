Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:32775 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab3BGLIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 06:08:52 -0500
Date: Thu, 7 Feb 2013 12:08:44 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv8 2/3] mac80211: add radar detection command/event
Message-ID: <20130207110844.GB26957@pandem0nium> (sfid-20130207_120856_988320_68FEC93B)
References: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359982200-2321-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1360172015.7910.51.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
In-Reply-To: <1360172015.7910.51.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 06, 2013 at 06:33:35PM +0100, Johannes Berg wrote:
> On Mon, 2013-02-04 at 13:49 +0100, Simon Wunderlich wrote:
>=20
> >   *
> >   * @channel: the channel to tune to
> >   * @channel_type: the channel (HT) type
> > + * @radar_enabled: whether radar detection is enabled on this channel
>=20
> There's only one channel for ieee80211_conf ;-)
>=20

OK

> >  /**
> > + * ieee80211_radar_detected - inform a configured connection that
> > + * radar was detected on the current channel
> > + *
> > + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> > + * @gfp: context flags.
> > + */
> > +void ieee80211_radar_detected(struct ieee80211_vif *vif, gfp_t gfp);
>=20
> Given the way this works in cfg80211 and my comment there, it seems
> pointless to report per vif, but rather should be per HW?
>=20

Yeah ... might be true. userspace can see for itself if it is affected
(for the case we use 40 MHz channel and a 20 MHz user is not interested
in problems on the extension channels)

> > +	res =3D ieee80211_vif_use_channel(sdata, chandef,
> > +					IEEE80211_CHANCTX_SHARED);
> > +	if (res)
> > +		return -EBUSY;
>=20
> return res? This really can't fail here (except for memory allocation
> etc.) so -EBUSY is a bit odd.
>=20

OK

> > @@ -753,6 +753,9 @@ struct ieee80211_sub_if_data {
> >  	int user_power_level; /* in dBm */
> >  	int ap_power_level; /* in dBm */
> > =20
> > +	bool radar_required;
> > +	struct delayed_work dfs_cac_timer_work;
>=20
> Does the work struct make sense here? It seems like an inherently global
> operation, so should that be in ieee80211_local? We should check anyway
> if radar detection is requested when it's already running, I guess.
>=20
> > +++ b/net/mac80211/iface.c
> > @@ -817,6 +817,15 @@ static void ieee80211_do_stop(struct ieee80211_sub=
_if_data *sdata,
> > =20
> >  	cancel_work_sync(&sdata->recalc_smps);
> > =20
> > +	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
>=20
> OTOH, I guess if the interface is going away then you'd want to stop
> radar detection if it was done for that interface, so in that sense it
> makes sense per interface.
>=20

For the CAC I would like to keep it like this - it is used per interface. F=
or NOP
stuff it must be per wiphy to enable channels later, and it is implemented =
like that.

> > @@ -1583,6 +1592,9 @@ int ieee80211_if_add(struct ieee80211_local *loca=
l, const char *name,
> >  	spin_lock_init(&sdata->cleanup_stations_lock);
> >  	INIT_LIST_HEAD(&sdata->cleanup_stations);
> >  	INIT_WORK(&sdata->cleanup_stations_wk, ieee80211_cleanup_sdata_stas_w=
k);
> > +	INIT_DELAYED_WORK(&sdata->dfs_cac_timer_work,
> > +			  ieee80211_dfs_cac_timer_work);
> > +
>=20
> unneeded blank line
>=20
OK
> > +void ieee80211_dfs_cac_timer_work(struct work_struct *work)
> > +{
> > +	struct delayed_work *delayed_work =3D
> > +		container_of(work, struct delayed_work, work);
> > +	struct ieee80211_sub_if_data *sdata =3D
> > +		container_of(delayed_work, struct ieee80211_sub_if_data,
> > +			     dfs_cac_timer_work);
> > +
> > +	rtnl_lock();
> > +	ieee80211_vif_release_channel(sdata);
> > +	cfg80211_radar_event(sdata->dev, &sdata->vif.bss_conf.chandef,
> > +			     NL80211_RADAR_CAC_FINISHED, GFP_KERNEL);
> > +	rtnl_unlock();
> > +}
>=20
> Did you test your code with lockdep enabled? I'm almost certain using
> rtnl_lock() isn't allowed on mac80211's workqueue.
>=20

Nope, I didn't test. Will do that.

> > +void ieee80211_radar_detected(struct ieee80211_vif *vif, gfp_t gfp)
>=20
> That "gfp" argument is misleading, ...
>=20
> > +{
> > +	struct ieee80211_sub_if_data *sdata =3D vif_to_sdata(vif);
> > +
> > +	trace_api_radar_detected(sdata);
> > +
> > +	/* may happen to devices which have currently no BSS configured */
> > +	if (!cfg80211_chandef_valid(&sdata->vif.bss_conf.chandef))
> > +		return;
> > +
> > +	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
>=20
> ... since you do something that requires being able to sleep, hence the
> only useful argument you could pass as gfp is GFP_KERNEL. However, not
> being able to calls this from softirq or so is probably not desirable
> for many drivers?

Hmm ... yeah that's right. Calling it from softirqs is probably desireable.=
 Maybe
another workqueue or just use cancel_delayed_work() ... I'll think about th=
at.

Thanks,
	Simon

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlETizwACgkQrzg/fFk7axblvACfcIjDT26DIqL+VczeFTEIF8KB
OnwAoLiUAcJWPW4XLjnv5nafa5SJqhUC
=jYq3
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
