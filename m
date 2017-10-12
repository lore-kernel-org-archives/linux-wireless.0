Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49898 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbdJLJ7c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 05:59:32 -0400
Date: Thu, 12 Oct 2017 10:59:25 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: linux-wireless@vger.kernel.org, "Reizer, Eyal" <eyalr@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>
Subject: wl1837: ERROR SW watchdog interrupt received! starting recovery
Message-ID: <20171012095925.GC20805@n2100.armlinux.org.uk> (sfid-20171012_120033_966222_933E15A2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like ti wilink is unmaintained, so I've added some people who
have touched the driver recently.

Running wl1837 on a Hummingboard2 (iMX6 Dual core) I've seen one instance
of the warning below.  Luckily, the recovery worked and connectivity was
maintained.

...
wlcore: Association completed.

After 19532s from boot, I saw:

wlcore: ERROR SW watchdog interrupt received! starting recovery.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 244 at drivers/net/wireless/ti/wlcore/main.c:796 wl12xx_queue_recovery_work+0x68/0x70 [wlcore]
Modules linked in: nfsd wl18xx wlcore mac80211 cfg80211 caam_jr imx_media_ic(C) imx_media_vdic(C) snd_soc_imx_sgtl5000 snd_soc_fsl_asoc_card imx_media_csi(C) imx_media_capture(C) snd_soc_imx_audmux wlcore_sdio snd_soc_sgtl5000 mux_mmio video_mux mux_core ci_hdrc_imx ci_hdrc caam udc_core usbmisc_imx imx_sdma imx2_wdt coda v4l2_mem2mem videobuf2_v4l2 rc_cec imx_vdoa videobuf2_dma_contig videobuf2_core videobuf2_vmalloc videobuf2_memops imx_thermal snd_soc_fsl_ssi imx_pcm_dma imx_media(C) dw_hdmi_ahb_audio dw_hdmi_cec imx_media_common(C) v4l2_fwnode etnaviv
CPU: 0 PID: 244 Comm: irq/243-wl18xx Tainted: G         C      4.14.0-rc1+ #2209
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Backtrace:
[<c0015288>] (dump_backtrace) from [<c00154ec>] (show_stack+0x18/0x1c)
 r6:60000013 r5:ffffffff r4:00000000 r3:00000000
[<c00154d4>] (show_stack) from [<c072d13c>] (dump_stack+0xa4/0xdc)
[<c072d098>] (dump_stack) from [<c003835c>] (__warn+0xdc/0x108)
 r6:bf376a48 r5:00000000 r4:00000000 r3:c0a41530
[<c0038280>] (__warn) from [<c00383b0>] (warn_slowpath_null+0x28/0x30)
 r10:ee309950 r8:ee30973c r7:00000000 r6:ee309788 r5:ee309704 r4:ee3096e0
[<c0038388>] (warn_slowpath_null) from [<bf3620c4>] (wl12xx_queue_recovery_work+0x68/0x70 [wlcore])
[<bf36205c>] (wl12xx_queue_recovery_work [wlcore]) from [<bf362228>] (wlcore_irq+0x15c/0x174 [wlcore])
 r4:ee3096e0 r3:00000001
[<bf3620cc>] (wlcore_irq [wlcore]) from [<c00a4710>] (irq_thread_fn+0x24/0x3c)
 r10:c00a46ec r8:ee349b00 r7:ef2ffc00 r6:ef2ffc00 r5:00000000 r4:ee349b00
[<c00a46ec>] (irq_thread_fn) from [<c00a48ac>] (irq_thread+0x128/0x1ec)
 r6:00000001 r5:00000000 r4:ee349b24 r3:00000004
[<c00a4784>] (irq_thread) from [<c005cd58>] (kthread+0x150/0x198)[19532.504033]  r10:c00a4784 r9:ef111d10 r8:ee349b00 r7:ee2b9680 r6:ee349c00 r5:00000000
 r4:ee2b9600
[<c005cc08>] (kthread) from [<c0010458>] (ret_from_fork+0x14/0x3c)
 r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c005cc08
 r4:ee349c00 r3:ed9a8000
---[ end trace b35f1ada6f716c27 ]---
wlcore: Hardware recovery in progress. FW ver: Rev 8.9.0.0.75
wlcore: pc: 0x116424, hint_sts: 0x00000000 count: 1
wlcore: down
ieee80211 phy0: Hardware restart was requested
wlcore: PHY firmware version: Rev 8.2.0.0.240
wlcore: firmware booted (Rev 8.9.0.0.75)
wlcore: Association completed.

The interrupt, according to /proc/interrupts, shows:

           CPU0       CPU1
243:      32387          0  gpio-mxc   4 Level     wl18xx

although that's from about a day or so after boot.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
