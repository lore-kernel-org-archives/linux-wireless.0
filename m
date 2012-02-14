Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from remail2.raritan.com ([62.132.199.138]:45682 "EHLO
	remail2.raritan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2BNPvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 10:51:35 -0500
Message-ID: <4F3A7F71.6000008@raritan.com> (sfid-20120214_165139_246814_70383B69)
Date: Tue, 14 Feb 2012 16:36:17 +0100
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net
CC: linux-wireless@vger.kernel.org
Subject: rtlwifi/rtl8192cu: scheduling while atomic / sleeping function called
 from invalid context
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I just got the below traces with the rtlwifi driver in linux 3.2.5 and a
rtl8192cu chip. It looks like that _usb_read_sync() and kmalloc(...,
GFP_KERNEL) is called while the rcu lock is held inside
rtl92c_dm_refresh_rate_adaptive_mask.

BUG: sleeping function called from invalid context at mm/slub.c:935
in_atomic(): 1, irqs_disabled(): 0, pid: 128, name: kworker/0:1
[<c000e158>] (unwind_backtrace+0x0/0x12c) from [<c02db684>] (dump_stack+0x20/0x24)
[<c02db684>] (dump_stack+0x20/0x24) from [<c0017238>] (__might_sleep+0x104/0x124)
[<c0017238>] (__might_sleep+0x104/0x124) from [<c00b123c>] (kmem_cache_alloc_trace+0x4c/0x1f0)
[<c00b123c>] (kmem_cache_alloc_trace+0x4c/0x1f0) from [<bf20b398>] (_usb_read_sync+0x40/0xd0 [rtlwifi])
[<bf20b398>] (_usb_read_sync+0x40/0xd0 [rtlwifi]) from [<bf20b44c>] (_usb_read32_sync+0x24/0x28 [rtlwifi])
[<bf20b44c>] (_usb_read32_sync+0x24/0x28 [rtlwifi]) from [<bf2a0be4>] (rtl92cu_update_hal_rate_table+0x1c8/0x210 [rtl8192cu])
[<bf2a0be4>] (rtl92cu_update_hal_rate_table+0x1c8/0x210 [rtl8192cu]) from [<bf21e950>] (rtl92c_dm_watchdog+0x10ec/0x1390 [rtl8192c_common])
[<bf21e950>] (rtl92c_dm_watchdog+0x10ec/0x1390 [rtl8192c_common]) from [<bf200484>] (rtl_watchdog_wq_callback+0x2ec/0x320 [rtlwifi])
[<bf200484>] (rtl_watchdog_wq_callback+0x2ec/0x320 [rtlwifi]) from [<c00398c4>] (process_one_work+0x294/0x474)
[<c00398c4>] (process_one_work+0x294/0x474) from [<c003c0a8>] (worker_thread+0x214/0x344)
[<c003c0a8>] (worker_thread+0x214/0x344) from [<c0040330>] (kthread+0x94/0x9c)
[<c0040330>] (kthread+0x94/0x9c) from [<c0009eec>] (kernel_thread_exit+0x0/0x8)

BUG: scheduling while atomic: kworker/0:1/128/0x00000002
Modules linked in: rtl8192cu aes_generic r8712u(C) arc4 rtl8192c_common rtlwifi rt2800usb rt2800lib crc_ccitt rt2x00usb rt2x00lib ath9k_htc ath9k_common ath9k_hw carl9170 mac80211 firmware_class ath cfg80211 g_serial v4l2_int_device uvcvideo v4l2_common videodev [last unloaded: rtl8192cu]
[<c000e158>] (unwind_backtrace+0x0/0x12c) from [<c02db684>] (dump_stack+0x20/0x24)
[<c02db684>] (dump_stack+0x20/0x24) from [<c0017770>] (__schedule_bug+0x70/0x7c)
[<c0017770>] (__schedule_bug+0x70/0x7c) from [<c02dbe40>] (__schedule+0x68/0x548)
[<c02dbe40>] (__schedule+0x68/0x548) from [<c02dc454>] (schedule+0x80/0x84)
[<c02dc454>] (schedule+0x80/0x84) from [<c02dc76c>] (schedule_timeout+0x28/0x2d4)
[<c02dc76c>] (schedule_timeout+0x28/0x2d4) from [<c02dbc2c>] (wait_for_common+0x110/0x1e0)
[<c02dbc2c>] (wait_for_common+0x110/0x1e0) from [<c02dbdb0>] (wait_for_completion_timeout+0x1c/0x20)
[<c02dbdb0>] (wait_for_completion_timeout+0x1c/0x20) from [<c01e5738>] (usb_start_wait_urb+0x78/0x13c)
[<c01e5738>] (usb_start_wait_urb+0x78/0x13c) from [<c01e5a08>] (usb_control_msg+0xdc/0x108)
[<c01e5a08>] (usb_control_msg+0xdc/0x108) from [<bf20b3e8>] (_usb_read_sync+0x90/0xd0 [rtlwifi])
[<bf20b3e8>] (_usb_read_sync+0x90/0xd0 [rtlwifi]) from [<bf20b44c>] (_usb_read32_sync+0x24/0x28 [rtlwifi])
[<bf20b44c>] (_usb_read32_sync+0x24/0x28 [rtlwifi]) from [<bf2a0be4>] (rtl92cu_update_hal_rate_table+0x1c8/0x210 [rtl8192cu])
[<bf2a0be4>] (rtl92cu_update_hal_rate_table+0x1c8/0x210 [rtl8192cu]) from [<bf21e950>] (rtl92c_dm_watchdog+0x10ec/0x1390 [rtl8192c_common])
[<bf21e950>] (rtl92c_dm_watchdog+0x10ec/0x1390 [rtl8192c_common]) from [<bf200484>] (rtl_watchdog_wq_callback+0x2ec/0x320 [rtlwifi])
[<bf200484>] (rtl_watchdog_wq_callback+0x2ec/0x320 [rtlwifi]) from [<c00398c4>] (process_one_work+0x294/0x474)
[<c00398c4>] (process_one_work+0x294/0x474) from [<c003c0a8>] (worker_thread+0x214/0x344)
[<c003c0a8>] (worker_thread+0x214/0x344) from [<c0040330>] (kthread+0x94/0x9c)
[<c0040330>] (kthread+0x94/0x9c) from [<c0009eec>] (kernel_thread_exit+0x0/0x8)

I hope you can fix this.

Thanks,
Ronald

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Burkhard Wessler
