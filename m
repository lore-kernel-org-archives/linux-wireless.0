Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49209 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2H2PCG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 11:02:06 -0400
Received: by wibhq12 with SMTP id hq12so7817567wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2012 08:02:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <45566970CF58C74CB52107862E0541CD1D1AC80D@POCITMSEXMB03.LntUniverse.com>
References: <45566970CF58C74CB52107862E0541CD1D1AC80D@POCITMSEXMB03.LntUniverse.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 29 Aug 2012 18:01:47 +0300
Message-ID: <CA+XVXfcD4jMYQUy25pqWTBq18ZN7pMg++j-mZqW14GqC2OmfOA@mail.gmail.com> (sfid-20120829_170212_448531_01FD5F7A)
Subject: Re: Crash with Wl12xx driver while Concurrent operation(P2P and Wi-Fi legacy)
To: Girish Bn <Girish.BN@lnties.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 28, 2012 at 5:45 PM, Girish Bn <Girish.BN@lnties.com> wrote:
> [  725.900000] [<bf0b8c24>] (wl1271_op_bss_info_changed+0x0/0xc24 [wlcore]) from [<bf06a56c>] (ieee80211_bss_info_change_notify+0x1dc/0x200 [mac80211])
> [  725.900000] [<bf06a390>] (ieee80211_bss_info_change_notify+0x0/0x200 [mac80211]) from [<bf089b98>] (ieee80211_reconfig+0x584/0x9a0 [mac80211])
> [  725.900000]  r7:c161a888 r6:c15f07d0 r5:c161a3a0 r4:c159cb00
> [  725.900000] [<bf089614>] (ieee80211_reconfig+0x0/0x9a0 [mac80211]) from [<bf06b460>] (ieee80211_restart_work+0x7c/0x94 [mac80211])
> [  725.910000] [<bf06b3e4>] (ieee80211_restart_work+0x0/0x94 [mac80211]) from [<c00487a4>] (run_workqueue+0xc4/0x14c)
> [  725.910000]  r7:00000000 r6:bf06b3e4 r5:c14d2000 r4:c1fef280
> [  725.910000] [<c00486e0>] (run_workqueue+0x0/0x14c) from [<c0048f18>] (worker_thread+0x10c/0x120)
> [  725.910000]  r7:c1fef288 r6:c14d3fa4 r5:c14d2000 r4:c1fef280
> [  725.910000] [<c0048e0c>] (worker_thread+0x0/0x120) from [<c004c888>] (kthread+0x60/0x9c)
> [  725.910000]  r7:00000000 r6:c1fef280 r5:c0048e0c r4:c14d2000
> [  725.910000] [<c004c828>] (kthread+0x0/0x9c) from [<c003ab6c>] (do_exit+0x0/0x734)
> [  725.910000]  r7:00000000 r6:00000000 r5:00000000 r4:00000000
> [  725.910000] ---[ end trace 1cd0b968bc5f5a81 ]---
> [  725.910000] wl12xx: ERROR AP rate policy change failed -22
> Can you please let me know the reason behind crash? Also confirm the driver and firmware version being used is right or not?

Seems you have problems since you're using p2p_go in multiple
interface mode (p2p-wlan0-0). Try removing
"driver_param=use_p2p_group_interface=1" from your wpa_s.conf and
apply this patch:
https://github.com/TI-OpenLink/hostap/commit/b0f48bcc8a61cf620412202166d0d6947f3ba26e
