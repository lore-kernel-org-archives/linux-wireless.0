Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762099AbZDAI3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 04:29:44 -0400
Subject: Re: [PATCH v2] cfg80211: send regulatory beacon hint events to
 userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1238549294-29168-1-git-send-email-lrodriguez@atheros.com>
References: <1238549294-29168-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CxpJSNKGeuTwP7DBnAwT"
Date: Wed, 01 Apr 2009 10:29:05 +0200
Message-Id: <1238574545.5970.137.camel@johannes.local> (sfid-20090401_102956_974126_26E8ECD4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CxpJSNKGeuTwP7DBnAwT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-31 at 21:28 -0400, Luis R. Rodriguez wrote:

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
> + * 	(%NL80211_ATTR_WIPHY) and the channel on which this occurred
> + * 	before (%NL80211_ATTR_FREQ_BEFORE) and after (%NL80211_ATTR_FREQ_AFT=
ER)
> + * 	the beacon hint was processed.


I wonder -- are there other reasons we may ever update the regdomain? I
could imagine the CMD being REG_UPDATE with an ATTR_REASON or so? Or
just using REG_CHANGE with NL80211_REGDOM_TYPE_WORLD _and_ the new
channel change attributes?
=20
> +static int nl80211_put_beacon_hint_channel(void *hdr,
> +					   struct sk_buff *msg,
> +					   enum nl80211_attrs attribute,
> +					   struct ieee80211_channel *chan)
> +{
> +	struct nlattr *nl_freq;
> +
> +	nl_freq =3D nla_nest_start(msg, attribute);
> +	if (!nl_freq)
> +		goto nla_put_failure;
> +
> +	NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_FREQ,
> +		    chan->center_freq);
> +
> +	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
> +		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_PASSIVE_SCAN);
> +	if (chan->flags & IEEE80211_CHAN_NO_IBSS)
> +		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
> +
> +	nla_nest_end(msg, nl_freq);
> +
> +	return 0;

I think you should send all possible channel attributes here -- please
refactor the code and extract the bit that sends a channel from
nl80211_send_wiphy(), this bit:
	NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_FREQ,...)
	..
	NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,...)

put it into a new function that takes a msg and channel pointer and call
it twice.

Does the relaxing we do on receiving beacons only apply to a single
wiphy though?

> +	/*
> +	 * Since we are applying the beacon hint to a wiphy we know its
> +	 * wiphy_idx is valid
> +	 */
> +	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, get_wiphy_idx(wiphy));

You're sending out the wiphy here.

And I just realised there's a bug in the existing code:

> @@ -1070,18 +1062,26 @@ static void handle_reg_beacon(struct wiphy *wiphy=
,
>  	if (likely(chan->center_freq !=3D reg_beacon->chan.center_freq))
>  		return;
> =20
> +	if (chan->beacon_found)
> +		return;
> +
> +	chan->beacon_found =3D true;
> +
> +	chan_before.center_freq =3D chan->center_freq;
> +	chan_before.flags =3D chan->flags;
> +
>  	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN) {
>  		chan->flags &=3D ~IEEE80211_CHAN_PASSIVE_SCAN;
> -		REG_DEBUG_BEACON_FLAG("active scanning");
> +		channel_changed =3D true;
>  	}
> =20
>  	if (chan->flags & IEEE80211_CHAN_NO_IBSS) {
>  		chan->flags &=3D ~IEEE80211_CHAN_NO_IBSS;
> -		REG_DEBUG_BEACON_FLAG("beaconing");
> +		channel_changed =3D true;
>  	}

This is incorrect, it has to be like this:

	if ((chan->flags & FLAG) && !(chan->orig_flags & FLAG)) {
		chan->flags &=3D ~FLAG;
		channel_changed =3D true;
	}

to take into account the flags the _driver_ had already set on the
channel. This is important for Intel hardware -- if you lift the IBSS
restriction on a channel that iwlwifi thinks should not use IBSS then
the firmware will hate you if you try to use it anyway. Now, I think
iwlwifi isn't world-roaming in that sense, but it should still be fixed!

Does this mean though you're sending one event per wiphy? Just
wondering, it's probably acceptable.

johannes

--=-CxpJSNKGeuTwP7DBnAwT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0yXOAAoJEKVg1VMiehFYzB0QAJlMHn2UmiXaS03rb8z1d63A
vZ9VOCSs9ppAfgNw5KqOWkyefeiRSSA4M76AGnkzObPvyVfKbrPXf40PdRwa6dvZ
UO54eyr0Twt7w2TOxsmFCD4dIWr96x87ouUwmfrQdhSjT+XUxQ1bhXwkNKJlCnSt
crzMrFsPO1lLTKFRb24x4z7hB+2qSp48NqwCV66AOHmMWfreZCP9nmUGZZt9Zvem
bOyzBB99LCBtnSZ6Do25SsyzPIX//YBXVz3/TEjDiDkYzq1jB0v9G29mhQSA6Tjs
pFoJ4MnfLPESmPQ7dQxSKvC3IA94qelMqqC8Qos0cqkU0pxg0MrOPdLZftql2STO
kFAnKOoZIuzU4GFpYIQ/adM5KfnekIxH2j7bf/CgHsV9UXpUJO4erwL8/Yl6XLlB
Q6p9Y3Rs0rxsInfreNYh8MTsxUXg2DtidKdQXoz+0kv1GgaZ3znPvma2Iy36ebYL
3uDXYf7arhqNgplSUAcuJ6V9kwoB18oj+bJkObEWu9nidIxyd45JJj8F2j6iLceO
stSGx7LYwcf5WWgY1pYyKNKKLcYMzP5aBF/WUp8uFbIKmYCSCdyZYKTx5Jy82afY
8wrhxZc4a9BDt0prEJjzdN6pbs6lwy1teeXqbTze4kUQ0DQc2wANb7Oe5i7PudHq
ZSfOaLwpg05MNF/CB8iZ
=2J2z
-----END PGP SIGNATURE-----

--=-CxpJSNKGeuTwP7DBnAwT--

