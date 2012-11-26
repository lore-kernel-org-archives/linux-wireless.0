Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60506 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2KZLuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 06:50:51 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so5586564lbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 03:50:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1351820654-24433-1-git-send-email-bzhao@marvell.com>
References: <1351820654-24433-1-git-send-email-bzhao@marvell.com>
Date: Mon, 26 Nov 2012 13:50:49 +0200
Message-ID: <CAMXE1-ptP5hEK_Bn4wU5jykcXxcpKf9uj4tR8gz5Cfp873iHvQ@mail.gmail.com> (sfid-20121126_125054_907084_F6235B4B)
Subject: Re: [PATCH] mwifiex: add support for SDIO card reset
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Tim Shepard <shep@laptop.org>, Daniel Drake <dsd@laptop.org>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

On Fri, Nov 2, 2012 at 3:44 AM, Bing Zhao <bzhao@marvell.com> wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
>
> When command timeout happens due to a bug in firmware/hardware,
> the timeout handler just prints some debug information. User is
> unable to reload the driver in this case.
>
> Inspired by 9a821f5 "libertas: add sd8686 reset_card support",
> this patch adds card reset support for SDIO interface when
> command timeout happens. If the SDIO host contoller supports
> MMC_POWER_OFF|UP|ON operations, the chip will be reset and the
> firmware will be re-downloaded.

After this patch my board started to reset itself frequently. Before I have seen
warnings but it was working (somehow).

See logs below:

[ 7402.431601] ieee80211 phy12: uap0: changing to 2 not supported
[ 7402.432234] Bluetooth: Skip incorrect packet: hdrlen 3077 buffer 64
[ 7412.436879] Bluetooth: hci1 command tx timeout
[ 7412.468830] Bluetooth: hci0 command tx timeout
[ 7412.468842] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func:
Timeout cmd id (1353927138.543839) = 0x10c, act = 0x1
[ 7412.468852] mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
[ 7412.468857] mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
[ 7412.468863] mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 1
[ 7412.468868] mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
[ 7412.468873] mwifiex_sdio mmc0:0001:1: last_cmd_index = 0
[ 7412.468879] mwifiex_sdio mmc0:0001:1: last_cmd_id: 0c 01 28 00 28
00 e4 00 0c 01
[ 7412.468885] mwifiex_sdio mmc0:0001:1: last_cmd_act: 01 00 13 01 13
01 ff 00 01 00
[ 7412.468890] mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 4
[ 7412.468896] mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 0c 81 28 80
28 80 e4 80 0c 81
[ 7412.468901] mwifiex_sdio mmc0:0001:1: last_event_index = 0
[ 7412.468907] mwifiex_sdio mmc0:0001:1: last_event: 00 00 00 00 00 00
00 00 00 00
[ 7412.468913] mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=1
[ 7412.468921] mwifiex_sdio mmc0:0001:1: ps_mode=1 ps_state=0
[ 7412.469014] mwifiex_sdio: Resetting card...
[ 7412.469452] mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0,
cmd_pending=-1
[ 7412.589781] mmc0:0001:1: pending IRQ with no handler
[ 7477.264586] kmemleak: 2 new suspected memory leaks (see
/sys/kernel/debug/kmemleak)
[ 7558.642494] INFO: task kworker/3:0:32056 blocked for more than 120 seconds.
[ 7558.642505] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 7558.642511] kworker/3:0     D 00000000     0 32056      2 0x00000000
[ 7558.642523]  e68f9cf0 00000086 f0e19694 00000000 00000004 f53ceae0
e0de9b71 000006bd
[ 7558.642544]  c19cb680 c19cb680 00008194 c1ed9f28 f55c9680 f0e191d0
c10a7f4d e68f9d1c
[ 7558.642563]  c10a7f4d f0e191d0 0ca6209c 00000004 0066850d 00008194
00598194 c1ecff58
[ 7558.642584] Call Trace:
[ 7558.642603]  [<c10a7f4d>] ? __lock_acquire+0x3ad/0x1770
[ 7558.642612]  [<c10a7f4d>] ? __lock_acquire+0x3ad/0x1770
[ 7558.642628]  [<c15fc2c3>] schedule+0x23/0x60
[ 7558.642639]  [<c15fa005>] schedule_timeout+0x135/0x1f0
[ 7558.642651]  [<c10a6c65>] ? mark_held_locks+0x85/0xe0
[ 7558.642660]  [<c15fd6d7>] ? _raw_spin_unlock_irq+0x27/0x40
[ 7558.642671]  [<c15fc172>] wait_for_common+0xd2/0x120
[ 7558.642682]  [<c107f330>] ? try_to_wake_up+0x290/0x290
[ 7558.642692]  [<c15fc297>] wait_for_completion+0x17/0x20
[ 7558.642703]  [<c106d587>] kthread_stop+0x47/0xf0
[ 7558.642717]  [<f8502ad6>] btmrvl_remove_card+0x36/0x80 [btmrvl]
[ 7558.642727]  [<f852f6d2>] btmrvl_sdio_remove+0x42/0x80 [btmrvl_sdio]
[ 7558.642737]  [<c14e1fc2>] sdio_bus_remove+0x32/0x100
[ 7558.642747]  [<c13cd841>] ? __pm_runtime_idle+0x61/0xa0
[ 7558.642760]  [<c13c2cb4>] __device_release_driver+0x64/0xc0
[ 7558.642769]  [<c13c2f96>] device_release_driver+0x26/0x40
[ 7558.642779]  [<c13c27f6>] bus_remove_device+0xb6/0x110
[ 7558.642789]  [<c13bfb2a>] ? device_remove_attrs+0x2a/0x60
[ 7558.642797]  [<c13c01b5>] device_del+0xe5/0x150
[ 7558.642806]  [<c14e21dc>] sdio_remove_func+0x1c/0x30
[ 7558.642814]  [<c14e0fbc>] mmc_sdio_remove+0x3c/0x80
[ 7558.642824]  [<c14da1f1>] mmc_stop_host+0x71/0x110
[ 7558.642835]  [<c14daa6d>] mmc_remove_host+0x1d/0x40
[ 7558.642845]  [<f8861877>] sdio_card_reset_worker+0x27/0x50 [mwifiex_sdio]
[ 7558.642856]  [<c106670b>] process_one_work+0x18b/0x4c0
[ 7558.642865]  [<c1066694>] ? process_one_work+0x114/0x4c0
[ 7558.642875]  [<f8861850>] ? mwifiex_register_dev+0x120/0x120 [mwifiex_sdio]
[ 7558.642886]  [<c1067e49>] worker_thread+0x119/0x3a0
[ 7558.642896]  [<c1067d30>] ? __next_gcwq_cpu+0x60/0x60
[ 7558.642904]  [<c106d52f>] kthread+0x9f/0xb0
[ 7558.642915]  [<c1604e37>] ret_from_kernel_thread+0x1b/0x28
[ 7558.642924]  [<c106d490>] ? kthread_create_on_node+0xe0/0xe0
[ 7558.642931] 3 locks held by kworker/3:0/32056:
[ 7558.642935]  #0:  (events){.+.+.+}, at: [<c1066694>]
process_one_work+0x114/0x4c0
[ 7558.642953]  #1:  (card_reset_work){+.+.+.}, at: [<c1066694>]
process_one_work+0x114/0x4c0
[ 7558.642970]  #2:  (&__lockdep_no_validate__){......}, at:
[<c13c2f8f>] device_release_driver+0x1f/0x40
[ 7678.604370] INFO: task kworker/3:0:32056 blocked for more than 120 seconds.
[ 7678.604381] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 7678.604387] kworker/3:0     D 00000000     0 32056      2 0x00000000
[ 7678.604400]  e68f9cf0 00000086 f0e19694 00000000 00000004 f53ceae0
e0de9b71 000006bd
[ 7678.604421]  c19cb680 c19cb680 00008194 c1ed9f28 f55c9680 f0e191d0
c10a7f4d e68f9d1c
[ 7678.604440]  c10a7f4d f0e191d0 0ca6209c 00000004 0066850d 00008194
00598194 c1ecff58
[ 7678.604461] Call Trace:
[ 7678.604479]  [<c10a7f4d>] ? __lock_acquire+0x3ad/0x1770
[ 7678.604487]  [<c10a7f4d>] ? __lock_acquire+0x3ad/0x1770
[ 7678.604503]  [<c15fc2c3>] schedule+0x23/0x60
[ 7678.604513]  [<c15fa005>] schedule_timeout+0x135/0x1f0
[ 7678.604526]  [<c10a6c65>] ? mark_held_locks+0x85/0xe0
[ 7678.604535]  [<c15fd6d7>] ? _raw_spin_unlock_irq+0x27/0x40
[ 7678.604546]  [<c15fc172>] wait_for_common+0xd2/0x120
[ 7678.604557]  [<c107f330>] ? try_to_wake_up+0x290/0x290
[ 7678.604568]  [<c15fc297>] wait_for_completion+0x17/0x20
[ 7678.604578]  [<c106d587>] kthread_stop+0x47/0xf0
[ 7678.604592]  [<f8502ad6>] btmrvl_remove_card+0x36/0x80 [btmrvl]
[ 7678.604602]  [<f852f6d2>] btmrvl_sdio_remove+0x42/0x80 [btmrvl_sdio]
[ 7678.604612]  [<c14e1fc2>] sdio_bus_remove+0x32/0x100
[ 7678.604622]  [<c13cd841>] ? __pm_runtime_idle+0x61/0xa0
[ 7678.604634]  [<c13c2cb4>] __device_release_driver+0x64/0xc0
[ 7678.604644]  [<c13c2f96>] device_release_driver+0x26/0x40
[ 7678.604653]  [<c13c27f6>] bus_remove_device+0xb6/0x110
[ 7678.604663]  [<c13bfb2a>] ? device_remove_attrs+0x2a/0x60
[ 7678.604671]  [<c13c01b5>] device_del+0xe5/0x150
[ 7678.604680]  [<c14e21dc>] sdio_remove_func+0x1c/0x30
[ 7678.604688]  [<c14e0fbc>] mmc_sdio_remove+0x3c/0x80
[ 7678.604698]  [<c14da1f1>] mmc_stop_host+0x71/0x110
[ 7678.604709]  [<c14daa6d>] mmc_remove_host+0x1d/0x40
[ 7678.604718]  [<f8861877>] sdio_card_reset_worker+0x27/0x50 [mwifiex_sdio]
[ 7678.604731]  [<c106670b>] process_one_work+0x18b/0x4c0
[ 7678.604741]  [<c1066694>] ? process_one_work+0x114/0x4c0
[ 7678.604750]  [<f8861850>] ? mwifiex_register_dev+0x120/0x120 [mwifiex_sdio]
[ 7678.604761]  [<c1067e49>] worker_thread+0x119/0x3a0
[ 7678.604771]  [<c1067d30>] ? __next_gcwq_cpu+0x60/0x60
[ 7678.604779]  [<c106d52f>] kthread+0x9f/0xb0
[ 7678.604790]  [<c1604e37>] ret_from_kernel_thread+0x1b/0x28
[ 7678.604799]  [<c106d490>] ? kthread_create_on_node+0xe0/0xe0

< skipped>

Regards,
Andrei
