Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755216AbYGaC5V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 22:57:21 -0400
Date: Wed, 30 Jul 2008 19:56:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [BUG] wireless : cpu stuck for 61s
Message-Id: <20080730195637.2197a82d.akpm@linux-foundation.org> (sfid-20080731_045727_974288_0FEE9E75)
In-Reply-To: <a8e1da0807301906j6438e5d8y64105fe8a2e3dffe@mail.gmail.com>
References: <20080729055731.GA3265@darkstar>
	<1217334724.10489.47.camel@johannes.berg>
	<20080730020820.8bcc00e2.akpm@linux-foundation.org>
	<a8e1da0807300302m35a0a7c0q2ff2e0ab92a69239@mail.gmail.com>
	<20080730031047.54e13e2d.akpm@linux-foundation.org>
	<a8e1da0807301906j6438e5d8y64105fe8a2e3dffe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 31 Jul 2008 10:06:31 +0800 "Dave Young" <hidave.darkstar@gmail.=
com> wrote:

>=20
> Ok here it is.
> BTW, I run "klogd -c 7" after boot

The sysrq output is still missing lots of stuff.  I guess we broke it.

>=20
> This time I get a kmalloc poison overwritten:
>

<fixes wordwrapping, cleans stuff up>

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
BUG kmalloc-4096: Poison overwritten
-----------------------------------------------------------------------=
------

INFO: 0xf6f3a080-0xf6f3a0ef. First byte 0x80 instead of 0x6b
INFO: Allocated in dev_alloc_skb+0x1c/0x30 age=3D3642 cpu=3D0 pid=3D0
INFO: Freed in skb_release_data+0x57/0x80 age=3D3146 cpu=3D0 pid=3D2398
INFO: Slab 0xc1c05440 objects=3D7 used=3D3 fp=3D0xf6f3a060 flags=3D0x40=
0020c3
INFO: Object 0xf6f3a060 @offset=3D8288 fp=3D0xf6f39030

Bytes b4 0xf6f3a050:  5e 09 00 00 57 c9 05 00 5a 5a 5a 5a 5a 5a 5a 5a ^=
=2E..W=C9..ZZZZZZZZ
Object 0xf6f3a060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkk=
kkkkkkkkkkkkk
Object 0xf6f3a070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkk=
kkkkkkkkkkkkk
Object 0xf6f3a080:  80 00 00 00 ff ff ff ff ff ff 00 17 7b 00 46 40 ...=
=2E=FF=FF=FF=FF=FF=FF..{.F@
Object 0xf6f3a090:  00 17 7b 00 46 40 30 09 81 21 08 7a 21 00 00 00 ..{=
=2EF@0..!.z!...
Object 0xf6f3a0a0:  64 00 21 04 00 07 00 00 00 00 00 00 00 01 08 82 d.!=
=2E............
Object 0xf6f3a0b0:  84 8b 0c 12 96 18 24 03 01 01 05 04 00 02 00 00 ...=
=2E..$.........
Object 0xf6f3a0c0:  07 06 43 4e 20 01 0d 14 2a 01 00 32 04 30 48 60 ..C=
N....*..2.0H`
Object 0xf6f3a0d0:  6c dd 18 00 17 7b 01 04 00 00 00 01 00 00 00 10 l=DD=
=2E..{..........
Redzone 0xf6f3b060:  bb bb bb bb                                     =BB=
=BB=BB=BB           =20
Padding 0xf6f3b088:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZ=
ZZZZZZ       =20
Pid: 0, comm: swapper Tainted: G        W 2.6.26-smp #2
[<c0180f5d>] print_trailer+0xad/0xf0
[<c018103b>] check_bytes_and_report+0x9b/0xc0
[<c018145e>] check_object+0x19e/0x1e0
[<c01821a4>] __slab_alloc+0x454/0x4f0
[<c01834d6>] __kmalloc_track_caller+0xe6/0xf0
[<c03dd1ec>] ? dev_alloc_skb+0x1c/0x30
[<c03dd1ec>] ? dev_alloc_skb+0x1c/0x30
[<c03dce79>] __alloc_skb+0x49/0x100
[<c03dd1ec>] dev_alloc_skb+0x1c/0x30
[<f8a58599>] ath5k_rxbuf_setup+0x39/0x200 [ath5k]
[<f8a5a697>] ath5k_tasklet_rx+0x127/0x5c0 [ath5k]
[<c014969a>] ? print_lock_contention_bug+0x1a/0xe0
[<c012eafc>] tasklet_action+0x4c/0xc0
[<c012e463>] __do_softirq+0x93/0x120
[<c012e547>] do_softirq+0x57/0x60
[<c012ea29>] irq_exit+0x69/0x80
[<c0106b55>] do_IRQ+0x45/0x80
[<c010a5d0>] ? mwait_idle+0x0/0x50
[<c0104752>] common_interrupt+0x2e/0x34
[<c010a5d0>] ? mwait_idle+0x0/0x50
[<c010a609>] ? mwait_idle+0x39/0x50
[<c01026e0>] cpu_idle+0x60/0xd0
[<c043c8ce>] rest_init+0x4e/0x60
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=46IX kmalloc-4096: Restoring 0xf6f3a080-0xf6f3a0ef=3D0x6b

=46IX kmalloc-4096: Marking all objects used
[<c0243b4f>] ? security_file_permission+0xf/0x20
[<c019436f>] sys_select+0x3f/0x190
[<c01878e9>] ? fput+0x19/0x20
[<c0103dbf>] ? restore_nocheck+0x12/0x15
[<c014b06d>] ? trace_hardirqs_on+0xbd/0x140
[<c0103d5e>] syscall_call+0x7/0xb
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

argh, that stuff hurts my brain.  None of the numbers seem to make any
sense for a 4k allocation :( Pekka, do you have time to decrypt this?

Dave, could you please remind us which net driver was in use here?

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
