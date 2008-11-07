Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYKGV1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 16:27:23 -0500
Subject: Re: [PATCH v3] cfg80211/mac80211: Add 802.11d support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1226005396-10666-1-git-send-email-lrodriguez@atheros.com>
References: <1226005396-10666-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7x+hmzsqOFQh2e8bJkLb"
Date: Fri, 07 Nov 2008 22:27:22 +0100
Message-Id: <1226093242.11203.25.camel@johannes.berg> (sfid-20081107_222727_998781_D5C2AA38)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7x+hmzsqOFQh2e8bJkLb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This replaces 3/3, right? Just got confused with the order.

> +/*
> + * IEEE 802.11-2007 7.3.2.9 Country information element
> + *
> + * Minimum length is 8 octects, ie len must be evenly

typo: octets

> +/**
> + * regulatory_hint_11d - hints a country IE as a regulatory domain
> + * @wiphy: the wireless device giving the hint (used only for reporting
> + *	conflicts)
> + * @country_ie: pointer to the country IE
> + * @country_ie_len: length of the country IE
> + *
> + * We will intersect the rd with the what CRDA tells us should apply
> + * for the alpha2 this country IE belongs to, this prevents APs from
> + * sending us incorrect or outdated information against a country.
> + */
> +extern void regulatory_hint_11d(struct wiphy *wiphy,
> +			        u8 *country_ie,
> +			        u8 country_ie_len);

that looks good :)

> +	if (elems.country_elem) {
> +		/* Note we are only reviewing this on beacons
> +		 * we are associated to */

that sounds a little awkward, are we really associated to beacons? :)


> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index ae7f226..c40a0f2 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -1,6 +1,15 @@
>  config CFG80211
>          tristate "Improved wireless configuration API"
> =20
> +config CFG80211_REG_DEBUG
> +        bool "cfg80211 regulatory debugging"

space indentation

> index 72825af..e2dda15 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -19,7 +19,6 @@
>  #include "nl80211.h"
>  #include "core.h"
>  #include "sysfs.h"
> -#include "reg.h"

why remove that?

> +/* Converts a country IE to a regulatory domain. A regulatory domain
> + * structure has a lot of information which the IE doesn't yet have,
> + * so for the other values we use upper max values as we will intersect
> + * with our userspace regulatory agent to get lower bounds. */
> +static struct ieee80211_regdomain *country_ie_2_rd(
> +				u8 *country_ie,
> +				u8 country_ie_len,
> +				u32 *checksum)
> +{
> +	struct ieee80211_regdomain *rd =3D NULL;
> +	unsigned int i =3D 0;
> +	char alpha2[2];
> +	u32 flags =3D 0;
> +	u32 num_rules =3D 0, size_of_regd =3D 0;
> +	u8 *triplets_start =3D NULL;
> +	u8 len_at_triplet =3D 0;
> +	/* Used too often */
> +	int triplet_size =3D sizeof(struct ieee80211_country_ie_triplet);

It's always like '3', no?

> +	/* the last channel we have registered in a subband (triplet) */
> +	int last_sub_max_channel =3D 0;
> +
> +	*checksum =3D 0xDEADBEEF;
> +
> +	/* Country IE requirements */
> +	BUG_ON(country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN ||
> +		country_ie_len & 0x01);

That seems rather dangerous?


> +		/* When dot11RegulatoryClassesRequired is supported
> +		 * we can throw ext triplets as part of this soup,
> +		 * for now we don't care when those change as we
> +		 * don't support them */
> +		*checksum ^=3D cur_channel ^ cur_sub_max_channel ^
> +			triplet->chans.max_power;

Shouldn't you shift the checksum a bit so that you don't always just use
the lowest byte of it?

> +		/* Note: this is not a IEEE requirement but
> +		 * simply a memory requirement */
> +		if (num_rules > NL80211_MAX_SUPP_REG_RULES)
> +			return NULL;

We could set NL80211_MAX_SUPP_REG_RULES to 85 or something, then
everything would fit. The IE is limited to 255 bytes after all. I don't
think it matters though.

> +		/* The +10 is since the regulatory domain expects
> +		 * the actual band edge, not the center of freq for
> +		 * its start and end freqs, assuming 20 MHz bandwidth on
> +		 * the channels passed */
> +		freq_range->start_freq_khz =3D
> +			MHZ_TO_KHZ(ieee80211_channel_to_frequency(
> +				triplet->chans.first_channel) + 10);
> +		freq_range->end_freq_khz =3D
> +			MHZ_TO_KHZ(ieee80211_channel_to_frequency(
> +				triplet->chans.first_channel +
> +					triplet->chans.num_channels) + 10);

Doesn't that have to be -10 in the start freq?


> +static bool reg_same_country_ie_hint(struct wiphy *wiphy,
> +			u32 country_ie_checksum)
> +{
> +	if (!last_request->wiphy)
> +		return false;
> +	if (likely(last_request->wiphy !=3D wiphy)) {
> +		if (likely(!country_ie_integrity_changes(country_ie_checksum)))
> +			return true;
> +		return false;

how about just
	return !country_ie_integrity_changes(...);

> +	/* IE len must be evenly divisible by 2 */
> +	if (country_ie_len & 0x01)
> +		goto out;
> +
> +	if (country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN)
> +		goto out;

ok nevermind, the BUG_ON above won't ever happen because of this.

> +	/* Pending country IE processing, this can happen after we
> +	 * call CRDA and wait for a response if a beacon was received before
> +	 * we were able to process the last regulatory_hint_11d() call */
> +	if (country_ie_regdomain)
> +		goto out;
> +
> +	alpha2[0] =3D country_ie[0];
> +	alpha2[1] =3D country_ie[1];
> +
> +	if (country_ie[2] =3D=3D 'I')
> +		env =3D ENVIRON_INDOOR;
> +	else if (country_ie[2] =3D=3D 'O')
> +		env =3D ENVIRON_OUTDOOR;
> +
> +	/* We will run this for *every* beacon processed for the BSSID, so
> +	 * we optimize an early check to exit out early if we don't have to
> +	 * do anything */

hopefully soon we won't be processing that many beacons but only changed
ones :)

> +	rd =3D country_ie_2_rd(country_ie, country_ie_len, &checksum);
> +	if (!rd)
> +		goto out;
> +
> +	/* This shouldn't happen right now */
> +	if (likely(reg_same_country_ie_hint(wiphy, checksum)))
> +		goto out;

"shouldn't happen" doesn't really go with likely()?

Overall looks pretty good to me. Much better than before, don't you
think? :)

johannes

--=-7x+hmzsqOFQh2e8bJkLb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFLK2AAoJEKVg1VMiehFYaBcP/jxe6mngzwRke/sVuFt+72Io
uCSaryHQCBUOfaHa5qrL3TooC0QYZQ3Aak5M+GuSl3aafOXxpD8/aG43A+r0Nrrp
JQEs7bm5UnJKSLnkg0Ltu98dr9USGEjw0i5vn/DjJ3/6QfY07sCtiZrNvVm4TzcV
Nr4o/Rz9eKfadSTlhTb0KlTAvWmbwyqcJcSwm5LElcIiCy1L65GGYW8VOM3WyCsa
cpbn+d33ZN8iPn0NkB5U0bHS+TiT7YbdNKLEqdXiC+RKSs+Q+RFHEcP/j83doSyb
ypIem3KQwwhSCpMYUr4Q1tmrNBP+Sf+ZZ2mkA0if0ILc0+6s3Exk8YVnZAIXKCJM
QAteK16+s9qQwEYayfRe/mnJiIN/ZLdqVKdQlUT+fOHYwEDJ6usO4+S3l2iQvo6C
eF3qa1RU5/Kkfu9wwW5DZPIQ5J5N+sLQaC0Xuv4XLg0FDCwNBd2qftWNRHmB6wPs
HJ5StGCdQN1T0+SSdDdgVwTC+Mli1zUVhmD5lCDL+KDy50pTg+WcP1SAEFLMqE/y
+jH4fvBkDbGEC2bkOxNmoOpolRLiavxMYQhi8PyjVWDPLhd3wu8lFZjSqSY/kjqC
Gl2cMR1ouuWSHNkSZDY/8HGOVF5mBr0tOJ0X053RiAo1TAb/n2Z3LaF5e+oeRsT9
eh60bn8vlM3jLDv/eVNa
=OSJR
-----END PGP SIGNATURE-----

--=-7x+hmzsqOFQh2e8bJkLb--

