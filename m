Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4-g19.free.fr ([212.27.42.30]:52238 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbYKYTq2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 14:46:28 -0500
Message-ID: <492C55FC.2040506@free.fr> (sfid-20081125_204632_764631_ED4A6B57)
Date: Tue, 25 Nov 2008 20:46:04 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
	Derek Smithies <derek@indranet.co.nz>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
	wally@theblackmoor.net, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath5k-devel] Unusually low speeds with ath5k and iwl3945
References: <492719ED.5000006@gmail.com> <20081122005240.GA27826@hash.localnet>	<alpine.DEB.2.00.0811221643030.7067@monster> <4927FC0C.10900@gmail.com> <492A5913.3070007@free.fr> <492A7733.2000205@openwrt.org>
In-Reply-To: <492A7733.2000205@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

=46elix Fietkau a =E9crit :
> While reading the code for calculating the frame duration, i noticed
> something odd: It doesn't seem to be taking into account the short
> vs long preamble distinction for ERP rates. IMHO this might be causin=
g
> issues like this. I've seen similar behaviour a long time ago when te=
sting
> iwl3945 against a Broadcom AP with exactly the same throughput drop (=
500-
> 600 kbits/s).
> When I analyzed the problem with an extra monitor mode card, I found =
out
> that the throughput drop is caused by a huge number of retransmission=
s,

In the test I've done, there was no retransmission at all (no
duplicates). I don't save a capture file, so I cannot tell for sure.

What is the code computing frame duration you are referring to? How it
could affect the hardware behavior?

> and if I remember correctly (I didn't look for this specifically back=
 then),
> the retransmissions went down the rate scaling table until they hit t=
he
> first non-ERP rate and that one worked on the first try.
>=20
> Johannes, does that sound like a probable cause? If so, it should be =
easy
> to fix.
>=20
> - Felix
>=20

Regards,
Benoit
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJLFX8OR6EySwP7oIRAp2pAJ0batdz64sh9L82CIKzkmVcLyANygCeOq5q
D18DQ/Ko9ggdGn5lmshlMJs=3D
=3D3efH
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
