Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49272 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbXGMJGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 05:06:44 -0400
Subject: Re: repeat scanning could cause disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: mohamed salim abbas <mabbaswireless@gmail.com>
Cc: mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <b3153e950707111616r7f3f36a2x7a262f41afce396c@mail.gmail.com>
References: <468EB36C.10508@linux.intel.com>
	 <1184109113.3738.39.camel@johannes.berg>
	 <b3153e950707111616r7f3f36a2x7a262f41afce396c@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ViabwidX5k0nLEj/KqT5"
Date: Thu, 12 Jul 2007 22:43:04 +0200
Message-Id: <1184272984.6669.52.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ViabwidX5k0nLEj/KqT5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[could you turn off HTML mail please?]
=20
> I am not sure if the AP actually sending any data frame since we are
> scanning,=20
> but the major problem is mac80211 does not update rx_last once
> recieved
> beacon during scanning causing the disconnect.

I'm somewhat confused now. What happens if we do background scanning in
mac80211 is that we tell the AP we want powersave mode and then go do
the scan.

Do you actually see the message "<device>: expiring inactive STA ..."?
Basically, what I can see happen is that the scan takes so long that the
check there in ieee80211_associated() (called from ieee80211_sta_work())
triggers, but that means the scan took on the order of two seconds. Is
that so?

I suppose we should update last_rx when we go out of the scan to avoid
this since there's no way we can determine whether the AP dropped off
during the time we scan. What you proposed was to update last_rx when we
see frames from our AP, but even then if we're the first channel of the
scan it doesn't really help. Then again you said that the firmware goes
back to the channel it's supposed to be on once a while, that is with
the hardware scan callback then?

johannes


--=-ViabwidX5k0nLEj/KqT5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlpJY/ETPhpq3jKURAsqLAJ99qzReRIR+AYC7GngPwQD8ck9pRwCfc9dA
V1zOVs3DBh+XugOoer/0gfc=
=W2rk
-----END PGP SIGNATURE-----

--=-ViabwidX5k0nLEj/KqT5--

