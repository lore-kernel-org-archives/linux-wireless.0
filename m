Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39566 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZAXOOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:14:06 -0500
Subject: Re: [PATCH] mac80211: change workqueue back to non-freezeable
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090124041229.GA13712@hash.localnet>
References: <20090124041229.GA13712@hash.localnet>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qlCvfxVnjWJ9dGMOphFx"
Date: Sat, 24 Jan 2009 15:13:57 +0100
Message-Id: <1232806437.4036.5.camel@johannes.local> (sfid-20090124_151411_344323_36EFE188)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qlCvfxVnjWJ9dGMOphFx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-23 at 23:12 -0500, Bob Copeland wrote:
> [apologies for resend, forgot to cc wireless]
>=20
> Commit 59959a6150c8af737898e83f727e824dbed7b0fa made the mac80211
> workqueue freezeable to prevent us from doing any work after the=20
> driver went away.  This was fine before mac80211 had any suspend=20
> support.
>=20
> However, now we want to flush this workqueue in suspend().  Because
> the thread for a freezeable workqueue is stopped before the device
> class suspend() is called, flush_workqueue() will hang in the
> suspend-to-disk case.
>=20
> Converting it back to a non-freezeable queue will keep suspend from
> hanging.  Moreover, since we flush the workqueue under RTNL and
> userspace is stopped, there won't be any new work in the workqueue
> until after resume.  Thus we still don't have to worry about pinging
> the AP without hardware.

Good catch! Do we have to freeze the workqueue ourselves manually or
something, to avoid drivers adding work to it?

> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  net/mac80211/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index a100793..a109c06 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -859,7 +859,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  	mdev->set_multicast_list =3D ieee80211_master_set_multicast_list;
> =20
>  	local->hw.workqueue =3D
> -		create_freezeable_workqueue(wiphy_name(local->hw.wiphy));
> +		create_singlethread_workqueue(wiphy_name(local->hw.wiphy));
>  	if (!local->hw.workqueue) {
>  		result =3D -ENOMEM;
>  		goto fail_workqueue;
> --=20
> 1.6.0.6
>=20

--=-qlCvfxVnjWJ9dGMOphFx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeyIiAAoJEKVg1VMiehFY+pIQALvB55qH/OXSjxx0w2mKP4ek
dxsbYU8axmc6PpPD/+yUhXWRzAHpQusgPdkRhFl8vzvlNk9WvTd9WFQps3zAtHab
2KpIQw/4YhLYd4fmaWWBWUsc1A61oh1wxjJv06Aezf5NcOAiSd5TUaKq9zK5JGyB
nzjgNPREgIb9G/dBLNOICPirQDKRv7YtXYqbp2tZqavfqYyfU0MCaKdjBB19gyfH
nI/D6isI/2OVLIW2HRc+0cqilnf3J44fnlwvNbnNU50yDXJHMd5oX7F72uIm32MB
hPeUY2Yajp/QErr8Nib2HEFBotRnEKZoxDpR8L5ofXiAfe2HxdlkE/ZvyPO/84+w
rygvCk6bp55rlpOwzc8W0mMYoIMAj+VSIoy//6SOxV3CudMw/ouU40fMXNKj9qDH
CQqUdQO5uMCYDsKQSFT5Rd7K4P4hWUSU0ofFCsMFEPTu4S3xBNgk6yZ9d2EAFm4Q
ZE4PSmHsoM8CiRKWdm5icO84F5qCiUqSv3O2Z1hVA0XJ8jaSLWXgsOE25jpmmvPB
DN9JXLvORCLc7d+Z8WxgXO4JH7xxsei4LywbdklN7xmYl3nOmkU2EQTz7OVUdchS
xru3GuFzdhailadU8yeqD8KJk/uiNtC6TuaEG+dBsE6HIgpjEgDIj0vZ15WspNQ0
3eEpiwM14lv8f8l/Rnx4
=IlAV
-----END PGP SIGNATURE-----

--=-qlCvfxVnjWJ9dGMOphFx--

