Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679AbZEKJx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 05:53:27 -0400
Subject: Re: [RFC 4/5] mac80211: add a struct for info upon device stop
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1242033904-25694-5-git-send-email-lrodriguez@atheros.com>
References: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com>
	 <1242033904-25694-5-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-B6IfE+5x261YrvPpFZ28"
Date: Mon, 11 May 2009 11:53:24 +0200
Message-Id: <1242035604.3284.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-B6IfE+5x261YrvPpFZ28
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-11 at 05:25 -0400, Luis R. Rodriguez wrote:

>  /**
> + * enum ieee80211_device_stop_reason - device stop reasons
> + *
> + * These are reasons why mac80211 would call the driver's stop()
> + * callback. Devices should probably not care other than when
> + * we call to stop during suspend, in these cases the device may
> + * want to leave the radio on for WoW events for example.
> + * @IEEE80211_DEV_STOP_INVALID_MAC: invalid mac address was detected for=
 device
> + * @IEEE80211_DEV_STOP_NO_OPEN_DEV: we were not able to open any
> +	netdevice for the current wireless device during user initialization.
> + * @IEEE80211_DEV_STOP_DEV_CLOSE_REQUEST: user requested the device to b=
e
> + *	closed.
> + * @IEEE80211_DEV_STOP_SUSPEND: we are going to suspend
> + */
> +enum ieee80211_device_stop_reasons {
> +	IEEE80211_DEV_STOP_INVALID_MAC,
> +	IEEE80211_DEV_STOP_NO_OPEN_DEV,
> +	IEEE80211_DEV_STOP_DEV_CLOSE_REQUEST,
> +	IEEE80211_DEV_STOP_SUSPEND,
> +};

> +struct ieee80211_device_stop_info {
> +       enum ieee80211_device_stop_reasons reason;
> +};

Hmm. You're creating a code-flow API rather than a do-what-I-want API, I
think it leaves the driver too much choice ;)

The way you're using this here is:

+#ifdef CONFIG_PM
+       if (sc->wow_enable &&
+           stop_info->reason =3D=3D IEEE80211_DEV_STOP_SUSPEND) {

So for one, all the other reasons are unnecessary. Additionally, as you
said, you need to stay associated for some WoW modes, so mac80211 needs
to be aware of that when going into suspend. It might even need to be
aware of things like the computer waking up only to cycle keys.

Therefore, IMHO the stop info struct (I would drop _info from the name,
seems not very useful and makes the struct name very long) should
contain the WoW parameters so that devices can program those parameters
instead of turning off completely. At suspend time, mac80211 would fill
in those parameters, whereas it wouldn't do that at the other times the
device is stopped.

Of course, that means adding a WOW_CAPABLE HW flag, and API to mac80211
to program WOW, but that will gain us more uniformity. Question is
whether we want to use nl80211 or ethtool.

johannes


--=-B6IfE+5x261YrvPpFZ28
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKB/WLAAoJEODzc/N7+QmaueEP/1tjpuwz6jBOWEEfg+tc37dR
Xn3N4V6cNyEblL8sA45nuTJp9b9GCqHLfaSOTTEg6G9/EJ3n9fUnYzvSm9y0tpgn
jJqdlDYREt6L30/knGI8PKWSjLeY85KVXpBZggiI8DsPAnTCRi0LLE6A2e6toknF
Gi48BGpRrxbSfC7umsLFdXcg3+8dZ3lo6j3MU9RvtI4Bcs/RLx6zI0tmofoItPt/
VWFKnJWkvel3OID1bwAhjttDpBU+1CLGqL0v6lNgvVf8wfHRkoBN25gTCKenIDK6
0nuvg1yTtIuAR14Ab2A52VaX15C+quVSDkbGeg/1oGZAAVdRpFQdfZNSEXCzEVzb
zfoV6OAJl0DR+OUAJyv2V09JDhKnzz89KMtf9frpqsFqgpSJ6AudRTc/NhryxKlJ
eiWMszDczBODoqE19zdk+v8S1yVJ97PL0HhRwvDiZXTxBMOPoLT4WUThQIB6tcfX
MK56SsY5KXq8qvF2fgB/0mnea1/P1ryFw18oKd8/p/KUiNd/jtbEZbFW+7maQSTM
tUatY4wHBn7ewzJU/Wmr3m61zcuKy1DpHphVgcLqw/XbMsu8XI8I9UrG9bHC3WOh
UJhTB0SulLGVQqDXF4QzfSU7JSeEL0uaZuHRHWPHc21IYnw9s121w36ch3cWM9Tt
qypGSYitrpU9uaKxYtuY
=tL0I
-----END PGP SIGNATURE-----

--=-B6IfE+5x261YrvPpFZ28--

