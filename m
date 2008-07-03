Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:52610 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbYGCNvE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 09:51:04 -0400
Message-ID: <486CD93B.90503@work.ksp.sk> (sfid-20080703_155151_271493_A8BED51A)
Date: Thu, 03 Jul 2008 15:50:51 +0200
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	bruno randolf <bruno@thinktube.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: fix alternating-BSSID issue in IBSS
References: <486A43D0.8020507@work.ksp.sk> <20080702190059.GA31288@tuxdriver.com>
In-Reply-To: <20080702190059.GA31288@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB2143141FBA987B07EE0B6AC"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB2143141FBA987B07EE0B6AC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

John W. Linville wrote:
> On Tue, Jul 01, 2008 at 04:48:48PM +0200, Vladimir Koutny wrote:
>> Due to the fact that we (still) keep old BSS information, we can end
>> up switching between 2 or more BSSIDs when in IBSS (these are the
>> BSSIDs of networks with the same name we've seen before, even if they
>> are not around anymore). This switching happens in 30sec intervals
>> (IBSS merge attempt when no active STAs are around).
>>
>> This patch expires old BSS entries after IEEE80211_SCAN_RESULT_EXPIRE
>> seconds (the same time after it will not be reported in scan results)
>> when trying to merge.
>>
>> Signed-off-by: Vladimir Koutny <vlado@ksp.sk>
>=20
> This seems like a good thing to do, but the sta_bss_list is used in STA=

> mode too.  Perhaps we should find a time to run ieee80211_bss_expire
> in STA mode as well?

Yes, probably. Any suggestions for a suitable place? (I'm not that
familiar with the code..) It should probably be done on some timer (and
probably also right before we try to associate?)..


>> +static void ieee80211_bss_expire(struct net_device *dev, unsigned lon=
g exp_time)
>=20
> You probably want this positioned before (or
> after?) ieee80211_rx_bss_free, and change the name to match.

OK, moved and renamed to ieee80211_rx_bss_expire.


>> @@ -3662,8 +3662,10 @@ static int ieee80211_sta_find_ibss(struct net_d=
evice *dev,
>>  	spin_unlock_bh(&local->sta_bss_lock);
>>
>>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
>> -	printk(KERN_DEBUG "   sta_find_ibss: selected %s current "
>> -	       "%s\n", print_mac(mac, bssid), print_mac(mac2, ifsta->bssid))=
;
>> +	if (found)
>> +		printk(KERN_DEBUG "   sta_find_ibss: selected %s current "
>> +		       "%s\n", print_mac(mac, bssid),
>> +		       print_mac(mac2, ifsta->bssid));
>>  #endif /* CONFIG_MAC80211_IBSS_DEBUG */
>>  	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) !=3D 0 &&
>>  	    (bss =3D ieee80211_rx_bss_get(dev, bssid,
>=20
> Should the last hunk be a different patch?

Oops - I've found this out at the same time I was doing the rest and
I kept it in the same patch.. I'll split this.

Vladimir

>=20
> John



--------------enigB2143141FBA987B07EE0B6AC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iJwEAQECAAYFAkhs2UMACgkQutgEj9ZLuzTKZgP8C8y+kO/LNydto3y3ZoddERrg
utFjl+2ueYxrMV96zRP68CH4zT0tESuMQW5enB+MORVArPlY6Le/YK8DuuNkJPWG
Kdy9XAo5ejJwzv1xmvgL5pq5VlicRH9t/l0kRhic4F+hqsqF0ewyXy5PAElFE31/
ryl5GA6xxLYNc0OLxrk=
=l0+Q
-----END PGP SIGNATURE-----

--------------enigB2143141FBA987B07EE0B6AC--
