Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764732AbXIUVQ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 17:16:27 -0400
Subject: Re: [PATCH 1/5] Move standard wireless defintions out of mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20070921210014.GE31768@pogo>
References: <20070921210014.GE31768@pogo>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ekyITg1rAnPlAGBYp4Dc"
Date: Fri, 21 Sep 2007 23:17:42 +0200
Message-Id: <1190409462.18521.160.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ekyITg1rAnPlAGBYp4Dc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-21 at 17:00 -0400, Luis R. Rodriguez wrote:

Ok one thing up front: I'm looking at this basically as "new code", iow
something we should do right from the start. mac80211 stuff is a mess,
so imho we should clean it up at this point when we break things anyway.

> + * @IEEE80211_CHAN_W_SCAN: if this flag is set it informs the lower laye=
r that
> + *   this channel can be passively scanned for.

Are there really channels that don't have _SCAN?

> +/**
> + * ieee80211_channel - internal structure definiton for an IEEE-802.11 c=
hannel
> + *
> + * This defines an ieee80211_channel. The IEEE-802.11 regulatory domain =
agent
> + * is in charge of filling most of these fields out. The low-level drive=
r=20
> + * is expected to fill in, if needed, the val field. Note that val is al=
ready=20
> + * set by the regulatory agent to the same channel as in chan.

Shouldn't you also set chan and freq in the driver?

> + * @modulation_cap: could be IEEE80211_RATE_*

Could be?

> + * @list: lets you make this structure part of a linked list

What do we need this for?

> +struct ieee80211_channel {
> +	/* XXX change to u8 */
> +	short chan;

Not sure, is a u8 always enough? I thought 802.11a had huge channel
numbers?

> +/* XXX consider removing the holes bellow */

I think these flags are shared with hostapd right now... :(

> +/**
> + * enum rate_flags - internal &ieee80211_rate flags

> + * Use these flags to indicate to the lower layers details about an
> + * &ieee80211_rate.
       ^ struct ieee80211_rate, for kernel-doc

> + * @IEEE80211_RATE_ERP: indicates if the rate is an  Extended Rate PHY (=
ERP)
> + * @IEEE80211_RATE_BASIC: indicates the rate is a basic rate for the=20
> + *   currently used mode
> + * @IEEE80211_RATE_PREAMBLE2: used to indicates that the rate for short
> + *   preamble is to be used. This is set in &ieee80211_rate's @val2.

Couldn't we just call it SHORT_PREAMBLE? :)

> + * @IEEE80211_RATE_SUPPORTED: indicates if rate is supported by the give=
n mode

What do we use this for?

> + * @IEEE80211_RATE_OFDM: indicates support for ODFM modulation
> + * @IEEE80211_RATE_CCK: indicates support for CCK modulation

I think this should be called "this rate is an OFDM/CCK rate"

> + * @IEEE80211_RATE_MANDATORY: indicates if this rate is mandatory for th=
e
> + *   currently used mode

I think this is wrong. Isn't the "mandatory" flag something for an AP to
ask it's stations for?

> +/* XXX move to inline and add documenation, kernel-doc can't doc
> defines */

Why don't you just do that then? :)

> + * Low-level driver should set PREAMBLE2, OFDM and CCK flags.
> + * BASIC, SUPPORTED, ERP, and MANDATORY flags are set in 80211.o based o=
n the
> + * configuration.

Oh come on. There hasn't been 80211.o for a loong time :)

> + * @flags: IEEE80211_RATE_* flags
> + * @val2: hw specific value for the rate when using short preamble
> + *   (only when IEEE80211_RATE_PREAMBLE2 flag is set, i.e., for
> + *   2, 5.5, and 11 Mbps)

Can't we just get rid of this field? Does anybody use it?

> + * @min_rssi_ack: Minimum required RSSI of packet to generate an ACK ??
> + * @min_rssi_ack_delta: ??

I thought we didn't use these fields.

> +	/* the following fields are set by 80211.o and need not be filled by th=
e

80211.o again :)

johannes

--=-ekyITg1rAnPlAGBYp4Dc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG9DT2/ETPhpq3jKURAvKGAJ9SmaM75xM2w0ztQ8F5vIhBjqYcPgCfTprb
KdP+/6+LfACgZ3TbtWLYZlM=
=g2ZI
-----END PGP SIGNATURE-----

--=-ekyITg1rAnPlAGBYp4Dc--

