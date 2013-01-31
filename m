Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:33215 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab3AaRoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 12:44:55 -0500
Date: Thu, 31 Jan 2013 18:44:43 +0100
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
Message-ID: <20130131174443.GB2018@pandem0nium> (sfid-20130131_184500_107218_912DA15B)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359642321.8415.56.camel@jlt4.sipsolutions.net>
 <20130131161346.GA1387@pandem0nium>
 <1359650760.8415.91.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
In-Reply-To: <1359650760.8415.91.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 05:46:00PM +0100, Johannes Berg wrote:
> On Thu, 2013-01-31 at 17:13 +0100, Simon Wunderlich wrote:
>=20
> > > > +int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
> > > > +				  const struct cfg80211_chan_def *c);
> > >=20
> > > Why does that need to be exported to mac80211/drivers? Shouldn't
> > > cfg80211 be able to check everything?
> > >=20
> > I'm using it in mac80211/ieee80211_start_ap() to find out whether radar=
 detection
> > is required. We could put into struct cfg80211_ap_settings *params if y=
ou prefer?
> > I guess similar params exist for IBSS.
>=20
> I kinda think that would make more sense because then it's right there
> when you look at the parameters, rather than having to remember it.
>=20

OK, will change that.

> > > Don't you need a cac_chandef or something?
>=20
> > The chandef is stored into wdev->preset_chandef anyway, so I didn't see=
 any
> > need to save it twice?
>=20
> (I'm just worried about that changing, see below. We could use
> "wdev->channel" though, which I need to change to chandef anyway)
>=20

I'll have a look at wdev->channel then. :)

> > Anyway, the idea was that a driver can report a radar only for a certai=
n part of
> > the currently used spectrum - e.g. we sense a radar on the extension ch=
annel in HT40+,
> > we would need to move but could still use the primary channel.
> >=20
> > I don't know if this is overkill since we don't support any more than H=
T20 yet, but
> > that would be kind of future proof.
>=20
> I guess I'm not worried about internal APIs much. Does that even make
> sense? Can you detect radar on one 20 MHz subchannel and then still use
> the other subchannel?
>=20

According to ETSI, that is possible. To quote from the EN 301 893 v1.7.1:

"If the master device has detected a radar signal on an Operating Channel d=
uring In-Service Monitoring, the
master device shall instruct all its associated slave devices to stop trans=
mitting on this channel which becomes
an Unavailable Channel. For devices operating on multiple (adjacent or non-=
adjacent) Operating Channels
simultaneously, only the Operating Channel containing the frequency on whic=
h radar was detected shall
become an Unavailable Channel."

At least in ath9k it appears that the radar header contains some informatio=
n whether
the radar was received on the primary or extension channel.

I don't know how upcoming 80 MHz devices handle that though.

We can remove it now and re-add it later if you prefer?

> > > > @@ -344,7 +467,10 @@ cfg80211_get_chan_state(struct wireless_dev *w=
dev,
> > > >  		break;
> > > >  	case NL80211_IFTYPE_AP:
> > > >  	case NL80211_IFTYPE_P2P_GO:
> > > > -		if (wdev->beacon_interval) {
> > > > +		if (wdev->cac_started) {
> > > > +			*chan =3D wdev->preset_chandef.chan;
> > > > +			*chanmode =3D CHAN_MODE_SHARED;
> > >=20
> > > Ah, ok, so you're using the preset_chandef for CAC as well. I'm not
> > > entirely sure that is correct though, since it could be changed by
> > > userspace without much effect, e.g. by setting the channel with iw or
> > > iwconfig? Unless you added "if (!cac_started)" there everywhere?
> > >=20
> >=20
> > Hmm, actually I've tried setting the frequency with iw and got a EINVAL=
 back.
> > I'll look into it again if I missed something, but thought it would be =
good to
> > not have this stuff redundant.
>=20
> Ok. Hmm. EINVAL? Maybe you tried setting to a radar frequency or
> something? Can you try setting to say channel 1? I don't think you
> changed __nl80211_set_channel() to check cac_started, so ...
>=20

I can try again ... but maybe this is obsolete when using wdev->channel.

> > > > +	err =3D cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
> > > > +	if (err < 1)
> > > > +		return err;
> > >=20
> > > That doesn't make sense, if userspace starts CAC and that is successf=
ul
> > > it would expect to eventually receive an event that it completed? Thus
> > > if you return 0 here it would get confused, no?
> > >=20
> >=20
> > Ah yes, I should probably return EINVAL in this case, or the appropriate
> > error code otherwise ...=20
>=20
> Maybe return some more useful error code? Can't really find any one that
> is appropriate though.

We should add EUSELESS. :D
Can't think of anything better, so will keep it at EINVAL until someone has
a better idea.

>=20
> Do we export the state yet when you do try to get the channel list? That
> would be helpful for userspace, particularly in this case, I think.
>=20

No, not yet, I've just put that on my TODO.

> > > > +	err =3D rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chan=
def);
> > > > +	if (!err) {
> > > > +		wdev->preset_chandef =3D chandef;
> > > > +		wdev->cac_started =3D true;
> > > > +		chandef.chan->dfs_state_entered =3D jiffies;
> > >=20
> > > No reason to assign dfs_state_entered since it won't be used in this
> > > state anyway, will it?
> > >=20
> >=20
> > Hmm ... yeah, that's stupid. I'll need to add wdev->cac_entered or some=
thing like
> > that to track CAC time. Using dfs_state_entered is just wrong.
>=20
> I didn't see you read that, or did I miss that?
>=20

chan->dfs_state_entered was read in cfg80211_radar_event() for the CAC_FINI=
SHED event,
which only worked "by accident" because we set the state entered above. :) =
I'll change
this part too.

> [...]
> > > > @@ -884,6 +884,9 @@ static void handle_channel(struct wiphy *wiphy,
> > > >  		return;
> > > >  	}
> > > > =20
> > > > +	chan->dfs_state =3D IEEE80211_DFS_USABLE;
> > > > +	chan->dfs_state_entered =3D jiffies;
> > >=20
> > > Here also you don't really need the time assignment.
> > >=20
> > > (I skipped this before, so pasting here)
> > >=20
> >=20
> > Hm, aren't channels initialized in this function? I wanted to set some
> > sane values here - although time is not relevant for the USABLE state,
> > I thought it might be useful if this info is exported to userspace or
> > for debugging.
>=20
> Maybe so, I just don't think you need the time there since it won't be
> of relevance in the USABLE state. The "state entered" time is only used
> for UNAVAILABLE.
>=20
> Maybe therefore state_entered should be renamed to "unavailable_until"
> with the corresponding change in the logic of adding the time when it's
> set to that state?

Can do that, if no one is interested in when we, say, change from unavailab=
le
to usable (after NOP). This is what Zefir asked for.=20

Personally I don't care at all, and we discuss that in the cover letter thr=
ead
anyway. Let's see what Zefir says or if anyone else objects, I put that onto
the "TODO if nobody objects list". :)

Thanks!
	Simon

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEKrYsACgkQrzg/fFk7axYofQCfatnfwlDkDm5+jR6bO2Y7GH2M
OIYAoJE3htmVsPrUJ+HdIoKYMrlpZ/8S
=E8j3
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
