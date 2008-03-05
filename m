Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44763 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbYCELRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 06:17:19 -0500
Subject: Re: [PATCH] mac80211: fix races between siwessid and siwencode
From: Johannes Berg <johannes@sipsolutions.net>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <b25c3fa70803050310i71023046gc3f40d4042038ba6@mail.gmail.com> (sfid-20080305_111045_653557_3B0AF33B)
References: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com>
	 <1204710843.25502.50.camel@johannes.berg>
	 <b25c3fa70803050310i71023046gc3f40d4042038ba6@mail.gmail.com>
	 (sfid-20080305_111045_653557_3B0AF33B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Dv600ksqL6FnlMSucuVC"
Date: Wed, 05 Mar 2008 12:17:05 +0100
Message-Id: <1204715825.25502.69.camel@johannes.berg> (sfid-20080305_111723_123786_27241CCF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Dv600ksqL6FnlMSucuVC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > This looks wrong. You could restart association when a key is set but
> > really the race is by design in WEXT so the only way to fix it is to se=
t
> > the key first.
> >
>=20
> Do you mean fix iwconfig to always do set key before set essid?

Well, no, I think it's more of a user error, I always do=20
   iwconfig enc ENC; iwconfig essid SSID
in that order.

> But, doing It cannot solve a race from two seperated iwconfig process, I =
think.
> (eg: iwconfig essid ESSID; iwconfig enc ENC)

Yeah, that's pretty ugly to start with.

> Moreover, now we just wake auth request task up and return when setting e=
ssid.
> Don't we need to wait a moment until the task is scheduled to be
> polite to iwconifg? :)

I think the only way to properly handle it is to reset the association
state machine when a key is added. Dan, what's the expected behaviour?

johannes

--=-Dv600ksqL6FnlMSucuVC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR86BMKVg1VMiehFYAQL+XA/+NVPSQ09Y9cxW0EpOvJVmjNN6Cv1YPBHe
wX/DVol7r7h6EGJAjzc3v7bb6fagC7sp5Y42/gfp/+RUYpSdi1PHdnlUz87ruDZB
s1FgCSUMKhCw74hPDd95x2SIK+wDim/eyFk7WLzVc5XlncN2mKysSCB+ulZjlSjV
CX6UYDNIRsoRdxpsvhv7RQrziEuhkmtgX4e69i3u6S6230I9qlFuS3ut08MDu1qp
htZd1Ir/OqVH0rdo0hcR3FiDKwnEhcT0/UIorc+hkWIr5FCGb5OdKWnM+IIfLlSQ
uDreIoySIvz8qIJZiCxvVlpxjfe6ohIBtSGTQxeYhGJdGE5rL9+RshiuRD08VpAW
mZRi1/btl0tKGkml1uVapO+fRG4aTQHXXGBuDUuybHTiFc/44LmgKPW0SQ7KeI3C
6ESm6KYXs8WOHb2MZYPtC0BhqrS2Jp0lrxgH9zpSuCdm9j3+pUBbTsmzzCJuUmV/
Tdh+2PNRK+KdL+AzKYwyRzpbXekZ5QZtqGvYqCMQW69+udqJrR4NwdC4vPrAHkmD
vg6jG7ho6kGKdKd/P4v15QFwKrXHZvo60yU3WuZY/0TLFSYxUDy9oFxBB2VWJqoc
4LZPq6ydYohYzDZeF0JGjZEkZdaVdKvcJeW3nIGKFPQUg3oq4kh9hwumM2MJMsgz
SdyVdOvM+oU=
=/rto
-----END PGP SIGNATURE-----

--=-Dv600ksqL6FnlMSucuVC--

