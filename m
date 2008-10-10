Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbYJJJQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 05:16:22 -0400
Subject: Re: [PATCH] allow AP interfaces to handle BACK action frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org, Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <45e8e6c40810091038i697c9615pb7121882a54d5873@mail.gmail.com> (sfid-20081009_193818_426795_A2D95AEB)
References: <48ed3fd6.1e068e0a.7847.4d37@mx.google.com>
	 <1223546217.22490.31.camel@johannes.berg>
	 <45e8e6c40810091038i697c9615pb7121882a54d5873@mail.gmail.com>
	 (sfid-20081009_193818_426795_A2D95AEB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3Acvz3KJXT8TC+eBOKAH"
Date: Fri, 10 Oct 2008 11:16:21 +0200
Message-Id: <1223630181.3930.73.camel@johannes.berg> (sfid-20081010_111625_645172_CBC31AD2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3Acvz3KJXT8TC+eBOKAH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-09 at 10:38 -0700, Andrey Yurovsky wrote:
> As I understand it, despite the "h" in ieee80211_rx_h_action,=20

Heh. That is part of _rx_h which stands for RX handler :)

> it
> filters both BACK (802.11e and required for 802.11n) and spectrum
> management (802.11h) action frames.  I suppose that the entire check
> isn't really necessary.  I don't know much about the
> WLAN_ACTION_SPCT_MSR_REQ frame but as far as the BACK frames, there
> shouldn't be any harm with passing them to the driver for any of the
> interface types.  Should I resubmit this as removing the check
> entirely?

I think so.

>   Should there perhaps be separate functions for the 11e and
> 11h action frames?

Possible, although right now we only handle measurement requests by
rejecting them...

> Additionally, with the check the way it currently is, an AP interface
> (for example) will respond to an ADDBA frame with something strange
> (action code 0x83 for starters, and the rest of the action frame
> doesn't make sense), at least with iwlagn.  It seems that if the check
> fails and we don't pass the frame to the driver, something weird still
> happens (otherwise, for iwlagn at least, the right thing happens).  I
> haven't had a chance to see if other drivers / interfaces do that.

Do we know where that frame comes from?

johannes

--=-3Acvz3KJXT8TC+eBOKAH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7x1hAAoJEKVg1VMiehFY+yYQALSbyKtZdqQJjL/dF/o1E+Lf
srJ6tTQzHrOJWcSAQcw/sm/BVz0vsqNu66BOw1AXkDA9bIx7Fxg2UfCXxZHhDxWr
ClGtyjfofTnQbYnaUPn/mhnL6CC691mNdDVM2g76uH+6Rcxwak6PGLVyFGIUEp+B
KgLwaKeUjxJEG1cTjXfCPklA0cL8Jt0qdOMnXlCeV6LQZNtRIR9cX5m/5U5yUqC7
R4O44SVUDOvZNc1nSayErlSeb8xg+6Wd3NVrLmDJhkTMCWVgCpjS50tGS40IkU/H
wL0UZGjcREqdqNeuCHY0/rEPIve1iw262Zs0qBKS9YEOdUQaJVlep8EFlnvmJyL+
y2l4ZgrROBejvg91hMnIkNVHzzP1k+d2vslbMhRHukxH2TgfKRSBuZ36/IHAfWeK
lxBtxdx8zCNAyGwTNiE4TZXu4pgsjfvyZPk+seHTp5LOK4o0FzaJjVi+8PjGowKD
33cDm2h7QGOREOetnRqnBOQP8bAKLJ7YLxb1ql8vBBWpkWRTU1t7xDBnui9Gokrh
LvAovrdYMjV6QvV+P++vyg1zO64zycn1JGILCRwvx1AoUr47zEMOVewrsjR6QuNF
h0JneZvzId0qwDXdvy1ykjUKxG+xthEDc+iyxFTmjZj243mxE0L7I3gmBkx7Oonp
7cvpnoEGviYHS5epJhkL
=zI7Y
-----END PGP SIGNATURE-----

--=-3Acvz3KJXT8TC+eBOKAH--

