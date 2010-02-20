Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:58488 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab0BTRhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2010 12:37:02 -0500
Received: by fg-out-1718.google.com with SMTP id 19so36320fgg.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Feb 2010 09:37:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4b7ed244.kkOlTpyZEarNKwxu%Larry.Finger@lwfinger.net>
References: <4b7ed244.kkOlTpyZEarNKwxu%Larry.Finger@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 20 Feb 2010 18:36:40 +0100
Message-ID: <69e28c911002200936y33e2e9duc9c3f40253acf473@mail.gmail.com>
Subject: Re: [PATCH] ssb: Add PCI ID 0x4322 to PHU handling
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2010 at 7:02 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Some of the N PHYs need a revision in the handling of the PMU.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> John,
>
> This will be needed for some of the N PHY devices - 2.6.34 amterial.
>
> Larry
> ---
>
> Index: wireless-testing/drivers/ssb/driver_chipcommon_pmu.c
> ===================================================================
> --- wireless-testing.orig/drivers/ssb/driver_chipcommon_pmu.c
> +++ wireless-testing/drivers/ssb/driver_chipcommon_pmu.c
> @@ -332,6 +332,12 @@ static void ssb_pmu_pll_init(struct ssb_
>        case 0x5354:
>                ssb_pmu0_pllinit_r0(cc, crystalfreq);
>                break;
> +       case 0x4322:
> +               if (cc->pmu.rev == 2) {
> +                       chipco_write32(cc, SSB_CHIPCO_PLLCTL_ADDR, 0x0000000A);
> +                       chipco_write32(cc, SSB_CHIPCO_PLLCTL_DATA, 0x380005C0);
> +               }
> +               break;
>        default:
>                ssb_printk(KERN_ERR PFX
>                           "ERROR: PLL init unknown for device %04X\n",
> @@ -417,6 +423,7 @@ static void ssb_pmu_resources_init(struc
>
>        switch (bus->chip_id) {
>        case 0x4312:
> +       case 0x4322:
>                /* We keep the default settings:
>                 * min_msk = 0xCBB
>                 * max_msk = 0x7FFFF
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>

Typo in title - PHU should be PMU.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
