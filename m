Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.31
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793194499;
	b=vaxsS0LA1UebuSt6WLevYtgGios8g7rg/L5WY4yNYmgP1EEeMdVx5IGR8/s5nwGf6UYH
	 xJCq67d255RpG4Pyq0kZg0OvWoN8ZJdhjwPu/B80kixqM8sE5LEFqgUMMUIbu1Fq5+qZh
	 esgmyZUctbCj+h3QXk+jS9aJuig3YbiX7fPQw/5EilyTlBGwEldbh6pC+6kU0o1HiC4fC
	 OJYu1Ym/9dyEJm0hJ33ic6opK6DdEDy6jxM/J7z6lY2QINUSJzEZV8Qropc8j/KG9mMES
	 b3+QsrbwOCRnVdzx+rVDVUQ/FkfHghrys5lMZTaZcl87F+8OH9xtqT6sHluCFvejZ7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793194499;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type;
	bh=maFM6J3tuW6aGxj4suln/5TGodXdNpTT72L7DWb+75E=;
	b=sVYrG8/gxjo0r2JTzIp0Rp6RnhOUuCQsnGni5AzhKP2nNvXbodRBLczjIm6QL4400/nr
	 AIxWYulELFYBm8js4BbcVJMIyRWPPPggInomxQg+3RtpUg5W1CD87aJu0A7hrpEBgfhe1
	 BCQjxgtPz8a+UOiSk/FA00EnbDKIqEtEjEzKwzCH56aOz/IcWe3AfrvLy0Y919JdkTO3X
	 RDkwsfMtdt84Sv+u5ntwkgsZUUamYFpdmshiNvbPQRFWnSuv48JCy22pJFoZ0zOcIuHlB
	 FwmByrY1YMPQognJvYaNhkXgLnIflJj8VizPLXvs5FaUApJVHnhWFomATrnjU23PUPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=lnBL5+QF;
	arc=none smtp.remote-ip=79.135.106.31
Received: from mail-10631.protonmail.ch (mail-10631.protonmail.ch [79.135.106.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A05606A324;
	Wed, 28 Oct 2026 13:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38A05606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=lnBL5+QF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1793194496; x=1793453696;
	bh=maFM6J3tuW6aGxj4suln/5TGodXdNpTT72L7DWb+75E=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=lnBL5+QFQhFFZbR2BE/I5znV5WXdjgw52krlOgqBACIdB7x9Y9gF4CX8fF5LXXh4b
	 yTAxXLDS2d3WGgZgXwtKu3CFAk3bWWPDrZBGuRV9oS9rq6P2BIxCoGsBkdBD55vBOJ
	 NJPdMbaQRo1e4ZvPB8XQY3UcDG+h+WFwYp48cZVm4k9WVHGven7f1g3jdgTCyVZni8
	 BZlfk7xJIEJctAkuZ9n2DxOJCj+wpvYT9P1LQeFcfrro1YW3oob+xuHZHNrGBGbo6o
	 1yZIhTUevJq5uWSEkNDExO404vcTvSbFJOgf9AUaRd3WX8GGQekizF8s181TSDsbPQ
	 4HwOe9El0bxcQ==
Date: Wed, 28 Oct 2026 13:34:50 +0000
To: Alessio Ferri <alessio.ferri@mythread.it>
From: vit9696 <vit9696@protonmail.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 2/8] bcma: pmu: init PLL and resources on BCM4352/BCM4360
Message-ID: <87C23173-4498-4D56-A143-03CA0358C4FF@protonmail.com>
In-Reply-To: <20261028101448.7f26dd0b@fedora>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it> <20261027-bcma-ac-rev1-v2-2-b69b61c31920@mythread.it> <B511987C-C9E8-442B-89EB-6AF6E8398F38@protonmail.com> <20261028101448.7f26dd0b@fedora>
Feedback-ID: 739018:user:proton
X-Pm-Message-ID: 029e3bdb5cd63c89a9cf081f415d2e8d8d5d4f6c
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------d27c6f642e9989b1867bbe9df4b0f546c8df97de4e21426f979626ae4acf2340"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------d27c6f642e9989b1867bbe9df4b0f546c8df97de4e21426f979626ae4acf2340
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.4\))
Subject: Re: [PATCH wireless-next v2 2/8] bcma: pmu: init PLL and resources on
 BCM4352/BCM4360
From: vit9696 <vit9696@protonmail.com>
In-Reply-To: <20261028101448.7f26dd0b@fedora>
Date: Wed, 28 Oct 2026 16:34:32 +0300
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
 Michael Buesch <m@bues.ch>,
 linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org
Message-Id: <87C23173-4498-4D56-A143-03CA0358C4FF@protonmail.com>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
 <20261027-bcma-ac-rev1-v2-2-b69b61c31920@mythread.it>
 <B511987C-C9E8-442B-89EB-6AF6E8398F38@protonmail.com>
 <PI9Cjv-14HEqAnf26GqGftOIUBT5oOa_o0utCXnHdtqKa24Jazoe-KvlG3LsxR1IOqUb22h9EpaxF0OYYrnNgg==@protonmail.internalid>
 <20261028101448.7f26dd0b@fedora>
To: Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: Apple Mail (2.3864.700.51.1.4)

Hi Alessio,

I checked the other patches and e-mailed my thoughts where I saw I could pr=
ovide some help.
Although I do not have expertise in Broadcom hardware design, I co-maintain=
 complementary set of extensions for macOS Broadcom drivers for the purpose=
 of broader hardware compatibility and happen to have some sparse informati=
on here and there.

In general I would recommend to rely more on the open-source part of the Br=
oadcom drivers, especially for Northstar boards, because it often contains =
useful information.

Best,
Vitaly

> On 28 Oct 2026, at 12:14, Alessio Ferri <alessio.ferri@mythread.it> wrote=
:
>=20
> Il giorno Wed, 28 Oct 2026 00:44:31 +0000
> vit9696 <vit9696@protonmail.com> ha scritto:
>=20
>> Hello,
>>=20
>> XTAL frequency on BCM4360 and BCM4352 apparently does not only depend
>> on the revision number. It is determined by bit #0 presence in
>> chipstatus. If bit #0 is set, then it is 40 MHz, otherwise it is 20
>> MHz. This logic is actually already present in the bcma driver[1],
>> and looks correct to me. FVCO frequency being 960 MHz for all BCM4360
>> and BCM4352 chips is also more or less known from the public
>> open-source part of the Broadcom driver[2].
>>=20
>> The nitpick here is that whereas PLL seems indeed to be only
>> programmed on revision 3 and newer[3] (with the code there assuming
>> 40 MHz XTAL frequency, probably because Broadcom migrated to 40 MHz
>> at a certain point for all newer chips), but there is a special case
>> for HT clk_ctl_st bit[4], i.e. backplane is running on HT clock.
>>=20
>> With this in mind I believe the patch:
>> - could handle revision 3 or newer, not just 3 in CTL2/3 logic;
>> - could bug on BCMA_CC_CHIPST_4360_XTAL_40MZ not being set in CTL2/3
>> logic;
>> - could check for CCS_HTAVAIL bit not being set in CTL2/3 logic;
>> - perhaps could calculate resulting CTL2/3 logic values in a slightly
>> cleaner way, after all si_set_bb_vcofreq_frac is open-source;
>> - perhaps could handle CTL6/14 for other revisions, si_pmu_res_init
>> is also open-source, and to me it makes little sense to ignore it.
>>=20
>> Best,
>> Vitaly
>>=20
>=20
> Hi Vitaly
> Ok, it seems i missed it, i'll fix. In the meantime would you mind
> looking in depth at rest of the series before i resend with this change?
>=20
> Best,
> Alessio
>=20
>> [1]
>> https://github.com/torvalds/linux/blob/8a36f53fd5ec3eff01f1b637d42cbdc38=
21d0493/drivers/bcma/driver_chipcommon_pmu.c#L336-L342
>> [2]
>> https://github.com/RMerl/asuswrt-merlin.ng/blob/386_x/release/src-rt-6.x=
.4708/shared/hndpmu.c#L3450-L3460
>> [3]
>> https://github.com/RMerl/asuswrt-merlin.ng/blob/386_x/release/src-rt-6.x=
.4708/shared/hndpmu.c#L5142-L5143
>> [4]
>> https://github.com/RMerl/asuswrt-merlin.ng/blob/386_x/release/src-rt-6.x=
.4708/shared/hndpmu.c#L4961C37-L4964
>>=20
>>> On 27 Oct 2026, at 02:53, Alessio Ferri <alessio.ferri@mythread.it>
>>> wrote:
>>>=20
>>> On chip rev 3:
>>>=20
>>> - program PLLCTL2/3 for a 960.0098 MHz fractional VCO from the 40
>>> MHz crystal, except on a BCM4360 strapped for USB;
>>> - set the up/down time of resource 6;
>>> - with chipstatus RSRC_INIT_MODE0 clear, program PLLCTL6/14 and set
>>> max_res_mask to 0x1ff.
>>>=20
>>> The values are those of Broadcom's driver on rev 3; other revisions
>>> are left as they are.
>>>=20
>>> Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
>>> ---
>>> drivers/bcma/driver_chipcommon_pmu.c        | 41
>>> +++++++++++++++++++++++++++++
>>> include/linux/bcma/bcma_driver_chipcommon.h |  4 +++ 2 files
>>> changed, 45 insertions(+)
>>>=20
>>> diff --git a/drivers/bcma/driver_chipcommon_pmu.c
>>> b/drivers/bcma/driver_chipcommon_pmu.c index 263ef6fa1..ab2b2701d
>>> 100644 --- a/drivers/bcma/driver_chipcommon_pmu.c
>>> +++ b/drivers/bcma/driver_chipcommon_pmu.c
>>> @@ -145,6 +145,39 @@ static void bcma_pmu2_pll_init0(struct
>>> bcma_drv_cc *cc, u32 xtalfreq) /* TODO: Do we need to update OTP? */
>>> }
>>>=20
>>> +static void bcma_pmu_4360_pll_init(struct bcma_drv_cc *cc)
>>> +{
>>> + struct bcma_bus *bus =3D cc->core->bus;
>>> +
>>> + if (bus->chipinfo.rev !=3D 3)
>>> + return;
>>> + if (bus->chipinfo.id =3D=3D BCMA_CHIP_ID_BCM4360 &&
>>> +    cc->status & BCMA_CC_CHIPST_4360_MODE_USB)
>>> + return;
>>> +
>>> + /* Fractional VCO, 960.0098 MHz from a 40 MHz crystal. */
>>> + bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2, 0x0c31);
>>> + bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3, 0x100e);
>>> + bcma_pmu_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
>>> +}
>>> +
>>> +/* Returns the max resource mask to program, 0 to leave it alone.
>>> */ +static u32 bcma_pmu_4360_resources_init(struct bcma_drv_cc *cc)
>>> +{
>>> + if (cc->core->bus->chipinfo.rev !=3D 3)
>>> + return 0;
>>> +
>>> + bcma_pmu_write32(cc, BCMA_CC_PMU_RES_TABSEL, 6);
>>> + bcma_pmu_write32(cc, BCMA_CC_PMU_RES_UPDNTM, 0x00200001);
>>> +
>>> + if (cc->status & BCMA_CC_CHIPST_4360_RSRC_INIT_MODE0)
>>> + return 0;
>>> + bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL6, 0x09048562);
>>> + bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL14, 0x09048562);
>>> + bcma_pmu_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
>>> + return 0x1ff;
>>> +}
>>> +
>>> static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
>>> {
>>> struct bcma_bus *bus =3D cc->core->bus;
>>> @@ -156,6 +189,10 @@ static void bcma_pmu_pll_init(struct
>>> bcma_drv_cc *cc) xtalfreq =3D 20000;
>>> bcma_pmu2_pll_init0(cc, xtalfreq);
>>> break;
>>> + case BCMA_CHIP_ID_BCM4352:
>>> + case BCMA_CHIP_ID_BCM4360:
>>> + bcma_pmu_4360_pll_init(cc);
>>> + break;
>>> }
>>> }
>>>=20
>>> @@ -188,6 +225,10 @@ static void bcma_pmu_resources_init(struct
>>> bcma_drv_cc *cc) BCMA_RES_4314_WL_CORE_READY;
>>> max_msk =3D 0x3FFFFFFF;
>>> break;
>>> + case BCMA_CHIP_ID_BCM4352:
>>> + case BCMA_CHIP_ID_BCM4360:
>>> + max_msk =3D bcma_pmu_4360_resources_init(cc);
>>> + break;
>>> default:
>>> bcma_debug(bus, "PMU resource config unknown or not needed for
>>> device 0x%04X\n", bus->chipinfo.id);
>>> diff --git a/include/linux/bcma/bcma_driver_chipcommon.h
>>> b/include/linux/bcma/bcma_driver_chipcommon.h index
>>> 0cb6638b5..45c37b6bd 100644 ---
>>> a/include/linux/bcma/bcma_driver_chipcommon.h +++
>>> b/include/linux/bcma/bcma_driver_chipcommon.h @@ -107,6 +107,8 @@
>>> #define  BCMA_CC_CHIPST_4706_PCIE1_DISABLE BIT(5) /* PCIE1 enable
>>> strap pin */ #define  BCMA_CC_CHIPST_5357_NAND_BOOT BIT(4) /* NAND
>>> boot, valid for CC rev 38 and/or BCM5357 */ #define
>>> BCMA_CC_CHIPST_4360_XTAL_40MZ 0x00000001 +#define
>>> BCMA_CC_CHIPST_4360_RSRC_INIT_MODE0 0x00000020 +#define
>>> BCMA_CC_CHIPST_4360_MODE_USB 0x00000100 #define BCMA_CC_JCMD 0x0030
>>> /* Rev >=3D 10 only */ #define  BCMA_CC_JCMD_START 0x80000000
>>> #define  BCMA_CC_JCMD_BUSY 0x80000000
>>> @@ -500,6 +502,8 @@
>>> #define BCMA_CC_PMU_PLL_CTL3 3
>>> #define BCMA_CC_PMU_PLL_CTL4 4
>>> #define BCMA_CC_PMU_PLL_CTL5 5
>>> +#define BCMA_CC_PMU_PLL_CTL6 6
>>> +#define BCMA_CC_PMU_PLL_CTL14 14
>>>=20
>>> #define BCMA_CC_PMU1_PLL0_PC0_P1DIV_MASK 0x00f00000
>>> #define BCMA_CC_PMU1_PLL0_PC0_P1DIV_SHIFT 20
>>>=20
>>> --
>>> 2.34.1



--------d27c6f642e9989b1867bbe9df4b0f546c8df97de4e21426f979626ae4acf2340
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wsCpBAEBCABdBYJq4fn5CRBPsoxt7Hy0xTUUAAAAAAAcABBzYWx0QG5vdGF0
aW9ucy5vcGVucGdwanMub3JnovhRn/wmbxLfqc36oddm5hYhBERSlkTqW1Te
3v1Bj0+yjG3sfLTFAABgsggAhyERKvEfFf7PNdZqgt/P5OZLnhUSn441S6XN
Rf1TMsUiAL8QQ4bWxD3G2orGt8d8//mZeHES0TMPlwFtkvjEeOVdLcybhuWP
qYNJFOpGcPJCUP++PNbxXnlk5tVYwUJRbm4rWDkw83rNgzqZNB+znFvy8S6n
UnvDVOIQO7gOjKuyhMBz8KSRzemFihyQ2nqImWyb/0NOh2LBQhQnrOP0jfRU
0PvVXI2hIIxY9JOG31AwZU36vQTV28HKxh1qAympi5UkBDbJQSurqPwkh3hf
roXUX8+knmCy4YlGKQXd8gg9dGEoFMwo+GPO14/jXcPuSM9oWzSb8LRWYEWK
PRZooA==
=vQFV
-----END PGP SIGNATURE-----


--------d27c6f642e9989b1867bbe9df4b0f546c8df97de4e21426f979626ae4acf2340--

