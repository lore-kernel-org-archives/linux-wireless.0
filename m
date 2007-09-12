Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46505 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977AbXILKt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 06:49:28 -0400
Subject: Re: rt2500 suspend problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcus Better <marcus@better.se>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <fc85aq$uu6$1@sea.gmane.org>
References: <fc85aq$uu6$1@sea.gmane.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qGwdxmtc8UX3HXtf8ypU"
Date: Wed, 12 Sep 2007 12:50:57 +0200
Message-Id: <1189594257.6161.45.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qGwdxmtc8UX3HXtf8ypU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-12 at 09:41 +0200, Marcus Better wrote:

> my laptop with rt2500 card won't wake up from suspend-to-RAM. The cause
> seems to be the rt2x00 driver. Are there any known issues with this? I
> tried 2.6.23-rc4 from wireless-dev head (yesterday), and also an earlier
> commit based on 2.6.23-rc3.

No idea, must be a driver bug.

> (As a separate issue, it seems I cannot even associate to my AP with WEP
> with the latest kernel. The syslog says:
> Sep 12 07:55:13 better kernel: wlan0: RX WEP frame, but no key set
> .)

known issue, actually. The driver doesn't set the
IEEE80211_HW_WEP_INCLUDE_IV flag and mac80211 expects it to be set. But
the driver shouldn't be changed, instead the patch "mac80211: rework
hardware crypto flags" should finally be merged. John seems to
hide... :)

johannes

--=-qGwdxmtc8UX3HXtf8ypU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG58SR/ETPhpq3jKURAihoAKCNnI6+6RDIrMaUX324D0p3g0gvpwCdHh+H
Qz4EmwNszAF2NK+3shy7T7E=
=ufgM
-----END PGP SIGNATURE-----

--=-qGwdxmtc8UX3HXtf8ypU--

