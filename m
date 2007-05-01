Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:53053 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423544AbXEAKlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 06:41:49 -0400
Message-ID: <4637195E.5050907@web.de>
Date: Tue, 01 May 2007 12:41:34 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>, Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: d80211: How does TX flow control work?
References: <459A5945.80909@web.de>	 <20070103185203.2754e059@griffin.suse.cz>	<459BF179.6000906@web.de>	 <20070103191853.4f440b8b@griffin.suse.cz> <459BFB05.9040608@web.de>	 <45A03825.9080807@web.de>  <45A2A728.1070404@web.de> <1175029130.5151.6.camel@johannes.berg> <460B7CAA.4020604@web.de>
In-Reply-To: <460B7CAA.4020604@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2EC53E854B1A786C1C55FD77"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2EC53E854B1A786C1C55FD77
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Jan Kiszka wrote:
> Johannes Berg wrote:
>>> The actual problem was meanwhile identified: shorewall happened to
>>> overwrite the queueing discipline of wmaster0 with pfifo_fast. I foun=
d
>>> the magic knob to tell shorewall to no longer do this (at least until=
 I
>>> want to manage traffic control that way...), but I still wonder if it=
 is
>>> an acceptable situation. Currently, the user can intentionally or
>>> accidentally screw up the stack this way.
>> I don't seem to be able to do that:
>>
>> # tc qdisc change dev wmaster0 pfifo
>> RTNETLINK answers: Invalid argument
>>
>> # tc qdisc replace dev wmaster0 pfifo
>> RTNETLINK answers: Invalid argument
>>
>> what exactly does shorewall do?
>>
>=20
> Don't recall... need to re-test... lacking time. :(
>=20
> Just one note: I observed this on a 2.6.19 kernel - in case there is a
> difference to the latest.
>=20

Now I came across this issue once again. It is still present, I just
observed it over the latest rt2x00 tree after updating shorewall and
forgetting to fix its config.

I redirected tc to some logging filter, and this is what shorewall does
when "CLEAR_TC=3DYes" is set in shorewall.conf:

=2E..
tc qdisc del dev wmaster0 root
tc qdisc del dev wmaster0 ingress
tc qdisc del dev wlan0 root
tc qdisc del dev wlan0 ingress

HTH,
Jan


--------------enig2EC53E854B1A786C1C55FD77
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGNxliniDOoMHTA+kRAgBtAJ9kjIeL1cHPbcyHrlcb5xSVQNPEhgCfWAKW
EnA1Hz+Ew57EISnzggF+2P0=
=F3W4
-----END PGP SIGNATURE-----

--------------enig2EC53E854B1A786C1C55FD77--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
