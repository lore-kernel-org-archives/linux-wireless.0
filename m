Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:61718 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754540AbeFNIge (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 04:36:34 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        "Shahar Patury" <shaharp@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [RFT 3/6] wlcore: Add support for runtime PM
Date: Thu, 14 Jun 2018 08:36:28 +0000
Message-ID: <e653ffeaa6ca48209cbcc42887711969@ti.com> (sfid-20180614_103641_928155_5D5A7E1D)
References: <20180529180605.73622-1-tony@atomide.com>
 <20180529180605.73622-4-tony@atomide.com> <20180531171420.GQ5705@atomide.com>
 <fe42f9d6bb744cd39e38db8f51c0b74e@ti.com> <20180605042000.GA5738@atomide.com>
 <20180605104404.GD5738@atomide.com>  
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> However, trying a wl1281 module and enabling PLT mode it boots ok but af=
ter a couple of seconds the below crash is seen.
>> Seems like a similar crash to the one I have seen before,right?
>
>Sorry for the delay, only today had enough time to figure
>this one out, see below.
>
>> sh-4.4# calibrator wlan0 plt power_mode on
>> [   57.198492] wlcore: power up
>> [   57.757871] wlcore: firmware booted in PLT mode PLT_ON (PLT 7.3.10.2.=
142)
>> sh-4.4#
>> sh-4.4#
>> sh-4.4# ca[   86.485020] ------------[ cut here ]------------
>> [   86.490334] WARNING: CPU: 0 PID: 502 at drivers/net/wireless/ti/wlcor=
e/main.c:806
>
>This happens on runtime_suspend() where we are already in PLT
>and then that error gets stored and then next pm_runtime_get()
>returns -EINVAL. The patch below should fix it. I'll fold it
i>nto the runtime PM related patch assuming it works for you.
>
>Regards,
>
>Tony
>
>8< -------
>diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/=
ti/wlcore/main.c
>--- a/drivers/net/wireless/ti/wlcore/main.c
>+++ b/drivers/net/wireless/ti/wlcore/main.c
>@@ -6677,7 +6677,7 @@ static int __maybe_unused wlcore_runtime_suspend(str=
uct device *dev)
>=20
> 	/* We do not enter elp sleep in PLT mode */
> 	if (wl->plt)
>-		return -EINVAL;
>+		return 0;
>=20
> 	/* Nothing to do if no ELP mode requested */
> 	if (wl->sleep_auth !=3D WL1271_PSM_ELP)

Even with this change I still see issues with a wl1281 module plugged in.
It take a few seconds for the crash to happen once you turn plt on.
Log below.
Do you see this on your wl12xx based platform?

sh-4.4#
sh-4.4# calibrator wlan0 plt power_mode on
[  231.105877] wlcore: power up
[  231.667604] wlcore: firmware booted in PLT mode PLT_ON (PLT 7.3.10.2.142=
)
sh-4.4#
sh-4.4#
sh-4.4# [  236.900817] ------------[ cut here ]------------
[  236.906012] WARNING: CPU: 0 PID: 520 at drivers/net/wireless/ti/wlcore/m=
ain.c:806 wl12xx_queue_recovery_work+0x64/0x6c [wlcore]
[  236.917783] Modules linked in: ctr aes_arm_bs crypto_simd cryptd ccm arc=
4 pru_rproc pruss_intc wl12xx wlcore mac80211 cfg80211 pruss musb_dsps musb=
_hdrc udc_core usbcore phy_am335x phy_generic usb_common phy_am335x_control=
 ti_am335x_adc ti_am335x_tsc snd_soc_simple_card snd_soc_simple_card_utils =
pm33xx wkup_m3_ipc wkup_m3_rproc remoteproc omap_aes_driver crypto_engine o=
map_crypto omap_sham ti_emif_sram pruss_soc_bus wlcore_sdio snd_soc_tlv320a=
ic3x rtc_omap musb_am335x omap_wdt ti_am335x_tscadc matrix_keypad matrix_ke=
ymap sch_fq_codel
[  236.965780] CPU: 0 PID: 520 Comm: irq/71-wl12xx Not tainted 4.14.40-0141=
5-g47241db-dirty #123
[  236.974439] Hardware name: Generic AM33XX (Flattened Device Tree)
[  236.980666] Backtrace:
[  236.983250] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[  236.990967]  r6:00000000 r5:bf2e25fc r4:00000000 r3:00000000
[  236.996799] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[  237.004145] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[  237.011339] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null+=
0x28/0x30)
[  237.019099]  r10:c0d4ea79 r8:c0169590 r7:db1bee58 r6:dc726ec8 r5:dc726d3=
8 r4:dc726d00
[  237.027285] [<c01287e4>] (warn_slowpath_null) from [<bf2cd468>] (wl12xx_=
queue_recovery_work+0x64/0x6c [wlcore])
[  237.037892] [<bf2cd404>] (wl12xx_queue_recovery_work [wlcore]) from [<bf=
2cda18>] (wlcore_irq+0x21c/0x234 [wlcore])
[  237.048412]  r4:dc726d00 r3:db2d3810
[  237.052260] [<bf2cd7fc>] (wlcore_irq [wlcore]) from [<c01695b4>] (irq_th=
read_fn+0x24/0x3c)
[  237.060688]  r7:db1bee58 r6:db1bee00 r5:00000001 r4:db1af3c0
[  237.066481] [<c0169590>] (irq_thread_fn) from [<c0169260>] (irq_thread+0=
x10c/0x1ec)
[  237.074242]  r6:db1bee00 r5:00000001 r4:db1af3c0 r3:dc73aa00
[  237.080069] [<c0169154>] (irq_thread) from [<c014526c>] (kthread+0x11c/0=
x154)
[  237.087350]  r10:c0169154 r8:db1af3c0 r7:db1af918 r6:db1af340 r5:0000000=
0 r4:db1af900
[  237.095305] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[  237.102673]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[  237.110646]  r4:db1af340 r3:ffffffff
[  237.114292] ---[ end trace 2c3213a5c8df86b0 ]---
[  237.856438] sched: RT throttling activated
[  238.886549] omap_i2c 44e0b000.i2c: controller timed out
[  242.846592] omap_i2c 44e0b000.i2c: controller timed out

BR,
Eyal
