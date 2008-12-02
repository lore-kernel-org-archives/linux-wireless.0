Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:42280 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYLBUqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:46:17 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1683984nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 12:46:15 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Tue, 2 Dec 2008 21:46:06 +0100
Cc: Henning Rogge <rogge@fgan.de>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812021425.44488.rogge@fgan.de> <20081202202919.GC9351@tesla>
In-Reply-To: <20081202202919.GC9351@tesla>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart13210851.1qEx6tQx99";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812022146.12363.hrogge@googlemail.com> (sfid-20081202_214622_036937_66EB598C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart13210851.1qEx6tQx99
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> > @@ -404,6 +404,10 @@ enum nl80211_sta_flags {
> >   * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this
> > station) * @__NL80211_STA_INFO_AFTER_LAST: internal
> >   * @NL80211_STA_INFO_MAX: highest possible station info attribute
> > + * @NL80211_STA_INFO_SIGNAL: signal strength of last received package
> > (u8, dBm)
> Shouldn't this be s8?
I did not find macros for nl80211 to add signed values... so its just "say=
=20
it's signed, but use the unsigned macro" ? If yes I will change the=20
documentation.

> > diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> > index 1d57835..cdf9433 100644
> > --- a/include/net/cfg80211.h
> > +++ b/include/net/cfg80211.h
> > @@ -167,6 +167,9 @@ struct station_parameters {
> >   * @STATION_INFO_LLID: @llid filled
> >   * @STATION_INFO_PLID: @plid filled
> >   * @STATION_INFO_PLINK_STATE: @plink_state filled
> > + * @STATION_INFO_SIGNAL: @signal filled
>
> Can you extend this to indicate drivers which enable this must
> pass the singal in dBm (IEEE80211_HW_SIGNAL_DBM for mac80211 drivers)
> as that is what cfg80211 expects?
The flag is only set if the driver sets the IEEE80211_HW_SIGNAL_DBM flag.
cfg.c:
+=A0=A0=A0=A0=A0=A0=A0if (sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
+=A0=A0=A0=A0=A0=A0=A0 =A0sinfo->filled |=3D STATION_INFO_SIGNAL;
+=A0=A0=A0=A0=A0=A0=A0 =A0sinfo->signal =3D sta->last_signal;
+=A0=A0=A0=A0=A0=A0=A0}

But it might be better to explain this in the documentation.

> This is important as mac80211 drivers not using IEEE80211_HW_SIGNAL_DBM
> will luck out of getting signal reports. This means these drivers won't
> get signal reports right now:
I know... (did search for the HW_SIGNAL flags in the drivers)

> I guess this is the iffy part... I'll see if zd1211rw can somehow use
> dBm though.
That would be good I think.

> Awesome stuff, now come to think of it, perhaps its best we let
> userspace do the calculation and we just give it the last RX/TX
> guard interval and the MCS index? Technically speaking it seems
> we don't have duplicate rates though so a reverse map is possible
> but it seems useful to just provide the information directly.
 the problem of this approach would be that every userspace calculation wou=
ld=20
have to do this calculation on it's own. Whats about transmitting "basic=20
datarate", "number of spatial streams" and "flags" (short/long GI, 20/40 Mh=
z=20
width) to userspace ? This way it would be just a multiplication to get the=
=20
total bandwith, but it still can easily be reverse mapped into MCS with som=
e=20
arithmetics.

Henning


--nextPart13210851.1qEx6tQx99
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk1npQACgkQcenvcwAcHWenOwCbBAPZhUptHff8CF04xTBXwKuP
8dEAn0fos10gaOzeBkr7svvH2of3foZQ
=mdoF
-----END PGP SIGNATURE-----

--nextPart13210851.1qEx6tQx99--
