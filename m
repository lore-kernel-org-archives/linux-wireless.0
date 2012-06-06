Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47822 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2FFIKp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:10:45 -0400
Received: by eaak11 with SMTP id k11so1821938eaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 01:10:44 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/8] bcma: Fix for 4329b0 bad LPOM is detection
Date: Wed, 06 Jun 2012 10:08:15 +0200
Message-ID: <2043822.26J1ek8FFi@flexo> (sfid-20120606_101050_708293_7A83EFCB)
In-Reply-To: <1338933307-13446-4-git-send-email-hauke@hauke-m.de>
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de> <1338933307-13446-4-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

On Tuesday 05 June 2012 23:55:02 Hauke Mehrtens wrote:
> This workaround should be triggered based on the chipid and rev and not
> the core id and rev. This is based on code in the Broadcom SDK.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/bcma/driver_chipcommon_pmu.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/bcma/driver_chipcommon_pmu.c 
b/drivers/bcma/driver_chipcommon_pmu.c
> index da8769e..dd2b55d 100644
> --- a/drivers/bcma/driver_chipcommon_pmu.c
> +++ b/drivers/bcma/driver_chipcommon_pmu.c
> @@ -166,6 +166,7 @@ static void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
>  void bcma_pmu_init(struct bcma_drv_cc *cc)
>  {
>  	u32 pmucap;
> +	struct bcma_bus *bus = cc->core->bus;
>  
>  	pmucap = bcma_cc_read32(cc, BCMA_CC_PMU_CAP);
>  	cc->pmu.rev = (pmucap & BCMA_CC_PMU_CAP_REVISION);
> @@ -180,7 +181,7 @@ void bcma_pmu_init(struct bcma_drv_cc *cc)
>  		bcma_cc_set32(cc, BCMA_CC_PMU_CTL,
>  			     BCMA_CC_PMU_CTL_NOILPONW);
>  
> -	if (cc->core->id.id == 0x4329 && cc->core->id.rev == 2)
> +	if (bus->chipinfo.id == 0x4329 && bus->chipinfo.rev == 2)
>  		pr_err("Fix for 4329b0 bad LPOM state not implemented!\n");

Does not that deserve a new define to be in line with your previous patch?
--
Florian
