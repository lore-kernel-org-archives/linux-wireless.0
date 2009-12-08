Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:51232 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966334AbZLHVvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 16:51:49 -0500
Message-ID: <4B1ECA75.3070403@web.de>
Date: Tue, 08 Dec 2009 22:51:49 +0100
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT] ar9170: AP broadcast buffering
References: <200911290206.07784.chunkeey@googlemail.com> <4B1BF68D.8060907@web.de> <200912071736.40929.chunkeey@googlemail.com>
In-Reply-To: <200912071736.40929.chunkeey@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB366CD563DA0AF96ECEB0520"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB366CD563DA0AF96ECEB0520
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Christian Lamparter wrote:
> On Sunday 06 December 2009 19:23:09 Jan Kiszka wrote:
>> Christian Lamparter wrote:
>>> This patch should fix "broadcast traffic before DTIM beacon",
>>> But there is a downside: the broadcast (e.g arp) frames
>>> might get delayed and won't make it in time.
>>>
>>> let me know, if this patch does any good, or not...
>> Mmm, how is this supposed to work?
> The driver sets the PRETBTT interval and the HW will trigger
> the PRETBTT event. Which will tell the driver to update the beacon,
> which _in turn_ triggers the BCN_CFG event and the buffered
> BC frames are _released_ into the queues.

When is that PRETBTT signaled, on every beacon or only on DTIM beacons?
If on the former, I do not see yet where the code filters for the latter.=


>=20
> Now the problem is that under traffic the BC/MC frames might
> be delayed in the tx_pending queues and don't make it in time.

I don't think it's the right long-term solution to let such
time-critical jobs be done by the host as long as the controller is
capable of handling it more accurately.

>=20
>> I still haven't started hacking on this as well, but I read a bit
>> about DTIM.
>> One thing I think to have understood is that the DTIM interval is typi=
cally
>> larger than the beacon interval. There is even some interrupt on ar917=
0
>> indicating this event, it's just not enabled yet.
> Na, I _think_ that BIT is meant for the PS/station mode and
> is used to say to the fw/driver to stay alert for incoming
> broadcast/multicast data.

Likely. But maybe it also signals the that this period has started so
that the controller can send out the corresponding frames. Otherwise it
had to process every beacon interrupt to filter for DTIM.

>=20
> If this really is the case, then I'm afraid to say:
> the bit is probably for little use in this situation.=20
>> Moreover, I do not yet understand how deferring multicast frames works=

>> in this patch. How are they filtered out from normal frames and queued=

>> until the beacon event? (But that misunderstanding might be due to the=

>> fact that I haven't read the whole driver code yet.)
> ar9170 does not have a "Content After Beacon" queue like p54 or ath5k/a=
th9k.
> But luckily the mac80211 stack provides the necessary queuing mechanism=
=2E
> And all the driver needs to do:=20
>  - set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING
>  - grab the buffered BC/MC frames and push them to the device.
>=20

Ah, I see.

> Note:
>=20
> That's the current situation. But maybe you'll be in for a big surprise=
=2E
> There is a special firmware & driver: "carl9170", which will add severa=
l
> useful features:
>  * accurate tx status feedback
>  * _CAB_ queuing in firmware
>   =3D> this should be enough to finally enable NL80211_IFTYPE_AP / MESH=
=2E
>=20
>  * multirate retry support (minstrel)
>   =3D> improve performance in suboptimal environments.
>=20
>  * Real Hardware QoS support.
>    (But unfortunately with a catch)
>=20
> I hope it will be ready for Christmas ;-)

Sounds interesting. Is it derived from ar9170-fw or written from
scratch? In any case, I'm looking forward to those improvements.

Jan


--------------enigB366CD563DA0AF96ECEB0520
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkseyngACgkQitSsb3rl5xQPaACgthrbxGHDzNOTnvB8ZAPJbUxH
C64AnRcshsa0UmvCwNPnH2R5YXTg6rda
=F1J4
-----END PGP SIGNATURE-----

--------------enigB366CD563DA0AF96ECEB0520--
