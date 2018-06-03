Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:36638 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbeFCGEi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Jun 2018 02:04:38 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>, Kalle Valo <kvalo@codeaurora.org>
CC: KISHON VIJAY ABRAHAM <kishon@ti.com>, "Mishol, Guy" <guym@ti.com>,
        "Luca Coelho" <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [RFT 3/6] wlcore: Add support for runtime PM
Date: Sun, 3 Jun 2018 06:04:31 +0000
Message-ID: <fe42f9d6bb744cd39e38db8f51c0b74e@ti.com> (sfid-20180603_080508_982602_18AD6765)
References: <20180529180605.73622-1-tony@atomide.com>
 <20180529180605.73622-4-tony@atomide.com> <20180531171420.GQ5705@atomide.com>
In-Reply-To: <20180531171420.GQ5705@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>=20
> * Tony Lindgren <tony@atomide.com> [180529 18:09]:
> > --- a/drivers/net/wireless/ti/wlcore/main.c
> > +++ b/drivers/net/wireless/ti/wlcore/main.c
> ...
> > +static int __maybe_unused wlcore_runtime_resume(struct device *dev)
> > +{
> > +	struct wl1271 *wl =3D dev_get_drvdata(dev);
> > +	DECLARE_COMPLETION_ONSTACK(compl);
> > +	unsigned long flags;
> > +	int ret;
> > +	unsigned long start_time =3D jiffies;
> > +	bool pending =3D false;
> > +
> > +	/* Nothing to do if no ELP mode requested */
> > +	if (!test_bit(WL1271_FLAG_IN_ELP, &wl->flags))
> > +		return 0;
> > +
> > +	wl1271_debug(DEBUG_PSM, "waking up chip from elp");
> > +
> > +	spin_lock_irqsave(&wl->wl_lock, flags);
> > +	if (test_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags))
> > +		pending =3D true;
> > +	else
> > +		wl->elp_compl =3D &compl;
> > +	spin_unlock_irqrestore(&wl->wl_lock, flags);
> > +
> > +	ret =3D wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG,
> ELPCTRL_WAKE_UP);
> > +	if (ret < 0) {
> > +		wl12xx_queue_recovery_work(wl);
> > +		goto err;
> > +	}
> > +
> > +	if (!pending) {
> > +		ret =3D wait_for_completion_timeout(&compl,
> > +			msecs_to_jiffies(WL1271_WAKEUP_TIMEOUT));
> > +		if (ret =3D=3D 0) {
> > +			wl1271_error("ELP wakeup timeout!");
> > +			wl12xx_queue_recovery_work(wl);
> > +
> > +			/* Return no error for runtime PM for recovery */
> > +			return 0;
>=20
> I noticed returning here and not clearing WL1271_FLAG_IN_ELP can
> produce errors. But I think it's unsafe to clear WL1271_FLAG_IN_ELP
> if wlcore did not wake. So I suggest we return early here to see the
> errors so we can fix the issues. I'll post one more patch that fixes
> the init time "ELP wakeup timeout!" issues for me.
>=20

I have noticed the following recovery a couple of times on my setup when th=
e board was=20
just sitting for a long time with just pings
It starts with a firmware recovery started from the interrupt handler but t=
he recovery fails=20
leaving the sdio stuck.
At this stage the only way to get out of it is unload/load of the driver mo=
dules.
Have you seen this on your side as well?

64 bytes from 192.168.100.1: seq=3D32772 ttl=3D64 time=3D9.644 ms
64 bytes from 192.168.100.1: seq=3D32773 ttl=3D64 time=3D9.572 ms
64 bytes from 192.168.100.1: seq=3D32774 ttl=3D64 time=3D10.974 ms
64 bytes from 192.168.100.1: seq=3D32775 ttl=3D64 time=3D9.618 ms
[127899.040526] wlcore: ERROR SW watchdog interrupt received! starting reco=
very.
[127899.047922] ------------[ cut here ]------------
[127899.053009] WARNING: CPU: 0 PID: 20135 at drivers/net/wireless/ti/wlcor=
e/main.c:806 wl12xx_queue_recovery_work+0x64/0x6c [wlcore]
[127899.064899] Modules linked in: wlcore_sdio wl18xx wlcore mac80211 cfg80=
211 ctr aes_arm_bs crypto_simd cryptd ccm usb_f_acm u_serial arc4 pru_rproc=
 pruss_intc usb_f_ecm pruss musb_dsps musb_hdrc phy_am335x usbcore phy_gene=
ric phy_am335x_control xfrm_user xfrm4_tunnel ipcomp xfrm_ipcomp esp4 ah4 g=
_multi usb_f_mass_storage usb_f_rndis af_key u_ether xfrm_algo libcomposite=
 udc_core usb_common bluetooth ecdh_generic snd_soc_simple_card snd_soc_sim=
ple_card_utils pm33xx wkup_m3_rproc wkup_m3_ipc remoteproc omap_aes_driver =
crypto_engine omap_crypto omap_sham ti_emif_sram pruss_soc_bus musb_am335x =
rtc_omap omap_wdt sch_fq_codel [last unloaded: cfg80211]
[127899.122874] CPU: 0 PID: 20135 Comm: irq/65-wl18xx Tainted: G        W  =
     4.14.40-01413-g9541ff6-dirty #107
[127899.132988] Hardware name: Generic AM33XX (Flattened Device Tree)
[127899.139247] Backtrace:
[127899.141866] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack=
+0x18/0x1c)
[127899.149636]  r6:00000000 r5:bf4e25fc r4:00000000 r3:00000000
[127899.155493] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x2=
0/0x28)
[127899.162876] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x=
104)
[127899.170032] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null=
+0x28/0x30)
[127899.177795]  r10:c0d4ea79 r8:c0169590 r7:db276658 r6:d6abaec8 r5:d6abad=
38 r4:d6abad00
[127899.185989] [<c01287e4>] (warn_slowpath_null) from [<bf4cd4d0>] (wl12xx=
_queue_recovery_work+0x64/0x6c [wlcore])
[127899.196605] [<bf4cd46c>] (wl12xx_queue_recovery_work [wlcore]) from [<b=
f4cda80>] (wlcore_irq+0x21c/0x234 [wlcore])
[127899.207161]  r4:d6abad00 r3:00000001
[127899.211036] [<bf4cd864>] (wlcore_irq [wlcore]) from [<c01695b4>] (irq_t=
hread_fn+0x24/0x3c)
[127899.219498]  r7:db276658 r6:db276600 r5:00000001 r4:d6818ec0
[127899.225341] [<c0169590>] (irq_thread_fn) from [<c0169260>] (irq_thread+=
0x10c/0x1ec)
[127899.233143]  r6:db276600 r5:00000001 r4:d6818ec0 r3:db361200
[127899.238997] [<c0169154>] (irq_thread) from [<c014526c>] (kthread+0x11c/=
0x154)
[127899.246324]  r10:c0169154 r8:d6818ec0 r7:d6818bd8 r6:d6818b80 r5:000000=
00 r4:d6818bc0
[127899.254313] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x1=
4/0x2c)
[127899.261724]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:000000=
00 r5:c0145150
[127899.269728]  r4:d6818b80 r3:ffffffff
[127899.273422] ---[ end trace 5ef4c2e6abb6b669 ]---
[127899.285612] wlcore: Hardware recovery in progress. FW ver: Rev 8.9.0.6.=
76
[127899.303137] wlcore: pc: 0xba1c, hint_sts: 0x00000000 count: 1
[127899.315757] wlcore: down
[127899.318420] wlcore: down
[127899.326230] ieee80211 phy0: Hardware restart was requested
[127901.063547] ------------[ cut here ]------------
[127901.068548] WARNING: CPU: 0 PID: 26417 at drivers/net/wireless/ti/wlcor=
e/sdio.c:145 wl12xx_sdio_raw_write+0xb4/0x138 [wlcore_sdio]
[127901.085327] Modules linked in: wlcore_sdio wl18xx wlcore mac80211 cfg80=
211 ctr aes_arm_bs crypto_simd cryptd ccm usb_f_acm u_serial arc4 pru_rproc=
 pruss_intc usb_f_ecm pruss musb_dsps musb_hdrc phy_am335x usbcore phy_gene=
ric phy_am335x_control xfrm_user xfrm4_tunnel ipcomp xfrm_ipcomp esp4 ah4 g=
_multi usb_f_mass_storage usb_f_rndis af_key u_ether xfrm_algo libcomposite=
 udc_core usb_common bluetooth ecdh_generic snd_soc_simple_card snd_soc_sim=
ple_card_utils pm33xx wkup_m3_rproc wkup_m3_ipc remoteproc omap_aes_driver =
crypto_engine omap_crypto omap_sham ti_emif_sram pruss_soc_bus musb_am335x =
rtc_omap omap_wdt sch_fq_codel [last unloaded: cfg80211]
[127901.160115] CPU: 0 PID: 26417 Comm: kworker/0:4 Tainted: G        W    =
   4.14.40-01413-g9541ff6-dirty #107
[127901.174489] Hardware name: Generic AM33XX (Flattened Device Tree)
[127901.185357] Workqueue: events_freezable ieee80211_restart_work [mac8021=
1]
[127901.192628] Backtrace:
[127901.200496] [<c010baf8>] (dump_backtrace) from [<c010bd5c>] (show_stack=
+0x18/0x1c)
[127901.214303]  r6:00000000 r5:bf073ad8 r4:00000000 r3:00000000
[127901.224251] [<c010bd44>] (show_stack) from [<c0805dd0>] (dump_stack+0x2=
0/0x28)
[127901.236220] [<c0805db0>] (dump_stack) from [<c01287bc>] (__warn+0xdc/0x=
104)
[127901.243355] [<c01286e0>] (__warn) from [<c012880c>] (warn_slowpath_null=
+0x28/0x30)
[127901.255388]  r10:00000000 r8:00004000 r7:d6838000 r6:db259c10 r5:000000=
00 r4:dc58ca00
[127901.270249] [<c01287e4>] (warn_slowpath_null) from [<bf0722fc>] (wl12xx=
_sdio_raw_write+0xb4/0x138 [wlcore_sdio])
[127901.284893] [<bf072248>] (wl12xx_sdio_raw_write [wlcore_sdio]) from [<b=
f4db23c>] (wlcore_boot_upload_firmware+0x1f0/0x444 [wlcore])
[127901.301116]  r10:e221f65c r8:d6838000 r7:bf4e9c40 r6:00014000 r5:000000=
00 r4:80900000
[127901.313657] [<bf4db04c>] (wlcore_boot_upload_firmware [wlcore]) from [<=
bf37205c>] (wl18xx_boot+0x974/0xd14 [wl18xx])
[127901.328804]  r10:00000000 r9:00000003 r8:db6b6bc8 r7:c0b134fc r6:bf4e9c=
40 r5:00000000
[127901.341001]  r4:d6abad00
[127901.344099] [<bf3716e8>] (wl18xx_boot [wl18xx]) from [<bf4cd18c>] (wl12=
71_op_add_interface+0x670/0x950 [wlcore])
[127901.359852]  r10:00000000 r8:db6b6bc8 r7:bf4e9c40 r6:d6abad38 r5:d6abad=
00 r4:00000000
[127901.374898] [<bf4ccb1c>] (wl1271_op_add_interface [wlcore]) from [<bf45=
cfe0>] (drv_add_interface+0x34/0x80 [mac80211])
[127901.390201]  r10:d6abaa00 r9:c0d0ea60 r8:00000000 r7:d6aba420 r6:d6aba4=
20 r5:db6b64e0
[127901.402221]  r4:db6b64e0
[127901.406026] [<bf45cfac>] (drv_add_interface [mac80211]) from [<bf48bfe8=
>] (ieee80211_reconfig+0x164/0xc0c [mac80211])
[127901.425079]  r4:d6aba420 r3:00000001
[127901.433671] [<bf48be84>] (ieee80211_reconfig [mac80211]) from [<bf45b35=
4>] (ieee80211_restart_work+0x90/0xbc [mac80211])
[127901.449257]  r10:00000000 r9:c0d0ea60 r8:00000000 r7:d6aba420 r6:d6aba4=
20 r5:d6abaa00
[127901.461411]  r4:d6abaa00
[127901.464785] [<bf45b2c4>] (ieee80211_restart_work [mac80211]) from [<c01=
3f128>] (process_one_work+0x12c/0x374)
[127901.480386]  r7:dcb39400 r6:c0d0ea60 r5:d6abac28 r4:db74e600
[127901.492467] [<c013effc>] (process_one_work) from [<c013f570>] (worker_t=
hread+0x1c0/0x5b8)
[127901.504786]  r10:00000008 r9:c0d0ea60 r8:c0d16380 r7:db74e618 r6:c0d0ea=
74 r5:c0d0ea60
[127901.517204]  r4:db74e600
[127901.519918] [<c013f3b0>] (worker_thread) from [<c014526c>] (kthread+0x1=
1c/0x154)
[127901.532463]  r10:c013f3b0 r9:d68fdeb4 r8:db74e600 r7:db4b2058 r6:db6ec4=
c0 r5:00000000
[127901.546911]  r4:db4b2040 r3:00000000
[127901.550678] [<c0145150>] (kthread) from [<c0107f68>] (ret_from_fork+0x1=
4/0x2c)
[127901.562972]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:000000=
00 r5:c0145150
[127901.577275]  r4:db6ec4c0 r3:ffffffff
[127901.580991] ---[ end trace 5ef4c2e6abb6b66a ]---
[127901.590827] wl1271_sdio mmc1:0001:2: sdio write failed (-110)
[127901.895777] ------------[ cut here ]------------
[127901.900624] WARNING: CPU: 0 PID: 26417 at drivers/net/wireless/ti/wlcor=
e/sdio.c:145 wl12xx_sdio_raw_write+0xb4/0x138 [wlcore_sdio]
[127901.920440] Modules linked in: wlcore_sdio wl18xx wlcore mac80211 cfg80=
211 ctr aes_arm_bs crypto_simd cryptd ccm usb_f_acm u_serial arc4 pru_rproc=
 pruss_intc usb_f_ecm pruss musb_dsps musb_hdrc phy_am335x usbcore phy_gene=
ric phy_am335x_

Best Regards,
Eyal
