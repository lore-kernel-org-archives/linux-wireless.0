Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbYIFWag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:30:36 -0400
Subject: Re: [RFC PATCH 3/3] mac80211: remove disassociation code from
	ieee80211_set_associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220739259-16918-4-git-send-email-tomas.winkler@intel.com>
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-3-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-4-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7drt48AXwc8YKuIHm8Zv"
Date: Sun, 07 Sep 2008 00:30:31 +0200
Message-Id: <1220740231.21016.13.camel@johannes.berg> (sfid-20080907_003039_961510_711C0078)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7drt48AXwc8YKuIHm8Zv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-07 at 01:14 +0300, Tomas Winkler wrote:

> -	ieee80211_led_assoc(local, assoc);
> +	ieee80211_led_assoc(local, 1);
> =20
> -	sdata->bss_conf.assoc =3D assoc;
> +	sdata->bss_conf.assoc =3D 1;

I think you should use "true" at least for the latter "1"

> +	sdata->bss_conf.assoc =3D 0;

and "false" here, and if the LED interface uses "bool" then for that
too.

The actual patch looks good to me though.

johannes

--=-7drt48AXwc8YKuIHm8Zv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwwSDAAoJEKVg1VMiehFYgJAQALm37cysmU0qhu7V3AIV6whn
/f1T5xYdXFjb83I2HJptVWa4dDERYePRQz3K8RwyEmoSjofi5xiVo0LuoEImhCnX
HYAiIJ4I2UMzpqeJoAtE7GwlL3Qr+H8EZFu5kwqdgVk3lAr23TSZrZ0c9KtoxTiT
GoiqilIDtfsLtYQoOvxWt4qHsMltmDBrOomnMvOAK39xqyzLvJgFzVsptcyV11Gn
r2kjtC3DxljmGaLH9CKvlUm4tCop4KQARJC1yY/QsWTPKYs1o0sqjNwfjNbol/7B
UvKBUy6rWxMPSyAwF6jZwKklU4h+eDKASUIr3BNHkB67Ig9eIPMt/cGuU4x3XXQh
yF7woFDVO9gbA3tz0iFX5gzgdjZ4ab9VNxpA1Vbsfm9Ec8RUIlJM0vtB1a25O22M
vGx7/36xun3XiryMsj8Z3gh+h20kJ+1Q0aQo84pOFHlwIVucwrG8O/GfcPBbvfTS
gHF+f78s4HnDPRaeESJU7SJbWwno4nEKzl2M8O3q9UMptekFVhS82TWDdfSW/oII
ja7j4R70sQmzVG40C90TXYrUr0Sw2+AAsEumNl7vx7fEzM67SnS4DX1K7dE1a6hc
qFRHB+alnOr9VcZqgRGw4eruy20Y19jPEd2r90tqLTf5habF1e2+G5ddeF0CQHjy
fF20tH8JMR02RV1zAALi
=8skX
-----END PGP SIGNATURE-----

--=-7drt48AXwc8YKuIHm8Zv--

