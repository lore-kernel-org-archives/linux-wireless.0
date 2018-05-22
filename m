Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:15454 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbeEVGkn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 02:40:43 -0400
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
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy, Chen" <c-loewy@ti.com>
Subject: RE: [EXTERNAL] [PATCHv2 0/5] Runtime PM support for wlcore
Date: Tue, 22 May 2018 06:40:32 +0000
Message-ID: <3793c7c0d2b140389c7b92a407125650@ti.com> (sfid-20180522_084049_217489_6B689BD9)
References: <20180517185029.71716-1-tony@atomide.com>
 <bff51dcc6fd441d9ab42db273219aaf4@ti.com>
 <20180521163830.GZ98604@atomide.com> <20180521224339.GD98604@atomide.com>
In-Reply-To: <20180521224339.GD98604@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> > This warning is because wlcore is wlcore is still in ELP. This is
> > somehow possible even though we call pm_runtime_get_sync() in
> > wl1271_op_resume(). Anyways, I'll try to reproduce it here.
>=20
> Sorry I can't somehow get my beagleboard to wake-up from suspend,
> I'm almost certain that worked the last time I tried.
>=20
> Anyways, maybe the following patch fixes this if you care to
> test again.
>=20
> Regards,
>=20
> Tony
>=20
> 8< ------------------------
> diff --git a/drivers/net/wireless/ti/wlcore/main.c
> b/drivers/net/wireless/ti/wlcore/main.c
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -1867,8 +1867,6 @@ static int __maybe_unused
> wl1271_op_resume(struct ieee80211_hw *hw)
>  			if (ret)
>  				wl12xx_queue_recovery_work(wl);
>  		}
> -
> -		wlcore_enable_interrupts(wl);
>  	}
>=20
>  	if (pending_recovery) {
> @@ -1877,6 +1875,8 @@ static int __maybe_unused
> wl1271_op_resume(struct ieee80211_hw *hw)
>  		goto out_sleep;
>  	}
>=20
> +	wlcore_enable_interrupts(wl);
> +
>  	ret =3D pm_runtime_get_sync(wl->dev);
>  	if (ret < 0) {
>  		pm_runtime_put_noidle(wl->dev);

It still crash.
The crash is different now.
It also complains about:
[   60.544224] Unbalanced enable for IRQ 65
Need down/up of the interface to recover after it.
Log below:

root@am335x-evm:~#
root@am335x-evm:~#
root@am335x-evm:~# echo mem > /sys/power/state
[   42.994534] PM: suspend entry (deep)
[   42.998182] PM: Syncing filesystems ... done.
[   43.946134] Freezing user space processes ... (elapsed 0.002 seconds) do=
ne.
[   43.957020] OOM killer disabled.
[   43.960449] Freezing remaining freezable tasks ... (elapsed 0.002 second=
s) done.
[   43.971227] Suspending console(s) (use no_console_suspend to debug)
[   44.093784] wlcore: down
[   44.181597] pm33xx pm33xx: PM: Successfully put all powerdomains to targ=
et state
[   44.181597] PM: Wakeup source UART
[   44.206334] net eth0: initializing cpsw version 1.12 (0)
[   44.304417] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver [=
SMSC LAN8710/LAN8720] (mii_bus:phy_addr=3D4a101000.mdio:00, irq=3DPOLL)
[   44.650784] wlcore: PHY firmware version: Rev 8.2.0.0.242
[   44.746182] wlcore: firmware booted (Rev 8.9.0.0.78)
[   44.929226] OOM killer enabled.
[   44.932602] Restarting tasks ... done.
[   44.961136] PM: suspend exit
root@am335x-evm:~# iw phy0 wowlan enable any
root@am335x-evm:~#
root@am335x-evm:~#
root@am335x-evm:~#
root@am335x-evm:~#
root@am335x-evm:~# echo mem > /sys/power/state
[   60.114495] PM: suspend entry (deep)
[   60.118146] PM: Syncing filesystems ... done.
[   60.139243] Freezing user space processes ... (elapsed 0.001 seconds) do=
ne.
[   60.148483] OOM killer disabled.
[   60.151723] Freezing remaining freezable tasks ... (elapsed 0.001 second=
s) done.
[   60.160874] Suspending console(s) (use no_console_suspend to debug)
[   60.411089] pm33xx pm33xx: PM: Successfully put all powerdomains to targ=
et state
[   60.411089] PM: Wakeup source UART
[   60.435069] net eth0: initializing cpsw version 1.12 (0)
[   60.534303] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver [=
SMSC LAN8710/LAN8720] (mii_bus:phy_addr=3D4a101000.mdio:00, irq=3DPOLL)
[   60.544143] ------------[ cut here ]------------
[   60.544213] WARNING: CPU: 0 PID: 730 at kernel/irq/manage.c:525 __enable=
_irq+0x4c/0x6c
[   60.544224] Unbalanced enable for IRQ 65
[   60.544232] Modules linked in: usb_f_acm u_serial arc4 pru_rproc pruss_i=
ntc wl18xx usb_f_ecm wlcore musb_dsps mac80211 musb_hdrc cfg80211 pruss phy=
_am335x usbcore phy_generic phy_am335x_control xfrm_user xfrm4_tunnel ipcom=
p xfrm_ipcomp esp4 ah4 af_key xfrm_algo g_multi usb_f_mass_storage usb_f_rn=
dis u_ether libcomposite udc_core usb_common bluetooth ecdh_generic snd_soc=
_simple_card snd_soc_simple_card_utils wkup_m3_rproc pm33xx wkup_m3_ipc rem=
oteproc omap_aes_driver crypto_engine omap_crypto omap_sham ti_emif_sram pr=
uss_soc_bus wlcore_sdio rtc_omap musb_am335x omap_wdt sch_fq_codel
[   60.544574] CPU: 0 PID: 730 Comm: kworker/u2:11 Not tainted 4.14.40-0141=
3-g36a61bea-dirty #105
[   60.544584] Hardware name: Generic AM33XX (Flattened Device Tree)
[   60.544624] Workqueue: events_unbound async_run_entry_fn
[   60.544639] Backtrace:
[   60.544698] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   60.544722]  r6:00000000 r5:c0a95d64 r4:db363d78 r3:c0d53158
[   60.544758] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   60.544794] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[   60.544821] [<c01286e0>] (__warn) from [<c012889c>] (warn_slowpath_fmt+0=
x40/0x48)
[   60.544848]  r10:c0d5310c r8:00000000 r7:db5a6d38 r6:00000000 r5:0000004=
1 r4:00000000
[   60.544874] [<c0128860>] (warn_slowpath_fmt) from [<c0169760>] (__enable=
_irq+0x4c/0x6c)
[   60.544889]  r3:00000041 r2:c0a95ec4
[   60.544898]  r4:db278000
[   60.544922] [<c0169714>] (__enable_irq) from [<c01697bc>] (enable_irq+0x=
3c/0x74)
[   60.545265] [<c0169780>] (enable_irq) from [<bf39e068>] (wlcore_enable_i=
nterrupts+0x14/0x18 [wlcore])
[   60.545280]  r5:db5a6d00 r4:bf3b3c40
[   60.545619] [<bf39e054>] (wlcore_enable_interrupts [wlcore]) from [<bf39=
9428>] (wl1271_op_resume+0x144/0x334 [wlcore])
[   60.546524] [<bf3992e4>] (wl1271_op_resume [wlcore]) from [<bf3291f8>] (=
ieee80211_reconfig+0x418/0xc0c [mac80211])
[   60.546548]  r7:db5a628c r6:bf26d640 r5:00000000 r4:db5a6420
[   60.547408] [<bf328de0>] (ieee80211_reconfig [mac80211]) from [<bf314ab8=
>] (ieee80211_resume+0x58/0x70 [mac80211])
[   60.547436]  r10:c0d5310c r9:db5a6258 r8:00000000 r7:db5a628c r6:bf26d64=
0 r5:00000000
[   60.547446]  r4:db5a6420
[   60.548310] [<bf314a60>] (ieee80211_resume [mac80211]) from [<bf26d694>]=
 (wiphy_resume+0x54/0x64 [cfg80211])
[   60.548326]  r4:db5a6258 r3:bf314a60
[   60.548611] [<bf26d640>] (wiphy_resume [cfg80211]) from [<c053c79c>] (dp=
m_run_callback+0x40/0xcc)
[   60.548625]  r4:00000000 r3:00000000
[   60.548652] [<c053c75c>] (dpm_run_callback) from [<c053ce24>] (device_re=
sume+0xbc/0x234)
[   60.548679]  r10:00000000 r9:dc005000 r8:00000000 r6:00000010 r5:0000000=
1 r4:db5a6258
[   60.548706] [<c053cd68>] (device_resume) from [<c053cfbc>] (async_resume=
+0x20/0x4c)
[   60.548732]  r8:00000000 r7:dc004100 r6:c0d4fde0 r5:c0d89b30 r4:db5a6258=
 r3:00000000
[   60.548765] [<c053cf9c>] (async_resume) from [<c01483e4>] (async_run_ent=
ry_fn+0x44/0x140)
[   60.548779]  r5:db56f480 r4:db56f490
[   60.548810] [<c01483a0>] (async_run_entry_fn) from [<c013f128>] (process=
_one_work+0x12c/0x374)
[   60.548830]  r6:dc005000 r5:db56f490 r4:db44eb80 r3:c01483a0
[   60.548855] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   60.548882]  r10:00000088 r9:dc005000 r8:c0d16380 r7:db44eb98 r6:dc00501=
4 r5:dc005000
[   60.548891]  r4:db44eb80
[   60.548924] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   60.548950]  r10:c013f3b0 r9:db3cfeb4 r8:db44eb80 r7:db56ff58 r6:db56f40=
0 r5:00000000
[   60.548963]  r4:db56ff40 r3:00000000
[   60.548996] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   60.549022]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   60.549034]  r4:db56f400 r3:ffffffff
[   60.549047] ---[ end trace 06c90d424e072151 ]---
[   60.549082] ------------[ cut here ]------------
[   60.549343] WARNING: CPU: 0 PID: 730 at drivers/net/wireless/ti/wlcore/c=
md.c:76 wlcore_cmd_send_failsafe+0x498/0x4f8 [wlcore]
[   60.549352] Modules linked in: usb_f_acm u_serial arc4 pru_rproc pruss_i=
ntc wl18xx usb_f_ecm wlcore musb_dsps mac80211 musb_hdrc cfg80211 pruss phy=
_am335x usbcore phy_generic phy_am335x_control xfrm_user xfrm4_tunnel ipcom=
p xfrm_ipcomp esp4 ah4 af_key xfrm_algo g_multi usb_f_mass_storage usb_f_rn=
dis u_ether libcomposite udc_core usb_common bluetooth ecdh_generic snd_soc=
_simple_card snd_soc_simple_card_utils wkup_m3_rproc pm33xx wkup_m3_ipc rem=
oteproc omap_aes_driver crypto_engine omap_crypto omap_sham ti_emif_sram pr=
uss_soc_bus wlcore_sdio rtc_omap musb_am335x omap_wdt sch_fq_codel
[   60.549675] CPU: 0 PID: 730 Comm: kworker/u2:11 Tainted: G        W     =
  4.14.40-01413-g36a61bea-dirty #105
[   60.549685] Hardware name: Generic AM33XX (Flattened Device Tree)
[   60.549714] Workqueue: events_unbound async_run_entry_fn
[   60.549728] Backtrace:
[   60.549773] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   60.549794]  r6:00000000 r5:bf3ae59c r4:00000000 r3:c0d53158
[   60.549828] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   60.549861] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[   60.549888] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null+=
0x28/0x30)
[   60.549915]  r10:c0d5310c r8:00000000 r7:db5a6d38 r6:db1b1980 r5:0000000=
c r4:db5a6d00
[   60.550110] [<c01287e4>] (warn_slowpath_null) from [<bf39a8b0>] (wlcore_=
cmd_send_failsafe+0x498/0x4f8 [wlcore])
[   60.550443] [<bf39a418>] (wlcore_cmd_send_failsafe [wlcore]) from [<bf39=
bea8>] (wlcore_cmd_configure_failsafe+0x60/0xd8 [wlcore])
[   60.550470]  r10:c0d5310c r9:db5a6258 r8:00000000 r7:db5a6d38 r6:0000005=
7 r5:db5a6d00
[   60.550480]  r4:db1b1980
[   60.550808] [<bf39be48>] (wlcore_cmd_configure_failsafe [wlcore]) from [=
<bf39bf3c>] (wl1271_cmd_configure+0x1c/0x28 [wlcore])
[   60.550825]  r6:00000001 r5:db5a6d00 r4:db1b1980
[   60.551133] [<bf39bf20>] (wl1271_cmd_configure [wlcore]) from [<bf3d47e8=
>] (wl18xx_acx_interrupt_notify_config+0x48/0x80 [wl18xx])
[   60.551374] [<bf3d47a0>] (wl18xx_acx_interrupt_notify_config [wl18xx]) f=
rom [<bf3994f4>] (wl1271_op_resume+0x210/0x334 [wlcore])
[   60.551395]  r6:db5a6e20 r5:db5a6d00 r4:db5a6e1c r3:bf3e3000
[   60.552096] [<bf3992e4>] (wl1271_op_resume [wlcore]) from [<bf3291f8>] (=
ieee80211_reconfig+0x418/0xc0c [mac80211])
[   60.552118]  r7:db5a628c r6:bf26d640 r5:00000000 r4:db5a6420
[   60.552941] [<bf328de0>] (ieee80211_reconfig [mac80211]) from [<bf314ab8=
>] (ieee80211_resume+0x58/0x70 [mac80211])
[   60.552968]  r10:c0d5310c r9:db5a6258 r8:00000000 r7:db5a628c r6:bf26d64=
0 r5:00000000
[   60.553361]  r4:db5a6420
[   60.554209] [<bf314a60>] (ieee80211_resume [mac80211]) from [<bf26d694>]=
 (wiphy_resume+0x54/0x64 [cfg80211])
[   60.554226]  r4:db5a6258 r3:bf314a60
[   60.554500] [<bf26d640>] (wiphy_resume [cfg80211]) from [<c053c79c>] (dp=
m_run_callback+0x40/0xcc)
[   60.554515]  r4:00000000 r3:00000000
[   60.554543] [<c053c75c>] (dpm_run_callback) from [<c053ce24>] (device_re=
sume+0xbc/0x234)
[   60.554569]  r10:00000000 r9:dc005000 r8:00000000 r6:00000010 r5:0000000=
1 r4:db5a6258
[   60.554596] [<c053cd68>] (device_resume) from [<c053cfbc>] (async_resume=
+0x20/0x4c)
[   60.554623]  r8:00000000 r7:dc004100 r6:c0d4fde0 r5:c0d89b30 r4:db5a6258=
 r3:00000000
[   60.554655] [<c053cf9c>] (async_resume) from [<c01483e4>] (async_run_ent=
ry_fn+0x44/0x140)
[   60.554669]  r5:db56f480 r4:db56f490
[   60.554699] [<c01483a0>] (async_run_entry_fn) from [<c013f128>] (process=
_one_work+0x12c/0x374)
[   60.554719]  r6:dc005000 r5:db56f490 r4:db44eb80 r3:c01483a0
[   60.554744] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   60.554770]  r10:00000088 r9:dc005000 r8:c0d16380 r7:db44eb98 r6:dc00501=
4 r5:dc005000
[   60.554780]  r4:db44eb80
[   60.554811] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   60.554837]  r10:c013f3b0 r9:db3cfeb4 r8:db44eb80 r7:db56ff58 r6:db56f40=
0 r5:00000000
[   60.554850]  r4:db56ff40 r3:00000000
[   60.554883] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   60.554909]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   60.554923]  r4:db56f400 r3:ffffffff
[   60.554937] ---[ end trace 06c90d424e072152 ]---
[   60.554950] ------------[ cut here ]------------
[   60.555200] WARNING: CPU: 0 PID: 730 at drivers/net/wireless/ti/wlcore/i=
o.h:66 wlcore_cmd_send_failsafe+0xb8/0x4f8 [wlcore]
[   60.555208] Modules linked in: usb_f_acm u_serial arc4 pru_rproc pruss_i=
ntc wl18xx usb_f_ecm wlcore musb_dsps mac80211 musb_hdrc cfg80211 pruss phy=
_am335x usbcore phy_generic phy_am335x_control xfrm_user xfrm4_tunnel ipcom=
p xfrm_ipcomp esp4 ah4 af_key xfrm_algo g_multi usb_f_mass_storage usb_f_rn=
dis u_ether libcomposite udc_core usb_common bluetooth ecdh_generic snd_soc=
_simple_card snd_soc_simple_card_utils wkup_m3_rproc pm33xx wkup_m3_ipc rem=
oteproc omap_aes_driver crypto_engine omap_crypto omap_sham ti_emif_sram pr=
uss_soc_bus wlcore_sdio rtc_omap musb_am335x omap_wdt sch_fq_codel
[   60.555529] CPU: 0 PID: 730 Comm: kworker/u2:11 Tainted: G        W     =
  4.14.40-01413-g36a61bea-dirty #105
[   60.555539] Hardware name: Generic AM33XX (Flattened Device Tree)
[   60.555568] Workqueue: events_unbound async_run_entry_fn
[   60.555582] Backtrace:
[   60.555627] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   60.555647]  r6:00000000 r5:bf3ae61c r4:00000000 r3:c0d53158
[   60.555679] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   60.555710] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[   60.555739] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null+=
0x28/0x30)
[   60.555766]  r10:c0d5310c r8:00000000 r7:db5a6d38 r6:db1b1980 r5:0000000=
c r4:db5a6d00
[   60.555961] [<c01287e4>] (warn_slowpath_null) from [<bf39a4d0>] (wlcore_=
cmd_send_failsafe+0xb8/0x4f8 [wlcore])
[   60.556294] [<bf39a418>] (wlcore_cmd_send_failsafe [wlcore]) from [<bf39=
bea8>] (wlcore_cmd_configure_failsafe+0x60/0xd8 [wlcore])
[   60.556321]  r10:c0d5310c r9:db5a6258 r8:00000000 r7:db5a6d38 r6:0000005=
7 r5:db5a6d00
[   60.556331]  r4:db1b1980
[   60.556659] [<bf39be48>] (wlcore_cmd_configure_failsafe [wlcore]) from [=
<bf39bf3c>] (wl1271_cmd_configure+0x1c/0x28 [wlcore])
[   60.556676]  r6:00000001 r5:db5a6d00 r4:db1b1980
[   60.556952] [<bf39bf20>] (wl1271_cmd_configure [wlcore]) from [<bf3d47e8=
>] (wl18xx_acx_interrupt_notify_config+0x48/0x80 [wl18xx])
[   60.557193] [<bf3d47a0>] (wl18xx_acx_interrupt_notify_config [wl18xx]) f=
rom [<bf3994f4>] (wl1271_op_resume+0x210/0x334 [wlcore])
[   60.557214]  r6:db5a6e20 r5:db5a6d00 r4:db5a6e1c r3:bf3e3000
[   60.557892] [<bf3992e4>] (wl1271_op_resume [wlcore]) from [<bf3291f8>] (=
ieee80211_reconfig+0x418/0xc0c [mac80211])
[   60.557913]  r7:db5a628c r6:bf26d640 r5:00000000 r4:db5a6420
[   60.558735] [<bf328de0>] (ieee80211_reconfig [mac80211]) from [<bf314ab8=
>] (ieee80211_resume+0x58/0x70 [mac80211])
[   60.558762]  r10:c0d5310c r9:db5a6258 r8:00000000 r7:db5a628c r6:bf26d64=
0 r5:00000000
[   60.558771]  r4:db5a6420
[   60.559488] [<bf314a60>] (ieee80211_resume [mac80211]) from [<bf26d694>]=
 (wiphy_resume+0x54/0x64 [cfg80211])
[   60.559502]  r4:db5a6258 r3:bf314a60
[   60.559770] [<bf26d640>] (wiphy_resume [cfg80211]) from [<c053c79c>] (dp=
m_run_callback+0x40/0xcc)
[   60.559784]  r4:00000000 r3:00000000
[   60.559811] [<c053c75c>] (dpm_run_callback) from [<c053ce24>] (device_re=
sume+0xbc/0x234)
[   60.559838]  r10:00000000 r9:dc005000 r8:00000000 r6:00000010 r5:0000000=
1 r4:db5a6258
[   60.559864] [<c053cd68>] (device_resume) from [<c053cfbc>] (async_resume=
+0x20/0x4c)
[   60.559890]  r8:00000000 r7:dc004100 r6:c0d4fde0 r5:c0d89b30 r4:db5a6258=
 r3:00000000
[   60.559919] [<c053cf9c>] (async_resume) from [<c01483e4>] (async_run_ent=
ry_fn+0x44/0x140)
[   60.559933]  r5:db56f480 r4:db56f490
[   60.559962] [<c01483a0>] (async_run_entry_fn) from [<c013f128>] (process=
_one_work+0x12c/0x374)
[   60.559982]  r6:dc005000 r5:db56f490 r4:db44eb80 r3:c01483a0
[   60.560006] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   60.560032]  r10:00000088 r9:dc005000 r8:c0d16380 r7:db44eb98 r6:dc00501=
4 r5:dc005000
[   60.560041]  r4:db44eb80
[   60.560071] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   60.560097]  r10:c013f3b0 r9:db3cfeb4 r8:db44eb80 r7:db56ff58 r6:db56f40=
0 r5:00000000
[   60.560110]  r4:db56ff40 r3:00000000
[   60.560140] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   60.560166]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   60.560179]  r4:db56f400 r3:ffffffff
[   60.560190] ---[ end trace 06c90d424e072153 ]---
[   60.560200] ------------[ cut here ]------------
[   60.560417] WARNING: CPU: 0 PID: 730 at drivers/net/wireless/ti/wlcore/m=
ain.c:806 wl12xx_queue_recovery_work+0x64/0x6c [wlcore]
[   60.560424] Modules linked in: usb_f_acm u_serial arc4 pru_rproc pruss_i=
ntc wl18xx usb_f_ecm wlcore musb_dsps mac80211 musb_hdrc cfg80211 pruss phy=
_am335x usbcore phy_generic phy_am335x_control xfrm_user xfrm4_tunnel ipcom=
p xfrm_ipcomp esp4 ah4 af_key xfrm_algo g_multi usb_f_mass_storage usb_f_rn=
dis u_ether libcomposite udc_core usb_common bluetooth ecdh_generic snd_soc=
_simple_card snd_soc_simple_card_utils wkup_m3_rproc pm33xx wkup_m3_ipc rem=
oteproc omap_aes_driver crypto_engine omap_crypto omap_sham ti_emif_sram pr=
uss_soc_bus wlcore_sdio rtc_omap musb_am335x omap_wdt sch_fq_codel
[   60.560736] CPU: 0 PID: 730 Comm: kworker/u2:11 Tainted: G        W     =
  4.14.40-01413-g36a61bea-dirty #105
[   60.560746] Hardware name: Generic AM33XX (Flattened Device Tree)
[   60.560772] Workqueue: events_unbound async_run_entry_fn
[   60.560785] Backtrace:
[   60.560825] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   60.560847]  r6:00000000 r5:bf3ac5f4 r4:00000000 r3:c0d53158
[   60.560877] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   60.560908] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[   60.560934] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null+=
0x28/0x30)
[   60.560961]  r10:c0d5310c r8:00000000 r7:db5a6d38 r6:db1b1980 r5:0000000=
c r4:db5a6d00
[   60.561154] [<c01287e4>] (warn_slowpath_null) from [<bf3974d0>] (wl12xx_=
queue_recovery_work+0x64/0x6c [wlcore])
[   60.561485] [<bf39746c>] (wl12xx_queue_recovery_work [wlcore]) from [<bf=
39a498>] (wlcore_cmd_send_failsafe+0x80/0x4f8 [wlcore])
[   60.561500]  r4:db5a6d00 r3:c0d53158
[   60.561826] [<bf39a418>] (wlcore_cmd_send_failsafe [wlcore]) from [<bf39=
bea8>] (wlcore_cmd_configure_failsafe+0x60/0xd8 [wlcore])
[   60.561852]  r10:c0d5310c r9:db5a6258 r8:00000000 r7:db5a6d38 r6:0000005=
7 r5:db5a6d00
[   60.561862]  r4:db1b1980
[   60.562188] [<bf39be48>] (wlcore_cmd_configure_failsafe [wlcore]) from [=
<bf39bf3c>] (wl1271_cmd_configure+0x1c/0x28 [wlcore])
[   60.562205]  r6:00000001 r5:db5a6d00 r4:db1b1980
[   60.562466] [<bf39bf20>] (wl1271_cmd_configure [wlcore]) from [<bf3d47e8=
>] (wl18xx_acx_interrupt_notify_config+0x48/0x80 [wl18xx])
[   60.562708] [<bf3d47a0>] (wl18xx_acx_interrupt_notify_config [wl18xx]) f=
rom [<bf3994f4>] (wl1271_op_resume+0x210/0x334 [wlcore])
[   60.562729]  r6:db5a6e20 r5:db5a6d00 r4:db5a6e1c r3:bf3e3000
[   60.563368] [<bf3992e4>] (wl1271_op_resume [wlcore]) from [<bf3291f8>] (=
ieee80211_reconfig+0x418/0xc0c [mac80211])
[   60.563526]  r7:db5a628c r6:bf26d640 r5:00000000 r4:db5a6420
[   60.564377] [<bf328de0>] (ieee80211_reconfig [mac80211]) from [<bf314ab8=
>] (ieee80211_resume+0x58/0x70 [mac80211])
[   60.564405]  r10:c0d5310c r9:db5a6258 r8:00000000 r7:db5a628c r6:bf26d64=
0 r5:00000000
[   60.564415]  r4:db5a6420
[   60.565129] [<bf314a60>] (ieee80211_resume [mac80211]) from [<bf26d694>]=
 (wiphy_resume+0x54/0x64 [cfg80211])
[   60.565144]  r4:db5a6258 r3:bf314a60
[   60.565413] [<bf26d640>] (wiphy_resume [cfg80211]) from [<c053c79c>] (dp=
m_run_callback+0x40/0xcc)
[   60.565429]  r4:00000000 r3:00000000
[   60.565456] [<c053c75c>] (dpm_run_callback) from [<c053ce24>] (device_re=
sume+0xbc/0x234)
[   60.565482]  r10:00000000 r9:dc005000 r8:00000000 r6:00000010 r5:0000000=
1 r4:db5a6258
[   60.565509] [<c053cd68>] (device_resume) from [<c053cfbc>] (async_resume=
+0x20/0x4c)
[   60.565535]  r8:00000000 r7:dc004100 r6:c0d4fde0 r5:c0d89b30 r4:db5a6258=
 r3:00000000
[   60.565565] [<c053cf9c>] (async_resume) from [<c01483e4>] (async_run_ent=
ry_fn+0x44/0x140)
[   60.565579]  r5:db56f480 r4:db56f490
[   60.565609] [<c01483a0>] (async_run_entry_fn) from [<c013f128>] (process=
_one_work+0x12c/0x374)
[   60.565629]  r6:dc005000 r5:db56f490 r4:db44eb80 r3:c01483a0
[   60.565653] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   60.565679]  r10:00000088 r9:dc005000 r8:c0d16380 r7:db44eb98 r6:dc00501=
4 r5:dc005000
[   60.565689]  r4:db44eb80
[   60.565718] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   60.565744]  r10:c013f3b0 r9:db3cfeb4 r8:db44eb80 r7:db56ff58 r6:db56f40=
0 r5:00000000
[   60.565756]  r4:db56ff40 r3:00000000
[   60.565788] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   60.565814]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   60.565827]  r4:db56f400 r3:ffffffff
[   60.565839] ---[ end trace 06c90d424e072154 ]---
[   60.565949] wlcore: WARNING CONFIGURE command NOK
[   60.565965] wlcore: WARNING acx interrupt notify setting failed: -5
[   60.566025] wlcore: Hardware recovery in progress. FW ver: Rev 8.9.0.0.7=
8
[   60.566037] ------------[ cut here ]------------
[   60.566280] WARNING: CPU: 0 PID: 713 at drivers/net/wireless/ti/wlcore/i=
o.h:66 wlcore_set_partition+0xa0/0x50c [wlcore]
[   60.566288] Modules linked in: usb_f_acm u_serial arc4 pru_rproc pruss_i=
ntc wl18xx usb_f_ecm wlcore musb_dsps mac80211 musb_hdrc cfg80211 pruss phy=
_am335x usbcore phy_generic phy_am335x_control xfrm_user xfrm4_tunnel ipcom=
p xfrm_ipcomp esp4 ah4 af_key xfrm_algo g_multi usb_f_mass_storage usb_f_rn=
dis u_ether libcomposite udc_core usb_common bluetooth ecdh_generic snd_soc=
_simple_card snd_soc_simple_card_utils wkup_m3_rproc pm33xx wkup_m3_ipc rem=
oteproc omap_aes_driver crypto_engine omap_crypto omap_sham ti_emif_sram pr=
uss_soc_bus wlcore_sdio rtc_omap musb_am335x omap_wdt sch_fq_codel
[   60.566605] CPU: 0 PID: 713 Comm: kworker/u2:5 Tainted: G        W      =
 4.14.40-01413-g36a61bea-dirty #105
[   60.566614] Hardware name: Generic AM33XX (Flattened Device Tree)
[   60.566800] Workqueue: phy0 wl1271_recovery_work [wlcore]
[   60.566813] Backtrace:
[   60.566860] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   60.566882]  r6:00000000 r5:bf3af4c4 r4:00000000 r3:c0d53158
[   60.566914] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   60.566944] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[   60.566971] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null+=
0x28/0x30)
[   60.566999]  r10:00000000 r8:db5a6d38 r7:00000000 r6:bf3b3c40 r5:bf3dc06=
4 r4:db5a6d00
[   60.567188] [<c01287e4>] (warn_slowpath_null) from [<bf39dae0>] (wlcore_=
set_partition+0xa0/0x50c [wlcore])
[   60.567520] [<bf39da40>] (wlcore_set_partition [wlcore]) from [<bf396884=
>] (wl1271_recovery_work+0x174/0x40c [wlcore])
[   60.567541]  r7:dc639a00 r6:db5a6d00 r5:00000000 r4:db5a6f94
[   60.567719] [<bf396710>] (wl1271_recovery_work [wlcore]) from [<c013f128=
>] (process_one_work+0x12c/0x374)
[   60.567743]  r8:00000005 r7:dc639a00 r6:dc005000 r5:db5a6f94 r4:db264880
[   60.567768] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   60.567794]  r10:00000088 r9:dc005000 r8:c0d16380 r7:db264898 r6:dc00501=
4 r5:dc005000
[   60.567804]  r4:db264880
[   60.567831] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   60.567857]  r10:c013f3b0 r9:d6b73eb4 r8:db264880 r7:db1eb4d8 r6:db1eb48=
0 r5:00000000
[   60.567870]  r4:db1eb4c0 r3:00000000
[   60.567899] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   60.567925]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   60.567938]  r4:db1eb480 r3:ffffffff
[   60.567948] ---[ end trace 06c90d424e072155 ]---
[   60.567984] wlcore: down
[   60.568843] ieee80211 phy0: Hardware restart was requested
[   62.536363] OOM killer enabled.
[   62.539523] Restarting tasks ... done.
root@am335x-evm:~# [   62.613165] PM: suspend exit
[   64.259379] ------------[ cut here ]------------
[   64.264263] WARNING: CPU: 0 PID: 3 at drivers/net/wireless/ti/wlcore/sdi=
o.c:145 wl12xx_sdio_raw_write+0xb4/0x138 [wlcore_sdio]
[   64.281202] Modules linked in: usb_f_acm u_serial arc4 pru_rproc pruss_i=
ntc wl18xx usb_f_ecm wlcore musb_dsps mac80211 musb_hdrc cfg80211 pruss phy=
_am335x usbcore phy_generic phy_am335x_control xfrm_user xfrm4_tunnel ipcom=
p xfrm_ipcomp esp4 ah4 af_key xfrm_algo g_multi usb_f_mass_storage usb_f_rn=
dis u_ether libcomposite udc_core usb_common bluetooth ecdh_generic snd_soc=
_simple_card snd_soc_simple_card_utils wkup_m3_rproc pm33xx wkup_m3_ipc rem=
oteproc omap_aes_driver crypto_engine omap_crypto omap_sham ti_emif_sram pr=
uss_soc_bus wlcore_sdio rtc_omap musb_am335x omap_wdt sch_fq_codel
[   64.348727] CPU: 0 PID: 3 Comm: kworker/0:0 Tainted: G        W       4.=
14.40-01413-g36a61bea-dirty #105
[   64.362411] Hardware name: Generic AM33XX (Flattened Device Tree)
[   64.373346] Workqueue: events_freezable ieee80211_restart_work [mac80211=
]
[   64.380520] Backtrace:
[   64.388153] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   64.401930]  r6:00000000 r5:bf024b00 r4:00000000 r3:00000000
[   64.411432] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   64.422527] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[   64.433906] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null+=
0x28/0x30)
[   64.441563]  r10:00000000 r8:00000004 r7:db7fc200 r6:db245810 r5:0001ffc=
4 r4:dc58ca00
[   64.454433] [<c01287e4>] (warn_slowpath_null) from [<bf023324>] (wl12xx_=
sdio_raw_write+0xb4/0x138 [wlcore_sdio])
[   64.471018] [<bf023270>] (wl12xx_sdio_raw_write [wlcore_sdio]) from [<bf=
39db0c>] (wlcore_set_partition+0xcc/0x50c [wlcore])
[   64.486457]  r10:00000000 r8:dc727bc8 r7:00000000 r6:bf3b3c40 r5:bf3dc06=
4 r4:db5a6d00
[   64.498730] [<bf39da40>] (wlcore_set_partition [wlcore]) from [<bf39015c=
>] (wl12xx_set_power_on+0x90/0x164 [wlcore])
[   64.513428]  r7:bf3b3c40 r6:db5a6d38 r5:00000000 r4:db5a6d00
[   64.519578] [<bf3900cc>] (wl12xx_set_power_on [wlcore]) from [<bf397160>=
] (wl1271_op_add_interface+0x644/0x950 [wlcore])
[   64.536110]  r5:db5a6d00 r4:dc727aa0
[   64.540729] [<bf396b1c>] (wl1271_op_add_interface [wlcore]) from [<bf2f9=
fe0>] (drv_add_interface+0x34/0x80 [mac80211])
[   64.561506]  r10:db5a6a00 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:dc7274e0
[   64.573554]  r4:dc7274e0
[   64.577270] [<bf2f9fac>] (drv_add_interface [mac80211]) from [<bf328f44>=
] (ieee80211_reconfig+0x164/0xc0c [mac80211])
[   64.595516]  r4:db5a6420 r3:00000001
[   64.600231] [<bf328de0>] (ieee80211_reconfig [mac80211]) from [<bf2f8354=
>] (ieee80211_restart_work+0x90/0xbc [mac80211])
[   64.616691]  r10:00000000 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:db5a6a00
[   64.630527]  r4:db5a6a00
[   64.637503] [<bf2f82c4>] (ieee80211_restart_work [mac80211]) from [<c013=
f128>] (process_one_work+0x12c/0x374)
[   64.651859]  r7:dcb39400 r6:c0d0ea60 r5:db5a6c28 r4:dc031180
[   64.661572] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   64.673966]  r10:00000008 r9:c0d0ea60 r8:c0d16380 r7:dc031198 r6:c0d0ea7=
4 r5:c0d0ea60
[   64.681867]  r4:dc031180
[   64.689198] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   64.702654]  r10:c013f3b0 r9:dc04fe9c r8:dc031180 r7:dc030658 r6:dc03060=
0 r5:00000000
[   64.714610]  r4:dc030640 r3:00000000
[   64.718295] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   64.730394]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   64.744797]  r4:dc030600 r3:ffffffff
[   64.748427] ---[ end trace 06c90d424e072156 ]---
[   64.757792] wl1271_sdio mmc1:0001:2: sdio write failed (-110)
[   64.772377] mmc mmc1:0001: wl12xx_sdio_power_off: wlcore write did not y=
et complete?
[   64.786318] CPU: 0 PID: 3 Comm: kworker/0:0 Tainted: G        W       4.=
14.40-01413-g36a61bea-dirty #105
[   64.799746] Hardware name: Generic AM33XX (Flattened Device Tree)
[   64.810624] Workqueue: events_freezable ieee80211_restart_work [mac80211=
]
[   64.821602] Backtrace:
[   64.828002] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   64.839410]  r6:db5a6d38 r5:dc5ad008 r4:00000000 r3:00000000
[   64.848960] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   64.860074] [<c0805db0>] (dump_stack) from [<bf023258>] (wl12xx_sdio_set=
_power+0x140/0x158 [wlcore_sdio])
[   64.874019] [<bf023118>] (wl12xx_sdio_set_power [wlcore_sdio]) from [<bf=
390204>] (wl12xx_set_power_on+0x138/0x164 [wlcore])
[   64.889128]  r7:bf3b3c40 r6:db5a6d38 r5:ffffff92 r4:db5a6d00
[   64.899225] [<bf3900cc>] (wl12xx_set_power_on [wlcore]) from [<bf397160>=
] (wl1271_op_add_interface+0x644/0x950 [wlcore])
[   64.914290]  r5:db5a6d00 r4:dc727aa0
[   64.918887] [<bf396b1c>] (wl1271_op_add_interface [wlcore]) from [<bf2f9=
fe0>] (drv_add_interface+0x34/0x80 [mac80211])
[   64.935169]  r10:db5a6a00 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:dc7274e0
[   64.949035]  r4:dc7274e0
[   64.952742] [<bf2f9fac>] (drv_add_interface [mac80211]) from [<bf328f44>=
] (ieee80211_reconfig+0x164/0xc0c [mac80211])
[   64.968580]  r4:db5a6420 r3:00000001
[   64.973279] [<bf328de0>] (ieee80211_reconfig [mac80211]) from [<bf2f8354=
>] (ieee80211_restart_work+0x90/0xbc [mac80211])
[   64.994171]  r10:00000000 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:db5a6a00
[   65.002067]  r4:db5a6a00
[   65.010091] [<bf2f82c4>] (ieee80211_restart_work [mac80211]) from [<c013=
f128>] (process_one_work+0x12c/0x374)
[   65.026590]  r7:dcb39400 r6:c0d0ea60 r5:db5a6c28 r4:dc031180
[   65.032348] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   65.045963]  r10:00000008 r9:c0d0ea60 r8:c0d16380 r7:dc031198 r6:c0d0ea7=
4 r5:c0d0ea60
[   65.059710]  r4:dc031180
[   65.062336] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   65.074803]  r10:c013f3b0 r9:dc04fe9c r8:dc031180 r7:dc030658 r6:dc03060=
0 r5:00000000
[   65.082708]  r4:dc030640 r3:00000000
[   65.095591] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   65.102898]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   65.115719]  r4:dc030600 r3:ffffffff
[   66.839684] ------------[ cut here ]------------
[   66.844563] WARNING: CPU: 0 PID: 3 at drivers/net/wireless/ti/wlcore/sdi=
o.c:145 wl12xx_sdio_raw_write+0xb4/0x138 [wlcore_sdio]
[   66.861361] Modules linked in: usb_f_acm u_serial arc4 pru_rproc pruss_i=
ntc wl18xx usb_f_ecm wlcore musb_dsps mac80211 musb_hdrc cfg80211 pruss phy=
_am335x usbcore phy_generic phy_am335x_control xfrm_user xfrm4_tunnel ipcom=
p xfrm_ipcomp esp4 ah4 af_key xfrm_algo g_multi usb_f_mass_storage usb_f_rn=
dis u_ether libcomposite udc_core usb_common bluetooth ecdh_generic snd_soc=
_simple_card snd_soc_simple_card_utils wkup_m3_rproc pm33xx wkup_m3_ipc rem=
oteproc omap_aes_driver crypto_engine omap_crypto omap_sham ti_emif_sram pr=
uss_soc_bus wlcore_sdio rtc_omap musb_am335x omap_wdt sch_fq_codel
[   66.928850] CPU: 0 PID: 3 Comm: kworker/0:0 Tainted: G        W       4.=
14.40-01413-g36a61bea-dirty #105
[   66.942559] Hardware name: Generic AM33XX (Flattened Device Tree)
[   66.953446] Workqueue: events_freezable ieee80211_restart_work [mac80211=
]
[   66.960627] Backtrace:
[   66.968163] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   66.981969]  r6:00000000 r5:bf024b00 r4:00000000 r3:00000000
[   66.991481] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   67.002560] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[   67.013807] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null+=
0x28/0x30)
[   67.021460]  r10:00000000 r8:00000004 r7:db7fc200 r6:db245810 r5:0001ffc=
4 r4:dc58ca00
[   67.034435] [<c01287e4>] (warn_slowpath_null) from [<bf023324>] (wl12xx_=
sdio_raw_write+0xb4/0x138 [wlcore_sdio])
[   67.051044] [<bf023270>] (wl12xx_sdio_raw_write [wlcore_sdio]) from [<bf=
39db0c>] (wlcore_set_partition+0xcc/0x50c [wlcore])
[   67.066297]  r10:00000000 r8:dc727bc8 r7:00000000 r6:bf3b3c40 r5:bf3dc06=
4 r4:db5a6d00
[   67.078668] [<bf39da40>] (wlcore_set_partition [wlcore]) from [<bf39015c=
>] (wl12xx_set_power_on+0x90/0x164 [wlcore])
[   67.093422]  r7:bf3b3c40 r6:db5a6d38 r5:00000000 r4:db5a6d00
[   67.099581] [<bf3900cc>] (wl12xx_set_power_on [wlcore]) from [<bf397160>=
] (wl1271_op_add_interface+0x644/0x950 [wlcore])
[   67.115910]  r5:db5a6d00 r4:ffffff92
[   67.120529] [<bf396b1c>] (wl1271_op_add_interface [wlcore]) from [<bf2f9=
fe0>] (drv_add_interface+0x34/0x80 [mac80211])
[   67.140965]  r10:db5a6a00 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:dc7274e0
[   67.152812]  r4:dc7274e0
[   67.160260] [<bf2f9fac>] (drv_add_interface [mac80211]) from [<bf328f44>=
] (ieee80211_reconfig+0x164/0xc0c [mac80211])
[   67.175659]  r4:db5a6420 r3:00000001
[   67.180363] [<bf328de0>] (ieee80211_reconfig [mac80211]) from [<bf2f8354=
>] (ieee80211_restart_work+0x90/0xbc [mac80211])
[   67.196643]  r10:00000000 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:db5a6a00
[   67.210562]  r4:db5a6a00
[   67.217633] [<bf2f82c4>] (ieee80211_restart_work [mac80211]) from [<c013=
f128>] (process_one_work+0x12c/0x374)
[   67.231776]  r7:dcb39400 r6:c0d0ea60 r5:db5a6c28 r4:dc031180
[   67.241634] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   67.253848]  r10:00000008 r9:c0d0ea60 r8:c0d16380 r7:dc031198 r6:c0d0ea7=
4 r5:c0d0ea60
[   67.261747]  r4:dc031180
[   67.269183] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   67.282565]  r10:c013f3b0 r9:dc04fe9c r8:dc031180 r7:dc030658 r6:dc03060=
0 r5:00000000
[   67.294532]  r4:dc030640 r3:00000000
[   67.298212] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   67.310193]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   67.324496]  r4:dc030600 r3:ffffffff
[   67.328127] ---[ end trace 06c90d424e072157 ]---
[   67.332801] wl1271_sdio mmc1:0001:2: sdio write failed (-110)
[   67.343419] mmc mmc1:0001: wl12xx_sdio_power_off: wlcore write did not y=
et complete?
[   67.351251] CPU: 0 PID: 3 Comm: kworker/0:0 Tainted: G        W       4.=
14.40-01413-g36a61bea-dirty #105
[   67.378058] Hardware name: Generic AM33XX (Flattened Device Tree)
[   67.388937] Workqueue: events_freezable ieee80211_restart_work [mac80211=
]
[   67.400047] Backtrace:
[   67.402618] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   67.415557]  r6:db5a6d38 r5:dc5ad008 r4:00000000 r3:00000000
[   67.421327] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   67.437885] [<c0805db0>] (dump_stack) from [<bf023258>] (wl12xx_sdio_set=
_power+0x140/0x158 [wlcore_sdio])
[   67.451892] [<bf023118>] (wl12xx_sdio_set_power [wlcore_sdio]) from [<bf=
390204>] (wl12xx_set_power_on+0x138/0x164 [wlcore])
[   67.467074]  r7:bf3b3c40 r6:db5a6d38 r5:ffffff92 r4:db5a6d00
[   67.473232] [<bf3900cc>] (wl12xx_set_power_on [wlcore]) from [<bf397160>=
] (wl1271_op_add_interface+0x644/0x950 [wlcore])
[   67.491756]  r5:db5a6d00 r4:ffffff92
[   67.500162] [<bf396b1c>] (wl1271_op_add_interface [wlcore]) from [<bf2f9=
fe0>] (drv_add_interface+0x34/0x80 [mac80211])
[   67.515502]  r10:db5a6a00 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:dc7274e0
[   67.527255]  r4:dc7274e0
[   67.530956] [<bf2f9fac>] (drv_add_interface [mac80211]) from [<bf328f44>=
] (ieee80211_reconfig+0x164/0xc0c [mac80211])
[   67.547152]  r4:db5a6420 r3:00000001
[   67.551854] [<bf328de0>] (ieee80211_reconfig [mac80211]) from [<bf2f8354=
>] (ieee80211_restart_work+0x90/0xbc [mac80211])
[   67.572462]  r10:00000000 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:db5a6a00
[   67.584507]  r4:db5a6a00
[   67.587806] [<bf2f82c4>] (ieee80211_restart_work [mac80211]) from [<c013=
f128>] (process_one_work+0x12c/0x374)
[   67.605215]  r7:dcb39400 r6:c0d0ea60 r5:db5a6c28 r4:dc031180
[   67.610986] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   67.629039]  r10:00000008 r9:c0d0ea60 r8:c0d16380 r7:dc031198 r6:c0d0ea7=
4 r5:c0d0ea60
[   67.640701]  r4:dc031180
[   67.647253] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   67.658699]  r10:c013f3b0 r9:dc04fe9c r8:dc031180 r7:dc030658 r6:dc03060=
0 r5:00000000
[   67.670355]  r4:dc030640 r3:00000000
[   67.677815] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   67.688918]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   67.700531]  r4:dc030600 r3:ffffffff
[   69.429476] ------------[ cut here ]------------
[   69.434355] WARNING: CPU: 0 PID: 3 at drivers/net/wireless/ti/wlcore/sdi=
o.c:145 wl12xx_sdio_raw_write+0xb4/0x138 [wlcore_sdio]
[   69.451344] Modules linked in: usb_f_acm u_serial arc4 pru_rproc pruss_i=
ntc wl18xx usb_f_ecm wlcore musb_dsps mac80211 musb_hdrc cfg80211 pruss phy=
_am335x usbcore phy_generic phy_am335x_control xfrm_user xfrm4_tunnel ipcom=
p xfrm_ipcomp esp4 ah4 af_key xfrm_algo g_multi usb_f_mass_storage usb_f_rn=
dis u_ether libcomposite udc_core usb_common bluetooth ecdh_generic snd_soc=
_simple_card snd_soc_simple_card_utils wkup_m3_rproc pm33xx wkup_m3_ipc rem=
oteproc omap_aes_driver crypto_engine omap_crypto omap_sham ti_emif_sram pr=
uss_soc_bus wlcore_sdio rtc_omap musb_am335x omap_wdt sch_fq_codel
[   69.518879] CPU: 0 PID: 3 Comm: kworker/0:0 Tainted: G        W       4.=
14.40-01413-g36a61bea-dirty #105
[   69.532530] Hardware name: Generic AM33XX (Flattened Device Tree)
[   69.543540] Workqueue: events_freezable ieee80211_restart_work [mac80211=
]
[   69.550718] Backtrace:
[   69.558381] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   69.572307]  r6:00000000 r5:bf024b00 r4:00000000 r3:00000000
[   69.581846] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   69.593360] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[   69.600478] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null+=
0x28/0x30)
[   69.612769]  r10:00000000 r8:00000004 r7:db7fc200 r6:db245810 r5:0001ffc=
4 r4:dc58ca00
[   69.626945] [<c01287e4>] (warn_slowpath_null) from [<bf023324>] (wl12xx_=
sdio_raw_write+0xb4/0x138 [wlcore_sdio])
[   69.641383] [<bf023270>] (wl12xx_sdio_raw_write [wlcore_sdio]) from [<bf=
39db0c>] (wlcore_set_partition+0xcc/0x50c [wlcore])
[   69.656809]  r10:00000000 r8:dc727bc8 r7:00000000 r6:bf3b3c40 r5:bf3dc06=
4 r4:db5a6d00
[   69.668932] [<bf39da40>] (wlcore_set_partition [wlcore]) from [<bf39015c=
>] (wl12xx_set_power_on+0x90/0x164 [wlcore])
[   69.683503]  r7:bf3b3c40 r6:db5a6d38 r5:00000000 r4:db5a6d00
[   69.689907] [<bf3900cc>] (wl12xx_set_power_on [wlcore]) from [<bf397160>=
] (wl1271_op_add_interface+0x644/0x950 [wlcore])
[   69.706166]  r5:db5a6d00 r4:ffffff92
[   69.710781] [<bf396b1c>] (wl1271_op_add_interface [wlcore]) from [<bf2f9=
fe0>] (drv_add_interface+0x34/0x80 [mac80211])
[   69.731566]  r10:db5a6a00 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:dc7274e0
[   69.743519]  r4:dc7274e0
[   69.747317] [<bf2f9fac>] (drv_add_interface [mac80211]) from [<bf328f44>=
] (ieee80211_reconfig+0x164/0xc0c [mac80211])
[   69.763281]  r4:db5a6420 r3:00000001
[   69.767976] [<bf328de0>] (ieee80211_reconfig [mac80211]) from [<bf2f8354=
>] (ieee80211_restart_work+0x90/0xbc [mac80211])
[   69.788733]  r10:00000000 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:db5a6a00
[   69.800487]  r4:db5a6a00
[   69.807663] [<bf2f82c4>] (ieee80211_restart_work [mac80211]) from [<c013=
f128>] (process_one_work+0x12c/0x374)
[   69.821891]  r7:dcb39400 r6:c0d0ea60 r5:db5a6c28 r4:dc031180
[   69.831594] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   69.843909]  r10:00000008 r9:c0d0ea60 r8:c0d16380 r7:dc031198 r6:c0d0ea7=
4 r5:c0d0ea60
[   69.851807]  r4:dc031180
[   69.859227] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   69.872667]  r10:c013f3b0 r9:dc04fe9c r8:dc031180 r7:dc030658 r6:dc03060=
0 r5:00000000
[   69.884690]  r4:dc030640 r3:00000000
[   69.888375] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   69.900364]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   69.914592]  r4:dc030600 r3:ffffffff
[   69.918222] ---[ end trace 06c90d424e072158 ]---
[   69.922897] wl1271_sdio mmc1:0001:2: sdio write failed (-110)
[   69.933405] mmc mmc1:0001: wl12xx_sdio_power_off: wlcore write did not y=
et complete?
[   69.941243] CPU: 0 PID: 3 Comm: kworker/0:0 Tainted: G        W       4.=
14.40-01413-g36a61bea-dirty #105
[   69.968249] Hardware name: Generic AM33XX (Flattened Device Tree)
[   69.979069] Workqueue: events_freezable ieee80211_restart_work [mac80211=
]
[   69.990223] Backtrace:
[   69.992794] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   70.005750]  r6:db5a6d38 r5:dc5ad008 r4:00000000 r3:00000000
[   70.011527] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   70.028035] [<c0805db0>] (dump_stack) from [<bf023258>] (wl12xx_sdio_set=
_power+0x140/0x158 [wlcore_sdio])
[   70.041927] [<bf023118>] (wl12xx_sdio_set_power [wlcore_sdio]) from [<bf=
390204>] (wl12xx_set_power_on+0x138/0x164 [wlcore])
[   70.057178]  r7:bf3b3c40 r6:db5a6d38 r5:ffffff92 r4:db5a6d00
[   70.063333] [<bf3900cc>] (wl12xx_set_power_on [wlcore]) from [<bf397160>=
] (wl1271_op_add_interface+0x644/0x950 [wlcore])
[   70.081996]  r5:db5a6d00 r4:ffffff92
[   70.090340] [<bf396b1c>] (wl1271_op_add_interface [wlcore]) from [<bf2f9=
fe0>] (drv_add_interface+0x34/0x80 [mac80211])
[   70.105745]  r10:db5a6a00 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:dc7274e0
[   70.117490]  r4:dc7274e0
[   70.121197] [<bf2f9fac>] (drv_add_interface [mac80211]) from [<bf328f44>=
] (ieee80211_reconfig+0x164/0xc0c [mac80211])
[   70.137336]  r4:db5a6420 r3:00000001
[   70.142045] [<bf328de0>] (ieee80211_reconfig [mac80211]) from [<bf2f8354=
>] (ieee80211_restart_work+0x90/0xbc [mac80211])
[   70.162550]  r10:00000000 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:db5a6a00
[   70.174625]  r4:db5a6a00
[   70.177923] [<bf2f82c4>] (ieee80211_restart_work [mac80211]) from [<c013=
f128>] (process_one_work+0x12c/0x374)
[   70.193199]  r7:dcb39400 r6:c0d0ea60 r5:db5a6c28 r4:dc031180
[   70.198959] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   70.217151]  r10:00000008 r9:c0d0ea60 r8:c0d16380 r7:dc031198 r6:c0d0ea7=
4 r5:c0d0ea60
[   70.228862]  r4:dc031180
[   70.231489] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   70.243312]  r10:c013f3b0 r9:dc04fe9c r8:dc031180 r7:dc030658 r6:dc03060=
0 r5:00000000
[   70.251212]  r4:dc030640 r3:00000000
[   70.265017] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   70.272321]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   70.285370]  r4:dc030600 r3:ffffffff
[   70.289003] wlcore: ERROR firmware boot failed despite 3 retries
[   70.304327] ------------[ cut here ]------------
[   70.309755] WARNING: CPU: 0 PID: 3 at net/mac80211/util.c:1902 ieee80211=
_reconfig+0x17c/0xc0c [mac80211]
[   70.323490] Modules linked in: usb_f_acm u_serial arc4 pru_rproc pruss_i=
ntc wl18xx usb_f_ecm wlcore musb_dsps mac80211 musb_hdrc cfg80211 pruss phy=
_am335x usbcore phy_generic phy_am335x_control xfrm_user xfrm4_tunnel ipcom=
p xfrm_ipcomp esp4 ah4 af_key xfrm_algo g_multi usb_f_mass_storage usb_f_rn=
dis u_ether libcomposite udc_core usb_common bluetooth ecdh_generic snd_soc=
_simple_card snd_soc_simple_card_utils wkup_m3_rproc pm33xx wkup_m3_ipc rem=
oteproc omap_aes_driver crypto_engine omap_crypto omap_sham ti_emif_sram pr=
uss_soc_bus wlcore_sdio rtc_omap musb_am335x omap_wdt sch_fq_codel
[   70.392540] CPU: 0 PID: 3 Comm: kworker/0:0 Tainted: G        W       4.=
14.40-01413-g36a61bea-dirty #105
[   70.406641] Hardware name: Generic AM33XX (Flattened Device Tree)
[   70.413537] Workqueue: events_freezable ieee80211_restart_work [mac80211=
]
[   70.424850] Backtrace:
[   70.427396] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   70.440543]  r6:00000000 r5:bf3494ac r4:00000000 r3:00000000
[   70.452546] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   70.466545] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[   70.477427] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null+=
0x28/0x30)
[   70.488858]  r10:db5a6a00 r8:ffffff92 r7:db5a6420 r6:db5a6420 r5:dc7274e=
0 r4:db5a6420
[   70.501458] [<c01287e4>] (warn_slowpath_null) from [<bf328f5c>] (ieee802=
11_reconfig+0x17c/0xc0c [mac80211])
[   70.516702] [<bf328de0>] (ieee80211_reconfig [mac80211]) from [<bf2f8354=
>] (ieee80211_restart_work+0x90/0xbc [mac80211])
[   70.531935]  r10:00000000 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:db5a6a00
[   70.543840]  r4:db5a6a00
[   70.547122] [<bf2f82c4>] (ieee80211_restart_work [mac80211]) from [<c013=
f128>] (process_one_work+0x12c/0x374)
[   70.562592]  r7:dcb39400 r6:c0d0ea60 r5:db5a6c28 r4:dc031180
[   70.574711] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   70.586858]  r10:00000008 r9:c0d0ea60 r8:c0d16380 r7:dc031198 r6:c0d0ea7=
4 r5:c0d0ea60
[   70.594931]  r4:dc031180
[   70.597541] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   70.610248]  r10:c013f3b0 r9:dc04fe9c r8:dc031180 r7:dc030658 r6:dc03060=
0 r5:00000000
[   70.627088]  r4:dc030640 r3:00000000
[   70.630774] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   70.642831]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   70.657197]  r4:dc030600 r3:ffffffff
[   70.660830] ---[ end trace 06c90d424e072159 ]---
[   70.677592] ------------[ cut here ]------------
[   70.683361] WARNING: CPU: 0 PID: 3 at net/mac80211/driver-ops.h:18 drv_r=
emove_interface+0x64/0x70 [mac80211]
[   70.699764] wlan0:  Failed check-sdata-in-driver check, flags: 0x0
[   70.707634] Modules linked in: usb_f_acm u_serial arc4 pru_rproc pruss_i=
ntc wl18xx usb_f_ecm wlcore musb_dsps mac80211 musb_hdrc cfg80211 pruss phy=
_am335x usbcore phy_generic phy_am335x_control xfrm_user xfrm4_tunnel ipcom=
p xfrm_ipcomp esp4 ah4 af_key xfrm_algo g_multi usb_f_mass_storage usb_f_rn=
dis u_ether libcomposite udc_core usb_common bluetooth ecdh_generic snd_soc=
_simple_card snd_soc_simple_card_utils wkup_m3_rproc pm33xx wkup_m3_ipc rem=
oteproc omap_aes_driver crypto_engine omap_crypto omap_sham ti_emif_sram pr=
uss_soc_bus wlcore_sdio rtc_omap musb_am335x omap_wdt sch_fq_codel
[   70.764973] CPU: 0 PID: 3 Comm: kworker/0:0 Tainted: G        W       4.=
14.40-01413-g36a61bea-dirty #105
[   70.776384] Hardware name: Generic AM33XX (Flattened Device Tree)
[   70.782902] Workqueue: events_freezable ieee80211_restart_work [mac80211=
]
[   70.792756] Backtrace:
[   70.796872] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[   70.806114]  r6:00000000 r5:bf348224 r4:dc05dd68 r3:00000000
[   70.811835] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[   70.821797] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[   70.830440] [<c01286e0>] (__warn) from [<c012889c>] (warn_slowpath_fmt+0=
x40/0x48)
[   70.839599]  r10:db5a6420 r8:00000000 r7:00000000 r6:db5a6a28 r5:dc7274e=
0 r4:00000000
[   70.849459] [<c0128860>] (warn_slowpath_fmt) from [<bf2fa0f4>] (drv_remo=
ve_interface+0x64/0x70 [mac80211])
[   70.861026]  r3:dc727000 r2:bf348240
[   70.866248]  r4:dc7274e0
[   70.869282] [<bf2fa090>] (drv_remove_interface [mac80211]) from [<bf30c0=
dc>] (ieee80211_do_stop+0x7d4/0x8dc [mac80211])
[   70.883184]  r4:db5a698c
[   70.886246] [<bf30b908>] (ieee80211_do_stop [mac80211]) from [<bf30c1fc>=
] (ieee80211_stop+0x18/0x20 [mac80211])
[   70.899279]  r10:db5a6a00 r9:c0d0ea60 r8:dc05de58 r7:00000001 r6:db5a600=
0 r5:dc05de58
[   70.908837]  r4:dc727000
[   70.911754] [<bf30c1e4>] (ieee80211_stop [mac80211]) from [<c06e62f0>] (=
__dev_close_many+0x90/0xd0)
[   70.923892] [<c06e6260>] (__dev_close_many) from [<c06e63a4>] (dev_close=
_many+0x74/0xf0)
[   70.932029]  r5:db5a63e8 r4:dc7274e8
[   70.938308] [<c06e6330>] (dev_close_many) from [<c06e88c0>] (dev_close+0=
x44/0x5c)
[   70.947444]  r8:ffffff92 r7:db5a6420 r6:db5a6000 r5:db5a63e8 r4:dc7274e8=
 r3:dc727000
[   70.957120] [<c06e887c>] (dev_close) from [<bf26cb18>] (cfg80211_shutdow=
n_all_interfaces+0x3c/0xc0 [cfg80211])
[   70.969490] [<bf26cadc>] (cfg80211_shutdown_all_interfaces [cfg80211]) f=
rom [<bf326c14>] (ieee80211_handle_reconfig_failure+0xcc/0xd0 [mac80211])
[   70.984618]  r6:db5a6420 r5:db5a6b10 r4:db5a6420 r3:db5a6b08
[   70.990774] [<bf326b48>] (ieee80211_handle_reconfig_failure [mac80211]) =
from [<bf329128>] (ieee80211_reconfig+0x348/0xc0c [mac80211])
[   71.005701]  r5:db5a6a00 r4:db5a6420
[   71.009760] [<bf328de0>] (ieee80211_reconfig [mac80211]) from [<bf2f8354=
>] (ieee80211_restart_work+0x90/0xbc [mac80211])
[   71.023910]  r10:00000000 r9:c0d0ea60 r8:00000000 r7:db5a6420 r6:db5a642=
0 r5:db5a6a00
[   71.031785]  r4:db5a6a00
[   71.037253] [<bf2f82c4>] (ieee80211_restart_work [mac80211]) from [<c013=
f128>] (process_one_work+0x12c/0x374)
[   71.049089]  r7:dcb39400 r6:c0d0ea60 r5:db5a6c28 r4:dc031180
[   71.056485] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[   71.066280]  r10:00000008 r9:c0d0ea60 r8:c0d16380 r7:dc031198 r6:c0d0ea7=
4 r5:c0d0ea60
[   71.075666]  r4:dc031180
[   71.078241] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[   71.088235]  r10:c013f3b0 r9:dc04fe9c r8:dc031180 r7:dc030658 r6:dc03060=
0 r5:00000000
[   71.097655]  r4:dc030640 r3:00000000
[   71.101282] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[   71.111064]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[   71.120527]  r4:dc030600 r3:ffffffff
[   71.125652] ---[ end trace 06c90d424e07215a ]---

root@am335x-evm:~# ifconfig wlan0 down
root@am335x-evm:~# ifconfig wlan0 up
[  590.896452] wlcore: PHY firmware version: Rev 8.2.0.0.242
[  591.017507] wlcore: firmware booted (Rev 8.9.0.0.78)
[  591.109143] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
root@am335x-evm:~#

Regards,
Eyal
