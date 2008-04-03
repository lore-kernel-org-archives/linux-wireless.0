Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20125 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759817AbYDCPZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 11:25:56 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: iwlwifi/rfkill cause iwlwifi problem and slab corruption
Date: Thu, 3 Apr 2008 08:24:59 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004195078@orsmsx416.amr.corp.intel.com> (sfid-20080403_162632_448650_D4C480C6)
In-Reply-To: <1207145976.3957.7.camel@johannes.berg>
References: <1207145976.3957.7.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, April 02, 2008 7:20 AM, Johannes Berg  wrote:

> Hi,
> 
> When I tried to rmmod iwl4965, iwlcore and mac80211, I got:
> 
> [  176.440255] iwl4965: No space for Tx
> [  176.440262] iwl4965: Error sending REPLY_CARD_STATE_CMD:
> enqueue_hcmd failed: -28 
> 
> I cannot explain this.
> 
> Also, later, this happened came out of the kernel:
> 
> [  173.589186]
> ===============================================================
> ============== [  173.589209] BUG kmalloc-2048: Poison overwritten [ 
> 173.589216] 
> ---------------------------------------------------------------
> --------------
> [  173.589219]
> [  173.589231] INFO: 0xc000000118fc8b23-0xc000000118fc8b23.
> First byte 0x6a instead of 0x6b
> [  173.589240] INFO: Allocated in .rfkill_allocate+0x40/0xf4
> [rfkill] age=2367858 cpu=2 pid=1125
> [  173.589273] INFO: Freed in .rfkill_release+0x24/0x4c
> [rfkill] age=509691 cpu=0 pid=6294
> [  173.589290] INFO: Slab 0xc000000008c61b00 used=14
> fp=0xc000000118fc8848 flags=0x40c3
> [  173.589297] INFO: Object 0xc000000118fc8848 @offset=2120
> fp=0x0000000000000000 [  173.589300]
> [  173.589305] Bytes b4 0xc000000118fc8838:  00 00 00 00 ff fb
> 93 eb 5a 5a 5a 5a 5a 5a 5a 5a ....XX.XZZZZZZZZ
> [  173.589433]   Object 0xc000000118fc8848:  6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  173.589561]   Object 0xc000000118fc8858:  6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  173.589689]   Object 0xc000000118fc8868:  6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  173.589818]   Object 0xc000000118fc8878:  6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  173.589949]   Object 0xc000000118fc8888:  6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  173.590072]   Object 0xc000000118fc8898:  6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  173.590133]   Object 0xc000000118fc88a8:  6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  173.590133]   Object 0xc000000118fc88b8:  6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  173.590133]  Redzone 0xc000000118fc9048:  bb bb bb bb bb bb
> bb bb                         XXXXXXXX
> [  173.590133]  Padding 0xc000000118fc9088:  5a 5a 5a 5a 5a 5a
> 5a 5a                         ZZZZZZZZ
> [  173.590133] Call Trace:
> [  173.590133] [c000000115c3f290] [c00000000000fa0c]
> .show_stack+0x78/0x1b0 (unreliable)
> [  173.590133] [c000000115c3f350] [c0000000003e154c]
> .dump_stack+0x20/0x34 [  173.590133] [c000000115c3f3d0]
> [c0000000000d6aa0] .print_trailer+0x1a4/0x1d0 [  173.590133]
> [c000000115c3f470] [c0000000000d6bd8]
> .check_bytes_and_report+0x10c/0x17c [  173.590133] [c000000115c3f530]
> [c0000000000d6da8] .check_object+0xfc/0x26c [  173.590133]
> [c000000115c3f5e0] [c0000000000d8ddc] .__slab_alloc+0x600/0x744 [ 
> 173.590133] [c000000115c3f6b0] [c0000000000d8fc0]
> .kmem_cache_alloc+0xa0/0x12c [  173.590133] [c000000115c3f760]
> [c000000000348a10] .__scm_send+0xd8/0x330 [  173.590133]
> [c000000115c3f820] [c0000000003ca484] .unix_stream_sendmsg+0xd8/0x46c
> [  173.590133] [c000000115c3f950] [c00000000033baac]
> .sock_sendmsg+0xc4/0xfc [  173.590133] [c000000115c3fb50]
> [c00000000033bce0] .sys_sendmsg+0x1fc/0x294 [  173.590133]
> [c000000115c3fd80] [c000000000361ddc]
> .compat_sys_socketcall+0x1f4/0x238 [  173.590133] [c000000115c3fe30]
> [c000000000007754] syscall_exit+0x0/0x40 [  173.590133] FIX
> kmalloc-2048: Restoring 0xc000000118fc8b23-0xc000000118fc8b23=0x6b [ 
> 173.590133] [  173.590133] FIX kmalloc-2048: Marking all objects used
> 
> And, uh, don't ask me why my time seems to be going backwards.

yeah ... we started seeing this here also. We are debugging it. May be
related to us calling rfkill_unregister as well as rfkill_free, which we
should not.

Thanks

Reinette
