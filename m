Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:59654 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3BGLBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 06:01:00 -0500
Date: Thu, 7 Feb 2013 12:00:49 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv8 1/3] nl80211/cfg80211: add radar detection
 command/event
Message-ID: <20130207110047.GA26957@pandem0nium> (sfid-20130207_120104_319932_27AC4FFE)
References: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359982200-2321-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1360171448.7910.43.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
In-Reply-To: <1360171448.7910.43.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 06, 2013 at 06:24:08PM +0100, Johannes Berg wrote:
> On Mon, 2013-02-04 at 13:49 +0100, Simon Wunderlich wrote:
>=20
> >  /**
> > + * cfg80211_chandef_dfs_required - checks if radar detection
> > + *	is required on any of the channels
>=20
> pretty sure this isn't valid kernel-doc, I think it has to fit into one
> line
>=20
OK
> > @@ -3663,6 +3694,21 @@ void cfg80211_cqm_rssi_notify(struct net_device =
*dev,
> >  			      gfp_t gfp);
> > =20
> >  /**
> > + * cfg80211_radar_event - radar detection event
> > + * @dev: network device
> > + * @chandef: chandef for the current channel
> > + * @event: type of event
> > + * @gfp: context flags
> > + *
> > + * This function is called when a radar is detected or a CAC event occ=
ured
>=20
> occurred :)
>=20
>=20
OK
> > @@ -2014,6 +2029,7 @@ enum nl80211_band_attr {
> >   *	(100 * dBm).
> >   * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
> >   *	currently defined
> > + * @NL80211_FREQUENCY_ATTR_DFS_STATE: current state for DFS
>=20
> missed docs for _DFS_TIME, maybe should put it before _MAX :)
> also, what values does this take?
>=20
Yeah, I'll fix that. States are the DFS states below.

> > +/**
> > + * enum nl80211_dfs_state - DFS states for channels
> > + *
> > + * Channel states used by the DFS code.
> > + *
> > + * @IEEE80211_DFS_USABLE: The channel can be used, but channel availab=
ility
> > + *	check (CAC) must be performed before using it for AP or IBSS.
> > + * @IEEE80211_DFS_UNAVAILABLE: A radar has been detected on this chann=
el, it
> > + *	is therefore marked as not available.
> > + * @IEEE80211_DFS_AVAILABLE: The channel has been CAC checked and is a=
vailable.
> > + */
> > +
> > +enum nl80211_dfs_state {
> > +	NL80211_DFS_USABLE	=3D 0,
>=20
> I don't really see a reason for explicit values?
>=20

You've suggested explicit values yourself last time [1], or did I misunders=
tand?

[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/103278
"Should UNAVAILABLE be =3D 0, so that's the default?" (usable should be the=
 default, btw)

> > +static inline int cfg80211_chandef_get_width(const struct cfg80211_cha=
n_def *c)
>=20
> no need for inline
>=20
OK

> > +int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
> > +				  const struct cfg80211_chan_def *chandef)
> > +{
> > +	int width;
> > +	int r;
> > +
> > +	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
> > +		return -EINVAL;
> > +
> > +	width =3D cfg80211_chandef_get_width(chandef);
> > +	if (width < 0)
> > +		return -EINVAL;
> > +
> > +	r =3D cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq1,
> > +					    width);
> > +	if (r)
> > +		return r;
> > +
> > +	if (!chandef->center_freq2)
> > +		return 0;
> > +
> > +	return cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq2,
> > +					       width);
> > +}
>=20
> If you don't export it why is it in the public header file -- either you
> need to export it as well or it doesn't need to be in cfg80211.h :)
>=20

right, will move it into net/wireless/core.h

> > @@ -454,6 +462,16 @@ cfg80211_can_use_chan(struct cfg80211_registered_d=
evice *rdev,
> >  					    chan, chanmode, 0);
> >  }
> > =20
> > +static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
> > +{
> > +	unsigned long end =3D jiffies;
> > +
> > +	if (end >=3D start)
> > +		return jiffies_to_msecs(end - start);
> > +
> > +	return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
> > +}
>=20
> That seems a bit magic, like it should be hidden away in jiffies.h. Is
> there really no function already to do something like this?
>=20

I've just moved this magic function from scan.c to core.h because I need it=
 too.
It appears another driver (drivers/net/wireless/ipw2x00) also implements th=
is
privately. We can suggest this patch for include/linux/jiffies.h if you pre=
fer.

> > +static void cfg80211_notify_nop_ended(struct cfg80211_registered_devic=
e *rdev,
> > +					struct ieee80211_channel *c)
>=20
> indentation :)
>=20

OK

> > +{
> > +	struct wireless_dev *wdev;
> > +	struct cfg80211_chan_def chandef;
> > +
> > +	cfg80211_chandef_create(&chandef, c, NL80211_CHAN_NO_HT);
> > +
> > +	mutex_lock(&rdev->devlist_mtx);
> > +	list_for_each_entry(wdev, &rdev->wdev_list, list) {
> > +		if (!wdev->netdev)
> > +			continue;
> > +
> > +		if (!netif_running(wdev->netdev))
> > +			continue;
> > +
> > +		nl80211_radar_notify(rdev, &chandef,
> > +				     NL80211_RADAR_NOP_FINISHED,
> > +				     wdev->netdev, GFP_ATOMIC);
> > +	}
>=20
> Why for all interfaces? This is multicast anyway, so why not just send
> the event without an interface index instead?
>=20

Hmm. I'll try. ;)

> > --- a/net/wireless/scan.c
> > +++ b/net/wireless/scan.c
> > @@ -1155,16 +1155,6 @@ static void ieee80211_scan_add_ies(struct iw_req=
uest_info *info,
> >  	}
> >  }
> > =20
> > -static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
> > -{
> > -	unsigned long end =3D jiffies;
> > -
> > -	if (end >=3D start)
> > -		return jiffies_to_msecs(end - start);
> > -
> > -	return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
> > -}
>=20
> Oh, heh. Oh well ...

:P

>=20
> I think I should probably look at locking too ...

Would be a good idea. I'll verify with lockdep enabled too, didn't do it so=
 far.

Thanks!
	Simon

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlETiV8ACgkQrzg/fFk7axaibgCgwUksuPcRInCRijDxjq5LKj6e
yD0AoNNbVzZMSKbFBsl9vSlQMldiHu1a
=FnJ2
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
