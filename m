Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:53889 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3AQNkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 08:40:47 -0500
Date: Thu, 17 Jan 2013 14:40:34 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 3/6] nl80211/cfg80211: add radar detection
 command/event
Message-ID: <20130117134034.GC19552@pandem0nium> (sfid-20130117_144052_078395_A7029950)
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357650251-17425-4-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1358376672.15012.37.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
In-Reply-To: <1358376672.15012.37.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--s9fJI615cBHmzTOP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2013 at 11:51:12PM +0100, Johannes Berg wrote:
> On Tue, 2013-01-08 at 14:04 +0100, Simon Wunderlich wrote:
>=20
>=20
> > + * @radar_detect_timeout: this timeout indicates the end of the channel
> > + *     availability check for radar channels (in jiffies), only after =
this
> > + *     period the user may initiate the tx on the channel.
> > + * @cac_started: indicates that channel availability check is started =
for this
> > + *     channel type.
>=20
> So you're enforcing a certain CAC time, but not the time we are allowed
> to treat the channel as clear? Shouldn't *that* be in each channel
> struct, rather than the other stuff?
>=20
> It also seems to me that "cac_started" isn't really all that relevant in
> the channel struct either. What seems relevant is the *result* of the
> CAC, and how long it's still valid, no?
>=20

Actually there is no limit how long a channel is considered "available", at
least in ETSI. ETSI EN 301-893 v1.4.1 had a limit of 24 hours for that,
but that was removed in v1.5.1 and didn't re-appear since then (current is
v1.7.1).

But we can move the CAC/timeout in the wdev and have keep a flag field in
the channel struct instead, marking the channel as available, unavailable, =
etc.

What do you think?

> > +++ b/net/wireless/chan.c
> > @@ -287,14 +287,18 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
> >  			     struct cfg80211_chan_def *chandef)
> >  {
> >  	bool res;
> > +	u32 prohibited_flags;
> > =20
> >  	trace_cfg80211_reg_can_beacon(wiphy, chandef);
> > =20
> > -	res =3D cfg80211_chandef_usable(wiphy, chandef,
> > -				      IEEE80211_CHAN_DISABLED |
> > -				      IEEE80211_CHAN_PASSIVE_SCAN |
> > -				      IEEE80211_CHAN_NO_IBSS |
> > -				      IEEE80211_CHAN_RADAR);
> > +	prohibited_flags =3D IEEE80211_CHAN_DISABLED;
> > +
> > +	if (!(wiphy->features & NL80211_FEATURE_DFS))
> > +		prohibited_flags |=3D IEEE80211_CHAN_PASSIVE_SCAN |
> > +				    IEEE80211_CHAN_NO_IBSS |
> > +				    IEEE80211_CHAN_RADAR;
>=20
> I have a feeling this change should take into account the channel width,
> and whether CAC completed successfully?
>=20

All channels used for operation are checked already in cfg80211_chandef_usa=
ble()
for the flags.

If the channel width is supported at all is checked with cfg80211_can_use_i=
ftype_chan()
before/after.

So I don't see the neccesity for further checking width, or am I missing so=
mething?

The CAC completed check is performed outside right now, but when we introdu=
ce
the available/unavailable flags as suggested above we can as well move this=
 check
into cfg80211_reg_can_beacon().

> > +static int nl80211_start_radar_detection(struct sk_buff *skb,
> > +					 struct genl_info *info)
> > +{
> > +	struct cfg80211_registered_device *rdev =3D info->user_ptr[0];
> > +	struct net_device *dev =3D info->user_ptr[1];
> > +	struct wireless_dev *wdev =3D dev->ieee80211_ptr;
> > +	struct cfg80211_chan_def chandef;
> > +	int err;
> > +
> > +	if (!(rdev->wiphy.features & NL80211_FEATURE_DFS))
> > +		return -EOPNOTSUPP;
> > +
> > +	err =3D nl80211_parse_chandef(rdev, info, &chandef);
> > +	if (err)
> > +		return err;
> > +
> > +	if (!(chandef.chan->flags & IEEE80211_CHAN_RADAR))
> > +		return -EINVAL;
> > +
> > +	if (chandef.chan->cac_started)
> > +		return -EBUSY;
> > +
> > +	if (!rdev->ops->start_radar_detection)
> > +		return -EOPNOTSUPP;
> > +
> > +	mutex_lock(&rdev->devlist_mtx);
> > +	err =3D cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
> > +					   chandef.chan, CHAN_MODE_SHARED,
> > +					   BIT(chandef.width));
> > +	mutex_unlock(&rdev->devlist_mtx);
> > +
> > +	if (err)
> > +		return err;
> > +
> > +	err =3D rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
> > +	if (!err) {
> > +		wdev->preset_chandef =3D chandef;
> > +		chandef.chan->cac_started =3D true;
> > +		chandef.chan->radar_detect_timeout =3D jiffies +
> > +			msecs_to_jiffies(NL80211_DFS_MIN_CAC_TIME_MS);
> > +	}
> > +
> > +	return err;
> > +}
>=20
> This still seems somewhat wrong. For the duration of the CAC, the
> channel should be "locked" in some way, no? As it stands now, nothing
> prevents userspace from adding another vif and using it for something
> entirely different, while cfg80211 thinks the CAC is actually running.
>=20

Hmm, we can put the "CAC state" in the wdev then, and use it for locking?

> > +	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
> > +	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
> > +	    nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ, chan->center_freq))
> > +		goto nla_put_failure;
>=20
> That should be the entire chandef info, and possibly the WDEV_ID too.

OK

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD3/1IACgkQrzg/fFk7axauxwCgsFuNN/piUUqy6vL01wnaCLSO
axAAnjSnGHsVai+t3HiYP3ybsFI9A9Ws
=oXqB
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--
