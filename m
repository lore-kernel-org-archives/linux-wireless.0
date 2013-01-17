Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:55611 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3AQNwk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 08:52:40 -0500
Date: Thu, 17 Jan 2013 14:52:28 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 4/6] mac80211: add radar detection command/event
Message-ID: <20130117135228.GD19552@pandem0nium> (sfid-20130117_145245_276660_E37A403B)
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357650251-17425-5-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1358377171.15012.45.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
In-Reply-To: <1358377171.15012.45.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2013 at 11:59:31PM +0100, Johannes Berg wrote:
> On Tue, 2013-01-08 at 14:04 +0100, Simon Wunderlich wrote:
>=20
> > +static int ieee80211_start_radar_detection(struct wiphy *wiphy,
> > +					   struct net_device *dev,
> > +					   struct cfg80211_chan_def *chandef)
> > +{
> > +	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> > +	struct ieee80211_local *local =3D sdata->local;
> > +	int res;
> > +
> > +	if (!local->ops->start_radar_detection)
> > +		return -EOPNOTSUPP;
> > +
> > +	/* whatever, but channel contexts should not complain about that one =
*/
> > +	sdata->smps_mode =3D IEEE80211_SMPS_OFF;
> > +	sdata->needed_rx_chains =3D local->rx_chains;
> > +
> > +	if (ieee80211_vif_use_channel(sdata, chandef,
> > +				      IEEE80211_CHANCTX_SHARED))
> > +		return -EBUSY;
>=20
> Should probably return whatever error vif_use_channel() returned?
>=20

OK

> > +	res =3D drv_start_radar_detection(local, sdata, chandef);
>=20
> If the vif is assigned the channel, why also pass it to the
> start_radar_detection command? That seems pointless, they can't be
> different?
>=20
In the initial phase, __nl80211_set_channel() should not be able to set
the channel (no CAC yet), and will fail for IBSS (to be implemented later)
generally, at least as it's implemented now.

But what we can do is set the channel from mac80211 and call the driver
function without the channel argument, as it'll be pointless in this case.
Is this what you mean?

> > +++ b/net/mac80211/iface.c
> > @@ -826,6 +826,10 @@ static void ieee80211_do_stop(struct ieee80211_sub=
_if_data *sdata,
> >  					 u.vlan.list)
> >  			dev_close(vlan->dev);
> >  		WARN_ON(!list_empty(&sdata->u.ap.vlans));
> > +
> > +		/* reset DFS channel availability check */
> > +		if (local->_oper_channel)
> > +			local->_oper_channel->cac_started =3D false;
>=20
> That doesn't really belong here, does it? Seems like it should be in
> cfg80211. Actually, should it be there at all?

Actually, no, you are right. After stopping an AP and no radar is detected,
the channel should go from "operational" back to "available" state. Quoting
=66rom ETSI EN 3001-893 v1.7.1

4.7.1.3/Master Devices/

c) Once the RLAN has started operations on an Available Channel, then that =
channel becomes an Operating Channel. During normal operation, the master d=
evice shall monitor all Operating Channels (In-Service Monitoring) to ensur=
e that there is no radar operating within these channel(s). If no radar was=
 detected on an Operating Channel but the RLAN stops operating on that chan=
nel, then the channel becomes an Available Channel.

I'll change that.

>=20
> If we allow using the channel for some amount of time after doing the
> CAC, even if we haven't been on the channel continuously, then we should
> also allow using the channel after stopping the AP for that much time.
>=20
> IOW -- deactivating should cause the timeout to start running.

As stated in a mail earlier from this patchset, a timeout ist not neccessar=
y.

I'd skip this patch entirely.

>=20
> Actually that raises another question: If we have "external" radar
> detection, say by a different NIC, then shouldn't we still ask the
> driver to start radar detection when using the channel? Or is that
> implicit, does the driver have to check?

That is a good question, I didn't consider that. In the "simple process"
we first start radar detection and start the ap on the same channel.
For external CAC that won't work, of course. What about mac80211 checking
the channel in start_ap(), and if the channel requires DFS, pass some flag
to the driver that radar detection should be enabled?

>=20
> It seems the driver API needs a lot more documentation :-)

Agreed, but I guess we still need to discuss some corner cases to get the
neccesary input for documentation. ;)

>=20
>=20
> > +++ b/net/mac80211/trace.h
> > @@ -45,6 +45,35 @@
> >  			__entry->center_freq1, __entry->center_freq2,		\
> >  			__entry->rx_chains_static, __entry->rx_chains_dynamic
> > =20
> > +#define CHAN_DEF_ENTRY __field(enum ieee80211_band, band)		\
>=20
> I'll apply my "mac80211: split out chandef tracing macros" patch
> instead.

OK.
>=20
>=20
> Also: once the CAC is completed, shouldn't the channel context be freed
> up in mac80211, or something like that?

Currently we don't handle the event "CAC finished" explicitly - we only have
the cac_started/timeout fields. More on that later ...

Cheers,
	Simon

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD4AhwACgkQrzg/fFk7axZHhgCguQco+1K74CleWtaM7IkypRKT
5+4AoMXwOdETKeJK2Niw88r5k4O9j2Sr
=ikoq
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
