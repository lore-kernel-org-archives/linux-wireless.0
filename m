Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6-g19.free.fr ([212.27.42.36]:50070 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYKXHeu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 02:34:50 -0500
Message-ID: <492A5913.3070007@free.fr> (sfid-20081124_083455_811898_5B9391D8)
Date: Mon, 24 Nov 2008 08:34:43 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Derek Smithies <derek@indranet.co.nz>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, wally@theblackmoor.net
Subject: Re: [ath5k-devel] Unusually low speeds with ath5k and iwl3945
References: <492719ED.5000006@gmail.com> <20081122005240.GA27826@hash.localnet>	<alpine.DEB.2.00.0811221643030.7067@monster> <4927FC0C.10900@gmail.com>
In-Reply-To: <4927FC0C.10900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Maxim Levitsky a =E9crit :
> Derek Smithies wrote:
>> Hi,
>>  to verify that it is a rate control issue, there is one very simple=
 and=20
>> very practical test.
>>
>> Take both ends of your link, and set them to fixed rate, and at the =
rate=20
>> you think it should be achieving.
>> If you can achieve significantly higher throughputs with fixed rate,=
 you=20
>> know that the rate control algorithm (or interface with rate algorit=
hm)=20
>> has failed.
>>
>> Derek.
>>
>> On Fri, 21 Nov 2008, Bob Copeland wrote:
>>
>>> On Fri, Nov 21, 2008 at 10:28:29PM +0200, Maxim Levitsky wrote:
>>>> I initially blamed iwl3945, then thought it got fixed, but now I h=
ave
>>>> ath5k, and speeds are low
>>>> and I suspect that both drivers has bugs regarding to speed.
>>> Quite possible, but both use mac80211 for rate control.  Which rate
>>> control algorithm are you using?
> Hi,
>=20
> Well, iwl3945 was showing 54M all the time in iwconfig,
> also it doesn't support setting fixed rate, at least not using iwconf=
ig.
>=20
> ath5k never shows higher that 18M, and supports setting fixed rate, b=
ut if I set it to anything higher that 18M,
> speeds drop to 0Kbytes/s immediately.
> Speeds lower that 18M work, and affect throughput accordantly
> For most of tests speeds are ether 18M or lower, but then when I set =
them to 18M this didn't increase throughput.
> =20
> iwl3945 was always at 54M
>=20
>=20
>=20
> Best regards,
> 	Maxim Levitsky

I did a similar test here and results is very strange. AP was my good
old linksys WRT54G running an iperf server. Client was a laptop running
either ath5k or madwifi/trunk and an iperf client. Channel is 5. Both
drivers show the same behaviour.

At the beginning, throughput was very low : 500 - 600 kbit/s. Suddenly
(after few minutes), it jumps to 15 - 17 Mbit/s and then few minutes
later (let's say 10 - 20 minutes maybe), it jumps back to 500 - 600
kbit/s. Using a fixed rate has no effect.

I used my latest wireless monitoring tools and I did not saw lost of
duplicates or lost packets. The only difference was the number of
packets sent by seconds....

Looking a my syslog, I just saw few messages, unrelated in time with th=
e
throughput going up or down. They were:
- - ath5k : unsupported jumbo
- - switching to short barker preamble
- - switching to long barker preamble

I can repeat the same test with iwl3945 as well, if needed.

Regards,
Beno=EEt
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJKlkTOR6EySwP7oIRAnR1AJ0UCiENM0qtZwQYngkVpiLvrKtgLACfRKPz
Wi/HreSX4NV+kfyeS+RMFaY=3D
=3DRKcV
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
