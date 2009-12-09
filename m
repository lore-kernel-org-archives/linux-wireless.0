Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:37231 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbZLINMp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 08:12:45 -0500
From: =?windows-1252?q?Luk=E1=9A_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 4/4] ath5k: Implement mac80211 callback set_coverage
Date: Wed, 9 Dec 2009 14:12:44 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net> <200912090216.09816.8an@praha12.net> <4B1F01D4.6020803@openwrt.org>
In-Reply-To: <4B1F01D4.6020803@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1545867.zBQFUhueFg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912091412.47689.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1545867.zBQFUhueFg
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 9.12.2009 02:48 Felix Fietkau wrote:
> Twice the propagation time (in microseconds) for a signal to cross the
> maximum distance between the most distant allowable STAs that are slot
> synchronized.
Oh, I missed that... And maybe I'm starting to understand it: the slots are=
 in=20
fact some kind of clock synchronization, recipient gets synchronized with a=
=20
one-way delay, and then when there's a transmit in the other direction,=20
another one-way delay is added to the "clock".

Unfortunately using this calculation makes us incompatible with FreeBSD and=
=20
madwifi-ng, however it seems current Madwifi uses the standard calculation:
http://madwifi-project.org/changeset/3977/madwifi/branches/madwifi-hal-0.10=
=2E5.6/ath/if_ath.c?format=3Ddiff&new=3D3977

And now I'm quite sure the athctrl calculation is completely wrong.
Even if it produces correct results :o)

> Some hardware internally calculates the ACK timeout based on the
> configured slot time. Broadcom does it this way.
> Maybe adjusting the ACK timeout without adjusting the slot time works,
> but it'll probably interfere with CSMA.
Ahteros is not Broadcom, it does not have a firmware, I'm writing the ACK=20
timeout directly into a register of the MAC chip. But you're suggesting wha=
t=20
I said in previus mail: we have to understand what the hardware does. And a=
s=20
there is no documentation, the only way is experiment. Most of ath5k was=20
developed this way.

> > 802.11a: 21 =B5s
> > 802.11b: 27 =B5s
> > 802.11g: 19 =B5s
>
> How did you measure it?
Just by gradually lowering the value in ACK timeout register (it's accessib=
le=20
via sysctl in FreeBSD) and testing the link using ordinary ping. When the A=
CK=20
timeout was too low, packetloss grew from 0% to 50% or so.

> I'm guessing that most hardware does have some degree of tolerance for
> timing variation. IMHO, if the standard recommends slightly higher but
> working values for the same distance, we should use that rather than
> experimentally determined limits.
The problem is, it's not slightly higher, it's twice or more higher:
aSIFSTime + aSlotTime + aPHY-RX-START-Delay is 50 in 802.11a mode, while th=
e=20
default ACK timeout for 802.11a used in ath5k initialisation is 25. And in=
=20
802.11b the aPHY-RX-START-Delay alone is defined as 192 =B5s, while the def=
ault=20
used by ath5k is 48.

I looked into the current Madwifi sources again, and found they use only
aSIFSTime + aSlotTime as ACK timeout. That's 25 for 11a, 30 for 11b and 19 =
for=20
11g, so it's in line with my experimental observations and also the 11a ath=
5k=20
default. Probably the hardware accounts for aPHY-RX-START-Delay itself (it'=
s=20
PHY value, while ACK timeout is MAC chip register).

So, what do you think about using the formula from Madwifi?

Lukas Turek

--nextPart1545867.zBQFUhueFg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLH6JPAAoJEEBjvk/UOfYwnfMQAMBrQeOrzBhaepkJarzI0hGW
NwGLxOT5R2GOyEVe6am3nH6srBed1zXIvEb6utCnwH2L/1RqdieaZsOdNZFA7oZi
I4lHJA1MdN+W50Cai8dV0/WDuWyDSVT7CCsott4dihaImhLm5ssm/+wACnX/hNGk
mxv/KM+jV7JGvSV9y2UOeBjzkXsaROdbia5lzZqo9CWtCP0C1atseICklsBtYReK
PgPwIeRQiinm0aGvMEFNhBd/SJIlXigImMqERWKrTKyQ3URs0YXE2Prbzx0a2fFI
vbEB4BvInqx6wdGsfXjT4SLMnWPGXzRtpiUHkAaScQZzsT2QwYyOqDT+Auu/0dk+
bTTpQc/ExVJn3H8RzVATRyfiKbDdvND9Lbrd/GvwEbAJWpMWjJMTmhgEAlhBYlo7
A1z2r6L+izP/u+LN3LfwRGdPTONqYyP7iKW2fYHilRzkmXKBcHZeSwmYs9jrFAaw
7+x8DBYfEKUiyyU9BXjJgsBdZ1jgMtMFGZqxSb8w95RWiay4dPKvxf11ur7lKcSW
SAVd1x0BB7pwQb4Ha1F95XWP8qoz0gFofKv94aEwQEJEky/wnz7538Zvfz+oNSsR
/Rnth+ePojMhU+FmQog0fmldeO57M/I6JdgcSAXRHf6UOrISMRhbo20pB15JejKb
6K/w6N1CSUq37HzjtiDN
=yJCH
-----END PGP SIGNATURE-----

--nextPart1545867.zBQFUhueFg--
