Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:58463 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbeFFMUa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jun 2018 08:20:30 -0400
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
Date: Wed, 6 Jun 2018 12:20:23 +0000
Message-ID: <b55bd6bf93eb4b7884ad05e44eded929@ti.com> (sfid-20180606_142036_668344_9451C2F0)
References: <20180529180605.73622-1-tony@atomide.com>
 <20180529180605.73622-4-tony@atomide.com> <20180531171420.GQ5705@atomide.com>
 <fe42f9d6bb744cd39e38db8f51c0b74e@ti.com> <20180605042000.GA5738@atomide.com>
 <20180605104404.GD5738@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > * Tony Lindgren <tony@atomide.com> [180605 04:22]:
> > > * Reizer, Eyal <eyalr@ti.com> [180603 06:07]:
> > > > I have noticed the following recovery a couple of times on my setup
> > when the board was
> > > > just sitting for a long time with just pings
> > > > It starts with a firmware recovery started from the interrupt handl=
er
> but
> > the recovery fails
> > >
> > > Sounds like the recovery needs some more work :)
> > >
> > > > leaving the sdio stuck.
> > > > At this stage the only way to get out of it is unload/load of the d=
river
> > modules.
> > > > Have you seen this on your side as well?
> > >
> > > Hmm I don't think I've seen this one yet.
> > >
> > > > 64 bytes from 192.168.100.1: seq=3D32772 ttl=3D64 time=3D9.644 ms
> > > > 64 bytes from 192.168.100.1: seq=3D32773 ttl=3D64 time=3D9.572 ms
> > > > 64 bytes from 192.168.100.1: seq=3D32774 ttl=3D64 time=3D10.974 ms
> > > > 64 bytes from 192.168.100.1: seq=3D32775 ttl=3D64 time=3D9.618 ms
> > > > [127899.040526] wlcore: ERROR SW watchdog interrupt received!
> starting
> > recovery.
> > >
> > > Do you know what does the SW watchdog means here? Does it mean the
> > > interrupt did not get delivered to wlcore? Or a spurious IRQ to wlcor=
e?
> > > Or a timeout waiting for the ELP wake interrupt?
> >
> > Also, can you check if patch "[RFT 7/6] wlcore: Make sure firmware is
> > initialized
> > in wl1271_op_add_interface()" already fixes this issue if you did not h=
ave it
> > already applied?
> >
> Sure will do. The firmware that showed this issue has some extra debuggin=
g
> info
> Enabled in it and this may have been the cause of the recovery (Infernal
> logging error).
> The fact that it didn't recover was the issue itself. I am now running wi=
th the
> latest's
> firmware 8.9.0.0.78 and will see if I can still replicate it.
> If I see it, I will try applying patch 7 and see if it helps. Right now I=
 don't yet
> have
> It applied.
>=20

Latest wl18xx firmware was running fine for two days without the crash, so =
it was indeed just a logging issue in this case.
However, trying a wl1281 module and enabling PLT mode it boots ok but after=
 a couple of seconds the below crash is seen.
Seems like a similar crash to the one I have seen before,right?
I do have patch 7/6 applied now.

sh-4.4# calibrator wlan0 plt power_mode on
[   57.198492] wlcore: power up
[   57.757871] wlcore: firmware booted in PLT mode PLT_ON (PLT 7.3.10.2.142=
)
sh-4.4#
sh-4.4#
sh-4.4# ca[   86.485020] ------------[ cut here ]------------
[   86.490334] WARNING: CPU: 0 PID: 502 at drivers/net/wireless/ti/wlcore/m=
ain.c:806 wl12xx_queue_recovery_work+0x64/0x6c [wlcore]
[   86.502047] Modules linked in: arc4 pru_rproc wl12xx pruss_intc wlcore m=
ac80211 cfg80211 pruss ti_am335x_tsc ti_am335x_adc musb_dsps musb_hdrc udc_=
core usbcore phy_am335x phy_generic phy_am335x_control usb_common pm33xx wk=
up_m3_ipc snd_soc_simple_card snd_soc_simple_card_utils wkup_m3_rproc remot=
eproc omap_aes_driver crypto_engine omap_sham omap_crypto ti_emif_sram prus=
s_soc_bus snd_soc_tlv320aic3x wlcore_sdio matrix_keypad rtc_omap ti_am335x_=
tscadc omap_wdt matrix_keymap musb_am335x sch_fq_codel
[   86.546686] CPU: 0 PID: 502 Comm: irq/71-wl12xx Not tainted 4.14.40-0141=
5-g47241db-dirty #119
[   86.555312] Hardware name: Generic AM33XX (Flattened Device Tree)
[   86.561540] Backtrace:
[   86.564119] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   86.571838]  r6:00000000 r5:bf30a5fc r4:00000000 r3:00000000
[   86.577661] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   86.584994] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[   86.592121] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null+=
0x28/0x30)
[   86.599838]  r10:c0d4ea79 r8:c0169590 r7:db0f1558 r6:dc716ec8 r5:dc716d3=
8 r4:dc716d00
[   86.608019] [<c01287e4>] (warn_slowpath_null) from [<bf2f5468>] (wl12xx_=
queue_recovery_work+0x64/0x6c [wlcore])
[   86.618630] [<bf2f5404>] (wl12xx_queue_recovery_work [wlcore]) from [<bf=
2f5a18>] (wlcore_irq+0x21c/0x234 [wlcore])
[   86.629157]  r4:dc716d00 r3:db164010
[   86.633009] [<bf2f57fc>] (wlcore_irq [wlcore]) from [<c01695b4>] (irq_th=
read_fn+0x24/0x3c)
[   86.641441]  r7:db0f1558 r6:db0f1500 r5:00000001 r4:db1b8680
[   86.647236] [<c0169590>] (irq_thread_fn) from [<c0169260>] (irq_thread+0=
x10c/0x1ec)
[   86.655044]  r6:db0f1500 r5:00000001 r4:db1b8680 r3:db623600
[   86.660875] [<c0169154>] (irq_thread) from [<c014526c>] (kthread+0x11c/0=
x154)
[   86.668148]  r10:c0169154 r8:db1b8680 r7:db1b8958 r6:db1b8600 r5:0000000=
0 r4:db1b8940
[   86.676104] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   86.683479]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   86.691451]  r4:db1b8600 r3:ffffffff
[   86.695099] ---[ end trace dea7def5777109c9 ]---

BR,
Eyal
