Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:34471 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab2IWKEv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2012 06:04:51 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath9k-devel@lists.ath9k.org, adrian.chadd@gmail.com,
	linux-wireless@vger.kernel.org, shafi.wireless@gmail.com,
	lindner_marek@yahoo.de, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: Re: [RFC] ath9k: Work around complete stuck of hw
Date: Sun, 23 Sep 2012 12:04:47 +0200
Message-ID: <1822413.FOnaUoKYHo@sven-desktop.home.narfation.org> (sfid-20120923_120543_776939_DFDABEC0)
In-Reply-To: <5053160B.8060908@openwrt.org>
References: <50521E02.4030809@openwrt.org> <1347616045-29336-1-git-send-email-sven@narfation.org> <5053160B.8060908@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9177922.zYgzQUEvc6"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart9177922.zYgzQUEvc6
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

On Friday 14 September 2012 13:33:31 Felix Fietkau wrote:
[..]
> > ---
> > This check is currently tested. This takes quite a long time and maybe
> > someone with more knowledge of atheros devices can check whether this one
> > is completely and utterly wrong.
> > 
> > The type RESET_TYPE_FATAL_INT was chosen in this test to allow us to see
> > whether this condition was already true by reading from
> > /sys/kernel/debug/ieee80211/phy0/ath9k/reset
> 
> Your debug patch should not be silent when it resets the hw. We need
> to make sure that this bug gets fixed properly. If my patch below does
> not fix it, then at least add a WARN_ON to ensure that we don't just
> hide the bug and move on.

It is not silent for me and is not a patch that should be applied to the 
upstream kernel. Just wanted to ask whether this is the right place and 
approach

> Somebody on the openwrt-devel list pointed out that there is some code
> missing in the ar933x wmac reset function. Please try this patch (apply
> it to your kernel tree):

Neither mine nor your patch has an effect. One node is now again dead after ~8 
1/2 days. It looks like the check isn't done (correctly). I will investigate 
this further tomorrow.

Kind regards,
	Sven
--nextPart9177922.zYgzQUEvc6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQXt6/AAoJEF2HCgfBJntGaoIQALz7kfkIcc6S4pLmVc0Gl4Ez
0dah942nNq3ONPhuG8pT5E02ShBo5QY+aUV2sKqsk5u1wW5XgEAUODFS7mRViLcI
Ugt6wn0pWtTYWtkYU5IAXloMi6E9LN0f+B4SxiWtuUlvxrqFNeLbtw3ZcUS0x3xH
KWvRfo4IUSLseXGmEVh1zL8EICsPkatuM/+z5TxhUqzjRHR7wabsZtIohBinWrrs
2EeR5gieVbGqXF/8E8r378fto6q4/sTqh89mpsLWZuTzn8AZVMlKOv80J02H1bW5
MmYAZv0zZP9EHwogv8avdhQjJ7dsaWc7ABggk6PcFA/AIbPXHbPgd3EtXXWSr7cQ
UEePdNH8DLZsvtsHC4yFquVbvgAS6V1yfA48QTaVC3VUNo1U7hc1esRwf5MWtrga
hRLOvl+hiCwidvKRu+zIoYuTp6/n4MaKEBHpEuhniBKNV7u9G/sAdGZnEgw5m8RR
HHpBdKryArnPGlNII2k8Zn3NjjSRCIlqXmXHZg889m8z0us7vBvv+yY4luQdmnqf
iN7QOnnuCwN3wMXgDUB6gGRf3CX6gIeG/ijBkcVYurh/PYIMSRlC3I6ohOJ/8A7L
Q3ALg/lJlEMdxkwVvo2YGJl9i4D0xlZpnyGV2ci5b8TUtzInTMjak5YvzkxqjWeH
QxrNU+jHutIL+L1wJ0sK
=MAis
-----END PGP SIGNATURE-----

--nextPart9177922.zYgzQUEvc6--

