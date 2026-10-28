Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793148277;
	b=G+7M6fIrNYH0Kj5A34vOKcpGwsFbOFh+H6vynVQBb+xUC6/xH2cTken++zzuTX6cCVaY
	 DeSbFRl8s896C8R7anC0qUM6KdqMt+aGk+jFmCsV39xqYvdgwLqSFl60ADGMZeAZJG7qF
	 Q2cAOXiRBIw6/2T7V5pfbzQwq8uEtd13cyR8zSsR+VkPYwhPidd0aN9jaI6aVISANxIsS
	 zsZasGpEWHlUgipRE1eGjofNRH24/X5LbTEsf7NyDeuXDTrokM3wvRtwFkAylQhvtn45R
	 dBY9ZwALM65rO+9nRzrvvv/WGxqGYYmV7tz7XLQ6rn7Etbdv/E3RnJgMN+xJGTM0mHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793148277;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type;
	bh=1v7Ke1XehsqZ4k0S4PNTpXWOWKd22NSdPZyeBvp/2HE=;
	b=mVScxNlGsXpAiiy8M/TJ4cF8i1z4fECZMkIgw46xkHBD4SA4e1oys/54jwK+ooSrIJg2
	 Egprhd6xPgkGvq1kB2fm180/YdoUhkLSojz9FCQNIVGJgSW+MskGndPWcK8Bc5vnI++vA
	 /ZxLA0cB3lt/qbJpKFPMzWqpN2sg5rnmHacyfW3p99p4073F5T+ZuDpjO/0+eqQcdT/Ag
	 rA3OSpg9YgyVMspgMf3GkKtVIDtGKk9uEXNnQqoW33Wp6+wfU05j8TZnm/z0ox/ANG98u
	 f9Rm+NV2R2l3hODylcBoxQDDPoBa+IfU1TvT9gdodbzigfHNKS0FEkgRG/Gz6F8rncA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=jJkkYXza;
	arc=none smtp.remote-ip=109.224.244.122
Received: from mail-244122.protonmail.ch (mail-244122.protonmail.ch [109.224.244.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BB5606A325;
	Wed, 28 Oct 2026 00:44:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78BB5606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=jJkkYXza
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1793148274; x=1793407474;
	bh=1v7Ke1XehsqZ4k0S4PNTpXWOWKd22NSdPZyeBvp/2HE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=jJkkYXzaAkR0kIGxzQWDinHzGRZ/eC1jeCGL/deHP0m2Dd5RDds97PbtrhA3eIqgn
	 uco7mRtxsJhZMQ5FtVMDrh7G3dDNyw5xPocyWacscgzKOQ8jbI7WYaJBt+57zUysZU
	 +iZlK7ktoTeOkw6y92tmn8XcgEfQt22KNd+3oJhP4VmJDKnvz1+57ABM7cu7gGkl+x
	 byMCJgpT8imxTnStDBCY8tg/DsVOzYPtkcA3pWvxJs8e0uLQBr27zshcz3475m9cN0
	 fByyIK+Czpjj0SpDryUdaFP8llLQxArjKLbqAoNATz17lurOElsIDGGzZ5ZOjogWC1
	 D6JThJ2CnFgVQ==
Date: Wed, 28 Oct 2026 00:44:31 +0000
To: Alessio Ferri <alessio.ferri@mythread.it>
From: vit9696 <vit9696@protonmail.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 2/8] bcma: pmu: init PLL and resources on BCM4352/BCM4360
Message-ID: <B511987C-C9E8-442B-89EB-6AF6E8398F38@protonmail.com>
In-Reply-To: <20261027-bcma-ac-rev1-v2-2-b69b61c31920@mythread.it>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it> <20261027-bcma-ac-rev1-v2-2-b69b61c31920@mythread.it>
Feedback-ID: 739018:user:proton
X-Pm-Message-ID: e592c053d390710f13c41625893b0cef14053540
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------c33969d8e1516fcdca326010fee8138465af6aa617ad10bcf2a92b5c644882fb"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------c33969d8e1516fcdca326010fee8138465af6aa617ad10bcf2a92b5c644882fb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.4\))
Subject: Re: [PATCH wireless-next v2 2/8] bcma: pmu: init PLL and resources on
 BCM4352/BCM4360
From: vit9696 <vit9696@protonmail.com>
In-Reply-To: <20261027-bcma-ac-rev1-v2-2-b69b61c31920@mythread.it>
Date: Wed, 28 Oct 2026 03:44:18 +0300
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
 Michael Buesch <m@bues.ch>,
 linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org
Message-Id: <B511987C-C9E8-442B-89EB-6AF6E8398F38@protonmail.com>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
 <ByO90-C2C5yWm8_jwhGnnMBETANahqas8IfQLYKE-HwzvaO9HX5BjrQEEkiBYSF2e4KtNJ0VwOL7RJ4jw8duXg==@protonmail.internalid>
 <20261027-bcma-ac-rev1-v2-2-b69b61c31920@mythread.it>
To: Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: Apple Mail (2.3864.700.51.1.4)

Hello,

XTAL frequency on BCM4360 and BCM4352 apparently does not only depend on th=
e revision number. It is determined by bit #0 presence in chipstatus. If bi=
t #0 is set, then it is 40 MHz, otherwise it is 20 MHz. This logic is actua=
lly already present in the bcma driver[1], and looks correct to me. FVCO fr=
equency being 960 MHz for all BCM4360 and BCM4352 chips is also more or les=
s known from the public open-source part of the Broadcom driver[2].

The nitpick here is that whereas PLL seems indeed to be only programmed on =
revision 3 and newer[3] (with the code there assuming 40 MHz XTAL frequency=
, probably because Broadcom migrated to 40 MHz at a certain point for all n=
ewer chips), but there is a special case for HT clk_ctl_st bit[4], i.e. bac=
kplane is running on HT clock.

With this in mind I believe the patch:
- could handle revision 3 or newer, not just 3 in CTL2/3 logic;
- could bug on BCMA_CC_CHIPST_4360_XTAL_40MZ not being set in CTL2/3 logic;
- could check for CCS_HTAVAIL bit not being set in CTL2/3 logic;
- perhaps could calculate resulting CTL2/3 logic values in a slightly clean=
er way, after all si_set_bb_vcofreq_frac is open-source;
- perhaps could handle CTL6/14 for other revisions, si_pmu_res_init is also=
 open-source, and to me it makes little sense to ignore it.

Best,
Vitaly

[1] https://github.com/torvalds/linux/blob/8a36f53fd5ec3eff01f1b637d42cbdc3=
821d0493/drivers/bcma/driver_chipcommon_pmu.c#L336-L342
[2] https://github.com/RMerl/asuswrt-merlin.ng/blob/386_x/release/src-rt-6.=
x.4708/shared/hndpmu.c#L3450-L3460
[3] https://github.com/RMerl/asuswrt-merlin.ng/blob/386_x/release/src-rt-6.=
x.4708/shared/hndpmu.c#L5142-L5143
[4] https://github.com/RMerl/asuswrt-merlin.ng/blob/386_x/release/src-rt-6.=
x.4708/shared/hndpmu.c#L4961C37-L4964

> On 27 Oct 2026, at 02:53, Alessio Ferri <alessio.ferri@mythread.it> wrote=
:
>=20
> On chip rev 3:
>=20
> - program PLLCTL2/3 for a 960.0098 MHz fractional VCO from the 40 MHz
>  crystal, except on a BCM4360 strapped for USB;
> - set the up/down time of resource 6;
> - with chipstatus RSRC_INIT_MODE0 clear, program PLLCTL6/14 and set
>  max_res_mask to 0x1ff.
>=20
> The values are those of Broadcom's driver on rev 3; other revisions are
> left as they are.
>=20
> Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
> ---
> drivers/bcma/driver_chipcommon_pmu.c        | 41 ++++++++++++++++++++++++=
+++++
> include/linux/bcma/bcma_driver_chipcommon.h |  4 +++
> 2 files changed, 45 insertions(+)
>=20
> diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_c=
hipcommon_pmu.c
> index 263ef6fa1..ab2b2701d 100644
> --- a/drivers/bcma/driver_chipcommon_pmu.c
> +++ b/drivers/bcma/driver_chipcommon_pmu.c
> @@ -145,6 +145,39 @@ static void bcma_pmu2_pll_init0(struct bcma_drv_cc *=
cc, u32 xtalfreq)
> /* TODO: Do we need to update OTP? */
> }
>=20
> +static void bcma_pmu_4360_pll_init(struct bcma_drv_cc *cc)
> +{
> + struct bcma_bus *bus =3D cc->core->bus;
> +
> + if (bus->chipinfo.rev !=3D 3)
> + return;
> + if (bus->chipinfo.id =3D=3D BCMA_CHIP_ID_BCM4360 &&
> +    cc->status & BCMA_CC_CHIPST_4360_MODE_USB)
> + return;
> +
> + /* Fractional VCO, 960.0098 MHz from a 40 MHz crystal. */
> + bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2, 0x0c31);
> + bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3, 0x100e);
> + bcma_pmu_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
> +}
> +
> +/* Returns the max resource mask to program, 0 to leave it alone. */
> +static u32 bcma_pmu_4360_resources_init(struct bcma_drv_cc *cc)
> +{
> + if (cc->core->bus->chipinfo.rev !=3D 3)
> + return 0;
> +
> + bcma_pmu_write32(cc, BCMA_CC_PMU_RES_TABSEL, 6);
> + bcma_pmu_write32(cc, BCMA_CC_PMU_RES_UPDNTM, 0x00200001);
> +
> + if (cc->status & BCMA_CC_CHIPST_4360_RSRC_INIT_MODE0)
> + return 0;
> + bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL6, 0x09048562);
> + bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL14, 0x09048562);
> + bcma_pmu_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
> + return 0x1ff;
> +}
> +
> static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
> {
> struct bcma_bus *bus =3D cc->core->bus;
> @@ -156,6 +189,10 @@ static void bcma_pmu_pll_init(struct bcma_drv_cc *cc=
)
> xtalfreq =3D 20000;
> bcma_pmu2_pll_init0(cc, xtalfreq);
> break;
> + case BCMA_CHIP_ID_BCM4352:
> + case BCMA_CHIP_ID_BCM4360:
> + bcma_pmu_4360_pll_init(cc);
> + break;
> }
> }
>=20
> @@ -188,6 +225,10 @@ static void bcma_pmu_resources_init(struct bcma_drv_=
cc *cc)
>  BCMA_RES_4314_WL_CORE_READY;
> max_msk =3D 0x3FFFFFFF;
> break;
> + case BCMA_CHIP_ID_BCM4352:
> + case BCMA_CHIP_ID_BCM4360:
> + max_msk =3D bcma_pmu_4360_resources_init(cc);
> + break;
> default:
> bcma_debug(bus, "PMU resource config unknown or not needed for device 0x%=
04X\n",
>   bus->chipinfo.id);
> diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/=
bcma/bcma_driver_chipcommon.h
> index 0cb6638b5..45c37b6bd 100644
> --- a/include/linux/bcma/bcma_driver_chipcommon.h
> +++ b/include/linux/bcma/bcma_driver_chipcommon.h
> @@ -107,6 +107,8 @@
> #define  BCMA_CC_CHIPST_4706_PCIE1_DISABLE BIT(5) /* PCIE1 enable strap p=
in */
> #define  BCMA_CC_CHIPST_5357_NAND_BOOT BIT(4) /* NAND boot, valid for CC =
rev 38 and/or BCM5357 */
> #define  BCMA_CC_CHIPST_4360_XTAL_40MZ 0x00000001
> +#define  BCMA_CC_CHIPST_4360_RSRC_INIT_MODE0 0x00000020
> +#define  BCMA_CC_CHIPST_4360_MODE_USB 0x00000100
> #define BCMA_CC_JCMD 0x0030 /* Rev >=3D 10 only */
> #define  BCMA_CC_JCMD_START 0x80000000
> #define  BCMA_CC_JCMD_BUSY 0x80000000
> @@ -500,6 +502,8 @@
> #define BCMA_CC_PMU_PLL_CTL3 3
> #define BCMA_CC_PMU_PLL_CTL4 4
> #define BCMA_CC_PMU_PLL_CTL5 5
> +#define BCMA_CC_PMU_PLL_CTL6 6
> +#define BCMA_CC_PMU_PLL_CTL14 14
>=20
> #define BCMA_CC_PMU1_PLL0_PC0_P1DIV_MASK 0x00f00000
> #define BCMA_CC_PMU1_PLL0_PC0_P1DIV_SHIFT 20
>=20
> --
> 2.34.1
>=20


--------c33969d8e1516fcdca326010fee8138465af6aa617ad10bcf2a92b5c644882fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wsCpBAEBCABdBYJq4UVvCRBPsoxt7Hy0xTUUAAAAAAAcABBzYWx0QG5vdGF0
aW9ucy5vcGVucGdwanMub3JnCldAWcWGuVJ8KVUMJFLkmxYhBERSlkTqW1Te
3v1Bj0+yjG3sfLTFAAAxdQgAlLWjxlD5XVUa4rjN4D8KVNhh3exQvxoPfVNy
VNjAIEyq3T51S/RoqfTSmu/IuTlyIBOqKI9vqhBso7CxQu2jN7AbLj614J6N
jaM87v9LSmtMsZ7HgtbXPhytKX9qcXl3wxu7L3ixzMyBhzD1bx9SONsFRhDc
QfZaBaIQM+80SQ3DzmWREu08RubXOsxnc47UCBOXjO7/Q0hqI59clvKaIy17
5n4U4anWHOjNcAkFzZZ3vhb+i1zatey3eVXparwOXc61gORWrgswplKLcvmX
EU7FsTqOcqQdVPoLfLtohb9JUfmydA2Yd05TVqkgWpYpna2bAu0vrPQMDely
h2Mn5w==
=dLS9
-----END PGP SIGNATURE-----


--------c33969d8e1516fcdca326010fee8138465af6aa617ad10bcf2a92b5c644882fb--

