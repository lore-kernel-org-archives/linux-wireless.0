Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZAGMqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 07:46:51 -0500
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for
	management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
In-Reply-To: <20090107122427.GA20019@jm.kir.nu>
References: <20090107112346.369581673@atheros.com>
	 <20090107112707.370907962@atheros.com> <1231330118.3545.28.camel@johannes>
	 <20090107122427.GA20019@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TjZj01stLRbd1S2jxzlR"
Date: Wed, 07 Jan 2009 13:47:08 +0100
Message-Id: <1231332428.3545.33.camel@johannes> (sfid-20090107_134703_626368_AC17CD13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TjZj01stLRbd1S2jxzlR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 14:24 +0200, Jouni Malinen wrote:

> I did consider this, but could not convince myself that drivers would be
> expected to work without some testing and likely changes..=20

Ok, I guess in that case it doesn't really matter much, though it'd be
good to not randomly associate to an AP that has MFP enabled when we
don't know the hardware can handle it.
I know, for example, that Broadcom hardware can handle it just fine when
done in software, but I'm pretty sure it cannot handle it in hardware
crypto...

> I do not care
> that much which way this is, so if you want this to be inverted, that's
> fine, too. I might even go as far as adding an explicit capability flag
> that drivers will need to set to claim MFP support and export this to
> userspace so that hostapd/wpa_supplicant could refuse the configuration
> early. With that kind of flag, inverting this key flag does not get much
> since the drivers would need to be changed anyway for MFP to work in
> every case.

You seem to be concerned only about AP mode, while I'm not much
concerned about that, there it's always tested explicitly by the person
setting up the AP, but someone who's just using STA mode would now
suddenly potentially run into problems when using an AP that is
MFP-enabled, no?

Hence, I think adding an explicit flag (whether it needs to be exported
to userspace I don't know) would probably be good so if the driver/hw
really cannot handle MFP at all then we don't associate using it, no?

johannes

--=-TjZj01stLRbd1S2jxzlR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZKRJAAoJEKVg1VMiehFYbCIP/jw7wZQujKPtzZjrgXXdJWOB
7ATxsI0twg8HeRvs+0KdYjL1OYm0EAClYN9F3thW01j/AuIuVqdIhNeJaZmBnCoy
btC/hqZ/1JeHvZskiausxWWID/ocUOZZ+w7RR7Qe43/y4U27zIzrxc1tqVCc/Iwv
8g9BY/fBHzKjPUivcNOBoGuqo/1s+F3wvGrGF7aDkVhymP7LaEFVRhloCQpcSD+X
u/8M7M5QWf1FyxbqREZtIO8Mw3+M2w9+6bKPzh73DnTrpqZbSgd9hWDSirdHWBIP
VfHQxYJcUDjqxa9A6EqOgryPy0tERnJxxqYyteYHdnnQeoegTeJqvt33F23a6wa8
ZYR5rf2kLfiKacGd/S+YWQqyE8t/w2dz2pfCjw+65ibAMG/n2LEebNczGBxa3CnR
LAykDzE3uWf9Q66ZLY3MT1e9WDsrX9F10kw+Ii3gqlIaBnCXlbOJjf0En+wuoj8a
+Wm6AB1cMrMTLoCs4GP3hlQqPxfhe6N2giqbQXPiNWmCqlKbB2Ylo7ag8zS7Xjf6
mtEvcGftkuk+MWqAKVfRU+45WEnJIE/hG2M18jSHIQA30iVsGyBpo6hvIyWQp4Is
K9qwNFzeDRsy4p7XZm8WXadbh9mOEpdIRwzbklh1fGQSrSt+1JwjXgM0NDWyNFzL
9TztNjA4YZ7A18BfNhSq
=LEJK
-----END PGP SIGNATURE-----

--=-TjZj01stLRbd1S2jxzlR--

