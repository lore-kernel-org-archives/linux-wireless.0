Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from daemonizer.de ([178.77.74.210]:51553 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964794Ab3GLMzq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 08:55:46 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: brcm80211-dev-list@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: Poor wireless reception on BCM4313
Date: Fri, 12 Jul 2013 14:55:33 +0200
Message-ID: <30534146.LWDmOHhHCG@eisbaer> (sfid-20130712_145549_836386_D1C79BEF)
In-Reply-To: <1624172.s6pnfBcJL7@fuchs>
References: <1624172.s6pnfBcJL7@fuchs>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1694392.91f12hcUQB"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1694392.91f12hcUQB
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 21 June 2013 20:26:25 Maximilian Engelhardt wrote:
> Hello developers,
> 
> I'm having problems with the reception performance of my BCM4313 wireless
> card. The card is basically working fine, but the reception is quite bad
> compared to other wifi equipment. I first suspected a hardware problem, but
> after I tried Windows 7 with the same hardware and having no problem there
> I'm quite sure this is a software issue.
> 
> 
> Here is a more detailed explanation of a test setup I performed to show the
> problem:
> 
> I have an AP in about 2m distance and I connected to it by my BCM4313 card
> and by a USB dongle (TP-Link TL-WN821N, using ath9k_htc). Both connections
> work and I can ping the AP using both cards.
> 
> iw dev $DEV link shows a signal of about -68 dBm for the broadcom card and
> about -51 dBm for the atheros dongle. I have no idea in how far one can
> trust these values, but the difference between these two cards mostly seems
> to be 20-30 dB, also in my further experiments (greater distance from the
> AP).
> 
> Now with both dongles being connected I move my laptop away from the AP and
> of course the signal is getting weaker. However at some point the broadcom
> card looses the connection to the AP while the USB dongle still has good
> connection (at this point the signal strength of the broadcom card is about
> -90dBm and -60dBm for the USB dongle). In my test with the Windows driver
> at that point the connection was still good and maximum distance till I
> lost the connection was much larger. So I don't think is a hardware
> problem.
> 
> In general I can say my BCM4313 card is only usable when I'm in vicinity of
> the AP. If I move further away the connection becomes unusable slow or is
> lost, while it is still working well using other cards/drivers.
> 
> 
> I'm currently using a 3.10-rc5 kernel with Debian jessie (kernel is from
> experimental, but the same behavior has been there with kernel 3.9, 3.8 (and
> older)). The driver used for the broadcom card is brcmsmac.
> 
> 
> I did a search non the Internet regarding this issue and found some other
> people having the same problem but no real solution to this. There is a
> workaround some Ubuntu related sites, which consists of blacklisting the
> brcmsmac driver and installing the wl driver. With the wl driver this
> problem seems to be fixed according to the web (I didn't try it myself).
> 
> As I have no idea where this problem could be and how I can debug it, so I'm
> writing this mail now. If you need any addition information I'm happy to
> provide it.
> From the numbers shown above it seems like there is an attenuator of 20-30dB
> active on the receiver of the broadcom card.
> 
[...]


Hello,

Is there any progress on this issue?
Here are the results of some additional test I performed.


I set up a AP (11g) and connected two client to it. The clients were my 
bcm4313 wireless card and the TP-Link TL-WN821N USB dongle which was connected 
to the laptop with the broadcom card. I connected both cards to the AP. The 
distance between the cards and the AP was about 3m.
Then I set up another wireless card (TP-WN722N) in monitor mode about 3m away 
from the AP and about 3m away from the laptop with the two wireless cards. 
This card was connected to a different PC and I captured the data of the 
clients and the AP. I then had a look at the reported SSI. You can see my 
measured results below:

SSI for packets from the AP:              -27 to -23dBm
SSI for packets from client1 (broadcom):  -20 to -14dBm
SSI for packets from client2 (atheros):   -40 to -38dBm

The received signal from the broadcom card were quite strong. The signal from 
the AP was a bit weaker. Interestingly the signal from the second card was 
noticeably weaker. I didn't investigate any further as I wanted to know how 
the broadcom cards performs in transmitting. So for me transmitting power 
seems to be fine with the broadcom card. My guess for the weaker signal from 
the 2nd client is ether some active power saving or different propagation 
conditions.

Here are the reported signal strength from the clients (while being connected 
to the AP):
client1 (broadcom): -74 to -75dBm
client2 (atheros):  -44 to -42dBm


So for me this test shows that the card only seems to have problems on 
receiving packets, transmitting seems to work fine.



Additionally I performed a test with the wl driver. I booted an ubuntu live CD 
and installed the wl driver there. Then I connected to my AP using this driver 
and tested reception. Everything looked like it was supposed to work. After 
connecting to the AP I got a reported signal strength of about -38dBm. I then 
moved away from the AP and was still able to get good connection where before 
I wasn't able to get any connection at all using the brcmsmac driver.



Please let me know if I should perform any additional tests or if you need any 
additional information.


Greetings,
Maxi
--nextPart1694392.91f12hcUQB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAABCgAGBQJR3/zKAAoJEIHqZH0kK9IVaUgP/jQfaUH7otUj0D48P+qfWvTv
ocHWD15g5+zQzT0YWzx/ZOHxccgMpZMi6pOf0TfQhShcCL+FRCHWhT0oDsbwqzr6
s4xs/56cL9WMPNvx6ZrlYJG3rs/9dRu7nUytTBCvz/YTsrgAXWgVfjv5JNnqMj89
sV9F4yuNpJPWhXAPuoZ8Fhr2cJ1XnHP6+ct2DzB2O5XNtFqeJwFMcxwNOL1mJVlJ
E4ftzv+dXrmob/HtVa0D5YKRUA5JI/84tDX2turYEgyn9v2MtRayDhhO/ClVY0Bj
hJ7B5vUsTrQlCmzXgEKNvMHvM7j8+ZmR1Qgs/D6TE8vPQ/OajmdD0O9IwCnIIjPx
ocu/eLcinyPcYCH6oq7TL56GkyjI7vFadr3BYLiag/5Hln+sgJJv9CINlYwUz91h
G3gH/mCZyq2JXh5vLoD5vlY3173p+hxCzvOYMdLWtXTkn/unPEv6X0U+ivfqcRHU
KOx70KJpeS1v76/Xv9tUojeQNEYx7hT0pfvYmysfsAiYueM/IWgHbARQXk1fDfZ2
xnabYrtG0l94A9E6ZyDKVBy+nSf0D7VEeAi5JIOGS0CSI7fBfXykq7sbQEkSj3Va
G4hpfDLo1b6soUZEVDU/SMokgOWU/wnq8lqA9xo6mDoF53zrSDQOM/RNraWAYcOy
pYPgbDLZv+ima7cGOGOF
=V0gY
-----END PGP SIGNATURE-----

--nextPart1694392.91f12hcUQB--

