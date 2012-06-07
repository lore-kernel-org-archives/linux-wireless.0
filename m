Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:37198 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab2FGQDi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 12:03:38 -0400
Date: Thu, 7 Jun 2012 18:03:25 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Andre Heider <a.heider@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
Message-ID: <20120607180325.7752b3c0@milhouse> (sfid-20120607_180341_907694_94E6B0FA)
In-Reply-To: <CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<1339014959.4523.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com>
	<1339053364.4517.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tG2q=WpLIDAeuNx5Xo6Va/H"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/tG2q=WpLIDAeuNx5Xo6Va/H
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Jun 2012 17:24:51 +0200
Andre Heider <a.heider@gmail.com> wrote:

> On Thu, Jun 7, 2012 at 9:16 AM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > On Thu, 2012-06-07 at 09:10 +0200, Andre Heider wrote:
> >> On Wed, Jun 6, 2012 at 10:35 PM, Johannes Berg
> >> <johannes@sipsolutions.net> wrote:
> >> > On Wed, 2012-06-06 at 21:10 +0200, Andre Heider wrote:
> >> >> Hi,
> >> >>
> >> >> the wlan daughterboard on a nintendo wii stopped working with curre=
nt master.
> >> >> Building from the v3.4 tag gives me a working device.
> >> >>
> >> >> I bisected this to:
> >> >>
> >> >> commit 3a25a8c8b75b430c4f4022918e26fa51d557ecde
> >> >> Author: Johannes Berg <johannes.berg@intel.com>
> >> >>
> >> >> The hw queues fail the check in ieee80211_check_queues(). When I ha=
ck
> >> >> that function to always "return 0;" wlan works again.
> >> >
> >> > There's a fix for this on the way since Larry had also reported the =
bug,
> >> > but I don't know where it is right now.
> >>
> >> Okay, nice. Then I won't go hunting and just try the next -rc.
> >
> > Found the commit now:
> >
> > commit a9d3c05cca51d80ef2b9eddabf794c9458e36c2c
> > Author: Johannes Berg <johannes.berg@intel.com>
> > Date: =C2=A0 Mon May 7 17:45:29 2012 +0200
> >
> > =C2=A0 =C2=A0mac80211: fix single queue drivers
>=20
> Just checked again, that commit was already part of my tree, so I
> still run into this issue.
>=20
> A couple of printk()'s report that local->hw.queues is 4 in
> ieee80211_set_default_queues() while n_queues in
> ieee80211_check_queues() is 1...

b43 messes with the queue count at runtime. I guess that's the reason.
I don't know if this can be fixed now, though. The problem is that we
first need to load the firmware before we know the queue count.
There seem to have been some firmware loading changes, but I didn't
track those too closely. So I don't know whether they allow fixing the
situation or not...

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/tG2q=WpLIDAeuNx5Xo6Va/H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0NDNAAoJEPUyvh2QjYsOPdQQAOKtxo7i9eOthRzJyb1pFSwc
AjU1jv1OnRRj7+jRnm0mDkoAULFR3MBnC/LnOh2PriSqo7tcR8J8BqRIuPXiVPN/
oioIaUQ9V6F/jMG9WCR8fXrV62763hx7CqHzwYFCrz8uM8LkT3YfQfRYgfSj0449
Y1sYboJyi5IiGNWMf9MvCMhzj4+EQK1NKHI2lBPCwabzkxETeof4dwRG0Tgr/s1w
mRuwbZtEwf7OyDIqgpQaJzbQqqWpUKD/FXEe2xqbvBfW9azaPNiYInlJDjtVVKG8
3HKUV1iN3qQRFDE9E8vhk68PGRH/fYaQB2TMzLi6z6UtiIHChOYOCx6HY9cTbmcQ
cMtSWaVr/Pkw/1dVS4PQzSp3aKnqRQWHOg8fXLy9SnLBiEQeSNLH5tImVZ0veNx4
C3dk1QtuhIrtNhHHtmASVZyB7Fsx4C0YOzLQ4IQOXxljIs5ZmzC62q3U14Esxi2F
qBPwfLovKUEQ93RKafCDfx71hdDd9Wc++3C8aoHpx0UhYj9g3Vdo2xGFpg7BwFDZ
3K4NqqOepetTW5pPEkXPWDxFXZIgGFxWI+x3+0DoIaMR+cJp7ZJNIwUNGZ3a1Aox
0lzu1/Mcl3Km68klpBlJboJfx3OKhW2R8TmzykpjI6HhQ69/TJAEkhIPf4zLvDSq
QepwbdvNNYVaCOP1arAo
=vkJw
-----END PGP SIGNATURE-----

--Sig_/tG2q=WpLIDAeuNx5Xo6Va/H--
