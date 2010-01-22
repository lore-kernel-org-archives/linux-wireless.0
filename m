Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45034 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0AVTqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 14:46:11 -0500
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org, j@w1.fi
In-Reply-To: <43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1264186981.2593.10.camel@johannes.local>
	 <43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4G/kMY0m8wCLdGt0AzQN"
Date: Fri, 22 Jan 2010 20:46:00 +0100
Message-ID: <1264189560.2593.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4G/kMY0m8wCLdGt0AzQN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-01-22 at 11:20 -0800, Luis R. Rodriguez wrote:

> > Previously, we would switch the channel completely to the new operating
> > channel before even probing the AP. That way, we would virtually always
> > receive a beacon from the new AP between the time we started the
> > association process (probe,auth,assoc) and configuring the driver.
> >
> > Now with the new changes that use the off-channel work, we may return t=
o
> > the old "operating" channel, which may be no particular channel, betwee=
n
> > all these steps. Thus, if there's no beacon between any of probe
> > request/response, auth "request"/"response", assoc request/response, we
> > never get one, and this situation happens.
> >
> > I see two solutions, apart from this special-case patch fixing
> >
> > First, we could go back to the original behaviour if we have just one
> > virtual interface. But that still leaves us with the race, we might do
> > all three frame exchanges within a beacon interval and still miss the
> > beacon, we just tend to not do that and get a beacon.
>=20
> Curious, what symptoms were seen when the dtim was not propagated
> prior to association, did the STA just not wake up for the right dtim
> interval when in PS mode?=20

Yes, I don't really know exactly what happens, but if you look at
Wey-Yi's patch you'll see most of the problem was that we calculated the
maximum powersaving interval wrong.

> Wouldn't we get the dtim interval on
> eventual beacons later or do we disregard all that information after
> associated?

As you can see from the patch, we currently disregard any "update" in
that information -- this patch changes it.

> If so what if the AP changes the dtim interval?

I believe the AP is not allowed to do that without turning off and back
on completely.

> I take it this can easily be reproduced with a long beacon interval?

Easier, yes. The easiest way to reproduce it is to associate using just
"iw", no NM or wpa_supplicant -- make sure the scan list is empty before
you associate -- and with a long beacon interval. We then scan, but that
will only give us a probe response with high probability, and then we do
all the switching as I explained and we don't ever get a beacon. If you
use NM it may scan more often and increase the probability of us having
a beacon at some point in time.

> > The other solution I see is that we add a new step before or after the
> > direct probe step, which would just be "wait for a beacon". This would
> > ensure we have both probe and beacon information always ready. It would
> > also ensure we have both probe and beacon info for our new userspace
> > reporting of that.
>=20
> This seems cleaner.

I agree. And since we already keep track of this since 34a6eddb, we
should be able to fairly easily determine whether we still need probe
response or beacon, and only do either the direct probe or wait for
beacon step.

johannes

--=-4G/kMY0m8wCLdGt0AzQN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWgB0AAoJEODzc/N7+QmaI30QALmAeEVTYG0rh40RV1NvkpvZ
bDTpb59cWKiNT7Dfm1Kf9kD7bBLi9NSfnvhD0iFthitnXua9TxTmnNf9NNeDkjPw
r2/A2Fd2Dwzy3U6Du5SkEMF4Ft8oGJ1fRMNosoj5W/0DoDU36Opas9HiqVO03SiM
ueBYI3VT1Za3iqrCOoNyKqF3u4ByUwJRBUxrHFXr+OHaYruhx6YB3sWfOvnAPYfZ
m7L/SV2fZWRQSGPoJN/XMwkAf8UKBJ2VIP5+TErMS+1lOmyUzqlE/30Y6lvRbOSi
zAc+DiZXJ4xzx7Tp/fpybBh7BkazkjW6jkDmj6iJOSV5gbqYpGULnoxnTXzlP6U0
zfMH7SYp5GMYl4gEZgQaxw3CC75rD7yONI7QJyY0/2GAC6t/QfL5gsibu1u6hiul
ru3yDLFp7nqPr0/0wTzV8FHno43BdzjxZFc31vLms+6nDQLj54zMF71cmccghFW/
RqytOkX7ctG5cp0juJTYH589r1tGqjZ4aMo1f8eRS7jADhHCbFJE0P28NLE8bo9W
5Uca8pudfBq32QFPY4lBCt7dpICSlcnrbtqrCVlSDWZNr93fWgBIjiY1yuTMhgKu
PpgI9vbw48OoEEIWWBse54SReUOK9RxjloLR3WIosL1gEZ9ekIwQoUYVv5QoH5rf
IbWxWUlsoXz+MWFD/KC2
=EqgC
-----END PGP SIGNATURE-----

--=-4G/kMY0m8wCLdGt0AzQN--

