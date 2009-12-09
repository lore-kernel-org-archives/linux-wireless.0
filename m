Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:38385 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967058AbZLIBQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 20:16:06 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 4/4] ath5k: Implement mac80211 callback set_coverage
Date: Wed, 9 Dec 2009 02:15:47 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net> <200912062123.13098.8an@praha12.net> <4B1CCF51.2040304@openwrt.org>
In-Reply-To: <4B1CCF51.2040304@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1461022.2UEqoP7g2A";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912090216.09816.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1461022.2UEqoP7g2A
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 7.12.2009 10:48 you wrote:
> ACKTimeout is:  aSIFSTime + aSlotTime + aPHY-RX-START-Delay
802.11a uses SIFS of 16 =C2=B5s and 9 =C2=B5s slot time, that's 25 =C2=B5s =
in total. However,=20
the athctrl calculation uses 21 =C2=B5s ACK timeout for zero distance. And =
I know=20
the result is correct, as we are using it on 70 links with distances varyin=
g=20
between 100m and 8km.

I don't say the standard is wrong, just that the hardware might start count=
ing=20
at a different moment than the standard assumes.

> Of course, the distance settting code in iw probably also needs
> changing, as it needs to accomodate for aAirPropagationTime being the
> round trip time, not one-way.
Well, according to my interpretation the aAirPropagationTime is the one-way=
=20
delay. I think it makes sense when we consider the reason the slots are use=
d=20
in CSMA/CA:

Station waits a random number of slots. If no other station was transmittin=
g=20
at the beginning of a previous slot, the station starts its own transmit. S=
o=20
the slot time has to be at least the time needed to switch the radio from R=
X=20
to TX plus the one-way propagation delay, so that every other station can=20
hear the medium is busy on time.


Anyway, I think there's only one sure way to determine the correct base ACK=
=20
timeout for different modes: experiment. It's easy to detect that the ACK=20
timeout is too low - packetloss grows dramatically.

The main observation is this: ACK timeout does not depend on slot time!
In retrospect it makes sense: station waits only SIFS before sending ACK, n=
ot=20
a single slot.

The measured values of minimum slot times (with AR5212 and AR5414) are thes=
e:

802.11a: 21 =C2=B5s
802.11b: 27 =C2=B5s
802.11g: 19 =C2=B5s

I can't give much explanation, the difference of 6 =C2=B5s between 11a and =
11b=20
might be the difference of SIFS (16=C2=B5s vs. 10=C2=B5s). 11g uses 10 =C2=
=B5s SIFS too, but=20
with additional 6 =C2=B5s "signal extension", maybe that's why the value is=
 closer=20
to 11a than 11b. It's all just guessing, though.

So I propose to use 21 =C2=B5s in 802.11a mode and 27 =C2=B5s in 802.11b/g =
mode (as=20
there might be some 802.11b clients and 6=C2=B5s won't make much difference=
).
What do you think?

Lukas Turek

--nextPart1461022.2UEqoP7g2A
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLHvpZAAoJEEBjvk/UOfYwRGAQAL68B5Fwh9SWoEzX3QDHz9pC
ReJHFDX64qfpaow5uprYGnbc5bhBO3EOiAFz/V0mKH9J7tjnZgsp9IJrh95O/MP+
3++Haq57iEFDRqHwmzhvJG5mgDPvg/fCAWb/jvoTzwsJkw4M9tV5jFu5TEOJJiSP
GP8z6DdwYwPCrNMmS0agrGY4v2x1xTgZP87uYqRd+QRVFAAKUvHtYySboxJQ45l/
4phLbJWdZx8hOPX7Jci6gyArB7rIE/kk+pfBkedc0gYYzwi4rHUTJY6xqzq71suJ
ZWN5RlQx4jcYbF0R7TQ6XEDhZGFZuk7PclllnLcfNWnbg9IW194LSeBHuXfALe9R
ErQurHlPYgah2HxrtSIytE+wDrFql6vvhL+qa7ZJHhUp7dDaPGLuhiKuY0LPSlFD
KIiyhtmBR2xcsGOmxoIVHW7qZO/gpSPBW/DdVzD87wQ1IjzIMT21rMM3xVfRF+Z2
vrRm3HCNfD3qz4Ygpj/VHQTHoZl0QraRkXQyGpicLKpRDuPR2exn5mfU51kPJssy
8HMONEN4HAWoIQLvghKVlRjF3nbWHAuHSnkEdRrRamP0IhXgsXD0WSy2JzsEAtRJ
e97x7zdUP/t/mLvCbR476xNkcrCAgGXODbrsl8mIB8WLRspI9+JqDSbe7wKtpKw2
ToFhM5krjp1dV4DHj8F7
=/pAJ
-----END PGP SIGNATURE-----

--nextPart1461022.2UEqoP7g2A--
