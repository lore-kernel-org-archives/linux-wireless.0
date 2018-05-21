Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:21562 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750923AbeEUH3o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 03:29:44 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>, Kalle Valo <kvalo@codeaurora.org>
CC: KISHON VIJAY ABRAHAM <kishon@ti.com>, "Mishol, Guy" <guym@ti.com>,
        "Luca Coelho" <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy, Chen" <c-loewy@ti.com>
Subject: RE: [EXTERNAL] [PATCHv2 0/5] Runtime PM support for wlcore
Date: Mon, 21 May 2018 07:29:38 +0000
Message-ID: <bff51dcc6fd441d9ab42db273219aaf4@ti.com> (sfid-20180521_092950_984929_550E9389)
References: <20180517185029.71716-1-tony@atomide.com>
In-Reply-To: <20180517185029.71716-1-tony@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tony,

>=20
> Hi all,
>=20
> Here's a series of patches to add runtime PM support for wlcore. It does =
not
> yet implement autosuspend support, but let's get this tested first as the
> autosuspend can mask enable/disable issues easily.
>=20
> Regards,
>=20
> Tony
>=20
> Changes since v1:
>=20
> - Fix issues reported by Eyal for recovery
>=20

Testing on BBB+WL1837 cape, scan, recovery, down/up and basic traffic seems=
 ok now.
Of course we need to test some more.
Standard suspend/resume seems to work ok as well.
Ennabling wowlan and suspending is  crashing on resume. See below.

root@am335x-evm:/usr/share/wl18xx# iw phy0 wowlan enable any=20
root@am335x-evm:/usr/share/wl18xx#
root@am335x-evm:/usr/share/wl18xx# echo mem > /sys/power/state
[  541.567039] PM: suspend entry (deep)
[  541.570688] PM: Syncing filesystems ... done.
[  541.594277] Freezing user space processes ... (elapsed 0.001 seconds) do=
ne.
[  541.603160] OOM killer disabled.
[  541.606738] Freezing remaining freezable tasks ... (elapsed 0.001 second=
s) done.
[  541.615984] Suspending console(s) (use no_console_suspend to debug)
[  542.895091] pm33xx pm33xx: PM: Successfully put all powerdomains to targ=
et state
[  542.895091] PM: Wakeup source UART
[  542.919791] net eth0: initializing cpsw version 1.12 (0)
[  543.017880] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver [=
SMSC LAN8710/LAN8720] (mii_bus:phy_addr=3D4a101000.mdio:00, irq=3DPOLL)
[  543.027646] ------------[ cut here ]------------
[  543.028023] WARNING: CPU: 0 PID: 932 at drivers/net/wireless/ti/wlcore/c=
md.c:76 wlcore_cmd_send_failsafe+0x498/0x4f8 [wlcore]
[  543.028033] Modules linked in: ctr aes_arm_bs crypto_simd cryptd ccm arc=
4 pru_rproc pruss_intc wl18xx usb_f_acm u_serial wlcore mac80211 cfg80211 p=
russ usb_f_ecm musb_dsps musb_hdrc usbcore phy_am335x phy_generic phy_am335=
x_control xfrm_user xfrm4_tunnel ipcomp xfrm_ipcomp esp4 ah4 af_key xfrm_al=
go g_multi usb_f_mass_storage usb_f_rndis u_ether libcomposite udc_core usb=
_common bluetooth ecdh_generic snd_soc_simple_card snd_soc_simple_card_util=
s pm33xx wkup_m3_ipc wkup_m3_rproc remoteproc omap_aes_driver crypto_engine=
 omap_crypto omap_sham ti_emif_sram pruss_soc_bus wlcore_sdio rtc_omap musb=
_am335x omap_wdt sch_fq_codel
[  543.028408] CPU: 0 PID: 932 Comm: kworker/u2:9 Not tainted 4.14.40-01413=
-g36a61bea-dirty #104
[  543.028418] Hardware name: Generic AM33XX (Flattened Device Tree)
[  543.028466] Workqueue: events_unbound async_run_entry_fn
[  543.028480] Backtrace:
[  543.028541] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack+=
0x18/0x1c)
[  543.028565]  r6:00000000 r5:bf3a759c r4:00000000 r3:c0d53158
[  543.028602] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x20=
/0x28)
[  543.028637] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x1=
04)
[  543.028665] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null+=
0x28/0x30)
[  543.028691]  r10:c0d5310c r8:00000000 r7:00000000 r6:d6be5080 r5:0000000=
c r4:db59ed00
[  543.028896] [<c01287e4>] (warn_slowpath_null) from [<bf393874>] (wlcore_=
cmd_send_failsafe+0x498/0x4f8 [wlcore])
[  543.029232] [<bf3933dc>] (wlcore_cmd_send_failsafe [wlcore]) from [<bf39=
4e60>] (wlcore_cmd_configure_failsafe+0x60/0xd8 [wlcore])
[  543.029259]  r10:c0d5310c r9:db59e258 r8:00000000 r7:00000000 r6:0000002=
4 r5:db59ed00
[  543.029269]  r4:d6be5080
[  543.029597] [<bf394e00>] (wlcore_cmd_configure_failsafe [wlcore]) from [=
<bf394ef4>] (wl1271_cmd_configure+0x1c/0x28 [wlcore])
[  543.029614]  r6:db59ed00 r5:00000001 r4:d6be5080
[  543.029943] [<bf394ed8>] (wl1271_cmd_configure [wlcore]) from [<bf39da70=
>] (wl1271_acx_default_rx_filter_enable+0x60/0xac [wlcore])
[  543.030272] [<bf39da10>] (wl1271_acx_default_rx_filter_enable [wlcore]) =
from [<bf39201c>] (wl1271_configure_wowlan+0x148/0x3c4 [wlcore])
[  543.030292]  r7:db59ed38 r6:db59ee20 r5:00000000 r4:dc705bc8
[  543.030616] [<bf391ed4>] (wl1271_configure_wowlan [wlcore]) from [<bf392=
5a8>] (wl1271_op_resume+0x310/0x344 [wlcore])
[  543.030643]  r10:c0d5310c r9:db59e258 r8:00000000 r7:db59ed38 r6:db59ee2=
0 r5:db59ed00
[  543.030652]  r4:dc705bc8
[  543.031484] [<bf392298>] (wl1271_op_resume [wlcore]) from [<bf343a0c>] (=
ieee80211_reconfig+0x418/0xc0c [mac80211])
[  543.031509]  r8:00000000 r7:db59e28c r6:bf2c75e8 r5:00000000 r4:db59e420
[  543.032290] [<bf3435f4>] (ieee80211_reconfig [mac80211]) from [<bf32fd9c=
>] (ieee80211_resume+0x58/0x70 [mac80211])
[  543.032318]  r10:c0d5310c r9:db59e258 r8:00000000 r7:db59e28c r6:bf2c75e=
8 r5:00000000
[  543.032327]  r4:db59e420
[  543.033150] [<bf32fd44>] (ieee80211_resume [mac80211]) from [<bf2c763c>]=
 (wiphy_resume+0x54/0x64 [cfg80211])
[  543.033165]  r4:db59e258 r3:bf32fd44
[  543.033448] [<bf2c75e8>] (wiphy_resume [cfg80211]) from [<c053c79c>] (dp=
m_run_callback+0x40/0xcc)
[  543.033462]  r4:00000000 r3:00000000
[  543.033489] [<c053c75c>] (dpm_run_callback) from [<c053ce24>] (device_re=
sume+0xbc/0x234)
[  543.033515]  r10:00000000 r9:dc005000 r8:00000000 r6:00000010 r5:0000000=
1 r4:db59e258
[  543.033542] [<c053cd68>] (device_resume) from [<c053cfbc>] (async_resume=
+0x20/0x4c)
[  543.033567]  r8:00000000 r7:dc004100 r6:c0d4fde0 r5:c0d89b30 r4:db59e258=
 r3:00000000
[  543.033600] [<c053cf9c>] (async_resume) from [<c01483e4>] (async_run_ent=
ry_fn+0x44/0x140)
[  543.033614]  r5:d6be5480 r4:d6be5490
[  543.033646] [<c01483a0>] (async_run_entry_fn) from [<c013f128>] (process=
_one_work+0x12c/0x374)
[  543.033666]  r6:dc005000 r5:d6be5490 r4:db5ee780 r3:c01483a0
[  543.033690] [<c013effc>] (process_one_work) from [<c013f570>] (worker_th=
read+0x1c0/0x5b8)
[  543.033717]  r10:00000088 r9:dc005000 r8:c0d16380 r7:db5ee798 r6:dc00501=
4 r5:dc005000
[  543.033727]  r4:db5ee780
[  543.033760] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x11=
c/0x154)
[  543.033786]  r10:c013f3b0 r9:db5a1eb4 r8:db5ee780 r7:d6be53d8 r6:d6be550=
0 r5:00000000
[  543.033798]  r4:d6be53c0 r3:00000000
[  543.033833] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x14=
/0x2c)
[  543.033859]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0145150
[  543.033872]  r4:d6be5500 r3:ffffffff
[  543.033885] ---[ end trace 980798e27041136d ]---

> - Add few patches for enable/disable issues found when using runtime PM
>=20
> - Remove unused ps.h includes
>=20
> Tony Lindgren (5):
>   wlcore: Add missing PM call for wlcore_cmd_wait_for_event_or_timeout()
>   wlcore: Make sure PM calls are paired
>   wlcore: Add support for runtime PM
>   wlcore: Fix misplaced PM call for scan_complete_work()
>   wlcore: sdio: Warn about runtime PM suspend errors
>=20
>  drivers/net/wireless/ti/wl18xx/debugfs.c    |  26 +-
>  drivers/net/wireless/ti/wlcore/acx.c        |   1 -
>  drivers/net/wireless/ti/wlcore/cmd.c        |   9 +
>  drivers/net/wireless/ti/wlcore/debugfs.c    |  79 ++--
>  drivers/net/wireless/ti/wlcore/main.c       | 404 ++++++++++++++------
>  drivers/net/wireless/ti/wlcore/ps.c         | 146 -------
>  drivers/net/wireless/ti/wlcore/ps.h         |   3 -
>  drivers/net/wireless/ti/wlcore/scan.c       |  12 +-
>  drivers/net/wireless/ti/wlcore/sdio.c       |   7 +
>  drivers/net/wireless/ti/wlcore/sysfs.c      |  12 +-
>  drivers/net/wireless/ti/wlcore/testmode.c   |  18 +-
>  drivers/net/wireless/ti/wlcore/tx.c         |   9 +-
>  drivers/net/wireless/ti/wlcore/vendor_cmd.c |  27 +-
>  drivers/net/wireless/ti/wlcore/wlcore.h     |   1 -
>  drivers/net/wireless/ti/wlcore/wlcore_i.h   |   1 -
>  15 files changed, 421 insertions(+), 334 deletions(-)
>=20
> --
> 2.17.0

Best Regards,
Eyal
