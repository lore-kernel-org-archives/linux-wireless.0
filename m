Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbYKXLVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 06:21:38 -0500
Subject: Re: [PATCH 2/2] zd1211rw: enable an AP that can't support fully PS
	clients (wireless-testing).
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <eb3ff54b0811240309u31944469xa444ee25f8ac8496@mail.gmail.com> (sfid-20081124_120908_115398_E83F0212)
References: <eb3ff54b0811232344t665fe6abp9ca2be85cfcbd855@mail.gmail.com>
	 <1227522918.3599.63.camel@johannes.berg>
	 <eb3ff54b0811240309u31944469xa444ee25f8ac8496@mail.gmail.com>
	 (sfid-20081124_120908_115398_E83F0212)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4yo2PJgLRAU1BR5+J6kx"
Date: Mon, 24 Nov 2008 12:21:34 +0100
Message-Id: <1227525694.3599.95.camel@johannes.berg> (sfid-20081124_122142_643959_C91DEB75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4yo2PJgLRAU1BR5+J6kx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-24 at 13:09 +0200, Rami Rosen wrote:

> If you are talking about whether the zd1211 driver can buffer
> mcast/bcast frames in software, it seems to me that the answer is
> negative, since there is no call for ieee80211_get_buffered_bc() in
> the zd1211rw driver code and also there is no handling of
> IEEE80211_TX_CTL_SEND_AFTER_DTIM or
> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING in the zd1211rw driver code.
> This what made me add the NL80211_ATTR_WIPHY_AP_PS_CHALLENGED
> attribute and prepare this patch.

Yes, I know that's why you did it, but I'm still wondering whether it
was necessary, is it really impossible to implement mcast/bcast
buffering with this hardware? IOW, can we fix the driver to do the
buffering and using _get_buffered_bc()?

johannes

--=-4yo2PJgLRAU1BR5+J6kx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKo4zAAoJEKVg1VMiehFYnrkP/1FxplPvSiTbYweHPDLu/QA5
fCS/kAD9OGOf652yDPtmoa7gHbyj1dqYhRB4cLIgVIXWmpkA2l/A93kQnue1mruQ
6RSdHdMBOAm+ilbEmovYHuTyyf62BC9YAp5txzSSFy1HbewPld5S7bO0UnKmSiR+
IldPy42DlVslWBEnUUCet3WGtgyM7Lymjs9ycmiljTSyRKPd1Tyds4dlIxjGcpXA
LDirqUD9dQQGxG+rCgKwNbzt6DSY/Gxej7qqZ6UW09CPibf+05EkuGihE9gtOt7O
/gP5GEwgfj2J7U+ZBPsKEODTASO/173rILqlFlxODbxGVPoenJb/NmO7+Nf6oA/s
HkiuO7MWv8UEvKyhRhuLctR0QMzX3XmKedi4WtAA6RFKpVejhS6MD8bImDdJC25H
9Ts6nYB/B6BsIcgc3UIHTvnmBgn8PNBJtOex2w0A51i/tPkBDsk4xcU/hZb8EW0C
mIreBigAa/fT2UF9wpzaJEKfmyNVZ5JIW8h8N8knhKN/gnBtlwlekBYRD4dkFnUc
54QPi1ngi0bzV4SjVvQ8js/clgH3/O1GXZt9UFFqGiTP5e+++vvzPOIklIl+OJVf
bMemEquiZtxo+KAhqAGW0YOXkgh5bIEKydouVXlue9Og9yvHDkT1YLcl9twMLvUS
2lTEAGODOt4NCWlddXcj
=dxi4
-----END PGP SIGNATURE-----

--=-4yo2PJgLRAU1BR5+J6kx--

