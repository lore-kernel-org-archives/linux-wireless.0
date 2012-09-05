Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51668 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2IEJjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 05:39:23 -0400
Received: by ieje11 with SMTP id e11so690355iej.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2012 02:39:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <45566970CF58C74CB52107862E0541CD1D1B0BFB@POCITMSEXMB03.LntUniverse.com>
References: <45566970CF58C74CB52107862E0541CD1D1B0BFB@POCITMSEXMB03.LntUniverse.com>
Date: Wed, 5 Sep 2012 12:39:23 +0300
Message-ID: <CAB3XZEd9mJMW-BeR3DhMg4ocCkLBDn41poAzGCpU7A2Apy1GJg@mail.gmail.com> (sfid-20120905_113927_960262_0FD25325)
Subject: Re: Crash with Wl12xx driver while Concurrent operation(P2P and Wi-Fi legacy)
From: Eliad Peller <eliad@wizery.com>
To: Girish Bn <Girish.BN@lnties.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 5, 2012 at 7:48 AM, Girish Bn <Girish.BN@lnties.com> wrote:
> Hi TI developers,
>
> Can anybody answer this? I am waiting for the reply
>
> Thanks
> Girish
>
> -----Original Message-----
> From: Girish Bn
> Sent: Tuesday, August 28, 2012 8:17 PM
> To: 'linux-wireless@vger.kernel.org'
> Subject: Crash with Wl12xx driver while Concurrent operation(P2P and Wi-Fi legacy)
>

> /wlan # dmesg
> Powering on wl12xx<6>Powering up MMC Slot<6>wl12xx: firmware booted (Rev 6.3.10.2.115) [  724.990000] wl12xx: down [  724.990000] Powering off wl12xx<6>Powering down MMC Slot<6>ieee80211 phy0: Hardware restart was requested [  725.030000] Powering on wl12xx<6>Powering up MMC Slot<6>wl12xx: firmware booted (Rev 6.5.7.0.27) [  725.900000] ------------[ cut here ]------------ [  725.900000] WARNING: at /home/bps/compat-wireless-2012-08-26/drivers/net/wireless/ti/wlcore/tx.c:1114 wl1271_tx_min_rate_get+0x28/0x54 [wlcore]() [  725.900000] Modules linked in: wlcore_sdio wl12xx wlcore compat_firmware_class mac80211 cfg80211 rfkill_backport compat lpc313x_mmc g_serial nxp_usb2_udc [  725.900000] [<c0205590>] (dump_stack+0x0/0x1c) from [<c0037b80>] (warn_on_slowpath+0x54/0x70) [  725.900000] [<c0037b2c>] (warn_on_slowpath+0x0/0x70) from [<bf0c0e98>] (wl1271_tx_min_rate_get+0x28/0x54 [wlcore]) [  725.900000]  r6:c161a890 r5:c159d780 r4:00000000 [  725.900000] [<bf0c0e70>] (wl1271_tx_min_rate_get+0x0/0x54 [wlcore]) from [<bf0b8d00>] (wl1271_op_bss_info_changed+0xdc/0xc24 [wlcore]) [  725.900000]  r5:c159d780 r4:c161a928 [  725.900000] [<bf0b8c24>] (wl1271_op_bss_info_changed+0x0/0xc24 [wlcore]) from [<bf06a56c>] (ieee80211_bss_info_change_notify+0x1dc/0x200 [mac80211]) [  725.900000] [<bf06a390>] (ieee80211_bss_info_change_notify+0x0/0x200 [mac80211]) from [<bf089b98>] (ieee80211_reconfig+0x584/0x9a0 [mac80211]) [  725.900000]  r7:c161a888 r6:c15f07d0 r5:c161a3a0 r4:c159cb00 [  725.900000] [<bf089614>] (ieee80211_reconfig+0x0/0x9a0 [mac80211]) from [<bf06b460>] (ieee80211_restart_work+0x7c/0x94 [mac80211]) [  725.910000] [<bf06b3e4>] (ieee80211_restart_work+0x0/0x94 [mac80211]) from [<c00487a4>] (run_workqueue+0xc4/0x14c) [  725.910000]  r7:00000000 r6:bf06b3e4 r5:c14d2000 r4:c1fef280 [  725.910000] [<c00486e0>] (run_workqueue+0x0/0x14c) from [<c0048f18>] (worker_thread+0x10c/0x120) [  725.910000]  r7:c1fef288 r6:c14d3fa4 r5:c14d2000 r4:c1fef280 [  725.910000] [<c0048e0c>] (worker_thread+0x0/0x120) from [<c004c888>] (kthread+0x60/0x9c) [  725.910000]  r7:00000000 r6:c1fef280 r5:c0048e0c r4:c14d2000 [  725.910000] [<c004c828>] (kthread+0x0/0x9c) from [<c003ab6c>] (do_exit+0x0/0x734) [  725.910000]  r7:00000000 r6:00000000 r5:00000000 r4:00000000 [  725.910000] ---[ end trace 1cd0b968bc5f5a81 ]--- [  725.910000] wl12xx: ERROR AP rate policy change failed -22 Can you please let me know the reason behind crash? Also confirm the driver and firmware version being used is right or not?
>

this doesn't look like a crash, but only a warning.
please try applying the following supplicant patch:
https://github.com/TI-OpenLink/hostap/commit/6ef9363d1bd503e622106a5250bb58619a709b13

Eliad.
