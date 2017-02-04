Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35506 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750876AbdBDP3J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Feb 2017 10:29:09 -0500
From: Dmitry Osipenko <digetx@gmail.com>
Subject: rtlwifi: rtl8192c_common: "BUG: KASAN: slab-out-of-bounds"
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com> (sfid-20170204_162944_624665_6D2A538B)
Date: Sat, 4 Feb 2017 18:29:04 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I ran a 4.9.7 kernel with CONFIG_KASAN=y on my machine and it detected the
following problem:

[   23.012238] rtl8192cu: MAC auto ON okay!
[   23.045656] rtl8192cu: Tx queue select: 0x05
[   23.541152] ==================================================================
[   23.541160] BUG: KASAN: slab-out-of-bounds in
rtl92c_dm_bt_coexist+0x858/0x1e40 [rtl8192c_common] at addr ffff8801c90edb08
[   23.541161] Read of size 1 by task kworker/0:1/38
[   23.541163] page:ffffea0007243800 count:1 mapcount:0 mapping:          (null)
index:0x0 compound_mapcount: 0
[   23.543194] flags: 0x8000000000004000(head)
[   23.545178] page dumped because: kasan: bad access detected
[   23.545181] CPU: 0 PID: 38 Comm: kworker/0:1 Not tainted 4.9.7-gentoo #3
[   23.545182] Hardware name: Gigabyte Technology Co., Ltd. To be filled by
O.E.M./Z77-DS3H, BIOS F11a 11/13/2013
[   23.545186] Workqueue: rtl92c_usb rtl_watchdog_wq_callback [rtlwifi]
[   23.545187]  0000000000000000 ffffffff829eea33 ffff8801d7f0fa30 ffff8801c90edb08
[   23.545189]  ffffffff824c0f09 ffff8801d4abee80 0000000000000004 0000000000000297
[   23.545191]  ffffffffc070b57c ffff8801c7aa7c48 ffff880100000004 ffffffff000003e8
[   23.545192] Call Trace:
[   23.545197]  [<ffffffff829eea33>] ? dump_stack+0x5c/0x79
[   23.545200]  [<ffffffff824c0f09>] ? kasan_report_error+0x4b9/0x4e0
[   23.545202]  [<ffffffffc070b57c>] ? _usb_read_sync+0x15c/0x280 [rtl_usb]
[   23.545204]  [<ffffffff824c0f75>] ? __asan_report_load1_noabort+0x45/0x50
[   23.545206]  [<ffffffffc06d7a88>] ? rtl92c_dm_bt_coexist+0x858/0x1e40
[rtl8192c_common]
[   23.545208]  [<ffffffffc06d7a88>] ? rtl92c_dm_bt_coexist+0x858/0x1e40
[rtl8192c_common]
[   23.545210]  [<ffffffffc06d0cbe>] ? rtl92c_dm_rf_saving+0x96e/0x1330
[rtl8192c_common]
[   23.545212]  [<ffffffffc06dab80>] ? rtl92c_dm_watchdog+0x1130/0x4590
[rtl8192c_common]
[   23.545214]  [<ffffffffc06d9a50>] ? rtl92c_dm_dynamic_txpower+0x9e0/0x9e0
[rtl8192c_common]
[   23.545216]  [<ffffffff8222038d>] ? pick_next_entity+0x18d/0x400
[   23.545218]  [<ffffffff8223fdde>] ? pick_next_task_fair+0xa6e/0xf60
[   23.545220]  [<ffffffff8207548a>] ? __switch_to+0x7ba/0x1160
[   23.545223]  [<ffffffffc0689a2b>] ? rtl_watchdog_wq_callback+0xb7b/0x1190
[rtlwifi]
[   23.545225]  [<ffffffffc0688eb0>] ? rtl_tx_mgmt_proc+0x2c0/0x2c0 [rtlwifi]
[   23.545228]  [<ffffffff82d1ecfe>] ? drm_fb_helper_dirty_work+0x25e/0x2f0
[   23.545230]  [<ffffffff83c65d20>] ? io_schedule_timeout+0x390/0x390
[   23.545233]  [<ffffffff82b8cef0>] ? update_attr.isra.2+0x170/0x170
[   23.545234]  [<ffffffff82b80a01>] ? fb_flashcursor+0x331/0x3e0
[   23.545237]  [<ffffffff821d7af9>] ? process_one_work+0x539/0x12b0
[   23.545239]  [<ffffffff821d894f>] ? worker_thread+0xdf/0x13e0
[   23.545240]  [<ffffffff8225343c>] ? __wake_up_common+0xbc/0x160
[   23.545242]  [<ffffffff821d8870>] ? process_one_work+0x12b0/0x12b0
[   23.545244]  [<ffffffff821e7f89>] ? kthread+0x1b9/0x210
[   23.545245]  [<ffffffff821e7dd0>] ? kthread_park+0x80/0x80
[   23.545247]  [<ffffffff821e7dd0>] ? kthread_park+0x80/0x80
[   23.545248]  [<ffffffff821e7dd0>] ? kthread_park+0x80/0x80
[   23.545250]  [<ffffffff83c724c5>] ? ret_from_fork+0x25/0x30
[   23.545251] Memory state around the buggy address:
[   23.545253]  ffff8801c90eda00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
[   23.545254]  ffff8801c90eda80: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
[   23.545255] >ffff8801c90edb00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
[   23.545256]                       ^
[   23.545257]  ffff8801c90edb80: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
[   23.545257]  ffff8801c90edc00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
[   23.545258] ==================================================================
[   23.545258] Disabling lock debugging due to kernel taint
[   23.545300] ==================================================================
[   23.545303] BUG: KASAN: slab-out-of-bounds in
rtl92c_dm_watchdog+0x3dfb/0x4590 [rtl8192c_common] at addr ffff8801c90edb1c
[   23.545304] Read of size 4 by task kworker/0:1/38
[   23.545305] page:ffffea0007243800 count:1 mapcount:0 mapping:          (null)
index:0x0 compound_mapcount: 0
[   23.547353] flags: 0x8000000000004000(head)
[   23.547354] page dumped because: kasan: bad access detected
[   23.547355] CPU: 0 PID: 38 Comm: kworker/0:1 Tainted: G    B
4.9.7-gentoo #3
[   23.547356] Hardware name: Gigabyte Technology Co., Ltd. To be filled by
O.E.M./Z77-DS3H, BIOS F11a 11/13/2013
[   23.547358] Workqueue: rtl92c_usb rtl_watchdog_wq_callback [rtlwifi]
[   23.547360]  0000000000000000 ffffffff829eea33 ffff8801d7f0fa80 ffff8801c90edb1c
[   23.547361]  ffffffff824c0f09 ffff8801c90e0748 ffff8801c90e1420 0000000000000297
[   23.547363]  ffff8801c90e1420 ffffffff824c0f75 ffff8801c90edb08 ffff8801c90edb08
[   23.547363] Call Trace:
[   23.547367]  [<ffffffff829eea33>] ? dump_stack+0x5c/0x79
[   23.547368]  [<ffffffff824c0f09>] ? kasan_report_error+0x4b9/0x4e0
[   23.547370]  [<ffffffff824c0f75>] ? __asan_report_load1_noabort+0x45/0x50
[   23.547371]  [<ffffffff824c1015>] ? __asan_report_load4_noabort+0x45/0x50
[   23.547373]  [<ffffffffc06dd84b>] ? rtl92c_dm_watchdog+0x3dfb/0x4590
[rtl8192c_common]
[   23.547375]  [<ffffffffc06dd84b>] ? rtl92c_dm_watchdog+0x3dfb/0x4590
[rtl8192c_common]
[   23.547377]  [<ffffffffc06d9a50>] ? rtl92c_dm_dynamic_txpower+0x9e0/0x9e0
[rtl8192c_common]
[   23.547378]  [<ffffffff8222038d>] ? pick_next_entity+0x18d/0x400
[   23.547380]  [<ffffffff8223fdde>] ? pick_next_task_fair+0xa6e/0xf60
[   23.547381]  [<ffffffff8207548a>] ? __switch_to+0x7ba/0x1160
[   23.547383]  [<ffffffffc0689a2b>] ? rtl_watchdog_wq_callback+0xb7b/0x1190
[rtlwifi]
[   23.547385]  [<ffffffffc0688eb0>] ? rtl_tx_mgmt_proc+0x2c0/0x2c0 [rtlwifi]
[   23.547387]  [<ffffffff82d1ecfe>] ? drm_fb_helper_dirty_work+0x25e/0x2f0
[   23.547388]  [<ffffffff83c65d20>] ? io_schedule_timeout+0x390/0x390
[   23.547390]  [<ffffffff82b8cef0>] ? update_attr.isra.2+0x170/0x170
[   23.547391]  [<ffffffff82b80a01>] ? fb_flashcursor+0x331/0x3e0
[   23.547393]  [<ffffffff821d7af9>] ? process_one_work+0x539/0x12b0
[   23.547394]  [<ffffffff821d894f>] ? worker_thread+0xdf/0x13e0
[   23.547396]  [<ffffffff8225343c>] ? __wake_up_common+0xbc/0x160
[   23.547398]  [<ffffffff821d8870>] ? process_one_work+0x12b0/0x12b0
[   23.547399]  [<ffffffff821e7f89>] ? kthread+0x1b9/0x210
[   23.547400]  [<ffffffff821e7dd0>] ? kthread_park+0x80/0x80
[   23.547401]  [<ffffffff821e7dd0>] ? kthread_park+0x80/0x80
[   23.547403]  [<ffffffff821e7dd0>] ? kthread_park+0x80/0x80
[   23.547404]  [<ffffffff83c724c5>] ? ret_from_fork+0x25/0x30
[   23.547405] Memory state around the buggy address:
[   23.547406]  ffff8801c90eda00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
[   23.547407]  ffff8801c90eda80: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
[   23.547407] >ffff8801c90edb00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
[   23.547408]                             ^
[   23.547409]  ffff8801c90edb80: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
[   23.547410]  ffff8801c90edc00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
[   23.547410] ==================================================================

-- 
Dmitry
