Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbXKUPS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 10:18:27 -0500
Subject: Re: [PATCH] mac80211: free ifsta->extra_ie in ieee80211_stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1195615039.3250.453.camel@debian.sh.intel.com>
References: <11955417361539-git-send-email-yi.zhu@intel.com>
	 <1195565876.10920.29.camel@johannes.berg>
	 <1195615039.3250.453.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Q1gO8duD8IMi3gLQ4qx9"
Date: Wed, 21 Nov 2007 16:19:48 +0100
Message-Id: <1195658389.12000.26.camel@johannes.berg> (sfid-20071121_151829_151055_5F3A6E56)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q1gO8duD8IMi3gLQ4qx9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> Indeed. But at least user has a way to let mac80211 forget the previous
> setting (ifconfig wlan0 down and up). Otherwise, user has to reload the
> modules to achieve this.

Yeah. Can you amend the patch to also clear the
IEEE80211_STA_PRIVACY_INVOKED flag?

> > Maybe this should also be done when removing keys?
>=20
> I agree there are more places we need to clear the setting. Putting it
> to ieee80211_stop() is a good start. Should we have a "reset" like
> ioctl? So the second config tool can call it to let mac80211 forget all
> the previous setting.

No. We're not adding any ioctls, we now have to live with the wext crap.

What I'm going to do in nl80211 is put *all* the required setting into
an "association" object. Then all settings can be deleted together when
the association object is removed which will probably be done by
userland tools automatigally when tell them to associate to something
else, i.e. add a new association (needs to remove the old because there
can be only one).

johannes

--=-Q1gO8duD8IMi3gLQ4qx9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0RMlKVg1VMiehFYAQJVzg//c2YTaeliqF1A/6kxChfOffIXxa5DGvJe
gKlu7BGQ2In2CUe/jGlaNCz+wMYBKMxeRVxHUGr50YH1dk0ScjomReXPpdSs7afH
zqyBtzZ173QJdmmPYA4XSrBm5TE4Hs0zRIz7qVJP+F2dIaFP/mM6RovroqcHbgPc
8WtTpf/Zueydk+aZj4pp9f4ieFc8C1d2A5HHctRjlfbXZirpXLVJCY49PRZMoNbu
fJtjPaLsPD2qEqTenQWAT0Qm3eoDhYZlM5ZheNiy7WQckw7YMCM0+wyKsVxqkGmF
HWDaTZ9+WNxxlRXj3Ws7FG6+La/J7d6njgWs5cBuUzcj9/CmR6mYVSPMz/iDqWBC
H+gi3oTm2xhc8UmMa+BYC2YbbZGyglKBO2JygUh6SOztER1MlORuoRO1hAcmIzwg
9pqfsodNbRNSrafj2HAfZq6wsCYwlVvMEkuE39x0mcS+I92H4Ll/z4pZKMZJLA+I
UE3dPbUKgPf63gK1h5DrBNUQJclwZxj+yFEtB9pknUMj6tlrD68wR9QYOObwF1q5
NLQnFXyI9tFbXS/Zq44C+kr0hOhwlv8zXXHhRQzf7/uQmo9xUNi7ve+9hssSvBcJ
wf5OnJIAs7h6Zp/UuA9YuMkyVuVm2AvEYaSwkt5DueDaQqqwMmlGaZ5sjyL64cel
dPpsnyzyauI=
=mOly
-----END PGP SIGNATURE-----

--=-Q1gO8duD8IMi3gLQ4qx9--

