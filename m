Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:9313 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZDGCDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 22:03:00 -0400
Received: by ey-out-2122.google.com with SMTP id 4so583048eyf.37
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2009 19:02:57 -0700 (PDT)
Message-ID: <49DAB445.7040206@gmail.com> (sfid-20090407_040310_628429_F7D9312F)
Date: Mon, 06 Apr 2009 22:02:45 -0400
From: Will Keaney <keaneyw@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Trouble Associating with ath5k on AR5212
References: <49D4C7B3.7010803@gmail.com> <b6c5339f0904020805w5e210c2bl542eadb20ac5d6c7@mail.gmail.com> <49D56445.20502@gmail.com> <20090403020358.GA12406@hash.localnet> <49D571BB.7060406@gmail.com> <20090403122332.GA14853@hash.localnet> <49D6117D.9020408@gmail.com>
In-Reply-To: <49D6117D.9020408@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF80D7420688FBA40B41BD0C4"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF80D7420688FBA40B41BD0C4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Will Keaney wrote:
> Bob Copeland wrote:
>  =20
>> On Thu, Apr 02, 2009 at 10:17:31PM -0400, Will Keaney wrote:
>>  =20
>>    =20
>>> dmesg shows this:
>>> [38645.639170] ath5k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -=
>
>>> IRQ 17
>>> [38645.639199] ath5k 0000:03:00.0: setting latency timer to 64
>>> [38645.639342] ath5k 0000:03:00.0: registered as 'phy5'
>>> [38645.872038] phy5: Selected rate control algorithm 'minstrel'
>>> [38645.882037] Registered led device: ath5k-phy5::rx
>>> [38645.882090] Registered led device: ath5k-phy5::tx
>>> [38645.882097] ath5k phy5: Atheros AR5414 chip found (MAC: 0xa3, PHY:=
 0x61)
>>> [38646.133614] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>>> [38667.211026] ath5k phy5: noise floor calibration timeout (5785MHz)
>>>
>>> I think the key there is the last line.  There is no further output i=
n
>>> dmesg, regardless of what I do in wpa_supplicant.
>>>    =20
>>>      =20
>> Probably a red herring, actually -- but yeah, you should be seeing mor=
e
>> output as the association process continues.  That is a pretty frequen=
t
>> and harmless error message, here you are scanning and just changed to
>> a 5.7 ghz channel for a passive scan.
>>
>> Are you getting any results at all from scans?  Is ath5k using 100% of=

>> any cpu?
>>  =20
>>    =20
> I do get some results on scans, but not as many as with madwifi.  Also,=

> it reports dramatically different signal strengths than madwifi (though=

> this may be because madwifi sets my maximun Tx power to 17dBm, and ath5=
k
> sets it to 20).
> I don't see any untoward CPU usage when ath5k is loaded.  wpa_supplican=
t
> uses about 40% on one core, give or take.
>  =20
Following up on our conversation in IRC, I found a few other nearby
networks where I could get stronger signal.
ath5k showed much higher signal strengths for all of the networks it
could see than madwifi did.  Although ath5k showed a particular network
with strength between 16-29 dBm, it was unable to connect.
madwifi showed the same network with a strength of 4 dBm, and was able
to connect almost instantly.
As before, I didn't see any additional dmesg output from athk, even with
'dmesg -n7'.

Will



--------------enigF80D7420688FBA40B41BD0C4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknatEoACgkQjfayWCA8dDGAuQCeNcXPiU9XkYxFVrCLGV85V+pj
EWAAoIQGQ3Vn9zK+G/Uc06cDydwVsEXg
=Zu5c
-----END PGP SIGNATURE-----

--------------enigF80D7420688FBA40B41BD0C4--
