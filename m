Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:58497 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYCRNp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2008 09:45:29 -0400
Message-ID: <47DFC762.10307@work.ksp.sk> (sfid-20080318_134533_744652_499437AB)
Date: Tue, 18 Mar 2008 14:45:06 +0100
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: configure default wmm params correctly
References: <47DFBA13.3060508@work.ksp.sk> <1205846472.16475.46.camel@johannes.berg>
In-Reply-To: <1205846472.16475.46.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC662D3C02057D877D778D713"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC662D3C02057D877D778D713
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

>=20
> There is lots of trailing whitespace (use scripts/checkpatch.pl)
>=20
>> +	if (local->hw.conf.channel->band =3D=3D IEEE80211_BAND_2GHZ &&
>> +    	have_higher_than_11mbit)
>=20
> and that really needs to be indented differently.
>=20
Oops, sorry for that :(

>> +		/* IBSS uses different parameters for Beacon sending */
>> +		qparam.cw_min++;
>> +		qparam.cw_min *=3D 2;
>> +		qparam.cw_min--;
>> +		local->ops->conf_tx(local_to_hw(local),
>> +				   IEEE80211_TX_QUEUE_BEACON, &qparam);
>=20
> And shouldn't we do that only for IBSS? I'm in favour of removing it
> completely, however, since the beacon queue is a way to construct
> hardware, not do things in software...

Good question; I've just moved this part of code out of
ieee80211_sta_set_ssid as that is not the best place for it. I don't
object to removing that code completely; seems that noone uses
IEEE80211_TX_QUEUE_BEACON anyway. On the other hand, it can be a good
hint for those implementing beaconing on hw where it has to be set
explicitly..

Vlado


--------------enigC662D3C02057D877D778D713
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH38dje5Z0y47EufgRAvFIAJ9ZexKr3oFssRf1oJeGi+ZZWi3I7gCgiFKm
DjyY4zGTrto5ht9pK/v6qx4=
=9jIS
-----END PGP SIGNATURE-----

--------------enigC662D3C02057D877D778D713--
