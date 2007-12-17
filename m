Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXLQRyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 12:54:25 -0500
Subject: Re: [PATCH 1/8] mac80211: A-MPDU Rx add low level driver API
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197907078132-git-send-email-ron.rindjunsky@intel.com> (sfid-20071217_161337_817126_CF0B10B6)
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <1197907078132-git-send-email-ron.rindjunsky@intel.com>
	 (sfid-20071217_161337_817126_CF0B10B6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YS631Kc1rPVO7WU61GVM"
Date: Mon, 17 Dec 2007 18:54:13 +0100
Message-Id: <1197914053.4885.62.camel@johannes.berg> (sfid-20071217_175431_750857_5E14C9E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YS631Kc1rPVO7WU61GVM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Cool stuff. Minor (really) comments below.

> +/**
> + * enum ieee80211_ampdu_mlme_flags - A-MPDU action flags
> + *
> + * These flags are used with the ampdu_action() callback in
> + * &struct ieee80211_ops to indicate which action is needed.
> + * @IEEE80211_AMPDU_RX_START: start Rx aggregation
> + * @IEEE80211_AMPDU_RX_STOP: stop Rx aggregation
> + */
> +enum ieee80211_ampdu_mlme_flags {
> +	IEEE80211_AMPDU_RX_START =3D 1<<0,
> +	IEEE80211_AMPDU_RX_STOP  =3D 1<<1,
> +};

Can both really happen at the same time? Or why are they flags rather
than just an action code?
=20
> + * @ampdu_action: Ask low-level driver to perform a certain A-MPDU actio=
n

I think we usually just say "Perform a certain A-MPDU action" because
these comments are more for driver writers than mac80211 people and they
like to be told what to do ;)

> + * 	The RA/TID combination determines the destination and TID we want
> + * 	the ampdu action to be perfoemed for. The action is defined through

small typo: "performed"

> + * 	ieee80211_ampdu_mlme_flags. starting sequence number (ssn)

small typo: "Starting"

@ssn will highlight the variable name afaik. I need to get my docbook
stuff up to be mergeable.

> + * 	is the first frame we expect to perform the action on.
>   */
>  struct ieee80211_ops {
>  	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
> @@ -1089,6 +1107,8 @@ struct ieee80211_ops {
>  			     struct ieee80211_tx_control *control);
>  	int (*tx_last_beacon)(struct ieee80211_hw *hw);
>  	int (*conf_ht)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
> +	int (*ampdu_action)(struct ieee80211_hw *hw, u8 action, const u8 *ra,
> +				u16 tid, u16 ssn);

I personally prefer indentation to right after the opening parenthesis
and that's the style over the whole struct.

johannes

--=-YS631Kc1rPVO7WU61GVM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2a3xKVg1VMiehFYAQJlTxAAmFCHC6msQpchvo1OePHl0iSS0R/uaiUR
WmeVz7ScnBPipftjodo6Zu75DAt6y1mF5Sfr8xEyoXIw2Cdnb7J4dIEsFL0TVo85
6pTpgCOiXaAAehVKzWFhb6vHoGfQnvtcPzCWa1kBvcSgtq1UtiLyc4jY5GLoSU/c
Yf36SRldWicyD5s/oVA5HtQ/u236dAE1tFowh3f994sMZQeT2xgr8tl15WJj9UjS
XuFiDYtEAYSngTkmvCVnYJPjAdlqbkZeZEPSGyL11AzPet/tRia/pcIvE90YqTZA
6tlMLPFTiMDqycR7wi/WFp7K1BnlvR0vBgh8BIVr3Gtm5dUk4pW8l2e/vnAJO7+5
E7XdGvk3b+NciQazcRF3oyPHYh7gp+xTOHskOlINiWV2YYzqDS5YqT/0iUQOKVk8
Ju4TXiMT1yubOlXpPXatMVTLs6SVydtSgUhdKGgtcc7/5Zz5MzcA/k1BOJgeC0sk
Q9MPkFpdwnC1tV+iiqmeFzY4qHQoPCXgODzsmnLBDP9iq8Q0TbIV920zFvvpJ1xI
MQN4JJxy/uF/9pHZuQ5ZRocxbWwfE+gm0ySm4koHcaDuAMY1ntYycjYqwONJjTMz
8zSFuIQswl79uJsk9UGIOMKOvI9vcv2Dn2s4wkoHCHYjyULZjXSjsM4TQsJzckQb
7qlU7gNTBaU=
=RMbk
-----END PGP SIGNATURE-----

--=-YS631Kc1rPVO7WU61GVM--

