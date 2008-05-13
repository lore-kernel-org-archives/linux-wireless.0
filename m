Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43229 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000AbYEMIgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 04:36:00 -0400
Subject: Re: [RFC PATCH] mac80211 : Association with 11n hidden ssid ap.
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1210641995.2506.200.camel@debian.sh.intel.com>
References: <12103509413156-git-send-email-abhijeet.kolekar@intel.com>
	 <1210641995.2506.200.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AJg2XK5J4fkZBpkqbIB5"
Date: Tue, 13 May 2008 10:35:47 +0200
Message-Id: <1210667747.3646.32.camel@johannes.berg> (sfid-20080513_103602_816894_0A8AB5A6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AJg2XK5J4fkZBpkqbIB5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Johannes, can you please take a look at this patch? The original code
> looks like a shortcut to start authentication/association when all the
> three parameters (BSSID/SSID/CHANNEL) are provided. But this is not
> sufficient in the case of associate with an 11N hidden SSID AP. The 11n
> and wmm information must be retrieved by an active probe request. Not
> doing so will cause the 11N AP refuse to associate with the client.


> > -	if (!(ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
> > -	    IEEE80211_STA_AUTO_BSSID_SEL | IEEE80211_STA_AUTO_CHANNEL_SEL))) =
{
> > -		ifsta->state =3D IEEE80211_AUTHENTICATE;
> > -		ieee80211_sta_reset_auth(dev, ifsta);
> > -		return 0;
> > -	}
> > -
> >  	spin_lock_bh(&local->sta_bss_lock);

Well, I'm not sure I'm the right person to look at this, I'm very
unfamiliar with the code in question. For all I care we can put it in
and revert/fixup when we get bug reports from it.

johannes

--=-AJg2XK5J4fkZBpkqbIB5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASClS4qVg1VMiehFYAQJfHQ/+LFppHrKfiufqUEuuOgKVnOiPTZTdrMv7
iysZEun8swqh3tYLgPihjJeIs0o4XI4K9o/39mDxhquAsLfl1ahrLLqD4mUb8Oau
AYGLunhACEPr7PbQDQtjm09OHmhRBuMSrLxblytOFxWlWpqS82JhgD/bywXWsR5f
thJDDHK0hw3lWefrqGzR6gUQ+MEdWv04Ql8j1QuiramdbUCsuLRsNWvA4foI/HVu
5qZYrIXnWLral/2wlYSFicXaTzWnugnzUU3gKoK8tvLE+3ukcHOlXadxOC20RuEM
aAdinpvDJpZ/9JgdIs+MWQwbA5PfyGwQy/APaKeH4E9e0PKdqVMtJB/C6PaYefUC
EmnpsdhWP37xSEqfty/vdaH6ftmAov0p3ogwgmVD9gGI/YBt9sb7q1n/FExgO0u5
uL8SQ8H5XLj7KbYpNM0KFpHoDubmrlv7txV6hyK8dlz54uy8LMYe4QCYXr94RvSh
R2H11H/sZwU40lO1m2ra8r/e/D2bkpw/IX7ulTfx8fkP50U4SdnRfDK4iBuDJGSk
t/ZkA4Ui4m9aCAbvAPzeEf/YQfNHAGTcbZB1JfVj4oYlb2fuLunosqoYF4fQNOsF
+LlZm/bZ7wVw4VXeBS10EsOfrPqctY5Xvw8/gKFnDGDtlbCds45GkhnjQyYYlwon
TxNh0zZLWWo=
=GGjQ
-----END PGP SIGNATURE-----

--=-AJg2XK5J4fkZBpkqbIB5--

