Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35855 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbXLWIkY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 03:40:24 -0500
Subject: Re: [RFC] mac80211: add unified BSS configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1ba2fa240712230028l1759abdcsd2a1bd9cd9fa36e7@mail.gmail.com> (sfid-20071223_082810_970929_A0B040C2)
References: <1198109817.16241.7.camel@johannes.berg>
	 <1ba2fa240712221255q2daee8eehf84e1a5829ad2ac0@mail.gmail.com>
	 <1198358103.6630.10.camel@johannes.berg>
	 <1ba2fa240712230028l1759abdcsd2a1bd9cd9fa36e7@mail.gmail.com>
	 (sfid-20071223_082810_970929_A0B040C2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4q2hFdonSw0BzG6cxgtT"
Date: Sun, 23 Dec 2007 09:39:54 +0100
Message-Id: <1198399196.4116.1.camel@johannes.berg> (sfid-20071223_084027_644243_F55E3F08)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4q2hFdonSw0BzG6cxgtT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Actually I need all the timing info Beacon Interval, Listen Interval,
> DTIM and TSF from the last beacon.
> The TSF is just a time stamp when this info was taken.

Oh, ok. I don't think we even keep that info right now.

That said, I'll probably respin this patch, putting the bss_info into
vif isn't such a good idea because drivers can't access it in a
race-free fashion (unlike the interface type which doesn't change).

johannes

--=-4q2hFdonSw0BzG6cxgtT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR24e2aVg1VMiehFYAQLImQ//etZ0Lcgs929445lgfTjspr8BZMx1Yaad
CipKm+ZpohgFdlW5awMSy/i3P3zmTpq6UsyXn5LgRL0Vt9ZlM6mlnpPF2VIjbVAW
pgku3lSr0fkkUXlHj8a95QcHad+OV+4QZWmjgxMBT6kHPfDvYiVXKaU5+8nuUulx
2nCjHOfKos3MZpQe99qKg4gsU+n5ZR3YnC9gTpOqm6aJLK15SstQFrcKiYvam95K
13ekTeisqDcY+gPTpwMK5SuTfz4RtBHOMAku9Rwt/HSdd9KBoXWpSSPro68hExhC
wtrWqg8T99cq1EK4MtIAjOyleHUsnI9HEqYmLzy/zAFG5C69GxJ6fpUAlbjLBV+q
TC2a+hZZq1iWZJ3AHHkKu9EuSmvKRGdUF030L5bo2aFHYpL6op3pc3fo4t5dTIaY
Mqg2fyCTm/mePdu3ztX00LyOzhEnahuxmTSeOlg5C5pzRF9xJS2lRKb2bFthSgq0
SNBaS4zjRkuk+hK2zuoXnnBmGb2VBIFEfxr8qu7jfl+aMaliFBdLPblZpPnHoLHV
kSTk2LyTVwBbIvagzOE/K049EjLeBlGxaWcl/Ed+74gz7J9uQFBx11PWEY0MzBIy
O5PvUnT2iNWIQC25WRY5h5pOlOBMb7/haH6/0eYg67mYf7saob/Oj939lG8NeFIS
WzYEjCro9Fk=
=pq6X
-----END PGP SIGNATURE-----

--=-4q2hFdonSw0BzG6cxgtT--

