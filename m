Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:4898 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118Ab2C0STB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 14:19:01 -0400
Message-ID: <4F720494.3030509@gmail.com> (sfid-20120327_201906_074442_A464B953)
Date: Tue, 27 Mar 2012 20:19:00 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Jakub Kicinski <kubakici@wp.pl>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/4] rt2x00: broaden PCIE L1-state wakeup configuration
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl> <1332859867-27921-2-git-send-email-kubakici@wp.pl>
In-Reply-To: <1332859867-27921-2-git-send-email-kubakici@wp.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jakub,

On 03/27/12 16:51, Jakub Kicinski wrote:
> Broaden wakeup configuration to all PCIE from rt3xxx on.
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> ---
> 2011_0406_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO
> rtmp_init_inf.c:171
> 
> Legacy driver applies this configuration to the following devices:
> 3071 3090 3572 3592 3562 3062 3390 3593 5390 5370 5392 5372 5360 5362
> if they are working on PCIE bus. AFAIK these are all post 2xxx PCIE
> devices.
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    4 +---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    5 +----
>  2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 6c0a12e..4722030 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -401,9 +401,7 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
>  		return -EBUSY;
>  
>  	if (rt2x00_is_pci(rt2x00dev)) {
> -		if (rt2x00_rt(rt2x00dev, RT3572) ||
> -		    rt2x00_rt(rt2x00dev, RT5390) ||
> -		    rt2x00_rt(rt2x00dev, RT5392)) {
> +		if (rt2x00_is_pcie(rt2x00dev) && rt2x00dev->chip.rt > 0x3000) {
>  			rt2800_register_read(rt2x00dev, AUX_CTRL, &reg);
>  			rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
>  			rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);

I don't like the comparison against 0x3000. Maybe you should invert the
conditions and test for the chipsets for which this does not have to be
applied (e.g. !rt2x00_rt(rt2x00dev, RT2860) && !rt2x00_rt(rt2x00dev,
RT2872).
Also, the flow looks a bit strange here. The old code applied to all PCI
and PCIe devices, now you narrow it down to just PCIe devices.
Is that right?
Can anything be done to the strange flow now, with first checking for
PCI and PCIe devices and then immediately only for PCIe devices?

> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 0397bbf..5a2f68f 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -478,10 +478,7 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
>  	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
>  	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
>  
> -	if (rt2x00_is_pcie(rt2x00dev) &&
> -	    (rt2x00_rt(rt2x00dev, RT3572) ||
> -	     rt2x00_rt(rt2x00dev, RT5390) ||
> -	     rt2x00_rt(rt2x00dev, RT5392))) {
> +	if (rt2x00_is_pcie(rt2x00dev) && rt2x00dev->chip.rt > 0x3000) {
>  		rt2x00pci_register_read(rt2x00dev, AUX_CTRL, &reg);
>  		rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
>  		rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);

---
Gertjan
