Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55168 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbXJXNPC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 09:15:02 -0400
Subject: Re: [PATCH 1/2] mac80211: [RFC] adding bss_config to low level
	driver ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
In-Reply-To: <11932213374183-git-send-email-ron.rindjunsky@intel.com>
References: <11932213323451-git-send-email-ron.rindjunsky@intel.com>
	 <11932213374183-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gRuq7T2hhhjgwUFH14/R"
Date: Wed, 24 Oct 2007 14:00:18 +0200
Message-Id: <1193227218.4510.31.camel@johannes.berg> (sfid-20071024_141514_341428_0ABCD7AC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gRuq7T2hhhjgwUFH14/R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-24 at 12:22 +0200, Ron Rindjunsky wrote:

> +#define BSS_VERIFY_STATE_ASSOC		(1<<0)

Why "verify"? Shouldn't it be "CHANGED" instead?

> +struct ieee80211_bss_data {
> +	u8 verify_map;

Seeing that you already used 5 of 8 bits and we're likely to increase
this in the future, I'd go with a u32 here. Also, have you attempted to
make all fields 'valid' all the time and if so, why is there no
'changed' bitmap passed to the callback?

> +	/* association related data */
> +	u8 assoc;
> +	u16 aid;

And then reorder these two for less padding.

> + * @bss_info_changed: Handler for configuration requests related to BSS
> + * 	parameters that may vary during BSS's lifespan, and may affect low
> + * 	level driver (e.g. assoc/disassoc status, erp parameters).
> + * 	This function should not be used if no BSS has been set, unless
> + * 	for association indication.

I don't understand the last sentence here. Can you elaborate? Is it
meant as a note for mac80211 hackers? If so, wouldn't it be more
appropriate to add it to the function that calls this? Also, you didn't
add the if_id which will even break Intel's driver once multi-MAC
support is added...

> @@ -276,6 +276,7 @@ struct ieee80211_if_sta {
>  	u32 supp_rates_bits;
> =20
>  	int wmm_last_param_set;
> +	struct ieee80211_bss_data bss_data;

Are you sure this will work properly? The same stuff must also be used
for AP mode, when hostapd decides to change things, no?

> +				if (bss->has_erp_value)
> +				    ieee80211_handle_erp_ie(dev,
> +							    bss->erp_value);

Seeing that you're shuffling around this code anyway, I'd put patch 2
into this patch.
=20
johannes

--=-gRuq7T2hhhjgwUFH14/R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARx8z0qVg1VMiehFYAQJL3xAAvth2cMidKlCaDmtZSjXsZqAenrvdMA1w
aWv+JlrZed5faTgf1kpMMcBCIUAkGXsSuvLqkMT1x0HilkjJIqmctQsoqkn/G6r0
a19xNtjmDr6gVjhsoujCdoW18U5cU/EZX/BtNUy+FKp5o+WGromhRMmYQsvTAXnJ
ymW+GyIVDCv9lc+FICFj6hSpY5CD5KvArkCpFEMVE/FBX+47hvZP68ZW28NP/+OE
zm7IBwseo6oOsWEemTaW3Qs3KkBMws95HvrlqNfyNJ+26nWY6TAIXpiEV+3STanZ
+6QtHqPEaPji1u8aLcmc8fCk6OOM0z0dnf+CKY3YH34f4NkMcyl+OF1I/z814HSw
Fw4aR9X1If+hru0XMN+Frt0uOpLYPkCp3tTrccQGZGQjar0sZwIjZMVvXCuTVwnv
l1WHlohlATMz/SkvTssQ1nWTQqBCglzNKhJVBX2Px7kKicUHq7oPhBEAVHa+a41V
ziquiaWSFqn5nrrce90SGiN85RQ8BV6NNUTUBuc8XKXA1bEWpQd9c08873B1UTo3
3YaeAzQMV8Df84TDkg9MWlmNB1uvxVzDaEnl2/mHNHqgP7thLhuIXnRvIyeeZVv4
fRYqxX7vtXwvm9fpNFAsrEFBAFcQTiKP7ELvEnJtrcu0zJcQp6iaLgscadtdEwdN
GIsdMbR/VLU=
=MU5t
-----END PGP SIGNATURE-----

--=-gRuq7T2hhhjgwUFH14/R--

