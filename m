Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:46862 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab3AaQN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 11:13:58 -0500
Date: Thu, 31 Jan 2013 17:13:46 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 1/3] nl80211/cfg80211: add radar detection
 command/event
Message-ID: <20130131161346.GA1387@pandem0nium> (sfid-20130131_171404_383203_A016C34E)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359642321.8415.56.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
In-Reply-To: <1359642321.8415.56.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Johannes,

thanks for the review!

On Thu, Jan 31, 2013 at 03:25:21PM +0100, Johannes Berg wrote:
> On Tue, 2013-01-29 at 13:21 +0100, Simon Wunderlich wrote:
>=20
> > From: Victor Goldenshtein <victorg@ti.com>
>=20
> Probably time for you to claim ownership ... ;-)
>=20

maybe ... I've changed most of the original patch, actually. I'll keep
his name in the commit message though ..

> > Changes to PATCHv6:
>=20
> Thanks for your patience and the frequent posting :-)
>=20

Well, thanks for your patience ;)

> >  /**
> > + * enum ieee80211_dfs_state - DFS states for channels
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
> > +enum ieee80211_dfs_state {
> > +	IEEE80211_DFS_USABLE,
> > +	IEEE80211_DFS_UNAVAILABLE,
> > +	IEEE80211_DFS_AVAILABLE,
>=20
> Should UNAVAILABLE be =3D 0, so that's the default?
>=20

yeah, good idea.


> > @@ -133,6 +151,9 @@ enum ieee80211_channel_flags {
> >   *	to enable this, this is useful only on 5 GHz band.
> >   * @orig_mag: internal use
> >   * @orig_mpwr: internal use
> > + * @dfs_state: current state of this channel. Only relevant if radar i=
s required
> > + *	on this channel.
> > + * @dfs_state_entered: time when the dfs state was entered.
>=20
> This is relevant for "unavailable", presumably, to make sure it stays
> there for long enough? What unit is that, and how long does it have to
> stay? "jiffies" can become unreliable after a long uptime so that might
> cause issues. It's unlikely, the issue would be that ~25 days after it
> was supposed to be available again it would be rejected as jiffies got
> back to the same value ... :)
> Also depends on your implementation which I haven't seen yet.
>=20
Right, this is used for unavailable - The Non-Occupancy period (NOP) time
is 30 minutes, for FCC it should be the same. All times in DFS are < 24 hou=
rs,
and we check this time with our own timers in kernel, so I don't think we w=
ill
ever hit the jiffies overrun. I would prefer using jiffies because it's ind=
ependent
of system time changes and enough for this task.

I'll add that the time is jiffies in documentation.

> > @@ -412,6 +435,16 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
> >  			     u32 prohibited_flags);
> > =20
> >  /**
> > + * cfg80211_chandef_dfs_required - checks if radar detection
> > + *	is required on any of the channels
> > + * @wiphy: the wiphy to validate against
> > + * @chandef: the channel definition to check
> > + * Return: 1 if radar detection is required, 0 if it is not, < 0 on er=
ror
> > + */
> > +int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
> > +				  const struct cfg80211_chan_def *c);
>=20
> Why does that need to be exported to mac80211/drivers? Shouldn't
> cfg80211 be able to check everything?
>=20
I'm using it in mac80211/ieee80211_start_ap() to find out whether radar det=
ection
is required. We could put into struct cfg80211_ap_settings *params if you p=
refer?
I guess similar params exist for IBSS.

> >  struct wireless_dev {
> >  	struct wiphy *wiphy;
> > @@ -2638,6 +2678,8 @@ struct wireless_dev {
> > =20
> >  	u32 ap_unexpected_nlportid;
> > =20
> > +	bool cac_started;
>=20
> Don't you need a cac_chandef or something?
>=20

The chandef is stored into wdev->preset_chandef anyway, so I didn't see any
need to save it twice?

> >  /**
> > + * cfg80211_radar - radar detection event
> > + * @dev: network device
> > + * @chandef: chandef for the current channel
>=20
> Doesn't cfg80211 know what channel the device is operating/doing CAC on?
>=20

Whoops, typo in the description - forgot the _event :)

Anyway, the idea was that a driver can report a radar only for a certain pa=
rt of
the currently used spectrum - e.g. we sense a radar on the extension channe=
l in HT40+,
we would need to move but could still use the primary channel.

I don't know if this is overkill since we don't support any more than HT20 =
yet, but
that would be kind of future proof.


> > +#define NL80211_DFS_MIN_CAC_TIME_MS		60000
> > +#define NL80211_DFS_MIN_NOP_TIME_MS		(30 * 60 * 1000)
>=20
> Why are those needed in the userspace API?
>=20

Hm, not needed anymore I guess, it's just a nice reference ... will move it=
 to other header
files (probably cfg80211.h) then.

> > @@ -3221,6 +3240,7 @@ enum nl80211_feature_flags {
> >  	NL80211_FEATURE_P2P_GO_CTWIN			=3D 1 << 11,
> >  	NL80211_FEATURE_P2P_GO_OPPPS			=3D 1 << 12,
> >  	NL80211_FEATURE_FULL_AP_CLIENT_STATE		=3D 1 << 13,
> > +	NL80211_FEATURE_DFS				=3D 1 << 14,
>=20
> I don't think we need this any more with the interface combinations
> thing?
>=20

Right, this is obsolete now. Will remove it.

> > +static void cfg80211_set_chans_dfs_state(struct wiphy *wiphy, u32 cent=
er_freq,
> > +					 u32 bandwidth,
> > +					 enum ieee80211_dfs_state dfs_state)
> > +{
> > +	struct ieee80211_channel *c;
> > +	u32 freq;
> > +
> > +	for (freq =3D center_freq - bandwidth/2 + 10;
> > +	     freq <=3D center_freq + bandwidth/2 - 10;
> > +	     freq +=3D 20) {
> > +		c =3D ieee80211_get_channel(wiphy, freq);
> > +		if (!c || !(c->flags & IEEE80211_CHAN_RADAR))
> > +			continue;
> > +
> > +		c->dfs_state =3D dfs_state;
> > +		c->dfs_state_entered =3D jiffies;
>=20
> I wonder if it'd make sense to not skip if the radar flag isn't set,
> that could be relevant with regdom changes? OTOH, if the regdom changes
> (much) I *suspect* we need to invalidate all the radar measurements
> anyway since the rules might now be different?
>=20

IMHO the channels should be cleared on each regdom change. At least radar
patterns are different from FCC and ETSI (although I don't know if there is
a pattern in FCC which can be ignored in ETSI and vice versa). To be sure,
I would vote for complete reset.

> > +int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
> > +				  const struct cfg80211_chan_def *chandef)
> > +{
> > +	u32 width;
> > +	int r;
> > +
> > +	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
> > +		return -EINVAL;
> > +
> > +	width =3D cfg80211_chandef_get_width(chandef);
> > +	if (width < 0)
>=20
> never true with a u32, I think you might want to change the function
> prototype and the variable :)
>=20

Whoops, right, thanks!

> > @@ -344,7 +467,10 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
> >  		break;
> >  	case NL80211_IFTYPE_AP:
> >  	case NL80211_IFTYPE_P2P_GO:
> > -		if (wdev->beacon_interval) {
> > +		if (wdev->cac_started) {
> > +			*chan =3D wdev->preset_chandef.chan;
> > +			*chanmode =3D CHAN_MODE_SHARED;
>=20
> Ah, ok, so you're using the preset_chandef for CAC as well. I'm not
> entirely sure that is correct though, since it could be changed by
> userspace without much effect, e.g. by setting the channel with iw or
> iwconfig? Unless you added "if (!cac_started)" there everywhere?
>=20

Hmm, actually I've tried setting the frequency with iw and got a EINVAL bac=
k.
I'll look into it again if I missed something, but thought it would be good=
 to
not have this stuff redundant.

> > +static inline void __cfg80211_dfs_clear_channel(struct ieee80211_chann=
el *c,
>=20
> no reason for inline
>=20
OK

> > +						bool *check_again,
> > +						unsigned long *check_again_time)
> > +{
> > +	unsigned long timeout;
> > +
> > +	if (c->dfs_state =3D=3D IEEE80211_DFS_UNAVAILABLE) {
>=20
> could save on indentation by returning early if it's not unavailable :-)

right, thanks.
>=20
> I guess this addresses the jiffies concern I had above.
>=20

OK - the state is entered via cfg80211_radar_event() when a radar is receiv=
ed.

> > +		timeout =3D c->dfs_state_entered + NL80211_DFS_MIN_NOP_TIME_MS;
> > +		if (time_after_eq(jiffies, timeout)) {
> > +			/* TODO: we could notify userspace about that change */
> > +			c->dfs_state =3D IEEE80211_DFS_USABLE;
> > +		} else {
> > +			if (!*check_again)
>=20
> should probably set it to false when the function starts, now you rely
> on it being set outside which is a bit odd? (or did I just snip that
> from my reply and don't see it any more?)
>=20

Actually I just have this function because I refactored
cfg80211_dfs_channels_update_work(), I had some trouble with the 80 charact=
ers
limit ... ;)

So yes, I rely on check_again set outside because I expect to only be used =
by
cfg80211_dfs_channels_update_work(). I'll try to write this nicer ...

> > +	err =3D cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
> > +	if (err < 1)
> > +		return err;
>=20
> That doesn't make sense, if userspace starts CAC and that is successful
> it would expect to eventually receive an event that it completed? Thus
> if you return 0 here it would get confused, no?
>=20

Ah yes, I should probably return EINVAL in this case, or the appropriate
error code otherwise ...=20

> > +	if (chandef.chan->dfs_state !=3D IEEE80211_DFS_USABLE)
> > +		return -EINVAL;
> > +
> > +	if (!rdev->ops->start_radar_detection)
> > +		return -EOPNOTSUPP;
> > +
> > +	mutex_lock(&rdev->devlist_mtx);
> > +	err =3D cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
> > +					   chandef.chan, CHAN_MODE_SHARED,
> > +					   BIT(chandef.width));
> > +	mutex_unlock(&rdev->devlist_mtx);
>=20
> You need to keep holding the mutex until you've set cac_started to true
> (or failed), otherwise you introduce races.
>=20

OK

> > +	if (err)
> > +		return err;
> > +
> > +	err =3D rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
> > +	if (!err) {
> > +		wdev->preset_chandef =3D chandef;
> > +		wdev->cac_started =3D true;
> > +		chandef.chan->dfs_state_entered =3D jiffies;
>=20
> No reason to assign dfs_state_entered since it won't be used in this
> state anyway, will it?
>=20

Hmm ... yeah, that's stupid. I'll need to add wdev->cac_entered or somethin=
g like
that to track CAC time. Using dfs_state_entered is just wrong.

Thanks.

> > @@ -5575,6 +5623,10 @@ static int nl80211_join_ibss(struct sk_buff *skb=
, struct genl_info *info)
> >  	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef))
> >  		return -EINVAL;
> > =20
> > +	if (cfg80211_chandef_usable(&rdev->wiphy, &ibss.chandef,
> > +				    IEEE80211_CHAN_NO_IBSS))
> > +		return -EINVAL;
>=20
> That seems like an unrelated change/fix?
>=20

Well, yeah, that is a survivor from some intermediate state that I forgot t=
o remove.
I still have some confusion/questions regarding the other flags, there is a=
 question
in the cover letter regarding this - we should discuss it there.

> > +	/* reason is unspecified, just notify that CAC has failed. */
> > +	if (nla_put_u8(msg, NL80211_ATTR_RADAR_EVENT, event))
>=20
> I think enums should generally be u32.
>=20

OK

> > +++ b/net/wireless/reg.c
> > @@ -884,6 +884,9 @@ static void handle_channel(struct wiphy *wiphy,
> >  		return;
> >  	}
> > =20
> > +	chan->dfs_state =3D IEEE80211_DFS_USABLE;
> > +	chan->dfs_state_entered =3D jiffies;
>=20
> Here also you don't really need the time assignment.
>=20
> (I skipped this before, so pasting here)
>=20

Hm, aren't channels initialized in this function? I wanted to set some
sane values here - although time is not relevant for the USABLE state,
I thought it might be useful if this info is exported to userspace or
for debugging.

> > +void cfg80211_radar_event(struct net_device *netdev,
> > +                         struct cfg80211_chan_def *chandef,
> > +                         enum nl80211_radar_event event,
> > +                         gfp_t gfp)
> > +{
> > +       struct wireless_dev *wdev =3D netdev->ieee80211_ptr;
> > +       struct wiphy *wiphy =3D wdev->wiphy;
> > +       struct cfg80211_registered_device *rdev =3D wiphy_to_dev(wiphy);
> > +       unsigned long timeout;
> > +
> > +       if (WARN_ON(!cfg80211_chandef_valid(chandef)))
> > +               return;
> > +
> > +       trace_cfg80211_radar_event(netdev, chandef, event);
> > +
> > +       switch (event) {
> > +       case NL80211_RADAR_DETECTED:
> > +               /*
> > +                * only set the chandef supplied channel to unavailable=
, in
> > +                * case the radar is detected on only one of multiple c=
hannels
> > +                * spanned by the chandef.
> > +                */
> > +               cfg80211_set_dfs_state(wiphy, chandef,
> > +                                      IEEE80211_DFS_UNAVAILABLE);
> > +
> > +               timeout =3D msecs_to_jiffies(NL80211_DFS_MIN_NOP_TIME_M=
S);
> > +               queue_delayed_work(cfg80211_wq, &rdev->dfs_update_chann=
els_wk,
> > +                                  timeout);
> > +               break;
> > +       case NL80211_CAC_FINISHED:
> > +               timeout =3D wdev->preset_chandef.chan->dfs_state_entere=
d;
> > +               timeout =3D msecs_to_jiffies(timeout +
> > +                                          NL80211_DFS_MIN_CAC_TIME_MS);
> > +               WARN_ON(!time_after_eq(jiffies, timeout));
> > +               cfg80211_set_dfs_state(wiphy, &wdev->preset_chandef,
> > +                                      IEEE80211_DFS_AVAILABLE);
> > +               break;
> > +       case NL80211_CAC_ABORTED:
> > +               /* Shouldn't happen if CAC was never started before. */
> > +               WARN_ON(!wdev->cac_started);
> > +               break;
> > +       default:
> > +               break;
>=20
> I think a warning (and maybe return) would be useful here.
>=20

OK

> > +       }
> > +
> > +       wdev->cac_started =3D false;
>=20
>=20
> Whew. :)
> Overall I think this is looking good, mostly minor comments.

I'm glad you say that! ;) Thanks as always for the comments. There
are a few questions in the cover letter I think we should discuss,
then I'll repost the patchset - hopefully quicker as most conceptional
changes have been included in this version already.

Cheers,
	Simon


--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEKmDoACgkQrzg/fFk7axZG+gCguajkbohxBI+BoaQaoh6777XT
syoAoOsliYZB4gAlneJEoDD6DpElpDWt
=53Uv
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
