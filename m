Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38005 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZDBBq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 21:46:58 -0400
Subject: Re: [PATCH v3 3/3] cfg80211: send regulatory beacon hint events to
 userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1238636130-27747-3-git-send-email-lrodriguez@atheros.com>
References: <1238636130-27747-1-git-send-email-lrodriguez@atheros.com>
	 <1238636130-27747-3-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-668TeznjudvGJFJfl9qU"
Date: Thu, 02 Apr 2009 03:46:21 +0200
Message-Id: <1238636782.4141.0.camel@johannes.local> (sfid-20090402_034701_942974_675CE102)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-668TeznjudvGJFJfl9qU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-01 at 21:35 -0400, Luis R. Rodriguez wrote:

> +void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
> +				    struct ieee80211_channel *channel_before,
> +				    struct ieee80211_channel *channel_after)
> +{
> +#define NL80211_PUT_BC_CHAN(_attr, _chan) do { \
> +	nl_freq =3D nla_nest_start(msg, _attr); \
> +	if (!nl_freq) \
> +		goto nla_put_failure; \
> +	if (nl80211_msg_put_channel(msg, _chan)); \
> +		goto nla_put_failure; \
> +	nla_nest_end(msg, nl_freq); \
> +} while (0)

Please just open-code that, and there's a ; too much after the if.

Otherwise good series, thanks.

johannes

--=-668TeznjudvGJFJfl9qU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1BjnAAoJEKVg1VMiehFYPXwQALrPiVli1fVZftY1xU8W1RAj
Z+aSFLQrZrf6OeLS6g5sIqKOqUx37DY867pPCZfSH4taU5jaEDTfY3EBUfVAJP33
VAUkn22rhlDM/jqz+fbSYBCGQrN2Sbes+Zb3lgpK6/jNXXkZ4QPJDQSHJELQ2A+G
HHSiSqRPVfek4XTl0Bf04KF+r4Gjmu+sDgVuOL2ECtBWYE4NEQ3K485U4WHFDDsu
xrLMmJN/hjQCUQ2U/MeBCM0AreChfy2NAYrIvoVSzEzQGDIS6L5CHD03IJnVhORs
UziKRAb4zFY4qft1Tbs0bYB/M840FIobkvbdpzP7YQNnAqcdLIAtH1XNTEI7YATh
fiPrE9T0iNr4OUU8wDSx74Hy7u4q0b8AXX9fbIKX+CWJSd/BmkV0i3T9bMaVPmFT
CTzn22dOV+gJCf5S4ezAlHWHgItWrctFd3T2LYBbi+RP9fBh8yktPv1gHosUZ1fU
JWs/vNEYOdu7K8oanzhqQPWp6gbd2P6QqlFxdsYjCnBEZCtWlebJy1pm5+ZbD0Nd
38zRkWgsBIt46NP8zThmSf+immBRhTWdLEzDrXhGpK7VbzgHW+uQEuFvKOvoz+v4
NP1fSg4ByLphfxS7A1249FG/7fK1yfxQh1k0i444Bt+k8dDHB+iWaj1Vhavx6Uu5
YmetBsUgqxzoWAky//Uf
=ZHCe
-----END PGP SIGNATURE-----

--=-668TeznjudvGJFJfl9qU--

