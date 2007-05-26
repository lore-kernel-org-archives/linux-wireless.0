Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:13945 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752085AbXEZBHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2007 21:07:30 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Will Dyson" <will.dyson@gmail.com>
Subject: Re: BUG: at net/mac80211/ieee80211.c:1280 ieee80211_tx()
Date: Fri, 25 May 2007 18:05:20 -0700
Cc: linux-wireless@vger.kernel.org,
	"Broadcom Linux" <bcm43xx-dev@lists.berlios.de>,
	Jiri Benc <jbenc@suse.cz>
References: <8e6f94720705251637o71a13d71w70199a3057048592@mail.gmail.com>
In-Reply-To: <8e6f94720705251637o71a13d71w70199a3057048592@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2368174.0oZgf0cOcV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705251805.25696.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2368174.0oZgf0cOcV
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 25 May 2007 16:37, Will Dyson wrote:
> But I've got ton's of these in my log:
>
>  BUG: at net/mac80211/ieee80211.c:1280 ieee80211_tx()
>
Do you have CONFIG_NET_SCHED on?

If you do, can you check what qdisc is attached to the master device? This=
=20
command should do it if you only have one mac80211 device on your system:

tc qdisc show dev wmaster0

I suspect the patch that made mac80211 work without the ieee80211 qdisc mig=
ht=20
not be working correctly.

=2DMichael Wu

--nextPart2368174.0oZgf0cOcV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGV4fVT3Oqt9AH4aERApBuAJ0SCideWTh2mBxkKF81pUAJOMOL1wCfRmCc
GoSOQqU74eMu/hlNn8RN8hY=
=1tSe
-----END PGP SIGNATURE-----

--nextPart2368174.0oZgf0cOcV--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
