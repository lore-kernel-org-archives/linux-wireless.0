Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbXKSOnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 09:43:51 -0500
Subject: Re: Suspend/Resume support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <Kalle.Valo@nokia.com>,
	Li YanBo <dreamfly281@gmail.com>, Ben Gamari <ben@mw0.ath.cx>,
	linux-wireless@vger.kernel.org,
	Jose Ignacio Naranjo Hernandez
	<joseignacio.naranjo@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <20071119035943.GJ8672@jm.kir.nu>
References: <1195087905.3814.11.camel@mercury>
	 <1197ff4c0711141937gc7bb1f8w499cd9d8634fa232@mail.gmail.com>
	 <1195171869.8147.79.camel@johannes.berg> <87ir42z5kq.fsf@nokia.com>
	 <1195224067.8147.122.camel@johannes.berg> <20071119035943.GJ8672@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DlbRJQcFAbpeOrt9KaeL"
Date: Mon, 19 Nov 2007 15:44:33 +0100
Message-Id: <1195483473.8642.7.camel@johannes.berg> (sfid-20071119_144408_986442_D1392B03)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DlbRJQcFAbpeOrt9KaeL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > mac80211 has a comment that NULL frames are just for PS control
> > operation and otherwise ignored. So no idea.
>=20
> Please note that this comment in ieee80211_rx_h_sta_process() is only
> after having went through association state validation in
> ieee80211_rx_h_check().

Oh good point.

> However, it looks like the sending of
> deauth/disassoc based on Class 2/3 frames being received in wrong state
> (IEEE 802.11, Clause 5.5) has been broken at some point..
>=20
> mac80211 is supposed to notify userspace (hostapd) of this and hostapd
> would then reply with disassoc/deauth depending on the current state of
> the STA. The current mac80211 implementation is just silently dropping
> the frames. The way this used to work was by sending the
> ieee80211_msg_sta_not_assoc message with ieee80211_rx_mgmt() in
> ieee80211_rx_h_check().

Yes. This was removed along with the mgmt iface, it needs to be added
back.

johannes

--=-DlbRJQcFAbpeOrt9KaeL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0GhUKVg1VMiehFYAQKqsQ/+LBqDGvv2t6/C1cVWdPv4SZHdc5NdChta
0PAqUKTVmH3FCypkElp+a7XCCfwLojP6AJJQKkU/9nad023ats2oAN1WcwBig6to
tmtemjz190okoOSpozuWsoO++Fj8P0audYfluYvrE7vUk5jg95DUeOBtF7dUDVZr
BgV1Fevg1LCMQrJsoxC1doXaJQZqWpf6EGCOBMVCzu7jtCsN+c+Gi5+z+tPs1vwR
JytwzQICUSUm57tSGWCM2e4ERiUGK9MnEaPzzdgHQWgXTNRRPI3uZbJvAWN6DvJR
TbVdweMiIuzQDYOXHcnxMEAF7g09Zbe5GZgBDA7rJhYUz2qZKmNUngVoX8EO2/12
K8AVP/pNHjLyicGwUR01k+RhDdtZpJhi6HKHauWpz5dfZPMhx7opNzFxxY83bXEE
A+h4Ne4NfndGHrOcDufOrtO3dzJanXjs3LbvNfqegATztFsGcvb72J0vfnHFg4nQ
zys6YnbvonIxd4N6fqQJAcLmv3k2DY4fQiC0kIfvzf7UMIVl+w29fDxmxIhRTbH6
kntKdFZvy9dOvuATiNuBIUAy3lqXJgvf12hIOfIOr8Z+HgY79b0QiuCg/vzYEA3y
GuImH+H2pPRVu0XUymCz1E5qakLEHtJVOz+i7Plw71REyb55C6b76m06igIW8wGn
NgZxgmJQOaQ=
=haIt
-----END PGP SIGNATURE-----

--=-DlbRJQcFAbpeOrt9KaeL--

