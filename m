Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47816 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYDSIdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 04:33:08 -0400
Subject: Re: RE: iwl3945 problem with 2.6.25-rc9
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Brian Morrison <bdm@fenrir.org.uk>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240804181728u7a3440cajbba7dcc696d02909@mail.gmail.com> (sfid-20080419_012818_214996_06C2AEF6)
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
	 <fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 <1208555842.4848.56.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
	 <20080418232358.000fbdf7@peterson.fenrir.org.uk>
	 <1208558255.4848.60.camel@johannes.berg>
	 <1208558382.4848.63.camel@johannes.berg>
	 <1ba2fa240804181728u7a3440cajbba7dcc696d02909@mail.gmail.com>
	 (sfid-20080419_012818_214996_06C2AEF6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MRKVb7xkS5iKjSrarIjp"
Date: Sat, 19 Apr 2008 10:32:53 +0200
Message-Id: <1208593973.26186.2.camel@johannes.berg> (sfid-20080419_093315_310519_2D56BCC5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MRKVb7xkS5iKjSrarIjp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Second the 3954 and 4965 my uCode may crash intentionally if you send
> probe requests on a passive channel.according EEPROM.

I really wonder what sort of error handling strategy that is, even if
it's done for regulatory compliance purposes I don't see a need to crash
the whole card. Especially considering that the userspace MLME in
wpa_supplicant will scan by itself (yes, it scans in userspace, whether
or not you may like that), of course it would be made comply with
regulatory settings but that makes it hard to develop.

> I personally  wish to not make SW scanning possible at all for that reaso=
n.

That is not going to happen since you can always "scan" by sending probe
requests manually.

> At last iwlwifi HW scanning can handle up to 4 essids for direct scan
> but currently wireless tools interface cannot utilize this.

Does anybody actually *want* that? I personally dislike the behaviour of
scanning for all previously known SSIDs actively when hidden SSIDs are
so uncommon, I see it as an information disclosure vulnerability.

johannes

--=-MRKVb7xkS5iKjSrarIjp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAmuM6Vg1VMiehFYAQKYtA//WUDJKI7+r7kAh7U4VzH3kIqxeCNIUicr
XO/2T5XTJOwFFc60W6D1e6f8xO0zCfcQvERc5/qV4oCNzCBCAYFhAtffz6tKG/YA
ogbnDTygGgQr4eVj83wtADC98ZCow5+WXdAv72ZOefUgjqjZJgQLirjGHpsJiPhn
ILLAPAWznIzntTInIfeMadpLc7GjY8qFnwSBOqSO4+vVdXPXC0GAMZbE3BdzSzqn
O3sqoHt45jbaaYEiq8vWuM6CaV/v4dSNj9rxnAnkYoKRZDIP9SY50355/Zz5QsLn
ucDpcgSCYR8OPvj/BeIvYQ9oPnFV1SM6uXwaWIoJ2ALSatjH2YGv9l5E9E5s+gBO
6yiABJ9IZY2rTN4bN+0BBD4reUjhulahS7AT/I9FHBJMdByD2eL1/QvUUcBymBdQ
DAflBS3hSK30bMp5K9GijuqBW/uK0IogQXSyAMQvo95RkKvmju1Tw96TSQzZeES6
OfmtkjZFjh6wt/lgGVVDKJrH6VoB99epyGticZ9dEN8VI87UtuJqBPeyOFQ+EHt9
ayXqBZBbErVhyMC8cFspL8QDe1mCnq24HXtV36IJtZhQxpKT5pb6tw6R/kyccO2p
rwTkXyBA3bGwr12wAbSHKLfhhwTCFGGC2J6UOusjk81mzgX6KqIRKvq8+dm+m2m3
sjI9PT1iZNk=
=LwxQ
-----END PGP SIGNATURE-----

--=-MRKVb7xkS5iKjSrarIjp--

