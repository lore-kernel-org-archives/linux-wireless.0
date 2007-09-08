Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbXIHHr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 03:47:56 -0400
Subject: Re: Kernel panic with rt2500pci built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <6b8cef970709072140o23cfd152nee56313db53739ae@mail.gmail.com>
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
	 <1189125944.28781.125.camel@johannes.berg>
	 <6b8cef970709071231s5693b835vaf8493254c8292da@mail.gmail.com>
	 <1189193840.28781.197.camel@johannes.berg>
	 <6b8cef970709071438o6870cecej355119fee4396dcb@mail.gmail.com>
	 <1189202441.28781.208.camel@johannes.berg>
	 <6b8cef970709072129r5d7658b8v46e5b327638b8f06@mail.gmail.com>
	 <6b8cef970709072140o23cfd152nee56313db53739ae@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O3zAuO9PLvMg1QTxMavs"
Date: Sat, 08 Sep 2007 09:49:24 +0200
Message-Id: <1189237764.4506.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O3zAuO9PLvMg1QTxMavs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-08 at 00:40 -0400, Rob Hussey wrote:

> You don't have to answer that. Going through the dmesg it seems a lot
> of devices rightfully have null for parent.

Ok so that means I read the stackdumps wrong.

>  The relevant line seems to
> be:
> [   28.348658] kobject phy0: registering. parent: ieee80211, set: devices

That's interesting though. I'll have to take another look. Maybe somehow
we initialise cfg80211 too late. In fact.. Hmm. Can you try something?
When having rt2500pci built in obviously you also have cfg80211 built
in. Can you go to the end of the file net/wireless/core.c and exchange
the module_init(cfg80211_init) with subsys_initcall(cfg80211_init)? It
looks like that might be the problem.

johannes

--=-O3zAuO9PLvMg1QTxMavs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4lQE/ETPhpq3jKURAn/ZAJ4jXgeABRstz7qHl1B+CQO6+XnW3QCdF0dC
/7ZnoJvOnrscmPfgXeMWgvs=
=VhKg
-----END PGP SIGNATURE-----

--=-O3zAuO9PLvMg1QTxMavs--

