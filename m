Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S943996AbYCTAEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 20:04:50 -0400
Subject: Re: [PATCH 5/7] mac80211: allows driver to request a Phase 1 RX key
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1205970106-22196-6-git-send-email-reinette.chatre@intel.com>
References: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com>
	 <1205970106-22196-2-git-send-email-reinette.chatre@intel.com>
	 <1205970106-22196-3-git-send-email-reinette.chatre@intel.com>
	 <1205970106-22196-4-git-send-email-reinette.chatre@intel.com>
	 <1205970106-22196-5-git-send-email-reinette.chatre@intel.com>
	 <1205970106-22196-6-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2pGrE4Lyk9+FSzULXFt7"
Date: Thu, 20 Mar 2008 01:04:34 +0100
Message-Id: <1205971474.16475.84.camel@johannes.berg> (sfid-20080320_000512_418815_AAA0DA86)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2pGrE4Lyk9+FSzULXFt7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -586,11 +586,15 @@ enum ieee80211_key_alg {
>   * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
>   *	the driver for a TKIP key if it requires Michael MIC
>   *	generation in software.
> + * @IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY: This flag should bet by
> + * 	the driver for a TKIP key if it requires phase 1 key generation
> + * 	in SW.

Please get rid of the flag and just use a condition like

	if (ops->update_tkip_callback &&
	    key->conf.flags & UPLOADED_TO_HARDWARE)

I cannot imagine hardware that wants this callback for some keys but not
for others.

> + *
> + * In TKIP some HW need to be provided a phase 1 key, for RX decryption
> + * acceleration (i.e. iwlwifi). Those drivers should set
> + * IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
> + * The update_tkip_key() call updates the driver with the new phase 1 ke=
y.
> + * This happens everytime the iv16 wraps around (every 65536 packets). T=
he
> + * set_key() call will happen only once during a rekeying session, it wi=
ll not

I would say "The set_key() call will still happen only once for each
key, ..."

> + * include a valid phase 1 key. The valid phase 1 key is provided by
> + * udpate_tkip_key only. The trigger that makes mac80211 call this handl=
er is

typo: update_tkip_key

johannes

--=-2pGrE4Lyk9+FSzULXFt7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+GqEaVg1VMiehFYAQI1og//Vj/dU3+EU4fCeumURx1JG2pazusMOhN8
16RWEO+uDUqpOyIPSbKooBTe1SwUHjdBfLhmr6U9NGHycUxdC6RbvevvU372ZuJG
3vCDbPcQJ371iBDeeyBlkKx79jMUdQupcW+8VCYA50kbWGDO4NMnc6aImbw668Xh
e8fJ48n7Pn/1uItan+2c41WnTc5t8o1tOuZx00DNHeGtVAmSjCpTF3vAdnDAhwe5
Og7G6V/FHoo7iiN8oo/NI32JaJ43IQ8yV96TLr5lIt39LWqGzFpNSd3Ds4vqWHRj
yncvL4nXR8WSOuJV/tU7bkV8Fr81uqOlBcLCS/Yx8b+JPr9QMRclUdfbGr8G2GGm
vtNf/Y/qw9s3jwpvcCYcqkhaj5zhJRz7UndrZ+lyW78XJF7HxyuLiqRaxpv8hbOQ
d9MoxJcdveEF2gJ9RiT/lKr4p3uVLH+k8pspvxKl4zYxWXOpl7Co995X73NiO9+H
U6AWL0+uuNH4KLF4bnhje96EG7dQa6m3Kzf+fnobT4C1BNprzM19pdOuZCBz+nHm
nucWOwU6yyKQSqmvUcVz6pOS5vknmuy5ELyHXilbk+YLvnj4pQIY4M2gTISOZbQC
z5cB4D1d9YxeOshkdfAnQV9Epdje3BUnk9fWjGgUGAoLIgfe9921zLZZftihaZX8
p7ECFx+lWig=
=X4yT
-----END PGP SIGNATURE-----

--=-2pGrE4Lyk9+FSzULXFt7--

