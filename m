Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616AbZAPJ3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:29:04 -0500
Subject: Re: [PATCH 13/13] cfg80211: Remove CONFIG_WIRELESS_OLD_REGULATORY
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232064746-17134-14-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-9-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-10-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-11-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-12-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-13-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-14-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ePCKWuUfKPd/1fsETL35"
Date: Fri, 16 Jan 2009 10:28:11 +0100
Message-Id: <1232098091.3854.37.camel@johannes> (sfid-20090116_102916_129582_D2D0A628)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ePCKWuUfKPd/1fsETL35
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> This removal was scheduled for 2.6.29 but we decided to
> keep it around a bit longer. Now that we are on road to
> 2.6.30 lets remove it.

Alright, fine, I still run this because my distro hasn't picked up crda
yet, but I guess that just means I need to get my distro to do that.

> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  Documentation/feature-removal-schedule.txt |   18 ---
>  net/wireless/Kconfig                       |   46 +++------
>  net/wireless/nl80211.c                     |    5 -
>  net/wireless/reg.c                         |  161 +++-------------------=
------
>  4 files changed, 26 insertions(+), 204 deletions(-)
>=20
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/f=
eature-removal-schedule.txt
> index ac98851..f178d8b 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -6,24 +6,6 @@ be removed from this file.
> =20
>  ---------------------------
> =20
> -What:	old static regulatory information and ieee80211_regdom module para=
meter
> -When:	2.6.29
> -Why:	The old regulatory infrastructure has been replaced with a new one
> -	which does not require statically defined regulatory domains. We do
> -	not want to keep static regulatory domains in the kernel due to the
> -	the dynamic nature of regulatory law and localization. We kept around
> -	the old static definitions for the regulatory domains of:
> -		* US
> -		* JP
> -		* EU
> -	and used by default the US when CONFIG_WIRELESS_OLD_REGULATORY was
> -	set. We also kept around the ieee80211_regdom module parameter in case
> -	some applications were relying on it. Changing regulatory domains
> -	can now be done instead by using nl80211, as is done with iw.
> -Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
> -
> ----------------------------
> -
>  What:	dev->power.power_state
>  When:	July 2007
>  Why:	Broken design for runtime control over driver power states, confusi=
ng
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index e28e2b8..bc00782 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -1,5 +1,18 @@
>  config CFG80211
>          tristate "Improved wireless configuration API"
> +	---help---
> +	  cfg80211 is the new wireless driver framework. If you have a
> +	  modern wireless card you want to enable this option.
> +
> +	  cfg80211's regulatory framework requires a userspace application
> +	  which has the database of regulatory information (CRDA). Setting
> +	  of regulatory domains can be done by drivers, or the wireless core
> +	  based on country information elements. Users can also use userspace
> +	  applications like iw or wpa_supplicant to help compliance further.
> +
> +	  For more information see:
> +
> +	  http://wireless.kernel.org/en/developers/Regulatory/
> =20
>  config CFG80211_REG_DEBUG
>  	bool "cfg80211 regulatory debugging"
> @@ -23,39 +36,6 @@ config NL80211
> =20
>  	  If unsure, say Y.
> =20
> -config WIRELESS_OLD_REGULATORY
> -	bool "Old wireless static regulatory definitions"
> -	default y
> -	---help---
> -	  This option enables the old static regulatory information
> -	  and uses it within the new framework. This is available
> -	  temporarily as an option to help prevent immediate issues
> -	  due to the switch to the new regulatory framework which
> -	  does require a new userspace application which has the
> -	  database of regulatory information (CRDA) and another for
> -	  setting regulatory domains (iw).
> -
> -	  For more information see:
> -
> -	  http://wireless.kernel.org/en/developers/Regulatory/CRDA
> -	  http://wireless.kernel.org/en/users/Documentation/iw
> -
> -	  It is important to note though that if you *do* have CRDA present
> -	  and if this option is enabled CRDA *will* be called to update the
> -	  regulatory domain (for US and JP only). Support for letting the user
> -	  set the regulatory domain through iw is also supported. This option
> -	  mainly exists to leave around for a kernel release some old static
> -	  regulatory domains that were defined and to keep around the old
> -	  ieee80211_regdom module parameter. This is being phased out and you
> -	  should stop using them ASAP.
> -
> -	  Note: You will need CRDA if you want 802.11d support
> -
> -	  Say Y unless you have installed a new userspace application.
> -	  Also say Y if have one currently depending on the ieee80211_regdom
> -	  module parameter and cannot port it to use the new userspace
> -	  interfaces.
> -
>  config WIRELESS_EXT
>  	bool "Wireless extensions"
>  	default n
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 123d3b1..2e7f9eb 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -1896,11 +1896,6 @@ static int nl80211_req_set_reg(struct sk_buff *skb=
, struct genl_info *info)
> =20
>  	data =3D nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
> =20
> -#ifdef CONFIG_WIRELESS_OLD_REGULATORY
> -	/* We ignore world regdom requests with the old regdom setup */
> -	if (is_world_regdom(data))
> -		return -EINVAL;
> -#endif
>  	mutex_lock(&cfg80211_drv_mutex);
>  	r =3D __regulatory_hint(NULL, REGDOM_SET_BY_USER, data, 0, ENVIRON_ANY)=
;
>  	mutex_unlock(&cfg80211_drv_mutex);
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 271b54a..d91a046 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -110,103 +110,6 @@ static const struct ieee80211_regdomain world_regdo=
m =3D {
>  static const struct ieee80211_regdomain *cfg80211_world_regdom =3D
>  	&world_regdom;
> =20
> -#ifdef CONFIG_WIRELESS_OLD_REGULATORY
> -static char *ieee80211_regdom =3D "US";
> -module_param(ieee80211_regdom, charp, 0444);
> -MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code")=
;
> -
> -/* We assume 40 MHz bandwidth for the old regulatory work.
> - * We make emphasis we are using the exact same frequencies
> - * as before */
> -
> -static const struct ieee80211_regdomain us_regdom =3D {
> -	.n_reg_rules =3D 6,
> -	.alpha2 =3D  "US",
> -	.reg_rules =3D {
> -		/* IEEE 802.11b/g, channels 1..11 */
> -		REG_RULE(2412-10, 2462+10, 40, 6, 27, 0),
> -		/* IEEE 802.11a, channel 36 */
> -		REG_RULE(5180-10, 5180+10, 40, 6, 23, 0),
> -		/* IEEE 802.11a, channel 40 */
> -		REG_RULE(5200-10, 5200+10, 40, 6, 23, 0),
> -		/* IEEE 802.11a, channel 44 */
> -		REG_RULE(5220-10, 5220+10, 40, 6, 23, 0),
> -		/* IEEE 802.11a, channels 48..64 */
> -		REG_RULE(5240-10, 5320+10, 40, 6, 23, 0),
> -		/* IEEE 802.11a, channels 149..165, outdoor */
> -		REG_RULE(5745-10, 5825+10, 40, 6, 30, 0),
> -	}
> -};
> -
> -static const struct ieee80211_regdomain jp_regdom =3D {
> -	.n_reg_rules =3D 3,
> -	.alpha2 =3D  "JP",
> -	.reg_rules =3D {
> -		/* IEEE 802.11b/g, channels 1..14 */
> -		REG_RULE(2412-10, 2484+10, 40, 6, 20, 0),
> -		/* IEEE 802.11a, channels 34..48 */
> -		REG_RULE(5170-10, 5240+10, 40, 6, 20,
> -			NL80211_RRF_PASSIVE_SCAN),
> -		/* IEEE 802.11a, channels 52..64 */
> -		REG_RULE(5260-10, 5320+10, 40, 6, 20,
> -			NL80211_RRF_NO_IBSS |
> -			NL80211_RRF_DFS),
> -	}
> -};
> -
> -static const struct ieee80211_regdomain eu_regdom =3D {
> -	.n_reg_rules =3D 6,
> -	/* This alpha2 is bogus, we leave it here just for stupid
> -	 * backward compatibility */
> -	.alpha2 =3D  "EU",
> -	.reg_rules =3D {
> -		/* IEEE 802.11b/g, channels 1..13 */
> -		REG_RULE(2412-10, 2472+10, 40, 6, 20, 0),
> -		/* IEEE 802.11a, channel 36 */
> -		REG_RULE(5180-10, 5180+10, 40, 6, 23,
> -			NL80211_RRF_PASSIVE_SCAN),
> -		/* IEEE 802.11a, channel 40 */
> -		REG_RULE(5200-10, 5200+10, 40, 6, 23,
> -			NL80211_RRF_PASSIVE_SCAN),
> -		/* IEEE 802.11a, channel 44 */
> -		REG_RULE(5220-10, 5220+10, 40, 6, 23,
> -			NL80211_RRF_PASSIVE_SCAN),
> -		/* IEEE 802.11a, channels 48..64 */
> -		REG_RULE(5240-10, 5320+10, 40, 6, 20,
> -			NL80211_RRF_NO_IBSS |
> -			NL80211_RRF_DFS),
> -		/* IEEE 802.11a, channels 100..140 */
> -		REG_RULE(5500-10, 5700+10, 40, 6, 30,
> -			NL80211_RRF_NO_IBSS |
> -			NL80211_RRF_DFS),
> -	}
> -};
> -
> -static const struct ieee80211_regdomain *static_regdom(char *alpha2)
> -{
> -	if (alpha2[0] =3D=3D 'U' && alpha2[1] =3D=3D 'S')
> -		return &us_regdom;
> -	if (alpha2[0] =3D=3D 'J' && alpha2[1] =3D=3D 'P')
> -		return &jp_regdom;
> -	if (alpha2[0] =3D=3D 'E' && alpha2[1] =3D=3D 'U')
> -		return &eu_regdom;
> -	/* Default, as per the old rules */
> -	return &us_regdom;
> -}
> -
> -static bool is_old_static_regdom(const struct ieee80211_regdomain *rd)
> -{
> -	if (rd =3D=3D &us_regdom || rd =3D=3D &jp_regdom || rd =3D=3D &eu_regdo=
m)
> -		return true;
> -	return false;
> -}
> -#else
> -static inline bool is_old_static_regdom(const struct ieee80211_regdomain=
 *rd)
> -{
> -	return false;
> -}
> -#endif
> -
>  static void reset_regdomains(void)
>  {
>  	/* avoid freeing static information or freeing something twice */
> @@ -216,8 +119,6 @@ static void reset_regdomains(void)
>  		cfg80211_world_regdom =3D NULL;
>  	if (cfg80211_regdomain =3D=3D &world_regdom)
>  		cfg80211_regdomain =3D NULL;
> -	if (is_old_static_regdom(cfg80211_regdomain))
> -		cfg80211_regdomain =3D NULL;
> =20
>  	kfree(cfg80211_regdomain);
>  	kfree(cfg80211_world_regdom);
> @@ -1203,16 +1104,6 @@ new_request:
>  	if (r < 0)
>  		return r;
> =20
> -	/*
> -	 * Note: When CONFIG_WIRELESS_OLD_REGULATORY is enabled
> -	 * AND if CRDA is NOT present nothing will happen, if someone
> -	 * wants to bother with 11d with OLD_REG you can add a timer.
> -	 * If after x amount of time nothing happens you can call:
> -	 *
> -	 * return set_regdom(country_ie_regdomain);
> -	 *
> -	 * to intersect with the static rd
> -	 */
>  	return call_crda(alpha2);
>  }
> =20
> @@ -1467,16 +1358,11 @@ static int __set_regdom(const struct ieee80211_re=
gdomain *rd)
>  	if (!last_request)
>  		return -EINVAL;
> =20
> -	/* Lets only bother proceeding on the same alpha2 if the current
> -	 * rd is non static (it means CRDA was present and was used last)
> -	 * and the pending request came in from a country IE */
> -	if (last_request->initiator !=3D REGDOM_SET_BY_COUNTRY_IE) {
> -		/* If someone else asked us to change the rd lets only bother
> -		 * checking if the alpha2 changes if CRDA was already called */
> -		if (!is_old_static_regdom(cfg80211_regdomain) &&
> -		    !regdom_changed(rd->alpha2))
> -			return -EINVAL;
> -	}
> +	/* Lets only bother proceeding on the same alpha2 if the
> +	 * pending request came in from a country IE */
> +	if (last_request->initiator !=3D REGDOM_SET_BY_COUNTRY_IE &&
> +	    !regdom_changed(rd->alpha2))
> +		return -EINVAL;
> =20
>  	wiphy =3D last_request->wiphy;
> =20
> @@ -1548,24 +1434,18 @@ static int __set_regdom(const struct ieee80211_re=
gdomain *rd)
>  	 */
> =20
>  	BUG_ON(!country_ie_regdomain);
> +	BUG_ON(rd =3D=3D country_ie_regdomain);
> =20
> -	if (rd !=3D country_ie_regdomain) {
> -		/* Intersect what CRDA returned and our what we
> -		 * had built from the Country IE received */
> +	/* Intersect what CRDA returned and our what we
> +	 * had built from the Country IE received */
> =20
> -		intersected_rd =3D regdom_intersect(rd, country_ie_regdomain);
> +	intersected_rd =3D regdom_intersect(rd, country_ie_regdomain);
> =20
> -		reg_country_ie_process_debug(rd, country_ie_regdomain,
> -			intersected_rd);
> +	reg_country_ie_process_debug(rd, country_ie_regdomain,
> +		intersected_rd);
> =20
> -		kfree(country_ie_regdomain);
> -		country_ie_regdomain =3D NULL;
> -	} else {
> -		/* This would happen when CRDA was not present and
> -		 * OLD_REGULATORY was enabled. We intersect our Country
> -		 * IE rd and what was set on cfg80211 originally */
> -		intersected_rd =3D regdom_intersect(rd, cfg80211_regdomain);
> -	}
> +	kfree(country_ie_regdomain);
> +	country_ie_regdomain =3D NULL;
> =20
>  	if (!intersected_rd)
>  		return -EINVAL;
> @@ -1634,19 +1514,6 @@ int regulatory_init(void)
>  	if (IS_ERR(reg_pdev))
>  		return PTR_ERR(reg_pdev);
> =20
> -#ifdef CONFIG_WIRELESS_OLD_REGULATORY
> -	cfg80211_regdomain =3D static_regdom(ieee80211_regdom);
> -
> -	printk(KERN_INFO "cfg80211: Using static regulatory domain info\n");
> -	print_regdomain_info(cfg80211_regdomain);
> -	/* The old code still requests for a new regdomain and if
> -	 * you have CRDA you get it updated, otherwise you get
> -	 * stuck with the static values. We ignore "EU" code as
> -	 * that is not a valid ISO / IEC 3166 alpha2 */
> -	if (ieee80211_regdom[0] !=3D 'E' || ieee80211_regdom[1] !=3D 'U')
> -		err =3D __regulatory_hint(NULL, REGDOM_SET_BY_CORE,
> -					ieee80211_regdom, 0, ENVIRON_ANY);
> -#else
>  	cfg80211_regdomain =3D cfg80211_world_regdom;
> =20
>  	err =3D __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00", 0, ENVIRON_AN=
Y);
> @@ -1654,8 +1521,6 @@ int regulatory_init(void)
>  		printk(KERN_ERR "cfg80211: calling CRDA failed - "
>  		       "unable to update world regulatory domain, "
>  		       "using static definition\n");
> -#endif
> -
>  	return 0;
>  }
> =20

--=-ePCKWuUfKPd/1fsETL35
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcFMpAAoJEKVg1VMiehFY/DgQAKw/4HRCG2Xe4fkthO9ak/Cm
8LNNsC1U7PKt3PKlY+eRE9uXYwBhZTrEYtPtf1wMZYo0o+q/2WAsz9AdL6psmFxN
5e8rbH0QlhETgTIfvFOEvnrMGk76UAQ/ppqpsY5eIcp6DL3w2AANzXf8xRzD2rMl
YZsVnWZH++O4FOkD8Nw1qstCGXXUut2m5yjO8jxlbRGci0REKPGS1HbwNcXZhq5V
KyFbjro4XGkACFgo1KbEpq1/Xsn/63ghtXQIz2kqp23e2uChtzZJTcWHfGjI/bF1
e6Sl1Z4zmjb1PIcMKU4nAr5bAoEoDHq3IigD2uIMxQkLfzTiXpXg61Ve3Sz9L67D
/bL3+igTjlrxXYtqRs6jixq6T5EmF5Zr5Qwx7ICR+4Tz0JXbEsi825HUWiwb5C+B
mJP4vJfy2E+NJCSzvX/tGLBDe6DENIwaihLdITOm8uAcRVJmRYxKkF2ErvFOOl1c
V2ZXWb/AXwa2X13TpwWkMPhtMZOcX0UchVzrFuZli+8/0ogtSTxYLofKZ7ooLL+m
OuihBXreCphkz/tZuiaeivX2WTJ59n5O3hp6FBecCwO3WAXwMBtOCLEh0UTbjht1
UTVkWmYHgIWGdPB+V++tBN7PXRQipxUkUinjCeS34/VQIQG2Uxt/TVRaxpE4AS5V
wpgD8rBot8eFgpPwxeaA
=UXeT
-----END PGP SIGNATURE-----

--=-ePCKWuUfKPd/1fsETL35--

