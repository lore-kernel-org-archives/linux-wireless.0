Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYKULw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 06:52:27 -0500
Subject: Re: [PATCH] mac80211: Look out for some other AP when disassoc is
	received.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
In-Reply-To: <8e92b4100811210346r125519d0gb5a71108719e1768@mail.gmail.com> (sfid-20081121_124651_042342_5B61A13E)
References: <20081120000322.GA2828@myhost.users.atheros.com>
	 <1227095716.26243.20.camel@johannes.berg>
	 <8e92b4100811190433l24ab5043nd4e14ff7c7124e20@mail.gmail.com>
	 <1227186290.14852.8.camel@johannes.berg>
	 <8e92b4100811210346r125519d0gb5a71108719e1768@mail.gmail.com>
	 (sfid-20081121_124651_042342_5B61A13E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kzdJP4xWYtpQ0hKKD2+m"
Date: Fri, 21 Nov 2008 12:52:20 +0100
Message-Id: <1227268340.3766.112.camel@johannes.berg> (sfid-20081121_125231_298489_7E306837)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kzdJP4xWYtpQ0hKKD2+m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-21 at 17:16 +0530, Vivek Natarajan wrote:
> Johannes Berg <johannes@sipsolutions.net> wrote:
>=20
> >> * After receiving a disassoc, mac80211 moves to ASSOCIATE state in whi=
ch scanning
> >>    is disabled. So, for the first scan request from wpa_supplicant(sca=
n duration of 30sec),
> >>    it tries to send probe   request to the same AP instead of scanning=
 for other APs.
> >>    Then it moves to DISABLED  state since there will be no probe respo=
nse.
> >> * The next scan request comes only after 30sec and now it will scan fo=
r all available APs
> >>    since scanning  is supported in DISABLED state.
> >>     So, it takes atleast 30sec to connect to some other AP.
>=20
> > we block scans for a short time while trying to probe/associate and
> > wpa supplicant request one exactly then.
> > However, I still think going to disabled is wrong. We should be in a
> > different state
>=20
> If the AP has explicitly told us that it is leaving the bss, what is the
> point in retrying in associate state? DISABLED state would be ideal
> for fresh scanning & assocation. What do you think?

Well, the thing is that if we go to disabled state then we don't
actually scan and associate again. Only if wpa supplicant is running
does that happen.

> > Ok, I understand the scenario, I think. But I don't understand why goin=
g
> > to DISABLED fixes this. In DISABLED the mlme does nothing at all, I
> > think, so how can that fix it?
> > I think you've also not accounted for the possibility that the AP simpl=
y
> > lost power for some reason and didn't send a deauth frame at all.
>=20
> If AP loses power, probe request times out and we directly move to
> disabled state. Hence we don't spend time in ASSOCIATE/DIRECT-PROBE
> state. The same behaviour is expected when we receive a disassoc
> frame with reason code as "AP leaving BSS". There should not be any
> intermediate state like ASSOCIATE.

Oh. You're right, we do go directly to disabled. I thought we somehow
went back to 'request auth' (which is not a proper state, unfortunately)

Hmm. I guess what your patch is doing is the best thing at this point
then until we actually rewrite the roaming code.

Can you add a comment to _set_disassoc that the "reason" variable passed
is either our own reason (when self_disconnected is true) or the remote
reason (when self_disconnected is false) please? Also, I haven't
checked, but there may be other places where we could pass the remote
reason.

johannes

--=-kzdJP4xWYtpQ0hKKD2+m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJqDwAAoJEKVg1VMiehFY+AkP/irBJJtLfBC6dYLJEHMbkCEB
1Z2g21vqtKLKIU0M01euXpHOhAfpQAotcI2I7lNbZ+eg+BIwYtpxjomcfFjDZ118
eE1d3mZIZtx9ah2oqMBVVS9dQogefU1DMfIjA2aKGhC+h71Fu+mTK7gJsYlzz1qj
Kc9i2a8mN+PL0XK0YLbr7LF4J160vj4T+J7+vWAi0NgHxWtQlqP9ErYM6d6McXRy
LNA0HPQ3GRfW62FwSnVo9m8DVaTh8NJidc2qsHLrd0GYE9Lim7b9x9jdSlHpJVDb
eiKYZPfM988Zr/7V2sERbfhHu+UmhmLzF66Ruv5ecgH7S1VlElAVzjL/3LiRcigz
qKym7Mwls2zTmEtIhts7SKniHpNsp8LKWvNgle+/LHnaXtEgdG9NbAHQI2bAXUfT
XbS4WnLD0GGuG5cBpajD1Zera5624w2Fone+YUjWZnOZGPq6GHvvjnMPYln40IaT
ZQUVr0iAX2ukAgrudk5F8tAHt2nqfBubKwryzYrPEX+2ImhBEVTcLzQzcDKOtFSv
mO+8Mg1hMcb/AFHlGcDzf+zVO7f2sAnbMb9tTvUNNDIuqDP9yqNeX7noym6qDC7E
JPoe9baM5yt4NWezmcUbKI73LanYmh75+3Efps/lglmB8HGIH3z/aeP0cXpG61zl
eVLlY3FQ91jSp4kLlopd
=LQog
-----END PGP SIGNATURE-----

--=-kzdJP4xWYtpQ0hKKD2+m--

