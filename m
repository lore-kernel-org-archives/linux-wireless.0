Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:60460 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751661Ab3ABGeK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 01:34:10 -0500
Date: Wed, 2 Jan 2013 07:32:55 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
Message-ID: <20130102063255.GA27676@open-mesh.com> (sfid-20130102_073413_999270_B83ACBF1)
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>
 <1355146824-25012-2-git-send-email-antonio@open-mesh.com>
 <1356706268.9922.23.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
In-Reply-To: <1356706268.9922.23.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

On Fri, Dec 28, 2012 at 03:51:08 +0100, Johannes Berg wrote:
> Anyway this part is really confusing. If userspace is handling auth
> frames, should the kernel really mark the station as authenticated? What
> then is the point in handling auth frames in userspace??
>=20
> Will?

Actually I don't know. Maybe Will can help us in understanding how to handl=
e this point.
I simply kept the same behaviour: before this (my) patch a station was mark=
ed as
AUTHenticated in by the kernel, even if userspace registered for AUTH frame=
s,
and the same I'm doing here.


>=20
> Any chance we could converge on a single implementation here?
>=20

Maybe yes :)

I think that leaving the station not AUTHenticated and let userspace do so =
would
be the best approach..but then we need a way to enable userspace to do it :)


> > +static void ieee80211_ibss_auth_sta(struct sta_info *sta)
> > +{
> > +	if (sta->sta_state > IEEE80211_STA_NONE)
> > +		return;
> > +
> > +	sta_info_move_state(sta, IEEE80211_STA_AUTH);
> > +	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
> > +	/* authorize the station only if the network is not RSN protected. If
> > +	 * not wait for the userspace to authorize it
> > +	 */
>=20
> technically, control_port !=3D RSN protected, but I guess for IBSS ...
> who's going to do WAPI? ;-)

This is a behaviour I introduced some time ago:=20

1153         sdata->u.ibss.control_port =3D params->control_port;

which is set based on NL80211_ATTR_CONTROL_PORT and at the moment, in IBSS,=
 I
think it is only set by wpa_supplicant when using IBSS/RSN..you told me to =
use
control_port instead of creating another member..but maybe it is general and
could be used for something else?

>=20
> > +	cfg80211_ibss_sta(sta->sdata->dev, sta->sta.addr, GFP_KERNEL);
>=20
> I'm not really convinced that this event is the right thing to do.
>=20
> If userspace is handing the auth frame, it already has the event right
> there, no? It can even reply, even if for some reason it can't send a
> negative reply because the kernel has already marked the station as
> authenticated (see above).
>=20

Here I am missing something. To the best of knowledge, wpa_supplicant (whic=
h is
the only userspace tool providing IBSS/RSN and it is not handling AUTH fram=
es.
Therefore it will not have any event for authentication..

> If there's no userspace, then RSN can't work anyway, so maybe this isn't
> really needed?

what we could do is to "move" the NEW_STA event and use it in this point. B=
ut I
preferred to create a new event type in order to distinguish between the ca=
se of
detecting a new station from the case of having a new station ready for key
exchange.

>=20
> Also, a more generic event would make more sense I think?
>=20

You mean a generic event to be triggered on state change? Yes sure, but at =
the
moment it was much more important to reshape the interaction between US and=
 KS
when using IBSS/RSN.

> > +	ieee80211_ibss_auth_expire(sdata);
>=20
> It seems you should have something to trigger the timer too?
>=20

uhm? I don't understand. This function is invoked in ieee80211_sta_merge_ib=
ss()
which should be periodically called (if I got it correctly...the timer stuf=
f in
ibss is not really clear to me)

Thank you very much for your feedbacks!
Happy new year :)

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ49SXAAoJEADl0hg6qKeOlfsQALOv8i/j4HG+0Vw/9w4rZE4q
GFZFUzeDIkOPUY2/LPLdklVKjA7Xw5t5mtLU7ND9QlR6zI+FIv33EtGxTOeIR5wW
QUJ3r/yPMpZuJn+AYOSRR1dy4H8WO2drhyyopA/pG4/yK6U5lGC/wYRbB5mVMI6Q
zIwHIfVa1Temqp4k2AV40rIB++wtjDA99LF1Fh+gt4Iw4QBvd/+dT/9a4AFI0jL3
MKHZMkMSHb/xPfLycpYQZxZkhY2ht4chHwll+BD6Go1+RuRfh4dHvx6g6gxc14BY
hL5zP67ms2Y4+qjZIb3BeYRBlOefwqcbckrhsDkdqPUcnRxZ7iTlK9mmjYFLXE3G
W7JGoILasPOv0INCV9r2TtNwfMxZ8W34n0YHOjBPTZwWSeFiQf2bdupJL9EpQ9YF
RZlCieRlMwI67q5yKhJbwNCEO/lQu4zu+mPs098T5HBe93ld35mFk0Z06BUI/hUg
CcvPUN1Dw1imxYMU7p0yXQyuYyfOLpjq7isJKWMRTMzhpEoGHp5pmIz7/e/akgJG
yY3F9abFQ1cUZOTe/ZrGxW4ynn5U1x1IXs2b5yIUJyjyhcVXZSaBCRAig8HFt1GR
FuhTXak+4RHpRrQrdTbApAGs0rPoFQPOL9eF4PNako66wy7WmEQEIspgm7Pwnnih
BVD7XQy0GT0XK+BjL2+i
=JZPj
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
