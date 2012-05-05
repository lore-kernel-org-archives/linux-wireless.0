Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s3.blu0.hotmail.com ([65.55.111.78]:37481 "EHLO
	blu0-omc2-s3.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133Ab2EEHXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2012 03:23:09 -0400
Message-ID: <BLU0-SMTP208D417EB15873D76387AC0AC2D0@phx.gbl> (sfid-20120505_092313_404578_412BD436)
Subject: Re: [PATCH v3 1/6] bcma: Find names of non BCM cores
From: Nathan Hintz <nlhintz@hotmail.com>
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	hauke@hauke-m.de
Date: Sat, 5 May 2012 00:23:01 -0700
In-Reply-To: <4FA4C5AA.1080008@broadcom.com>
References: <1336193796-32599-1-git-send-email-nlhintz@hotmail.com>
	 <BLU0-SMTP19886E577929273F2D9108CAC2D0@phx.gbl>
	 <4FA4C5AA.1080008@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-05-05 at 08:16 +0200, Arend van Spriel wrote:
> On 05/05/2012 06:56 AM, Nathan Hintz wrote:
> > bcma_device_name only provides names for Broadcom cores.  Modify logic to
> > provide names for MIPS and ARM cores as well.
> 
> The description does not seem accurate. In my opinion the aim is to make
> the device name lookup a little bit more efficient by moving from one
> lookup table to a lookup table per vendor.
> 
> > Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
> > ---
> >  drivers/bcma/scan.c |   54 +++++++++++++++++++++++++++++++++++++-------------
> >  1 files changed, 40 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
> > index f94cccc..e19e987 100644
> > --- a/drivers/bcma/scan.c
> > +++ b/drivers/bcma/scan.c
> > @@ -19,7 +19,14 @@ struct bcma_device_id_name {
> >  	u16 id;
> >  	const char *name;
> >  };
> > -struct bcma_device_id_name bcma_device_names[] = {
> > +
> > +static const struct bcma_device_id_name bcma_arm_device_names[] = {
> > +	{ BCMA_CORE_ARM_1176, "ARM 1176" },
> > +	{ BCMA_CORE_ARM_7TDMI, "ARM 7TDMI" },
> > +	{ BCMA_CORE_ARM_CM3, "ARM CM3" },
> > +};
> > +
> > +static const struct bcma_device_id_name bcma_bcm_device_names[] = {
> >  	{ BCMA_CORE_OOB_ROUTER, "OOB Router" },
> >  	{ BCMA_CORE_INVALID, "Invalid" },
> >  	{ BCMA_CORE_CHIPCOMMON, "ChipCommon" },
> > @@ -27,7 +34,6 @@ struct bcma_device_id_name bcma_device_names[] = {
> >  	{ BCMA_CORE_SRAM, "SRAM" },
> >  	{ BCMA_CORE_SDRAM, "SDRAM" },
> >  	{ BCMA_CORE_PCI, "PCI" },
> > -	{ BCMA_CORE_MIPS, "MIPS" },
> >  	{ BCMA_CORE_ETHERNET, "Fast Ethernet" },
> >  	{ BCMA_CORE_V90, "V90" },
> >  	{ BCMA_CORE_USB11_HOSTDEV, "USB 1.1 Hostdev" },
> > @@ -44,7 +50,6 @@ struct bcma_device_id_name bcma_device_names[] = {
> >  	{ BCMA_CORE_PHY_A, "PHY A" },
> >  	{ BCMA_CORE_PHY_B, "PHY B" },
> >  	{ BCMA_CORE_PHY_G, "PHY G" },
> > -	{ BCMA_CORE_MIPS_3302, "MIPS 3302" },
> >  	{ BCMA_CORE_USB11_HOST, "USB 1.1 Host" },
> >  	{ BCMA_CORE_USB11_DEV, "USB 1.1 Device" },
> >  	{ BCMA_CORE_USB20_HOST, "USB 2.0 Host" },
> > @@ -58,15 +63,11 @@ struct bcma_device_id_name bcma_device_names[] = {
> >  	{ BCMA_CORE_PHY_N, "PHY N" },
> >  	{ BCMA_CORE_SRAM_CTL, "SRAM Controller" },
> >  	{ BCMA_CORE_MINI_MACPHY, "Mini MACPHY" },
> > -	{ BCMA_CORE_ARM_1176, "ARM 1176" },
> > -	{ BCMA_CORE_ARM_7TDMI, "ARM 7TDMI" },
> >  	{ BCMA_CORE_PHY_LP, "PHY LP" },
> >  	{ BCMA_CORE_PMU, "PMU" },
> >  	{ BCMA_CORE_PHY_SSN, "PHY SSN" },
> >  	{ BCMA_CORE_SDIO_DEV, "SDIO Device" },
> > -	{ BCMA_CORE_ARM_CM3, "ARM CM3" },
> >  	{ BCMA_CORE_PHY_HT, "PHY HT" },
> > -	{ BCMA_CORE_MIPS_74K, "MIPS 74K" },
> >  	{ BCMA_CORE_MAC_GBIT, "GBit MAC" },
> >  	{ BCMA_CORE_DDR12_MEM_CTL, "DDR1/DDR2 Memory Controller" },
> >  	{ BCMA_CORE_PCIE_RC, "PCIe Root Complex" },
> > @@ -79,16 +80,41 @@ struct bcma_device_id_name bcma_device_names[] = {
> >  	{ BCMA_CORE_SHIM, "SHIM" },
> >  	{ BCMA_CORE_DEFAULT, "Default" },
> >  };
> > -const char *bcma_device_name(struct bcma_device_id *id)
> > +
> > +static const struct bcma_device_id_name bcma_mips_device_names[] = {
> > +	{ BCMA_CORE_MIPS, "MIPS" },
> > +	{ BCMA_CORE_MIPS_3302, "MIPS 3302" },
> > +	{ BCMA_CORE_MIPS_74K, "MIPS 74K" },
> > +};
> > +
> > +static const char *bcma_device_name(const struct bcma_device_id *id)
> >  {
> > -	int i;
> > +	const struct bcma_device_id_name *names;
> > +	int size, i;
> > +
> > +	/* search manufacturer specific names */
> > +	switch (id->manuf) {
> > +	case BCMA_MANUF_ARM:
> > +		names = bcma_arm_device_names;
> > +		size = ARRAY_SIZE(bcma_arm_device_names);
> > +		break;
> > +	case BCMA_MANUF_BCM:
> > +		names = bcma_bcm_device_names;
> > +		size = ARRAY_SIZE(bcma_bcm_device_names);
> > +		break;
> > +	case BCMA_MANUF_MIPS:
> > +		names = bcma_mips_device_names;
> > +		size = ARRAY_SIZE(bcma_mips_device_names);
> > +		break;
> > +	default:
> > +		return "UNKNOWN";
> > +	}
> >  
> > -	if (id->manuf == BCMA_MANUF_BCM) {
> > -		for (i = 0; i < ARRAY_SIZE(bcma_device_names); i++) {
> > -			if (bcma_device_names[i].id == id->id)
> > -				return bcma_device_names[i].name;
> > -		}
> > +	for (i = 0; i < size; i++) {
> > +		if (names[i].id == id->id)
> > +			return names[i].name;
> >  	}
> > +
> >  	return "UNKNOWN";
> >  }
> >  
> 
> 
> 
While it is true the change was structured with efficiency in mind; the
goal was to enable printing for non-BCM cores.  In the old code, the
statement "if (id->manuf == BCMA_MANUF_BCM) {" prevented cores from
other vendors from ever being recognized.

Nathan


