Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbYCPARQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2008 20:17:16 -0400
Subject: Re: [PATCH 2/5] mac80211: allows driver to request a Phase 1 RX key
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1205366762-12828-3-git-send-email-reinette.chatre@intel.com>
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-3-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mQFtTrPidoGeYJz7kKhF"
Date: Sat, 15 Mar 2008 20:11:32 +0100
Message-Id: <1205608293.15910.53.camel@johannes.berg> (sfid-20080316_001722_922785_4EDA3CD0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mQFtTrPidoGeYJz7kKhF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-03-12 at 17:05 -0700, Reinette Chatre wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>=20
> This patch makes mac80211 able to send a phase1 key for TKIP decryption.
> This is needed for drivers that don't do the rekeying by themselves
> (i.e. iwlwifi). Upon IV16 wrap around, the packet is decrypted in SW, if
> decryption is ok, mac80211 calls to set_key with a new phase 1 RX key.

> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -590,12 +590,20 @@ enum ieee80211_key_alg {
>   * @IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY: This flag should be set by
>   *	the driver for a TKIP key if it requires a phase2 TX key generation
>   *	in SW. The key will be attached to each packet.
> + * @IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY: This flag should be set by th=
e driver
> + *	for a TKIP key if it requires phase 1 key generation in software.
> + *	The phase 1 key will be sent in the same context as Rx.
> + * @IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID: Set by mac80211, valid only wh=
en
> + *	IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY was set. When set, the phase 1
> + *	fields (tkip_p1k and tkip_iv32) in ieee80211_key_conf are valid.

This really breaks the set_key() model of having always one set_key()
call to add the key and another one to remove it again.

I think it would be much more appropriate to handle this in the driver
by exporting an appropriate phase1 mixing function that takes the
key_conf, iv16, RX vs. TX flag, and for RX the queue number as
arguments. The RX vs. TX flag could be used by the b43 driver since that
hardware can actually derive the phase2 key by itself.

I think for advanced features like crypto hardware acceleration or
similar we should deviate from the "push" model mac80211 has for most
things (and which you also implemented here) so we don't end up creating
special flags for all possible different hardware. A "pull" model is
much more scalable here.

johannes

--=-mQFtTrPidoGeYJz7kKhF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9wfY6Vg1VMiehFYAQLhTw//X9vr6Y4NUxkMn676HflMII1FSpMxZ2fz
8D3bXzEfehLCNgYSoLV+Ad4ntbz+kzf57GjtcMfTfoSvwcg2JHeTRPpvDZzs/QxA
GUvEYP1U8zdu9LLENbKq7buQmRY5Go06sPmuNs54w8rWoiuhospL8FbV8rRmRuMy
LbCaIFjp8uvcLcb0sJ6NutEA9Ipg3zulUKm8fWKpgURT0qth6ou9bYQCnRV0z+le
MSEVV0xprGuufbEGbsd4AbEESfWYTAsgeS6nzNoiO84F6LNAmoM1A5mnTPIwfFan
Kwa9hNKE4Q/BiuT/VbAzit60m7C3BCdO75jA4mJkIEITvxjtrAj7QEp1yDKFC/5U
U7fwGspK8uJhPQZzoWYkeAOfkmRVQNdOEJ2WAkaczmLcQ6ol/mhyUDY97uZ5i6SO
TwF94ZNcPyM/GzJEdmRYYiuugDO6I5l4qCL/OiQvNuDjCGQPaA6BVjpVc1x+N9Mh
KLMDEzBmcGCjR54BM0Ur2TNGAb0Xtq+bFeCOrd9mfweorcsL4bHDW7WbkwQYblk0
tT0NUWymU8YLbDQDLGW8HsXnCoGXXv7zlqnQ5xFBvSQRsykXqMonbZpgUVCjgakq
RW4Qn3ummgzHAwrwQVtaszzy6HUMYE7WDQMLuar0QamVnI3p2FtlbIZlzIwLalc7
rFjJDDNtIhY=
=G9xn
-----END PGP SIGNATURE-----

--=-mQFtTrPidoGeYJz7kKhF--

