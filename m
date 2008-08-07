Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbYHGNtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 09:49:02 -0400
Subject: Re: [RFC] mac80211/cfg80211: Add BSS configuration options for AP
	mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080807134043.GA5138@jm.kir.nu>
References: <20080807134043.GA5138@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZgjQ9d5CkZs4WK5jZeSr"
Date: Thu, 07 Aug 2008 15:48:26 +0200
Message-Id: <1218116906.23048.179.camel@johannes.berg> (sfid-20080807_154907_352086_6B94BF35)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZgjQ9d5CkZs4WK5jZeSr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Thanks.


> Could you please take a quick look at whether this looks like a correct
> way of introducing new functionality into cfg80211? I'll finish the
> short slot time part in mac80211 and post an updated patch as a proper
> submission later.

I used to have a patch to move the short-slot stuff in mac80211 to the
BSS info struct so that drivers that support different slot timing for
each frame can use it for different virtual BSSes. It no longer applies
though:

http://johannes.sipsolutions.net/patches/kernel/all/2008-08-04-12%3a26/013-=
BROKEN-mac80211-bss-slot-time.patch

> +static int ieee80211_change_bss(struct wiphy *wiphy,
> +                               struct net_device *dev,
> +                               struct bss_parameters *params)
> +{
> +       struct ieee80211_local *local =3D wiphy_priv(wiphy);
> +       struct ieee80211_sub_if_data *sdata;
> +
> +       if (dev =3D=3D local->mdev)
> +               return -EOPNOTSUPP;
> +
> +       sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);

I think you may need to handle the case where dev is a VLAN? Or do we
want to have these settings per VLAN too? And should we reject them for
other modes than AP where the AP controls the settings?

> + * @NL80211_CMD_SET_BSS: Set BSS attributes for BSS identified by
> + *	%NL80211_ATTR_IFINDEX.

Maybe we should have a way to retrieve the settings as well, and that
could even work in STA mode to see what the AP asked us to do.

Other than that, looks good to me.

johannes

--=-ZgjQ9d5CkZs4WK5jZeSr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImv0nAAoJEKVg1VMiehFYKrEQALn0JCOI4fOSEf1r4Rej7NL0
z7HP4y2CC7vV0YSO7eE1mdS6P75QucJJw6aLKXmVno+X7B9OoFk/JH1RJoqi7Kzt
MfmM+ELiuDRKfFRBWHwu92t/ZTrF+i+sQAiaBusEs3Z4N/purZZeg0bNFYI1Tpph
ZJP1uiSYiVErL6O6dyqrxUIO7LlVTaqSGw9R05+0dqERn6mVuOs1xMexy+eykbRY
tHOe8nUNjClnAE18zEec7X0IpMqK7vCb5HXztLCtlOekrTeUU7u/LAHWGmcA0dVe
DxgIP1tYqbXdFp4J8AlgrhjlM2HKAbcFYArutQAyf2vmtS1DOQzKmxvPOmTVsxRV
T62qzB3aKkflV/NDHeAzySgaX6Axo8QrLsS7NRIIh3DQfFCs/uXMFnbSGTGlSQU4
M0VztH3VaxfxT7yohAK3frwwCvpiWoO27LEIIe5DIf7W4j7UEB39Q9WfpQAXOMtX
v11/jX1IyxQQyBTQpPB4qst7K/2KBuMIWNTpaSs1uWSnTwsQ7isXDz+uyi7fgxTQ
XhtgmOjOlUTzxojKjSzEgrYjXc9YymNCbu37Oj8Yvn9A/PyasD4t6qkls4jb6e1s
ENU4UUeikUuhmIqSiBH0NoGCdqWhqLYaWNpwr6xkSeIyT6MPPA3xTPboyk6/ibbc
6A0L+B2Q6Bv4pLoNBuRs
=Hdtu
-----END PGP SIGNATURE-----

--=-ZgjQ9d5CkZs4WK5jZeSr--

