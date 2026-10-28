Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793178899;
	b=N7yyxcICUnOEJ+erb7Zl4uOa7oaJj6zZB6DAmkYuDDjntyI9iNGqepjBoIHG4cKJQJ9U
	 Q5BgOjnKJQiG6Va//pGy0uAmjh3jAS9sSlEh9nurO+LPM/1XsNCrIgmBz+LSDGV2F4pWF
	 rxxu4j2PKESHkwEdsCw4kLTSKi5cRXNmFoyM3pHy/ISDmrueH9MYKBvnniFgunf+HPwwC
	 XEGodOxCsD7YPyJeSz8htjhdik3+YB6+YmOUpCHk2IzDuTjttd6tvf0WtCfs2QPvnC4NR
	 4vFSH6X8FL87HQViEYidT3yx/ChpzvxF9DqrQWRfAG83BgYJh+YFhge+u2XywVJcnUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793178899;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=vM7ePCiA0GIT9PZIhtuNKaBfNxFFbv9k8qFL9CbO59I=;
	b=cwUXGCjCmKrS67yt9OmdxDRblL0SuY7XEkJ6rEIafMveO+P1/EG+YYW1MTni2PVETSfS
	 NfTYq5efGr4leAAQHndwlwJ2++A5JPfuJGsVhKoHhlh9HpWZMybt481zR+XDGAj+GNPKS
	 VF1gjraW5wl68aPaXvenK/hq5rynMpRES9HCqNAokBwFYIwdlRp+LMB22IKis4X+l+gIr
	 ZKqI2Sbu3YzsyGmcuY5LaPj8ecdWryp8Apqazatucb6Gk5FtTO3yFrCeR9KaQIVhW/LaX
	 6j4EE/lmgVuzRGZLJF6aBpsAMOG2dgooozdECWDnQraBaEldy5JGweDuP8CG1h97Z+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=E+sgkwrh;
	arc=none smtp.remote-ip=62.149.156.41
Received: from smtpcmd0641.aruba.it (smtpcmd0641.aruba.it [62.149.156.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62488606A31C
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 09:14:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62488606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=E+sgkwrh
Received: from fedora ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id Lzk8xux8CRFT1Lzk8xzkPx; Wed, 28 Oct 2026 10:14:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793178888; bh=srkNCduzA/E39ZepF0XQGzQ9W/uleEmVEfY/V+wYPKw=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=E+sgkwrhwulSWSqJpKraBGaqb9lK/Bt+TxWL2Zr/Tef6Y9/++UnC249bRXNh3Y8jf
	 HMGR37u+/xGWlHeyQutap4oK1IjOxwCB9mwv8JIDzkuOTkbo/vmIhOgrsepgq4Hezy
	 JYJAPghuxelvKV0FjWs3nikIvtmviu+RBbhFWkmcYzSHxCgsZnPdTY8AmrfLw+vzKt
	 Sbsj/49NTqk3xduoDQiYwHhtmdYNP3Bka63JXeBszi64LyOAnJJBOZOg4vtGGNQUBO
	 F2V+s6KaBQ7zlrKkLc5Bg6+Q84yzoqanQ1HaLkthjWYOYIxtLlSYB+3sRIy8SGSZuh
	 OEBAXpT2KGzNQ==
Date: Wed, 28 Oct 2026 10:14:48 +0100
From: Alessio Ferri <alessio.ferri@mythread.it>
To: vit9696 <vit9696@protonmail.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, Michael Buesch
 <m@bues.ch>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 2/8] bcma: pmu: init PLL and resources
 on BCM4352/BCM4360
Message-ID: <20261028101448.7f26dd0b@fedora>
In-Reply-To: <B511987C-C9E8-442B-89EB-6AF6E8398F38@protonmail.com>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
	<20261027-bcma-ac-rev1-v2-2-b69b61c31920@mythread.it>
	<B511987C-C9E8-442B-89EB-6AF6E8398F38@protonmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfJSpa75WNKwWisHkxWlekWRG2/blg6eDUkdoIyqqsHZKpMzgippfLKTiCCau8xnJrwC+znTKa4Iy040wO8qeyuKcnOfnU2N2aO6o0/2ZBeQzJAf3cvux
 AIV4Tofl0rYhQfNN1kdB51u3xgjzVsQZwYh0+xhbE1gkcNASvQXAJtPTCV0B3oKHCVRTJcHJ/TqsYnLQ0na/mc14or6+1RCX75Atab5Gmh6npNJ6tDgg7T4T
 jLfA/ye1tjloG0YqPyTrVBI35VOt+Jcbt3u/aCohRZGtLuWXr295UssZod0tNuBwv1UsS4MKiH1UbE3WC2unTaZHp86YAZCr2USbubDVvaE/2mM1tL3+50k7
 ybe8XN2+

Il giorno Wed, 28 Oct 2026 00:44:31 +0000
vit9696 <vit9696@protonmail.com> ha scritto:

> Hello,
> 
> XTAL frequency on BCM4360 and BCM4352 apparently does not only depend
> on the revision number. It is determined by bit #0 presence in
> chipstatus. If bit #0 is set, then it is 40 MHz, otherwise it is 20
> MHz. This logic is actually already present in the bcma driver[1],
> and looks correct to me. FVCO frequency being 960 MHz for all BCM4360
> and BCM4352 chips is also more or less known from the public
> open-source part of the Broadcom driver[2].
> 
> The nitpick here is that whereas PLL seems indeed to be only
> programmed on revision 3 and newer[3] (with the code there assuming
> 40 MHz XTAL frequency, probably because Broadcom migrated to 40 MHz
> at a certain point for all newer chips), but there is a special case
> for HT clk_ctl_st bit[4], i.e. backplane is running on HT clock.
> 
> With this in mind I believe the patch:
> - could handle revision 3 or newer, not just 3 in CTL2/3 logic;
> - could bug on BCMA_CC_CHIPST_4360_XTAL_40MZ not being set in CTL2/3
> logic;
> - could check for CCS_HTAVAIL bit not being set in CTL2/3 logic;
> - perhaps could calculate resulting CTL2/3 logic values in a slightly
> cleaner way, after all si_set_bb_vcofreq_frac is open-source;
> - perhaps could handle CTL6/14 for other revisions, si_pmu_res_init
> is also open-source, and to me it makes little sense to ignore it.
> 
> Best,
> Vitaly
> 

Hi Vitaly
Ok, it seems i missed it, i'll fix. In the meantime would you mind
looking in depth at rest of the series before i resend with this change?

Best,
Alessio

> [1]
> https://github.com/torvalds/linux/blob/8a36f53fd5ec3eff01f1b637d42cbdc3821d0493/drivers/bcma/driver_chipcommon_pmu.c#L336-L342
> [2]
> https://github.com/RMerl/asuswrt-merlin.ng/blob/386_x/release/src-rt-6.x.4708/shared/hndpmu.c#L3450-L3460
> [3]
> https://github.com/RMerl/asuswrt-merlin.ng/blob/386_x/release/src-rt-6.x.4708/shared/hndpmu.c#L5142-L5143
> [4]
> https://github.com/RMerl/asuswrt-merlin.ng/blob/386_x/release/src-rt-6.x.4708/shared/hndpmu.c#L4961C37-L4964
> 
> > On 27 Oct 2026, at 02:53, Alessio Ferri <alessio.ferri@mythread.it>
> > wrote:
> > 
> > On chip rev 3:
> > 
> > - program PLLCTL2/3 for a 960.0098 MHz fractional VCO from the 40
> > MHz crystal, except on a BCM4360 strapped for USB;
> > - set the up/down time of resource 6;
> > - with chipstatus RSRC_INIT_MODE0 clear, program PLLCTL6/14 and set
> >  max_res_mask to 0x1ff.
> > 
> > The values are those of Broadcom's driver on rev 3; other revisions
> > are left as they are.
> > 
> > Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
> > ---
> > drivers/bcma/driver_chipcommon_pmu.c        | 41
> > +++++++++++++++++++++++++++++
> > include/linux/bcma/bcma_driver_chipcommon.h |  4 +++ 2 files
> > changed, 45 insertions(+)
> > 
> > diff --git a/drivers/bcma/driver_chipcommon_pmu.c
> > b/drivers/bcma/driver_chipcommon_pmu.c index 263ef6fa1..ab2b2701d
> > 100644 --- a/drivers/bcma/driver_chipcommon_pmu.c
> > +++ b/drivers/bcma/driver_chipcommon_pmu.c
> > @@ -145,6 +145,39 @@ static void bcma_pmu2_pll_init0(struct
> > bcma_drv_cc *cc, u32 xtalfreq) /* TODO: Do we need to update OTP? */
> > }
> > 
> > +static void bcma_pmu_4360_pll_init(struct bcma_drv_cc *cc)
> > +{
> > + struct bcma_bus *bus = cc->core->bus;
> > +
> > + if (bus->chipinfo.rev != 3)
> > + return;
> > + if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4360 &&
> > +    cc->status & BCMA_CC_CHIPST_4360_MODE_USB)
> > + return;
> > +
> > + /* Fractional VCO, 960.0098 MHz from a 40 MHz crystal. */
> > + bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2, 0x0c31);
> > + bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3, 0x100e);
> > + bcma_pmu_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
> > +}
> > +
> > +/* Returns the max resource mask to program, 0 to leave it alone.
> > */ +static u32 bcma_pmu_4360_resources_init(struct bcma_drv_cc *cc)
> > +{
> > + if (cc->core->bus->chipinfo.rev != 3)
> > + return 0;
> > +
> > + bcma_pmu_write32(cc, BCMA_CC_PMU_RES_TABSEL, 6);
> > + bcma_pmu_write32(cc, BCMA_CC_PMU_RES_UPDNTM, 0x00200001);
> > +
> > + if (cc->status & BCMA_CC_CHIPST_4360_RSRC_INIT_MODE0)
> > + return 0;
> > + bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL6, 0x09048562);
> > + bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL14, 0x09048562);
> > + bcma_pmu_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
> > + return 0x1ff;
> > +}
> > +
> > static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
> > {
> > struct bcma_bus *bus = cc->core->bus;
> > @@ -156,6 +189,10 @@ static void bcma_pmu_pll_init(struct
> > bcma_drv_cc *cc) xtalfreq = 20000;
> > bcma_pmu2_pll_init0(cc, xtalfreq);
> > break;
> > + case BCMA_CHIP_ID_BCM4352:
> > + case BCMA_CHIP_ID_BCM4360:
> > + bcma_pmu_4360_pll_init(cc);
> > + break;
> > }
> > }
> > 
> > @@ -188,6 +225,10 @@ static void bcma_pmu_resources_init(struct
> > bcma_drv_cc *cc) BCMA_RES_4314_WL_CORE_READY;
> > max_msk = 0x3FFFFFFF;
> > break;
> > + case BCMA_CHIP_ID_BCM4352:
> > + case BCMA_CHIP_ID_BCM4360:
> > + max_msk = bcma_pmu_4360_resources_init(cc);
> > + break;
> > default:
> > bcma_debug(bus, "PMU resource config unknown or not needed for
> > device 0x%04X\n", bus->chipinfo.id);
> > diff --git a/include/linux/bcma/bcma_driver_chipcommon.h
> > b/include/linux/bcma/bcma_driver_chipcommon.h index
> > 0cb6638b5..45c37b6bd 100644 ---
> > a/include/linux/bcma/bcma_driver_chipcommon.h +++
> > b/include/linux/bcma/bcma_driver_chipcommon.h @@ -107,6 +107,8 @@
> > #define  BCMA_CC_CHIPST_4706_PCIE1_DISABLE BIT(5) /* PCIE1 enable
> > strap pin */ #define  BCMA_CC_CHIPST_5357_NAND_BOOT BIT(4) /* NAND
> > boot, valid for CC rev 38 and/or BCM5357 */ #define
> > BCMA_CC_CHIPST_4360_XTAL_40MZ 0x00000001 +#define
> > BCMA_CC_CHIPST_4360_RSRC_INIT_MODE0 0x00000020 +#define
> > BCMA_CC_CHIPST_4360_MODE_USB 0x00000100 #define BCMA_CC_JCMD 0x0030
> > /* Rev >= 10 only */ #define  BCMA_CC_JCMD_START 0x80000000
> > #define  BCMA_CC_JCMD_BUSY 0x80000000
> > @@ -500,6 +502,8 @@
> > #define BCMA_CC_PMU_PLL_CTL3 3
> > #define BCMA_CC_PMU_PLL_CTL4 4
> > #define BCMA_CC_PMU_PLL_CTL5 5
> > +#define BCMA_CC_PMU_PLL_CTL6 6
> > +#define BCMA_CC_PMU_PLL_CTL14 14
> > 
> > #define BCMA_CC_PMU1_PLL0_PC0_P1DIV_MASK 0x00f00000
> > #define BCMA_CC_PMU1_PLL0_PC0_P1DIV_SHIFT 20
> > 
> > --
> > 2.34.1
> >   
> 

