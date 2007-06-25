Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXFYIoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2007 04:44:44 -0400
Subject: Re: radiotap for TX
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sam@errno.com>
Cc: radiotap@ojctech.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
In-Reply-To: <467AE460.1070606@errno.com>
References: <1182375853.3714.103.camel@johannes.berg>
	 <467AE460.1070606@errno.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/Vv/w5rJthMmZrzvDS+g"
Date: Mon, 25 Jun 2007 09:24:32 +0200
Message-Id: <1182756272.21939.154.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/Vv/w5rJthMmZrzvDS+g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-06-21 at 13:49 -0700, Sam Leffler wrote:

> This is the control state available on FreeBSD for doing raw 802.11=20
> frame xmit (packets need not include all this; I've just provided the=20
> most complete set of knobs):
>=20
>          uint8_t         ibp_flags;
> #define IEEE80211_BPF_SHORTPRE  0x01    /* tx with short preamble */
> #define IEEE80211_BPF_NOACK     0x02    /* tx with no ack */
> #define IEEE80211_BPF_CRYPTO    0x04    /* tx with h/w encryption */
> #define IEEE80211_BPF_FCS       0x10    /* frame incldues FCS */
> #define IEEE80211_BPF_DATAPAD   0x20    /* frame includes data padding */
> #define IEEE80211_BPF_RTS       0x40    /* tx with RTS/CTS */
> #define IEEE80211_BPF_CTS       0x80    /* tx with CTS only */
>          uint8_t         ibp_pri;        /* WME/WMM AC+tx antenna */
>          uint8_t         ibp_try0;       /* series 1 try count */
>          uint8_t         ibp_rate0;      /* series 1 IEEE tx rate */
>          uint8_t         ibp_power;      /* tx power (device units) */
>          uint8_t         ibp_ctsrate;    /* IEEE tx rate for CTS */
>          uint8_t         ibp_try1;       /* series 2 try count */
>          uint8_t         ibp_rate1;      /* series 2 IEEE tx rate */
>          uint8_t         ibp_try2;       /* series 3 try count */
>          uint8_t         ibp_rate2;      /* series 3 IEEE tx rate */
>          uint8_t         ibp_try3;       /* series 4 try count */
>          uint8_t         ibp_rate3;      /* series 4 IEEE tx rate */

Sounds simillar to what we're trying here though Dave had some good
comments that equally well apply here. I expect I'll be posting a
radiotap patch, maybe you can comment on that then? Even wrt. how well
you could implement this, possibly even on top of those fields you have.

> Note that using a monitor mode interface for transmit is a bad idea.  It=20
> is likely you will encounter devices that disallow any packet transmit=20
> when operating in monitor mode.  In practice this can be worked around=20
> by using a non-monitor operating mode for the device (e.g. adhoc mode=20
> w/o setting up beacons) but exporting this notion to user mode is bad=20
> IMO.  In net80211 there is an adhoc-demo mode which is essentially adhoc=20
> mode which was originally added for functionality found in old lucent=20
> cards but more recently has been used for building applications that=20
> want a "raw 802.11 device".

There's a tradeoff here; the actual notion to userspace ought to be a
monitor interface because that is what tools need to have opened anyway.
It is also natural to use from userspace via libpcap. Also, most modern
hardware doesn't actually care what you send.

If we ever end up being able to support such cards that do care, then I
expect we'll either be able to work around the problem in the driver or
need some special instructions for users of such hardware.

johannes

--=-/Vv/w5rJthMmZrzvDS+g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGf22w/ETPhpq3jKURAu9FAKCWMTxpgwDfrElRif9nLrsAqtnw7QCglvbZ
bKK0yfj1ssoZ1vM27ulqgNw=
=wH49
-----END PGP SIGNATURE-----

--=-/Vv/w5rJthMmZrzvDS+g--

