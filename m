Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:55664 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756674AbYDUTFN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 15:05:13 -0400
Message-ID: <480CE50A.1000200@lwfinger.net> (sfid-20080421_210605_263113_A4A0F745)
Date: Mon, 21 Apr 2008 14:03:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>
Subject: Re: b43 speed problem over 2.6.24
References: <a44ae5cd0804161701k1014f3dkebaa1d35f1a8e20a@mail.gmail.com>	 <a44ae5cd0804181446g596daa2yd1be5b1ac7e5e472@mail.gmail.com>	 <1208555536.4848.54.camel@johannes.berg>	 <a44ae5cd0804190801n66035332ubedbae99a7b635ce@mail.gmail.com>	 <a44ae5cd0804190811g10335c22mf10b9ddb2ab568ec@mail.gmail.com>	 <a44ae5cd0804190814i434dc92bwba3bb33737fbec1f@mail.gmail.com>	 <a44ae5cd0804191905qb281d7ehf839f80cd753a82@mail.gmail.com>	 <1208766258.26186.35.camel@johannes.berg>	 <a44ae5cd0804210400o1ed662aeqb00b9ba5abc61126@mail.gmail.com>	 <1208779022.26186.91.camel@johannes.berg> <a44ae5cd0804211150l1ede6030t5844458e4f92c73c@mail.gmail.com>
In-Reply-To: <a44ae5cd0804211150l1ede6030t5844458e4f92c73c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Miles Lane wrote:
> On Mon, Apr 21, 2008 at 7:57 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> Hi,
>>
>>  Miles described a b43 speed problem in the thread
>>
>>         =EF=BB=BF2.6.25-rc9 -- bcm4306 performance is in the toilet
>>
>>  (over 2.6.24) and not being able to see anything from his logs/pack=
et
>>  captures/... I asked him to bisect. This resulted in
>>
>>  commit 61bca6eb85c863603d6054530e2f65c3b9aba85b
>>  Author: Stefano Brivio <stefano.brivio@polimi.it>
>>  Date:   Tue Nov 6 22:49:05 2007 +0100
>>
>>     b43: rewrite A PHY initialization
>>
>>  which is a huge commit and hence a bit of a problem. Does anyone ha=
ve
>>  suggestions how to proceed?
>>
>>  I have very similar hardware, maybe this card is affected by the
>>  boardflags problems we found recently? Miles, can you give us
>>   * lspci -vn -s =EF=BB=BF01:06.0
>>   * the kernel init messages when ssb is built with debugging
>=20
> Here you go:
>=20
> # lspci -vn -s 01:06.0
> 01:06.0 0280: 14e4:4320 (rev 03)
> 	Subsystem: 1057:7110
> 	Flags: bus master, fast devsel, latency 16, IRQ 5
> 	Memory at ed000000 (32-bit, non-prefetchable) [size=3D8K]
>=20
> [    3.977930] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x04, ven=
dor 0x4243)
> [    3.977942] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x05,
> vendor 0x4243)
> [    3.977952] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x02, vendor =
0x4243)
> [    3.977962] ssb: Core 3 found: V90 (cc 0x807, rev 0x02, vendor 0x4=
243)
> [    3.977971] ssb: Core 4 found: PCI (cc 0x804, rev 0x09, vendor 0x4=
243)
> [    3.993965] ssb: SPROM revision 2 detected.
> [    3.994816] ssb: Sonics Silicon Backplane found on PCI device 0000=
:01:06.0
>=20
> Thanks,
>       Miles
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD*=DE=95=EF=BF=BD,=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD=
,j=07=EF=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=
=BF=BDz=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=
=BF=BD=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ=
+=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D
I don't know what got garbled, but we also need the b43 debugging=20
information. In particular, what is the PHY rev?

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
