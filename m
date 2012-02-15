Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from remail2.raritan.com ([62.132.199.138]:23780 "EHLO
	remail2.raritan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab2BONkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 08:40:23 -0500
Message-ID: <4F3BB5C4.9040803@raritan.com> (sfid-20120215_144029_146019_01263C32)
Date: Wed, 15 Feb 2012 14:40:20 +0100
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtlwifi/rtl8192cu: scheduling while atomic / sleeping function
 called from invalid context
References: <4F3A7F71.6000008@raritan.com> <4F3ACC50.2000201@lwfinger.net>
In-Reply-To: <4F3ACC50.2000201@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14.02.2012 22:04, Larry Finger wrote:
> On 02/14/2012 09:36 AM, Ronald Wahl wrote:
>> Hi,
>>
>> I just got the below traces with the rtlwifi driver in linux 3.2.5 and a
>> rtl8192cu chip. It looks like that _usb_read_sync() and kmalloc(...,
>> GFP_KERNEL) is called while the rcu lock is held inside
>> rtl92c_dm_refresh_rate_adaptive_mask.
> 
> --snip--
> 
>> I hope you can fix this.
> 
> Thanks to your analysis, it was easy. Routine 
> rtl92c_dm_refresh_rate_adaptive_mask() makes a callback to 
> rtlpriv->cfg->ops->update_rate_tbl() with the lock held. For rtl8192ce, 
> it is OK, but rtl8192cu kmallocs a data buffer. The irony is that 
> rtl8192cu does not use the ieee80211_sta struct, which is what is being 
> locked. The quick fix is to release the lock in the affected routine and 
> reacquire it before the exit. The real fix will be to redefine the 
> callback routines. That will be done for 3.4, but we need to get 3.2 and 
> 3.3 fixed first.
> 
> Could you please test this patch?

Thanks for the patch. It improves the situation but I found a second trace
during association:

BUG: sleeping function called from invalid context at mm/slub.c:935
in_atomic(): 1, irqs_disabled(): 0, pid: 11580, name: kworker/u:2
[<c000e158>] (unwind_backtrace+0x0/0x12c) from [<c02db684>] (dump_stack+0x20/0x24)
[<c02db684>] (dump_stack+0x20/0x24) from [<c0017238>] (__might_sleep+0x104/0x124)
[<c0017238>] (__might_sleep+0x104/0x124) from [<c00b123c>] (kmem_cache_alloc_trace+0x4c/0x1f0)
[<c00b123c>] (kmem_cache_alloc_trace+0x4c/0x1f0) from [<bf459398>] (_usb_read_sync+0x40/0xd0 [rtlwifi])
[<bf459398>] (_usb_read_sync+0x40/0xd0 [rtlwifi]) from [<bf45944c>] (_usb_read32_sync+0x24/0x28 [rtlwifi])
[<bf45944c>] (_usb_read32_sync+0x24/0x28 [rtlwifi]) from [<bf486c04>] (rtl92cu_update_hal_rate_table+0x1e8/0x24c [rtl8192cu])
[<bf486c04>] (rtl92cu_update_hal_rate_table+0x1e8/0x24c [rtl8192cu]) from [<bf451830>] (rtl_op_sta_add+0x114/0x13c [rtlwifi])
[<bf451830>] (rtl_op_sta_add+0x114/0x13c [rtlwifi]) from [<bf0bd4d0>] (sta_info_finish_insert+0x80/0x204 [mac80211])
[<bf0bd4d0>] (sta_info_finish_insert+0x80/0x204 [mac80211]) from [<bf0bdb18>] (sta_info_insert_non_ibss+0x108/0x140 [mac80211])
[<bf0bdb18>] (sta_info_insert_non_ibss+0x108/0x140 [mac80211]) from [<bf0bdfc0>] (sta_info_reinsert+0x4c/0x78 [mac80211])
[<bf0bdfc0>] (sta_info_reinsert+0x4c/0x78 [mac80211]) from [<bf0c7d4c>] (ieee80211_assoc_success+0x474/0x7c0 [mac80211])
[<bf0c7d4c>] (ieee80211_assoc_success+0x474/0x7c0 [mac80211]) from [<bf0c81c0>] (ieee80211_assoc_done+0x128/0x1e4 [mac80211])
[<bf0c81c0>] (ieee80211_assoc_done+0x128/0x1e4 [mac80211]) from [<bf0c98a8>] (ieee80211_work_work+0x2c0/0x11c0 [mac80211])
[<bf0c98a8>] (ieee80211_work_work+0x2c0/0x11c0 [mac80211]) from [<c00398c4>] (process_one_work+0x294/0x474)
[<c00398c4>] (process_one_work+0x294/0x474) from [<c003c0a8>] (worker_thread+0x214/0x344)
[<c003c0a8>] (worker_thread+0x214/0x344) from [<c0040330>] (kthread+0x94/0x9c)
[<c0040330>] (kthread+0x94/0x9c) from [<c0009eec>] (kernel_thread_exit+0x0/0x8)

Here it looks like the lock is held in the mac80211 layer ouside of the
lowlevel driver. I tried GFP_ATOMIC in _usb_read_sync() but this does not
work because on one hand usb_control_msg() calls non-atomic kmalloc() itself
and we also wait for completion of the usb transfer.

Note: I'm away until end of next week so I can't test any further patches
      during that time.

thanks,
ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Burkhard Wessler
