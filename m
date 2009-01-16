Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f31.google.com ([209.85.219.31]:39645 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759622AbZAPXqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 18:46:17 -0500
Received: by ewy12 with SMTP id 12so674499ewy.13
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 15:46:15 -0800 (PST)
Message-ID: <49711C45.6070704@gmail.com> (sfid-20090117_004633_196366_DCD38C17)
Date: Sat, 17 Jan 2009 00:46:13 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901162138.51855.chunkeey@web.de> <497105D1.5040906@gmail.com> <200901162352.32037.chunkeey@web.de>
In-Reply-To: <200901162352.32037.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Friday 16 January 2009 23:10:25 Artur Skawina wrote:
>> Christian Lamparter wrote:
>>> On Friday 16 January 2009 10:13:07 Johannes Berg wrote:
>>>> On Thu, 2009-01-15 at 21:18 -0600, Larry Finger wrote:
>>>>
>>>>>>>   Object 0xddec18d0:  >69< 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ikkkkkkkkkkkkkkk
>>>>> I too have seen real single bit changes - in my case 6b went to 6a,
>>>>> and my memory is fine. I wouldn't necessarily blame your hardware.
>>>> 6b to 6a is often the result of a refcounting bug that happens to unref
>>>> a value _after_ it has been freed. But that doesn't explain 6b to 69,
>>>> unless you happen to have _two_ refcounting bugs. Not that I necessarily
>>>> think that memory is bad
>>> Well, this idiotic debug patch (kref-kernel-debug-patch) could shed some light into
>>> the problem who's using a freed skb. 
>> didn't trigger anything here, just the usual:
>>
>> BUG kmalloc-4096: Poison overwritten
>> -----------------------------------------------------------------------------
>>
>> INFO: 0xdc8161b0-0xdc8161b0. First byte 0x6a instead of 0x6b
>> INFO: Allocated in dev_alloc_skb+0x19/0x30 age=1762 cpu=0 pid=3530
>> INFO: Freed in __kfree_skb+0xf/0x90 age=613 cpu=0 pid=3527
>> INFO: Slab 0xc1390200 objects=7 used=5 fp=0xdc816120 flags=0x400020c2
>> INFO: Object 0xdc816120 @offset=24864 fp=0xdc8140c0
>>
>> but no other warnings...
> but the refcount-test-module.c works on your system?
> 
> It should produce something like:

yes, that works.

RefTest
RefTest - Static
released dfb02f10
RefTest - Watermark test
------------[ cut here ]------------
WARNING: at lib/kref.c:67 kref_put+0x65/0xb0()
Modules linked in: refcount_test_module(+) netconsole saa7134_empress saa6752hs lnbp21 s5h1420 saa7134 videobuf_dma_sg budget videobuf_core tveeprom budget_ci budget_core saa7146 ttpci_eeprom serio_raw ir_common [last unloaded: microcode]
Pid: 3592, comm: insmod Not tainted 2.6.29-rc1-00280-g0fe8b7d-dirty #49
Call Trace:
 [<c04d3a46>] ? printk+0x18/0x1a
 [<c0122cb3>] warn_slowpath+0x73/0xd0
 [<c01274ba>] ? irq_exit+0x2a/0x80
 [<c0110803>] ? smp_apic_timer_interrupt+0x43/0x80
 [<c0103714>] ? apic_timer_interrupt+0x28/0x30
 [<c0123800>] ? vprintk+0x110/0x2e0
 [<e2060000>] ? reftst_release+0x0/0x18 [refcount_test_module]
 [<c04d3a46>] ? printk+0x18/0x1a
 [<e2060016>] ? reftst_release+0x16/0x18 [refcount_test_module]
 [<e2060000>] ? reftst_release+0x0/0x18 [refcount_test_module]
 [<c0245955>] kref_put+0x65/0xb0
 [<e2063000>] ? reftst_init+0x0/0xbd [refcount_test_module]
 [<e2063074>] reftst_init+0x74/0xbd [refcount_test_module]
 [<e2063000>] ? reftst_init+0x0/0xbd [refcount_test_module]
 [<c010102a>] _stext+0x2a/0x150
 [<c0145cc8>] sys_init_module+0x88/0x1c0
 [<c016face>] ? sys_close+0x6e/0xb0
 [<c0103146>] sysenter_do_call+0x12/0x25
 [<c04d0000>] ? p54u_probe+0xa0/0x13c0
---[ end trace 5d36c2dda20ece59 ]---
RefTest - slXb poison test
------------[ cut here ]------------
WARNING: at lib/kref.c:67 kref_put+0x65/0xb0()
Modules linked in: refcount_test_module(+) netconsole saa7134_empress saa6752hs lnbp21 s5h1420 saa7134 videobuf_dma_sg budget videobuf_core tveeprom budget_ci budget_core saa7146 ttpci_eeprom serio_raw ir_common [last unloaded: microcode]
Pid: 3592, comm: insmod Tainted: G        W  2.6.29-rc1-00280-g0fe8b7d-dirty #49
Call Trace:
 [<c04d3a46>] ? printk+0x18/0x1a
 [<c0122cb3>] warn_slowpath+0x73/0xd0
[...]
=============================================================================
BUG kmalloc-96: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xdeaedda0-0xdeaedda0. First byte 0x6a instead of 0x6b
INFO: Allocated in 0xe2063083 age=6932 cpu=0 pid=3592
INFO: Freed in 0xe20630af age=6928 cpu=0 pid=3592
INFO: Slab 0xc13d5da0 objects=28 used=26 fp=0xdeaedd80 flags=0x400000c2
INFO: Object 0xdeaedd80 @offset=3456 fp=0xdeaed480

artur
