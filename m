Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:35478 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031203Ab3HIV2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 17:28:37 -0400
Received: by mail-qc0-f178.google.com with SMTP id s1so2407324qcw.23
        for <linux-wireless@vger.kernel.org>; Fri, 09 Aug 2013 14:28:36 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 9 Aug 2013 23:28:36 +0200
Message-ID: <CAF1_xX0PfHsSduF0ZGYE-skfC2Q1ZJgtqpOH5iSzJvX9HJu1mg@mail.gmail.com> (sfid-20130809_232840_517414_D7A49152)
Subject: Re: [v3.10] [regression] [b43] : mac80211/minstrel: use the new rate
 control API
From: Ronald <ronald645@gmail.com>
To: linux-wireless@vger.kernel.org, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Excuse me, this should be a v3.10 regression.

2013/8/9 Ronald <ronald645@gmail.com>:
> [ Please cc me as I'm not subscribed ]
>
> Mentioned commit causes a regression on my box. It oopses after
> NetworkManager comes up and tries to use the card (I think).
>
> The card is:
>
> [    1.220907] b43-phy0: Broadcom 4311 WLAN found (core revision 10)
> [    1.230206] ata1.00: configured for UDMA/100
> [    1.320018] b43-phy0: Found PHY: Analog 4, Type 2 (G), Revision 8
> [    1.380120] Broadcom 43xx driver loaded [ Features: P ]
>
> I typed over the oops (first lines fell off, sorry):
>
> Workqueue: phy0 ieee80211_scan_work
> task: ffff880000211c20 ti: ffff880034c0c000 task.ti: ffff880034c0c000
> RIP: 0010:[<ffffffff81580382>] [<ffffffff81580382>] minstrel_get_rate+0x22/0x250
> RSP: 0018:ffff880034c0da88 EFLAGS: 00010286
> RAX: ffffffff81870ac0 RBX: 0000000000000000 RCX: ffff880034c0db58
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880034c67a00
> RBP: ffff880034c0dac8 R08: ffff8800000863a0 R09: 0000000000000fff
> R10: ffffffff81856020 R11: 0000000000000000 R12: ffff880034c67a00
> R13: ffff880034da2740 R14: ffff880034c0db58 R15: ffff88000039f940
> FS:  00007fd6da002700(0000) GS:ffffffff8181e000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000000005003b
> CR2: 0000000000000048 CR3: 000000003517e000 CR4: 00000000000007f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Stack:
>  0000000000000000 ffff880034c0db28 ffff880034c0daf8 ffff88003517c330
>  0000000000000000 ffff880034da2740 ffff880034c0db58 ffff88000039f940
>  ffff880034c0daf8 ffffffff815653e1 ffff880034c0dbe0 ffff88003517c300
> Call Trace:
>  [<ffffffff815653e1>] rate_control_get_rate+0xa1/0xe0
>  [<ffffffff815709e9>] invoke_tx_handlers+0x729/0x1360
>  [<ffffffff8104bc3d>] ? sched_clock_local.constprop.1+0x1d/0x90
>  [<ffffffff8104ce6e>] ? check_preempt_wakeup+0x11e/0x240
>  [<ffffffff8157169d>] ieee80211_tx+0x7d/0x100
>  [<ffffffff815717b1>] ieee80211_xmit+0x91/0xc0
>  [<ffffffff8157307e>] __ieee80211_tx_skb_tid_band+0x6e/0x80
>  [<ffffffff81577643>] ieee80211_send_probe_req+0x73/0xc0
>  [<ffffffff8155a10f>] ieee80211_scan_state_send_probe+0x9f/0xe0
>  [<ffffffff8155ad9c>] ieee80211_scan_work+0x1fc/0x440
>  [<ffffffff8103c9ba>] process_one_work+0x13a/0x3b0
>  [<ffffffff8103cfcb>] worker_thread+0x10b/0x350
>  [<ffffffff8103cec0>] ? rescuer_thread+0x250/0x250
>  [<ffffffff81042afa>] kthread+0xba/0xc0
>  [<ffffffff81042a40>] ? __kthread_parkme+0x80/0x80
>  [<ffffffff8158c32a>] ret_from_fork+0x7a/0xb0
>  [<ffffffff81042a40>] ? __kthread_parkme+0x80/0x80
> Code: 00 00 00 00 00 0f 1f 40 00 55 48 89 e5 48 83 ec 40 48 89 5d d8
> 4c 89 65 e0 48 89 d3 4c 89 6d e8 4c 89 7d f8 49 89 fc 4c 89 75 f0 <44>
> 0f b6 f7 4c 8b 71 18 48 89 ca 48 89 de 49 89 cd
> RIP  [<ffffffff81580382>] minstrel_get_rate+0x22/0x250
>  RSP <ffff880034c0da88>
> CR2: 0000000000000048
> ---[ end trace 071727ab6dc6fcf3 ]---
> Kernel panic - not syncing: Fatal exception in interrupt
> drm_kms_helper: panic occurred, switching back to text console
