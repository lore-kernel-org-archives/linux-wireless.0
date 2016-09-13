Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:50932 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754071AbcIMMaP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 08:30:15 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: ath10k mesh + ap + encryption?
Date: Tue, 13 Sep 2016 14:30:07 +0200
Message-ID: <3247815.ey5ZWkP5uX@prime> (sfid-20160913_143023_507698_FDC9A7DB)
In-Reply-To: <87d1k8jb34.fsf@kamboji.qca.qualcomm.com>
References: <2661831.slnB0LOeVt@prime> <15353347.MUgkgiNHdu@prime> <87d1k8jb34.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2495314.WmS40FRLRn"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2495314.WmS40FRLRn
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday, September 13, 2016 11:25:21 AM CEST Valo, Kalle wrote:
> Simon Wunderlich <sw@simonwunderlich.de> writes:
> > On Tuesday, September 13, 2016 10:59:31 AM CEST Valo, Kalle wrote:
> >> Simon Wunderlich <sw@simonwunderlich.de> writes:
> >> > we have done some experiments last week on ath10k, trying to run mesh
> >> > (802.11s) and access point at the same time, both encrypted.
> >> > 
> >> > We have tested a recent LEDE (reboot-1519-g42f559e) but with
> >> > firmware-5.bin_10.2.4.70.42-2 and the included wpa_supplicant, which
> >> > gave
> >> > us a working encrypted 802.11s network. However, starting an AP at the
> >> > same time didn't work (AP doesn't beacon). This wasn't a problem when
> >> > 802.11s was running unencrypted.
> >> > 
> >> > We also tested version 10.2.4.97 (from codeaurora), which is now
> >> > default
> >> > in
> >> > LEDE. However, this version apparently doesn't support 11s mesh at all
> >> > (WMI_SERVICE_MESH_11S is disabled in the service map, but cfg/mac80211
> >> > advertises support).
> >> > 
> >> > So here are my questions:
> >> >  * Did anyone succesfully run AP and mesh, both encrypted at the same
> >> >  time?
> >> >  * Do you have any pointers how we could fix this? Could it be fixable
> >> >  in
> >> >  the>
> >> > 
> >> > driver (i.e. not in firmware)?
> >> > 
> >> >  * Does anyone have an idea if 11s will be supported in future
> >> >  versions? I
> >> > 
> >> > didn't find any changelogs, but having 11s mode no longer in the
> >> > service
> >> > map does not make me optimistic.
> >> 
> >> Why is LEDE using 10.2.4.97? It seems to be a quite old release and I
> >> have no knowledge if anyone even tests that firmware branch with ath10k.
> >> I recommend to only use firmware releases from ath10k-firmware.git as we
> >> use those internally with ath10k. In any case, don't make any
> >> assumptions about future from that firmware branch as it's so old.
> > 
> > This was introduced in December 25th, 2015 after some firmware-related
> > problems. I'm CC'ing Martin Blumenstingl who suggested this change.
> > 
> > Since then, ath10k is pulling firmware from here (unless ct firmware is
> > used):
> > 
> > https://source.codeaurora.org/quic/qsdk/oss/firmware/ath10k-firmware/plain
> > /
> > 10.2.4/firmware-5.bin_10.2.4.97-1
> > 
> > However, I don't understand the numbering? 10.2.4.97 > 10.2.4.70, but you
> > say 10.2.4.70.42-2 is more recent? I would have assumed otherwise from
> > the numbers. However, 10.2.4.70 has much more sub-revisions.
> 
> As I said before, I just deliver the firmware files to the community and
> the firmware team creates the actual releases. But my understanding is
> that these are from different branches which are built independently
> (and might have different features, like in this case the mesh support)
> so I would not make any conclusions if any firmware is "better" just
> from the numbers alone.

you are right ... those numbers are not a good pointer. I found this repo, and 
from the checkin dates it looks like 10.2.4.97 is indeed way older (from 
September 2015) than 10.2.4.70.42 (April 2016):

https://source.codeaurora.org/quic/qsdk/oss/firmware/ath10k-firmware/log/10.2.4

I would agree that Changelogs would be helpful.

Thanks for the clarification. We will then stick to the 70's branch then.

Does anyone have pointers for the other questions? :) I would believe hat many 
people would be interested in running AP + Mesh encrypted at the same time (at 
least in the open source community ...).

Thanks,
      Simon
--nextPart2495314.WmS40FRLRn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJX1/FPAAoJEKEr45hCkp6h2zYP/02lLJ8+oBTfl0Ya3hTVTPl+
nu8RcSJTXgz6smYlvq/LBPQi6+/y9mWhXa8pjvCqrWWuUNdLh6/9EH+DuN45mJFm
yRMHZO4G5MNDyhk97bsXSwMJkb1Yn4mWmuArT6h2fDaZfjtz0io4eYtM8hVIGzha
v+QJq+bLrGh5Jh90lJ39FHF4XbY789SjkzTcYfpmyaMncjATEAE3UO/39e/+yJ2J
tYMKRZiqzjWeNWpEEC6q7ONIVtSCVEeESS9qGa+qEZE/p634l9rppSc1/BvcCYw8
keUQNL8D5D5w7aiqXi9sM1Sqj50P6GxzKnBlW0V6pFy2i6W4zMnR8SKW4bEJKTIL
BTVL5IBJZgHqGavnACQbku3nYCVHTKOEFGNyBYqvwbbGVfFPx5JBgSucZU/XxGBt
gZHEx06k1FFduV4c3KpEIUBBPx2g7t3saU3LkeywG8pNOXmFHZyMgy4PxmPQuqTo
Ldi89IOp8eSIjGZeKTqGAayXswsAOavrv7vosZGjRRkiHE5e5LDH8Wux/5s68HaB
c7/nWO6SS5lqcq65wN2KqGqDhHCzz/xANJKgbAP1hFob22WaFINAC4HTyiWwpnxh
HGanxH4agM2vFO2G7Do0jG43pSipvvMf7KDRrX9wqmSBOXlI3T7FTlzSmU+JvZZU
39xIZZRyw5I1GIYOJlc5
=2RLc
-----END PGP SIGNATURE-----

--nextPart2495314.WmS40FRLRn--
