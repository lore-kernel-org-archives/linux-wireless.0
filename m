Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826AbYKTRwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 12:52:54 -0500
Subject: Re: [PATCH] mac80211: Look out for some other AP when disassoc is
	received.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
In-Reply-To: <8e92b4100811190433l24ab5043nd4e14ff7c7124e20@mail.gmail.com> (sfid-20081119_133338_552806_6F54661F)
References: <20081120000322.GA2828@myhost.users.atheros.com>
	 <1227095716.26243.20.camel@johannes.berg>
	 <8e92b4100811190433l24ab5043nd4e14ff7c7124e20@mail.gmail.com>
	 (sfid-20081119_133338_552806_6F54661F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e7Fsh+qtsWY/sz/smps3"
Date: Thu, 20 Nov 2008 14:04:49 +0100
Message-Id: <1227186290.14852.8.camel@johannes.berg> (sfid-20081120_185259_404936_10311C49)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e7Fsh+qtsWY/sz/smps3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 18:03 +0530, Vivek Natarajan wrote:

> Here is the test scenario that exposed this issue:
> * There are two APs with the same SSID so that the sta can roam if one is=
 down.
> * When the AP to which the station is connected is brought down or restar=
ted,
>   it sends( should send according to 802.11 spec) a disassoc frame with a
>   reason code of 8 which means the sender is leaving the BSS.
> * After receiving a disassoc, mac80211 moves to ASSOCIATE state in which =
scanning
>    is disabled. So, for the first scan request from wpa_supplicant(scan d=
uration of 30sec),
>    it tries to send probe   request to the same AP instead of scanning fo=
r other APs.
>    Then it moves to DISABLED  state since there will be no probe response=
.
> * The next scan request comes only after 30sec and now it will scan for a=
ll available APs
>    since scanning  is supported in DISABLED state.
>     So, it takes atleast 30sec to connect to some other AP.

Ok, I understand the scenario, I think. But I don't understand why going
to DISABLED fixes this. In DISABLED the mlme does nothing at all, I
think, so how can that fix it?

We can only request a new scan if we get into ieee80211_sta_config_auth,
which we can only get into by setting IEEE80211_STA_REQ_AUTH, which in
turn we get from ieee80211_sta_req_auth. Therefore, going into disabled
won't help at all.

Ok, I think I see, let me take a step back: you're not just using the
mlme code in the kernel but wpa supplicant as well? That has a 30 second
scan timeout? Seems a bit of a race condition thing, we block scans for
a short time while trying to probe/associate and wpa supplicant requests
one exactly then.

However, I still think going to disabled is wrong. We should be in a
different state and if we detect a problem with the AP, got disconnected
and it didn't respond to probes, then we could go back to scanning if we
had previously been associated. Not if we haven't ever been associated
though because then we could get caught in an endless loop.

I think you've also not accounted for the possibility that the AP simply
lost power for some reason and didn't send a deauth frame at all.

Unfortunately, I don't see a good way to fix this. I've long meant to
completely rewrite the MLME state machine which would have made this
easier, never got around to it though. Taking into account what I've
just said, do you have another idea?

> > Also, the reason code that's being passed is the one we send ourselves,
> > not the one we received.
>=20
> I have passed the reason code from ieee80211_rx_mgmt_disassoc which is ca=
lled
> only after we receive a disassoc frame from the AP.

Yes, but the parameter we pass to that function used to be for the
reason code we send, I have no trouble making it both depending on the
other parameters though, but I guess we should document that if we
really need to do it.

johannes

--=-e7Fsh+qtsWY/sz/smps3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJWBuAAoJEKVg1VMiehFYguEP/2YrKJjJHMYGQTvRTCPhwYgj
vksSD0KtM3DTIx15RM/W8O8CppVYhVX+XCJL3N1Jv8/hhdFIXFZz0EovrJnuQz8J
wHwNn5JrOI/uTg8gw3OhIZ14Z0PAH7hwJDz6q5PS8937rp4QJ4KOV78umuseXRYd
xjPusOutJkyzAxYJjHjKp6DaqZpg3D4ittrTLGBchno45cSY1nvSzW80wW+34tEN
p96bwy/qBv3JGQiS6Oq/93EzNCdHsC+5rNMGkCW/WxIieVTo1X5fCB3v5cCLCJIb
LF4AmZsCUr4gy5Tp4WxlFk+t2WN9gVLN0X3p5oRfTFZ4y1t9dmSmZcTqcFMtRth0
9saYzbA8XDTRH/hsNnfNQrFUicc80FoZy5NJc11QSAWKuveENNY7f0vEBVbeG03f
Er0fjN2E3WcxxQwMUjj0r2BwHjDpu7AnpXO3bq+PgfxbFUnsYkUwojkpri/JeC0Y
c46PKVAS0aSDEYkwx6W/U0INM3yxbIEsuspB249sSWwT62vg+2H3XWwcCyKwO+1U
U0+kgjrv50swPtRmF34cWZJ4yQLulBw0iEokhQZd3UA6wqoOg4lXGpWyjSk4UjUW
9AEYXnPNJTnEIIncJkFXVUYrH+EaM9TKcXNj9uFJRQYZl2etRad8f/WcU34cp+vK
pvr2e04wX5tmzyOis0fd
=r7GF
-----END PGP SIGNATURE-----

--=-e7Fsh+qtsWY/sz/smps3--

