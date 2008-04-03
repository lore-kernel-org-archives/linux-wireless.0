Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:35665 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbYDCP5r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 11:57:47 -0400
Message-ID: <47F4FE6D.2000307@work.ksp.sk> (sfid-20080403_165752_683171_38D6FBED)
Date: Thu, 03 Apr 2008 17:57:33 +0200
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	Bill Moss <bmoss@CLEMSON.EDU>, Daniel Drake <dsd@gentoo.org>,
	Dan Williams <dcbw@redhat.com>,
	Tomas Winkler <tomasw@gmail.com>
Subject: Re: mac80211 MLME scanning - BSS list trouble
References: <1206865999.22530.187.camel@johannes.berg> <20080331200536.GA13799@tuxdriver.com>
In-Reply-To: <20080331200536.GA13799@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA0293F35FD1D7FE00B5E95A9"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA0293F35FD1D7FE00B5E95A9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

John W. Linville wrote:
> On Sun, Mar 30, 2008 at 10:33:19AM +0200, Johannes Berg wrote:
>=20
>> The first one is that there is no actual expiration of BSS structs. Ea=
ch
>> BSS struct has a 'last_update' member that contains (in jiffies) the
>> time this item was last updated. This means that we accumulate BSS
>> information forever, but due to the 'last_update' only the last few
>> items will be returned to the user on asking for a scan result. This
>> obviously has problems since a rogue station could bombard us with fak=
e
>> probe responses and cause us to build a huge BSS list which is never
>> again freed until the hardware is deregistered. This will need to be
>> fixed, of course.
>=20
> Assuming this was fixed, does the rest of this issue go away?
> It seems like it would.

I can just add another bug this is causing, this time for IBSS.

The scenario:
- you happen to have 2 IBSS entries for the same SSID/different BSSID (bo=
th
  of them inactive at this time; this can happen e.g. with IBSS merge),
- you start new IBSS with the same SSID,
- there is no other IBSS station with this SSID around.

In this case, the stack will end up using those 2 BSSIDs alternately, in =
30sec
intervals. The reason is that since there is no other active IBSS STA, it=
 will
look at its BSS list and adopts the BSSID (and other params) of first mat=
ching
IBSS that is different to current one (or triggers a new scan, which will=
 never
happen in this scenario; see ieee80211_sta_find_ibss).

This seems to be fine when BSS list expiration is fixed, though (with tim=
eout
of less than 30s (IEEE80211_IBSS_MERGE_INTERVAL)).

Vlado


--------------enigA0293F35FD1D7FE00B5E95A9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQCVAwUBR/T+bbrYBI/WS7s0AQIRWQQAxIHT+G0vhqbsxP5SMMifKDn+W+6HGhrc
hVaJwxEsw4BtA2FgLDt/mTIwMRomg4ZL3eoIBivfLZ6OpzVsfk6doV/k1XTiF11P
cbo6lO72NisQUNL/r2FenTzGTyOChg+9yFMR5lxYRSgrtE0UUeBBy2Wokhh3v75i
a7vpDdynuM4=
=8GVa
-----END PGP SIGNATURE-----

--------------enigA0293F35FD1D7FE00B5E95A9--
