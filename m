Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbZCaHth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 03:49:37 -0400
Subject: Re: [PATCH] cfg80211: send regulatory beacon hint events to
 userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1238471826-3980-1-git-send-email-lrodriguez@atheros.com>
References: <1238471826-3980-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-D95i3HbYGc0abzSHWXO2"
Date: Tue, 31 Mar 2009 09:48:58 +0200
Message-Id: <1238485738.5970.64.camel@johannes.local> (sfid-20090331_094941_342223_B1A2E222)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D95i3HbYGc0abzSHWXO2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 23:57 -0400, Luis R. Rodriguez wrote:

> + * @NL80211_CMD_REG_BEACON_HINT: indicates to userspace that an AP beaco=
n
> + * 	has been found while world roaming thus enabling active scan or
> + * 	any mode of operation that initiates TX (beacons) on a channel
> + * 	where we would not have been able to do either before. As an example
> + * 	if you are world roaming (regulatory domain set to world or if your
> + * 	driver is using a custom world roaming regulatory domain) and while
> + * 	doing a passive scan on the 5 GHz band you find an AP there (if not
> + * 	on a DFS channel) you will now be able to actively scan for that AP
> + * 	or use AP mode on your card on that same channel. Note that this wil=
l
> + * 	never be used for channels 1-11 on the 2 GHz band as they are always
> + * 	enabled world wide. This beacon hint is only sent if your device had
> + * 	either disabled active scanning or beaconing on a channel. We send t=
o
> + * 	userspace the wiphy on which we removed a restriction from
> + * 	(%NL80211_ATTR_WIPHY) and the channel on which this occured

occurred

> + * 	(%NL80211_ATTR_WIPHY_FREQ) before and after the beacon hint was appl=
ied.
> + * 	We send the two channels on a frequency nestered attribute

nested

>   * @NL80211_CMD_AUTHENTICATE: authentication request and notification.
>   *	This command is used both as a command (request to authenticate) and
> @@ -254,6 +273,7 @@ enum nl80211_commands {
>  	NL80211_CMD_SCAN_ABORTED,
> =20
>  	NL80211_CMD_REG_CHANGE,
> +	NL80211_CMD_REG_BEACON_HINT,
> =20
>  	NL80211_CMD_AUTHENTICATE,
>  	NL80211_CMD_ASSOCIATE,

No go for adding in the middle.

> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -3391,6 +3391,93 @@ void nl80211_send_rx_disassoc(struct cfg80211_regi=
stered_device *rdev,
>  				NL80211_CMD_DISASSOCIATE);
>  }
> =20
> +void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
> +				    struct ieee80211_channel *channel_before,
> +				    struct ieee80211_channel *channel_after)
> +{
> +	struct sk_buff *msg;
> +	void *hdr;
> +	enum ieee80211_band band;
> +	struct nlattr *nl_bands, *nl_band, *nl_freqs, *nl_freq;
> +	struct ieee80211_channel *chan;
> +	unsigned int i;
> +
> +	msg =3D nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
> +	if (!msg)
> +		return;
> +
> +	hdr =3D nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_REG_BEACON_HINT);
> +	if (!hdr) {
> +		nlmsg_free(msg);
> +		return;
> +	}
> +
> +	/*
> +	 * Since we are applying the beacon hint to a wiphy we know its
> +	 * wiphy_idx is valid
> +	 */
> +	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, get_wiphy_idx(wiphy));
> +
> +	band =3D channel_after->band;
> +	if (WARN_ON(!wiphy->bands[band]))
> +		goto nla_put_failure;
> +
> +	/* Unforunately this is needed */
> +	nl_bands =3D nla_nest_start(msg, NL80211_ATTR_WIPHY_BANDS);
> +	if (!nl_bands)
> +		goto nla_put_failure;
> +	nl_band =3D nla_nest_start(msg, band);
> +	if (!nl_band)
> +		goto nla_put_failure;
> +
> +	/*
> +	 * Our hack is to piggy back the channel prior to beacon hint
> +	 * and after the beacon hint so userspace can analyze the
> +	 * differences. Right now only no-ibss and passive-scan flags
> +	 * can change as that's the only thing we expect to learn out
> +	 * of a beacon for now. By re-using these attributes we can
> +	 * avoid introducing new structs.
> +	 */
> +	nl_freqs =3D nla_nest_start(msg, NL80211_BAND_ATTR_FREQS);
> +	if (!nl_freqs)
> +		goto nla_put_failure;
> +
> +	for (i =3D 0; i <=3D 1; i++) {
> +		nl_freq =3D nla_nest_start(msg, i);
> +		if (!nl_freq)
> +			goto nla_put_failure;
> +
> +		chan =3D (i =3D=3D 0) ? channel_before : channel_after;
> +
> +		NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_FREQ,
> +			    chan->center_freq);
> +
> +		if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
> +			NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_PASSIVE_SCAN);
> +		if (chan->flags & IEEE80211_CHAN_NO_IBSS)
> +			NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
> +
> +		nla_nest_end(msg, nl_freq);
> +	}

I don't think I like this -- it's confusing to userspace code that wants
to use a unified message parser.

Do we really need that before/after thing anyway? I think if we really
need this then we should add new attributes.

johannes

--=-D95i3HbYGc0abzSHWXO2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0crnAAoJEKVg1VMiehFYpasQAJ5SQRjBRxrtuNx5JIApg1SK
lT4bnviwWgAiH+QHldoY3c9J4WtLBNUTtexiJD/jQXEYNSIfSx23wB7umWS3eJim
4KpR25ipsRMco55KgYQcCnO8WHsdHTZKWrnNLX7LG0DGdvhi/zuvMSKZtagwE+Qe
YJwO9bmWyGC4uOzPzN37w87G9jApHVn8U6ngVwAKIDINgKGDYGCLPw5N9MjrqRt9
/MDaQiSaP9F+AyU5eNBwrayXQHWWpqbIKw1TWIhHZOhsJHHAm9IXoinLaImGpUlD
iRzIkNWBMhrhFn5+xwyX9+XNulNCQNxelOyvmYlJ8pF2OvjyjhAo1VG7SF72mnOW
LRwwohrhKIJ4MBKkntg4+m2+vW0kb4lH/xHePD6pKak6yzLPemC4Vdd+o0T5uFfB
6PibGr06d0LfATXwBjQtuoDvuQx02jIVrBeXTaMtRiV43gTYkulxKVgzVtdgQ2VV
AXaxwhXQYcwpvl/XZmWstg60jpHNbTmFobd7HbG6FUOcXNddQPCXT6RWXNmYwB+G
itL5zRktE2ywXFgnKcHbvdgJuc9Fy5mkOicLRL/BGoUoIEjmW8CmIiJzY/MZ3c8r
haamw0a1OT9jYS0jlOEWCXrHUfe8u4YB4R6+Ga9TEMOBVSS07lqc0GvlJOlXrH0B
WIlUeU6mU14UUbqT14LS
=mMU+
-----END PGP SIGNATURE-----

--=-D95i3HbYGc0abzSHWXO2--

