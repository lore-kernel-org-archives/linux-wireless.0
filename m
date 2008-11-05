Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbYKEMXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 07:23:05 -0500
Subject: Re: [PATCH 7/7] cfg80211/mac80211: Add Country IE parsing/802.11d
	support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225853406-16322-8-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-8-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f+m6sg43y/kGeinxrdqf"
Date: Wed, 05 Nov 2008 13:23:03 +0100
Message-Id: <1225887783.3619.108.camel@johannes.berg> (sfid-20081105_132311_982255_6264667A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f+m6sg43y/kGeinxrdqf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-04 at 18:50 -0800, Luis R. Rodriguez wrote:


>=20
> +/*
> + * IEEE 802.11-2007 7.3.2.9 Country information element
> + *
> + * Minimum length is 8 octects, ie len must be evenly
> + * divisible by 2
> + */

That seems odd, I thought there are triplets in there? That mean it
should be 2+N*3, no?

> +/*
> + * Regulatory extension stuff is for 802.11j, ammeneded to
> + * IEEE 802.11-2007, see Annex I (page 1141) and Annex J
> + * (page 1147). Also review 7.3.2.9.

I think you should drop the 802.11j mention, it's just confusing when
that document no longer exists and you also mention annex J.

> + * When dot11RegulatoryClassesRequired is true and the
> + * first_channel/reg_extension_id is >=3D 201 then the IE
> + * compromises of the 'ext' struct represented below:
> + *
> + *  - Regulatory extension ID - when generating IE this just needs
> + *    to be monotonically increasing for each triplet passed in
> + *    the IE
> + *  - Regulatory class - index into set of rules
> + *  - Coverage class - index into air propagation time (Table 7-27),
> + *    in microseconds, you can compute the air propagation time from
> + *    the index by multiplying by 3, so index 10 yields a propagation
> + *    of 10 us. Valid values are 0-31, values 32-255 are not defined
> + *    yet. A value of 0 inicates air propagation of <=3D 1 us.

indicates

> + *
> + *  See also Table I.2 for Emission limit sets and table
> + *  I.3 for Behavior limit sets. Table J.1 indicates how to map
> + *  a reg_class to an emission limit set and behavior limit set.

heh. my spell checker doesn't like behavior (rather than behaviour) but
I guess that's because it's set to proper English ;)

> + */
> +#define IEEE80211_COUNTRY_EXTENSION_ID 201

Should that be something like EXTENSION_ID_OFFSET? Clearly they must
mean to subtract this?

> +/*
> + *  Channels numbers in the IE must be monntonically increasing

monotonically

> @@ -181,6 +181,13 @@ struct ieee80211_supported_band {
>   * struct wiphy - wireless hardware description
>   * @idx: the wiphy index assigned to this item
>   * @class_dev: the class device representing /sys/class/ieee80211/<wiphy=
-name>
> + * @country_ie_alpha2: ISO / IEC 3166 alpha2 for which this wiphy is rec=
eiving
> + * 	country IEs on, this should help drivers and the wireless
> + * 	stack disregard country IEs from APs quickly on the same alpha2.
> + * 	The alpha2 may differ from cfg80211_regdomain's alpha2 when
> + * 	an intersection has occurred. If the AP is reconfigured this
> + * 	can also be used to tell us if the country on the country
> + * 	IE changed.


>   * @reg_notifier: the driver's regulatory notification callback
>   */
>  struct wiphy {
> @@ -201,6 +208,8 @@ struct wiphy {
> =20
>  	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
> =20
> +	char country_ie_alpha2[2];

Is that needed in the external interface? It seems it should be part of
cfg80211_registered_device?

> +
> +/**
> + * regulatory_hint_ie - wireless stack hints a regulatory domain
> + * @wiphy: the wireless device giving the hint (used only for reporting
> + *	conflicts)
> + * @rd: a regulatory domain built from the received country IE
> + * @country_ie_checksum: checksum of country IE of fields we are interes=
ted in,
> + * 	we can remove this if its determined the IE never should change
> + * 	for an AP, keep in mind dot11RegulatoryClassesRequired.
> + *
> + * We will intersect the rd with the what CRDA tells us should apply
> + * for the alpha2 this country IE belongs to, this prevents APs from
> + * sending us incorrect or outdated information against a country.
> + * If CONFIG_WIRELESS_OLD_REGULATORY is enabled and CRDA is not present
> + * we will intersect immediately against what is currently set in the
> + * wireless core.
> + */
> +extern int regulatory_hint_ie(struct wiphy *wiphy,
> +	struct ieee80211_regdomain *rd,
> +	u32 country_ie_checksum);

Ok this I don't understand. Why the checksum thing? Why pass the
regdomain struct in? Can't cfg80211 do the work of parsing the IE and
you just parse the IE in, possibly "debouncing" when it hasn't changed
(or do the debouncing in cfg80211 too, for the overhead of an extra
function call)

> +/**
> + * cfg80211_is_country_change - tells us if wiphy moves to new country
> + * @wiphy: the wireless device on which the IE was received on
> + * @alpha2: the alpha2 for the country IE the wiphy received
> + *
> + * This can be used to determine if a country IE a wiphy receives
> + * has changed the alpha2. The structure of the IEs generated on
> + * the AP should not change. If the the country changes we should
> + * disassociate and re-associate as the AP was probably reconfigured
> + * and rebooted, hopefully with a correct country setting.
> + *
> + * We don't support two wiphys being present in two different
> + * countries, however it might be possible a different wiphy
> + * already set the current regulatory domain; in that case we
> + * want to process this wiphy's country IE in case it may be
> + * different even if on the same alpha2.
> + */
> +extern bool cfg80211_is_country_change(struct wiphy *wiphy,
> +	const char *alpha2);

How would you call this?

> +/**
> + * country_ie_integrity_changes - tells us if the country IE has changed
> + * @checksum: checksum of country IE of fields we are interested in
> + *
> + * If the country IE has not changed you can ignore it safely. This is
> + * useful to determine if two wiphys are seeing two different country IE=
s
> + * even on the same alpha2. Note that this will return false if no IE ha=
s
> + * been set on the wireless core yet.
> + */
> +extern bool country_ie_integrity_changes(u32 checksum);

Heh. Ok if you're going to have this function here, let cfg80211 do the
debouncing completely.

>  #endif /* __NET_WIRELESS_H */
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index 7f710a2..219fb7b 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -203,6 +203,14 @@ config MAC80211_DEBUG_COUNTERS
> =20
>  	  If unsure, say N.
> =20
> +config MAC80211_COUNTRY_IE_DEBUG
> +	bool "Country IE parsing debug (IEEE 802.11d) debugging"
> +	depends on MAC80211_DEBUG_MENU
> +	---help---
> +	  Say Y here to print out verbose country IE parsing (IEEE 802.11d)
> +	  debug messages. This generates a lot of messages. You should only
> +	  enable this option if no regulatory changes are being made.

No, you should never enable an option that might print messages if
somebody sends you frames, even beacons can trivially be faked. This may
lull people into a false sense of security ("who'd change the regulatory
settings??")

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -648,6 +648,211 @@ static void ieee80211_sta_send_apinfo(struct ieee80=
211_sub_if_data *sdata,
>  	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
>  }
> =20
> +/* Converts a country IE to a regulatory domain. A regulatory domain
> + * structure has a lot of information which the IE doesn't yet have,
> + * so for the other values we use upper max values as we will intersect
> + * with our userspace regulatory agent to get lower bounds. */
> +static struct ieee80211_regdomain *ieee80211_country_ie_2_rd(
> +				u8 *country_ie,
> +				u8 country_ie_len,
> +				u32 *checksum)

I think this is misplaced. You can live with a single new exported
function that takes the country IE and parses it in cfg80211, put this
function into cfg80211, and the checksumming and everything else too.


> +	if (elems.country_elem) {
> +		/* Note we are only reviewing this on management beacons */

"management beacon" sounds weird. beacons are management frames :)

> +config CFG80211_REG_DEBUG
> +        bool "cfg80211 regulatory debugging"
> +	depends on CFG80211

there seems to be a space indentation there

> @@ -40,6 +49,8 @@ config WIRELESS_OLD_REGULATORY
>  	  ieee80211_regdom module parameter. This is being phased out and you
>  	  should stop using them ASAP.
> =20
> +	  Note: You will need CRDA if you want 802.11d support
> +

Why is this? Not that I really mind, but I haven't seen an explanation
yet.

> + * @country_ie_checksum: checksum of the last processed and accepted
> + * 	country IE
>   */
>  struct regulatory_request {
>  	struct wiphy *wiphy;
>  	enum reg_set_by initiator;
>  	char alpha2[2];
>  	bool intersect;
> +	u32 country_ie_checksum;

I definitely don't like this, it seems out of place, but it'll go away
once you push the parsing functionality up from mac80211 to cfg80211, I
think.

> +/* We use this as a place for the rd structure built from the
> + * last parsed country IE to rest until CRDA gets back to us with
> + * what it thinks should apply for the same country */
> +static const struct ieee80211_regdomain *country_ie_regdomain;
> +

How are you handling this variable when two beacons come in while crda
is being called? Locking rules?

> @@ -660,16 +680,14 @@ static int ignore_request(struct wiphy *wiphy, enum=
 reg_set_by set_by,
>  					return -EOPNOTSUPP;
>  				return -EALREADY;
>  			}
> -			/* Two consecutive Country IE hints on the same wiphy */
> -			if (!alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
> +			/* Two consecutive Country IE hints on the same wiphy.
> +			 * This should be picked up early by the driver/stack */
> +			if (WARN_ON(!alpha2_equal(cfg80211_regdomain->alpha2,
> +					alpha2)))
>  				return 0;

I don't like warning here, but I suppose pushing the stuff into cfg80211
assures this won't ever happen.

>  	case REGDOM_SET_BY_USER:
>  		if (last_request->initiator =3D=3D REGDOM_SET_BY_COUNTRY_IE)
>  			return REG_INTERSECT;
> +		/* If the user knows better the user should set the regdom
> +		 * to their country before the IE is picked up */
> +		if (last_request->initiator =3D=3D REGDOM_SET_BY_USER &&
> +				last_request->intersect)
> +			return -EOPNOTSUPP;

Can you use a more customary indentation of the second if line to just
after the parenthesis?

> @@ -685,7 +708,8 @@ static int ignore_request(struct wiphy *wiphy, enum r=
eg_set_by set_by,
> =20
>  /* Caller must hold &cfg80211_drv_mutex */
>  int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
> -		      const char *alpha2)
> +			const char *alpha2,
> +			u32 country_ie_checksum)

Same there, why this obsession with tabs :)
Besides that, I don't like the addition of the checksum, it's weird,
calculated by mac80211 and then used up here... But that'll go away when
you push the functionality into cfg80211 too.

When I suggested to use a checksum I was thinking of an easy way to
debounce. But a checksum is never perfect. Hence, the WARN_ON you added
might trigger despite the debounce checksum. Or we might fail to follow
changes. Maybe we should just keep a copy of the IE. When you change the
code to be parsing in cfg80211, please keep in mind that all this
doesn't need to be part of the wiphy struct, public API users don't need
it.

>  	kfree(last_request);
> -	last_request =3D request;
> -	r =3D call_crda(alpha2);
> =20
> -#ifndef CONFIG_WIRELESS_OLD_REGULATORY
> -	if (r)
> -		printk(KERN_ERR "cfg80211: Failed calling CRDA\n");
> -#endif
> +	last_request =3D request;
> +	call_crda(alpha2);
> +
> +	/* Note: When CONFIG_WIRELESS_OLD_REGULATORY is enabled
> +	 * AND if CRDA is NOT present nothing will happen, if someone
> +	 * wants to bother with 11d with OLD_REG you can add a timer.
> +	 * If after x amount of time nothing happens you can call:
> +	 *
> +	 * return set_regdom(country_ie_regdomain);
> +	 *
> +	 * to intersect with the static rd
> +	 */

Ah, I see. I suppose it'll still work as before so that's fine.

> +	mutex_lock(&cfg80211_drv_mutex);
> +
> +	/* Pending country IE processing, this can happen after we
> +	 * call CRDA and wait for a response if a beacon was received before
> +	 * we were able to process the last regulatory_hint_ie() call */
> +	if (country_ie_regdomain)
> +		goto out;

Oh ok, that answers my other question. Might still want to indicate
locking rules.

> +static inline void reg_country_ie_process_debug(
> +	const struct ieee80211_regdomain *rd,
> +	const struct ieee80211_regdomain *country_ie_regdomain,
> +	const struct ieee80211_regdomain *intersected_rd)
> +{
> +	return;
> +}

No need for return, heh.

> +	if (rd !=3D country_ie_regdomain) {
> +		/* Intersect what CRDA returned and our what we
> +		 * had built from the Country IE received */

our what we?

>  	last_request =3D NULL;
> +	country_ie_regdomain =3D NULL;

no need
=20
> +	if (unlikely(country_ie_regdomain)) {
> +		kfree(country_ie_regdomain);
> +		country_ie_regdomain =3D NULL;
> +	}

no need, kfree(null) is fine, and setting to NULL useless

johannes

--=-f+m6sg43y/kGeinxrdqf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEZAjAAoJEKVg1VMiehFYpnEP/3S9rbEJGSFvbr0wNZvreagw
mjxUhONgY724LFakkYxU+HHFOCxvUbwXi9NbFhO20JzOSX9wJ4QRCR9SaSrFNvlV
kF8g7sromvnW9t4NgE2FxrT2sx9wYlSpOU5pncn60mAnrjTG5hyoI8mhB+kliXp2
LDhl+Js9/lvlfD+99+7EngVM7/cxzaRh47dysYk4gbylMcG7RDXe/PsVTQ9nQUCH
EY77k6UOhxRWVpc4MXII7j+5CrWJBJgqDD15gQB2T4NVD72xlfgY9pqRkN+sNtR+
aIvSig+zeVUYPHQvaw7cmWatwVE+6BG7oLqTdglaqQgjGQowULRSSw5RJ56no3x2
hjkbPTKOVtSBSMnKED8N01MzMaqdUYa+iCX+417XXsZ+Ygp7r4lmFqLWhwGjZN9k
gW7fTosbO70wAKQyDSFc8O4/H/9uuTf8Q+ee9F42/7k5cahldLbFTv9yFXJWaTG4
/9PhwFFBAw6LMSbCwokvRpy476iJevFZPYFukFn2gA3+D+QWCUCWGzs5ylapzhiU
m72xu/mrsRtbFrUx5shjMAChU0ocM/GOsDGGQK/wDZ+8AvIXIjzxqsXasZ3zPFBZ
fvWrZ/cZXRsetTxYHR+DoTRuJB9M97y/VO/SR06Z2jIGEkpchGI4qakPwziR4qsA
ddqkHEQqsMP8lBtK6X8V
=q994
-----END PGP SIGNATURE-----

--=-f+m6sg43y/kGeinxrdqf--

