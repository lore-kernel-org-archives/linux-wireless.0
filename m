Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43452 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbXKIUSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 15:18:52 -0500
Subject: Re: [PATCH 07/14] mac80211: adding 802.11n configuration flows
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
In-Reply-To: <11945953313626-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
	 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312367-git-send-email-ron.rindjunsky@intel.com>
	 <1194595331658-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312456-git-send-email-ron.rindjunsky@intel.com>
	 <11945953313491-git-send-email-ron.rindjunsky@intel.com>
	 <11945953313626-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JvZbAj3aAaov9BIQtXW9"
Date: Fri, 09 Nov 2007 17:48:45 +0100
Message-Id: <1194626925.4793.144.camel@johannes.berg> (sfid-20071109_201854_446838_CD448939)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JvZbAj3aAaov9BIQtXW9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> + *
> + * @conf_ht: Configures low level driver with 802.11n HT data. Must be a=
tomic.

Why is this a special callback when you pass struct ieee80211_conf?

> +#ifdef CONFIG_MAC80211_HT
> +	int (*conf_ht)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
> +#endif /* CONFIG_MAC80211_HT */

Shouldn't you use the if_conf callback then? I know that callback needs
to be rewritten to indicate what parameters changed, I think Michael
wanted to do something in that direction? Similar to my filter flags
change in how it'd work I guess.

> +#ifdef CONFIG_MAC80211_HT
> +
> +/**
> + * ieee80211_hw_config_ht should be used only after legacy configuration
> + * has been determined, as ht configuration depends upon the hardware's
> + * HT abilities for a _specific_ band.
> + */

This is part of ieee80211_hw_mode right? I have patches to remove that,
just to be clear on it, it's band specific not in any other way "mode"
specific. So without digging through all the details I assume you're
registering an 802.11 G mode with HT capabilities? That's pretty warped,
but yeah, mac80211 works that way right now. Crap. I should hurry up and
get that mode -> band change ready.

> +		conf->flags &=3D ~(IEEE80211_CONF_SUPPORT_HT_MODE);

> +		conf->flags &=3D ~(IEEE80211_CONF_SUPPORT_HT_MODE);

No parentheses please.

> +		conf->ht_conf.cap &=3D ~(IEEE80211_HT_CAP_MIMO_PS);

Same here. If any of the defines need parentheses they should have them
built-in.

> +		for (i =3D 0; i < 16; i++)
> +			conf->ht_conf.supp_mcs_set[i] =3D
> +				mode->ht_info.supp_mcs_set[i] &
> +				  req_ht_cap->supp_mcs_set[i];

Hmm. No define for that 16?
=20
> +#ifdef CONFIG_MAC80211_HT
> +	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
> +	    local->ops->conf_ht) {
> +		struct ieee80211_ht_bss_info bss_info;
> +
> +		ieee80211_ht_cap_ie_to_ht_info(
> +				(struct ieee80211_ht_cap *)
> +				elems.ht_cap_elem, &sta->ht_info);
> +		ieee80211_ht_addt_info_ie_to_ht_bss_info(
> +				(struct ieee80211_ht_addt_info *)
> +				elems.ht_info_elem, &bss_info);
> +		ieee80211_hw_config_ht(local, 1, &sta->ht_info, &bss_info);
> +	}
> +#endif /* CONFIG_MAC80211_HT */

Since it's part of if_conf, isn't it passed to the driver as part of
such a call anyway later in this function? I don't see the need for the
special ht conf callback.
=20
> +		/* check if AP changed bss inforamation */
> +		if ((conf->ht_bss_conf.primary_channel !=3D
> +		     bss_info.primary_channel) ||
> +		    (conf->ht_bss_conf.bss_cap !=3D bss_info.bss_cap) ||
> +		    (conf->ht_bss_conf.bss_op_mode !=3D bss_info.bss_op_mode))
> +			ieee80211_hw_config_ht(local, 1, &conf->ht_conf,
> +						&bss_info);

Yeah this is what I was talking about. mac80211 really sucks with all
this "has changed stuff". Hrmm. Michael, any time-frame on rewriting the
interface config stuff?

johannes

--=-JvZbAj3aAaov9BIQtXW9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzSPbKVg1VMiehFYAQJj6g/+KbxTi+hE3QlVbmupJZSfFdjkyPXBac1V
gXUK92bWLnNyqzXG+ik/5XC+HM1IU/AbbXRHWgOOeueYLIRJVX224oavg50jiEGn
8CSSsXPJFh9p7Aw/5I1rRz9Iebw1gGs4dCq6I7tmVaXN7fGOHJG7gvOHt1I2WURY
06PW5kYuPmk1XU69uhu/wQoao2jSdr4ZgRB0ByG478B5qRAbEko3VqMI3nqJn5Ui
JELyeHdZM5ZVG8pPePqmFaV7g2T+oCjPpF/RMo+6N4Ms3RupjgAOkuurRVVQEneb
8MCrbNvlphnBz2ryyMa3/svkrK8KgbTcYEYnBo2wE5f4NHLwH4gG29wTsfkGcJGG
Krv/lpGTn6iVtEew/RsmbGUQW3nlLRriow7X8rz4GZ3FUbm1yFoIHYhFuF2a8F7K
b0v7vYWsQSYcmoF1PWTxAZrP4LgXZFSdjpbwiIlOPZYLveDR9pr/aZAk1xGmoLBg
PXVDmuUi4imUtWnrNJmBlHAFhPEB61sCzw7u6qa0m8ui7VY7DxdJJZ//ks7bXbTC
If63lVjoauwQdqRyopAVczXop2no0H6cP77hMqdBe91ChXrLjmI0vkJzeX0TIECk
XDQcRd43w5UerFJw2zaJr//VI37PcUQ/0Fr+c7imRYOz2W0ZqR4i1l4EAAWenBMC
ExdPJmctoWo=
=ak3W
-----END PGP SIGNATURE-----

--=-JvZbAj3aAaov9BIQtXW9--

