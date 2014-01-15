Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46842 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaAOSnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 13:43:10 -0500
Received: by mail-wg0-f44.google.com with SMTP id l18so2175520wgh.35
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 10:43:08 -0800 (PST)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <CAN8YU5NqZxz0pjyk2dwLXRPaXeSCwp4bT37w6GtkbUQYuK53Rw@mail.gmail.com>
References: <CAN8YU5NTKUtS8+YzmcOSM3=YUX-FSwLTD86F_hXsNdVkw5NEGA@mail.gmail.com>
	<522F584E.6000806@lwfinger.net>
	<CAN8YU5PCFj-gtQwuuR3fM52YAVTi_5NYPbDVj-KMSzMpXjvFWQ@mail.gmail.com>
	<CAN8YU5PGkx9s9deWpFTO_ZtDr-+wDD5cX2JRv1zd1m1Q0BpkCw@mail.gmail.com>
	<52D6B31F.8080007@lwfinger.net>
	<CAN8YU5NLzULTB1H0WMEfyL6jKn8naAM95fm3n0RT02KUXWe68Q@mail.gmail.com>
	<52D6C871.7020302@lwfinger.net>
	<CAN8YU5NqZxz0pjyk2dwLXRPaXeSCwp4bT37w6GtkbUQYuK53Rw@mail.gmail.com>
Date: Wed, 15 Jan 2014 19:43:08 +0100
Message-ID: <CAN8YU5NVS0Xi7Lx854AUpNm3agxW91p01tZMFgDwHZvhc=6B3w@mail.gmail.com> (sfid-20140115_194314_648788_9EE24B35)
Subject: Re: RTL8187SE staging Linux driver
From: Andrea Merello <andrea.merello@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	John Linville <linville@tuxdriver.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

should be
+                (hw->max_signal < 0),

I'm sorry, I did something wrong in my git commit

On Wed, Jan 15, 2014 at 7:41 PM, Andrea Merello
<andrea.merello@gmail.com> wrote:
> Thank you.
>
> The driver tries to set this in rtl8180_probe, line 2140
> dev->max_signal = 65;
>
> I have no idea yet if this will be overwritten somewhere other or
> whatever else..
>
> In this case maybe the value become corrupted later on, after mac80211
> initialization, BTW, what about making mac80211 robust to at least
> wrong initialization?
> Simulating a initialization to zero, the following patch will triggers
> also lot of other WARN_ON because of broken signal information, but
> should avoid the panic..
>
> BTW Currently i'm not able to reproduce the rtl8187se bug anymore :(
>
> From cdc000007a1226b9daaab2d8354aab55127c1fb4 Mon Sep 17 00:00:00 2001
> From: andrea merello <andrea.merello@gmail.com>
> Date: Wed, 15 Jan 2014 19:17:25 +0100
> Subject: [PATCH] MAC80211: Issue a WARN and prevent divide by zero when
>  max_signal is not set
>
> if the driver sets IEEE80211_HW_SIGNAL_UNSPEC, then mac80211 tries to
> perform a division by max_signal while scanning.
>
> Print a warn and set a dummy value.
> This should result is wrong signal information but avoid a crash.
> ---
>  net/mac80211/main.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index d767cfb..449c417 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -753,6 +753,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>         netdev_features_t feature_whitelist;
>         struct cfg80211_chan_def dflt_chandef = {};
>
> +       if (WARN((hw->flags & IEEE80211_HW_SIGNAL_UNSPEC) &&
> +                (hw->max_signal < 0),
> +                "max_signal not set while set IEEE80211_HW_SIGNAL_UNSPEC\n"))
> +           hw->max_signal = 1;
> +
>         if (hw->flags & IEEE80211_HW_QUEUE_CONTROL &&
>             (local->hw.offchannel_tx_hw_queue == IEEE80211_INVAL_HW_QUEUE ||
>              local->hw.offchannel_tx_hw_queue >= local->hw.queues))
> --
> 1.8.3.2
>
>
>
>
>
> On Wed, Jan 15, 2014 at 6:42 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 01/15/2014 11:22 AM, Andrea Merello wrote:
>>>
>>> Hello,
>>> Thank you for testing!
>>>
>>> This is interesting:
>>> I ever worked on this patch on an older wireless-testing tree, that
>>> gave me no oops after lot of time.
>>>
>>> Yesterday, before sending you my patch, I ported it to a newer
>>> wireless-testing, and I did just a quick compile/load test.
>>> But today I got  panic me too with the new kernel...
>>>
>>> I have a serial console over I could capture the the oops..
>>> I will look at this issue in next days...
>>>
>>> 86509.384436] divide error: 0000 [#1] PREEMPT SMP
>>> [86509.387743] Modules linked in: rtl8180(O) mac80211 cfbfillrect
>>> cfbimgblt cfbcopyarea drm_kms_helper cfg80211 ttm [last unloaded:
>>> rtl8180]
>>> [86509.399253] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O
>>> 3.13.0-rc7-wl+ #16
>>> [86509.399253] Hardware name: System manufacturer System Product
>>> Name/M3N78 PRO, BIOS ASUS M3N78 PRO ACPI BIOS Revision 1402 12/04/2009
>>> [86509.399253] task: ffffffff81c10460 ti: ffffffff81c00000 task.ti:
>>> ffffffff81c00000
>>> [86509.428032] RIP: 0010:[<ffffffffa00fdac2>]  [<ffffffffa00fdac2>]
>>> ieee80211_bss_info_update+0x1c2/0x350 [mac80211]
>>> [86509.433405] RSP: 0018:ffff88006fc03cb8  EFLAGS: 00010202
>>> [86509.441368] RAX: 00000000000003e8 RBX: ffff88006fc03d08 RCX:
>>> 0000000000000077
>>> [86509.451441] RDX: 0000000000000000 RSI: ffff880068aa97b0 RDI:
>>> 0000000000000000
>>> [86509.451441] RBP: ffff88006fc03cf8 R08: ffff88006fc03d08 R09:
>>> 000000000000000a
>>> [86509.464969] R10: ffff88006fc03d08 R11: 0000000000000000 R12:
>>> ffff880068a93300
>>> [86509.464969] R13: ffff88006c2db628 R14: ffff880068a93301 R15:
>>> ffff880068aa84c0
>>> [86509.478134] FS:  00007f413fab8800(0000) GS:ffff88006fc00000(0000)
>>> knlGS:0000000000000000
>>> [86509.488032] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> [86509.489400] CR2: 00007f413eedbfc9 CR3: 0000000001c0b000 CR4:
>>> 00000000000007f0
>>> [86509.494704] Stack:
>>> [86509.494704]  0000000000000000 0000000000000000 0000000020000000
>>> ffff88006c2db600
>>> [86509.494704]  ffff880068a93300 ffff880068aa84c0 ffff880068a93300
>>> ffff880068aa9ac0
>>> [86509.494704]  ffff88006fc03e38 ffffffffa00fdd8e ffff880068a93324
>>> 0000000000000053
>>> [86509.494704] Call Trace:
>>> [86509.494704]  <IRQ>
>>> [86509.494704]  [<ffffffffa00fdd8e>] ieee80211_scan_rx+0x13e/0x1a0
>>> [mac80211]
>>> [86509.494704]  [<ffffffffa0114ff0>] ieee80211_rx+0x700/0x7c0 [mac80211]
>>> [86509.494704]  [<ffffffffa00f6119>]
>>> ieee80211_tasklet_handler+0xb9/0xc0 [mac80211]
>>> [86509.494704]  [<ffffffff8106b3c7>] tasklet_action+0xa7/0xb0
>>> [86509.494704]  [<ffffffff8106b7fd>] __do_softirq+0xcd/0x1d0
>>> [86509.494704]  [<ffffffff8106bba6>] irq_exit+0x76/0xa0
>>> [86509.494704]  [<ffffffff81032dde>] do_IRQ+0x5e/0xd0
>>> [86509.494704]  [<ffffffff817210ea>] common_interrupt+0x6a/0x6a
>>> [86509.494704]  <EOI>
>>> [86509.494704]  [<ffffffff81039198>] ? amd_e400_idle+0x68/0xe0
>>> [86509.494704]  [<ffffffff810398c6>] arch_cpu_idle+0x16/0x20
>>> [86509.494704]  [<ffffffff810a0d6d>] cpu_startup_entry+0x11d/0x170
>>> [86509.494704]  [<ffffffff8171344f>] rest_init+0x7f/0x90
>>> [86509.494704]  [<ffffffff81cb0d63>] start_kernel+0x307/0x313
>>> [86509.494704]  [<ffffffff81cb0865>] ? repair_env_string+0x5c/0x5c
>>> [86509.494704]  [<ffffffff81cb05a3>] x86_64_start_reservations+0x2a/0x2c
>>> [86509.494704]  [<ffffffff81cb066c>] x86_64_start_kernel+0xc7/0xca
>>> [86509.494704] Code: 5e 41 5f 5d c3 0f 1f 40 00 45 31 c9 83 e7 20 0f
>>> 84 9f fe ff ff 45 0f be 4d 21 bf 64 00 00 00 44 89 c8 0f af c7 41 0f
>>> be 7f 74 99 <f7> ff 41 89 c1 e9 7f fe ff ff 0
>>> [86509.494704] RIP  [<ffffffffa00fdac2>]
>>> ieee80211_bss_info_update+0x1c2/0x350 [mac80211]
>>> [86509.494704]  RSP <ffff88006fc03cb8>
>>> [86509.654701] ---[ end trace 08e0a7abe35b1caf ]---
>>> [86509.661368] Kernel panic - not syncing: Fatal exception in interrupt
>>
>>
>> The divide fault occurs because hw.max_signal was not set in line 75 of
>> net/mac80211/scan.c. The failing line is
>>
>>       signal = (rx_status->signal * 100) / local->hw.max_signal;
>>
>> I have not yet looked to see where that info comes from in the driver.
>>
>> Larry
>>
>>
>>
