Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:33720 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbYD2QBe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2008 12:01:34 -0400
Received: from 92-60-53-2.rev.bonet.sk ([92.60.53.2] helo=[192.168.1.2])
	by element.ksp.sk with esmtpa (Exim 4.69)
	(envelope-from <vlado@work.ksp.sk>)
	id 1JqsGp-0005hJ-QC
	for linux-wireless@vger.kernel.org; Tue, 29 Apr 2008 18:01:31 +0200
Message-ID: <48174652.6080909@work.ksp.sk> (sfid-20080429_180141_582175_8C7B6399)
Date: Tue, 29 Apr 2008 18:01:22 +0200
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC] WARNING: at net/mac80211/ieee80211_rate.h:159 rate_lowest_index()
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFAB6D9AA882568FD2E8B8D26"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFAB6D9AA882568FD2E8B8D26
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,
the warning in $subj can pop up in the following scenario:

- iwconfig wlan0 mode ad-hoc; ifconfig wlan0 up
- a frame arrives from an unknown station which triggers
  ieee80211_ibss_sta_add() (called from prepare_for_handlers())

In this case, we create a new sta entry, fill in supp_rates field,
initialize rate_control algo, and insert this sta entry into the list.

The problem is the assignment for supp_rates:

sta->supp_rates[local->hw.conf.channel->band] =3D
	sdata->u.sta.supp_rates_bits[local->hw.conf.channel->band];

because sdata->u.sta.supp_rates_bits is set only when we actually
join an ibss, which is not the case in this scenario; so we assign
zero here. Then, the code in rate_control_pid_rate_init() calls
rate_lowest_index() for some reason, and since no supported rate is
found, this warning is issued.


The question is how sta->supp_rates should be initialized:

- we could initialize it to our sta's rates, but then we could
  probably transmit to a station at unsupported rate

- add new ibss station only on received beacon, not on a data frame;
  currently, beacons are ignored for this purpose (they just update
  the bss list later on)

- something else (like 1Mbps only)?

As soon as we do sta_join_ibss(), this warning won't happen again.


Note that once we have sta entry (in our ibss), we will update its
supported rates based on beacons it sends (in rx_bss_info()).

Any thoughts?

Regards,
  Vlado


--------------enigFAB6D9AA882568FD2E8B8D26
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQCVAwUBSBdGW7rYBI/WS7s0AQKe8gP/YMqKhkp1jM+BM8A0vDLARuY3LXVQhh2s
ZFu6CzQ66cqmv90x1ZUIxb+lHcILkUEY1T42/yDFYXf7xOeA07PlmOXG1ZhxAQvs
vjPF3xN1JudaR3JgMi+SMae5qMB6Af91xOsni4koOfogMLJcDPqD+h2XciqCCCBS
jWhGE6ibnyE=
=ckUd
-----END PGP SIGNATURE-----

--------------enigFAB6D9AA882568FD2E8B8D26--
