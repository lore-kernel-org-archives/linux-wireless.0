Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39123 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbYJaKPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 06:15:47 -0400
Subject: Re: [RFC] wireless: Add 802.11d support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225428211-17353-1-git-send-email-lrodriguez@atheros.com> (sfid-20081031_054338_414241_747AA340)
References: <1225428211-17353-1-git-send-email-lrodriguez@atheros.com>
	 (sfid-20081031_054338_414241_747AA340)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VXOZIPhCE427KahnOi4s"
Date: Fri, 31 Oct 2008 11:15:43 +0100
Message-Id: <1225448143.3535.17.camel@johannes.berg> (sfid-20081031_111553_159356_AF924B40)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VXOZIPhCE427KahnOi4s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 21:43 -0700, Luis R. Rodriguez wrote:

> +struct ieee80211_regdomain *ieee80211_country_ie_2_rd(
> +				u8 *country_ie, u8 country_ie_len)
> +{
> +	struct ieee80211_regdomain *rd =3D NULL;
> +	u32 flags =3D 0;
> +	u32 num_rules =3D 0, size_of_regd =3D 0;
> +	u8 *triplets_start =3D NULL;
> +	u8 len_at_triplet =3D 0;
> +	unsigned int i =3D 0;
> +	/* Used too often */
> +	int triplet_size =3D sizeof(struct ieee80211_country_ie_triplet);
> +
> +	rd->alpha2[0] =3D country_ie[0];
> +	rd->alpha2[1] =3D country_ie[1];
> +
> +	/*
> +	 * Third octet can be:
> +	 *    'I' - Indoor
> +	 *    'O' - Outdoor
> +	 *
> +	 *  anything else we assume is no restrictions
> +	 */
> +	if (country_ie[2] =3D=3D 'I')
> +		flags =3D NL80211_RRF_NO_OUTDOOR;
> +	else if (country_ie[2] =3D=3D 'O')
> +		flags =3D NL80211_RRF_NO_INDOOR;
> +
> +	country_ie +=3D 3;
> +	country_ie_len -=3D 3;

This needs to verify that the country IE is valid to start with, i.e. >=3D
3 bytes long.

<snipped, will review algorithm and stuff later>

> +#ifdef CONFIG_WIRELESS_OLD_REGULATORY
> +		/* We can't expect to have anything to intersect with...
> +		 * so use standard low values */
> +		freq_range->max_bandwidth_khz =3D MHZ_TO_KHZ(40);
> +		power_rule->max_antenna_gain =3D DBI_TO_MBI(6);
> +		power_rule->max_eirp =3D DBM_TO_MBM(20);
> +#else
> +		/* Large arbitrary values, we intersect later */
> +		/* Increment this if we ever support >=3D 40 MHz channels
> +		 * in IEEE 802.11 */
> +		freq_range->max_bandwidth_khz =3D MHZ_TO_KHZ(40);
> +		power_rule->max_antenna_gain =3D DBI_TO_MBI(100);
> +		power_rule->max_eirp =3D DBM_TO_MBM(100);
> +#endif

Why is this necessary? In case of OLD_REGULATORY we _do_ have values to
intersect with, from the old hardcoded stuff. Please don't treat that so
special, just treat old regulatory as though we had pre-loaded some
regulatory information into the kernel.


> +#ifdef CONFIG_WIRELESS_OLD_REGULATORY
> +	/* If the userspace regulatory agent is installed when
> +	 * OLD_REGULATORY is enabled then great, if not then oh well,
> +	 * we'll use low ball values */
> +	return 0;
> +#endif

Same here.

> +	if (!r) {
> +		printk(KERN_ERR "cfg80211: calling CRDA failed - "
> +			"unable to get country regulatory information "
> +			"for country IE\n");
> +		return -EINVAL;
> +	}

This printk is misplaced, if it should be there at all it should be in
cfg80211, mac80211 need not know anything about crda. Also, !r is
incorrect, just remove the whole code block and do

return regulatory_hint_ie(...);

Also, the printk shouldn't be there at all because otherwise it'll
happen all the time when a country IE is received w/o crda installed,
flooding the logs.

> +	if (elems.country_elem) {
> +		r =3D ieee80211_sta_process_country_ie(ifsta, local,
> +			elems.country_elem, elems.country_elem_len);

Some code here or in the processing function should compare the country
element and only process it if it changed to avoid calling crda 10 times
per second....

> +#ifdef CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG
> +		if (!r)

!r is wrong again

johannes

--=-VXOZIPhCE427KahnOi4s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCtrLAAoJEKVg1VMiehFYRjgP/jaVkz5torTVuZZtsrxAvsgc
bA99Poqlea/lrFJME7p0XO3jPjBYRsQtUvvOGpICSr+arWEq2yLNP+2XYoEoDXY9
T9tolyc635eGWVFprd1i3TNFjfpzgD4VhMeBWXPF2TRRC18ZyABSMUlxLhAuSVig
2fkMRuPSvalwVHcGnNjLRTPse+7Cvb/WZfPaB1UBUpHXZhvH7LyREU0+rc5a3eRK
bo0py+5yR1w4YKCftEMtcnWGA583ResgwKPGUf+E2xRk8F0S6K1G2D6g3hz8nOUo
zCol1Cmn7Rl/cV52gbVkW1Bzj17/1UJcq2Agw8kj6Ct7nDkBx2dt8YD08S/UMa+9
rFdMmxQFX2PM/zVLArBnII6gZnBqI5jJsXKUMaEVrHSTH0lop6GlLnN0wr9sMIy5
kX2GR2zfBkYUy+DvtKpHx3d0lie7Fk4VGzdzNib7PlvQOeWyy4Q9VPNRn2b4HbiL
fg8KM1AkrYaNkIA4OEe7mYd7Xt4Bwti23sBsZC82hdMvvsZNiY0GDQKy+RPqtClb
5yz78s5piwLi/kcn6E2oVNbyfCHSRFyWqvwSpN6jSF+5tE3NkNIrX9zIq41rF2hn
WKYllxEMqFqmI620wxUlXUSqu5i/F1t3rx6iBHEsKXdRt1g/8/Hj5r4SCka08hO9
6lCmwHijz85j6D0sKDeF
=Q3kL
-----END PGP SIGNATURE-----

--=-VXOZIPhCE427KahnOi4s--

