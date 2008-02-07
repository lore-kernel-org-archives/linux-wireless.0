Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbYBGKfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 05:35:47 -0500
Subject: Re: [PATCH 03/13] o11s: (zd1211) support for mesh interface and
	beaconing
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47a78266.24528c0a.29f3.ffffdde9@mx.google.com> (sfid-20080204_212411_276523_290FB136)
References: <47a78266.24528c0a.29f3.ffffdde9@mx.google.com>
	 (sfid-20080204_212411_276523_290FB136)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6c6LQ7OrRN0iG1SZTaWx"
Date: Thu, 07 Feb 2008 01:19:50 +0100
Message-Id: <1202343590.9965.50.camel@johannes.berg> (sfid-20080207_103600_127947_210625D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6c6LQ7OrRN0iG1SZTaWx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> +		if (hw->flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE) {
> +			zd_mac_config_beacon(hw, conf->beacon);
> +			kfree_skb(conf->beacon);
> +			zd_set_beacon_interval(&mac->chip, BCN_MODE_IBSS |
> +					hw->conf.beacon_int);

As I already mentioned, hw flags are never set by mac80211. So the
driver should set this particular hw flag before hw registration and
then the conditional here can go away once you reworked the mac80211
code.

johannes

--=-6c6LQ7OrRN0iG1SZTaWx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6pOpaVg1VMiehFYAQJ0DQ//aXSmZggF0ATM+qIKAbz/dbZ4aHVLAImY
Z+dquqaCuU+D2HsZbxljHxFtd4Wc0QRU7cQq0/K5Fify1i76FwWWLTBcwnfkWqYK
ZyUtRdL+It862XCxoHldOE7BLZg3u9TJ4Y4BrfD1G0XGkFGVnX96k5zeFa9hY8Vk
9FOuCDEUHbkDqeubSbvtkotT9fFEjB2IaTvizIYm7YIdKK9Mp2dvX2blqtP6xg0n
EfiQIPfZ72OCmDCmUi9smSVlcGXBCD86WNi7xJIUO0hF0PpchXzcE1TLL99OkRbf
MDrJOxGE+hZDO1bNbkueFxn2zNyPfP/TFLV1iijIdYTwXjHkqD1Als1JN8fVM+zy
v5SylnByIieJyuhb/LpseOR75sIh6w1ZZOkQoEoHrvGICvlAG4UOz05LeB4WJ1SJ
nwynT1S8FMJzFf+xKb5t4+Zz3f5WvddHhKg9cXDAZQox0FYly3BD3+csqpEv9d2R
bOzSu1mAbeZhrgDU1aIquQ4T66G/mafuucKjSTKPB+bHwTsmkUJDABCcYLOnuAyQ
hhNa9lxCA4vKrMCS8Z0owDcR2Qj+ZLOOiHrTGaumYDl8kyqGpm7Bj5q9pk9eKeqJ
GgQThnhFc1heZiYhLtdIakx4RviH768xusY/+6/I2ymMa894bD2jlTx90c4mo8E4
w5cs5Usz+vA=
=18kU
-----END PGP SIGNATURE-----

--=-6c6LQ7OrRN0iG1SZTaWx--

