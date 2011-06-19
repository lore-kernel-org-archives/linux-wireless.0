Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:63323 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab1FSRnT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 13:43:19 -0400
Date: Sun, 19 Jun 2011 19:44:44 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH wireless-2.6 v2] rt2x00: fix rmmod crash
Message-ID: <20110619174444.GA19934@localhost.localdomain> (sfid-20110619_194332_919529_D0804FAD)
References: <20110604144854.GA4865@localhost.localdomain>
 <20110604172940.GA10984@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20110604172940.GA10984@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 04, 2011 at 07:29:40PM +0200, Stanislaw Gruszka wrote:
> Jun  4 17:13:30 localhost kernel: [ 3054.165453] BUG kmalloc-4096: Redzone overwritten
> Jun  4 17:13:30 localhost kernel: [ 3054.165456] -----------------------------------------------------------------------------
> Jun  4 17:13:30 localhost kernel: [ 3054.165458] 
> Jun  4 17:13:30 localhost kernel: [ 3054.165462] INFO: 0xeeb4a032-0xeeb4a033. First byte 0xc0 instead of 0xcc
> Jun  4 17:13:30 localhost kernel: [ 3054.165478] INFO: Allocated in 0xc06f age=3761052035 cpu=3342336 pid=304021504
> Jun  4 17:13:30 localhost kernel: [ 3054.165484] INFO: Freed in 0xc06f age=4294917602 cpu=3342336 pid=1822949376
> Jun  4 17:13:30 localhost kernel: [ 3054.165489] INFO: Slab 0xf500d900 objects=7 used=5 fp=0xeeb48000 flags=0x40004081
> Jun  4 17:13:30 localhost kernel: [ 3054.165494] INFO: Object 0xeeb49030 @offset=4144 fp=0x0b06eeb4
> Jun  4 17:13:30 localhost kernel: [ 3054.165496] 
> Jun  4 17:13:30 localhost kernel: [ 3054.165499] Bytes b4 0xeeb49020:  34 00 00 00 a1 d6 29 00 5a 5a 5a 5a 5a 5a 5a 5a 4...¡Ö).ZZZZZZZZ
[snip]
> Jun  4 17:13:30 localhost kernel: [ 3054.171146]  Redzone 0xeeb4a030:  cc cc c0 c0                                     ÌÌÀÀ            
> Jun  4 17:13:30 localhost kernel: [ 3054.171166]  Padding 0xeeb4a058:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
> Jun  4 17:13:30 localhost kernel: [ 3054.171190] Pid: 51, comm: kworker/u:5 Tainted: G        W   3.0.0-rc1+ #111
> Jun  4 17:13:30 localhost kernel: [ 3054.171194] Call Trace:
> Jun  4 17:13:30 localhost kernel: [ 3054.171205]  [<c04d335f>] print_trailer+0xe2/0xea
> Jun  4 17:13:30 localhost kernel: [ 3054.171212]  [<c04d35ba>] check_bytes_and_report+0xa0/0xcc
> Jun  4 17:13:30 localhost kernel: [ 3054.171219]  [<c04d3cb9>] check_object+0x48/0x16e
> Jun  4 17:13:30 localhost kernel: [ 3054.171225]  [<c04d404f>] free_debug_processing+0x5f/0x16f
> Jun  4 17:13:30 localhost kernel: [ 3054.171233]  [<c045fa1f>] ? trace_hardirqs_off_caller+0x2e/0x86
> Jun  4 17:13:30 localhost kernel: [ 3054.171240]  [<c04d4480>] __slab_free+0x40/0x106
> Jun  4 17:13:30 localhost kernel: [ 3054.171248]  [<c06f1ffd>] ? skb_release_data+0x7c/0x80
> Jun  4 17:13:30 localhost kernel: [ 3054.171257]  [<c05b8f54>] ? debug_check_no_obj_freed+0x11/0x15
> Jun  4 17:13:30 localhost kernel: [ 3054.171263]  [<c04d4619>] kfree+0xd3/0xdc
> Jun  4 17:13:30 localhost kernel: [ 3054.171268]  [<c06f1ffd>] ? skb_release_data+0x7c/0x80
> Jun  4 17:13:30 localhost kernel: [ 3054.171274]  [<c0462536>] ? lock_acquire+0xac/0xb7
> Jun  4 17:13:30 localhost kernel: [ 3054.171281]  [<c06f1ffd>] ? skb_release_data+0x7c/0x80
> Jun  4 17:13:30 localhost kernel: [ 3054.171287]  [<c06f1ffd>] skb_release_data+0x7c/0x80
> Jun  4 17:13:30 localhost kernel: [ 3054.171293]  [<c06f221b>] __kfree_skb+0x17/0x74
> Jun  4 17:13:30 localhost kernel: [ 3054.171299]  [<c06f22cb>] consume_skb+0x53/0x57
> Jun  4 17:13:30 localhost kernel: [ 3054.171328]  [<f832bdb5>] ieee80211_rx+0x680/0x696 [mac80211]
> Jun  4 17:13:30 localhost kernel: [ 3054.171335]  [<c06f0a6a>] ? __alloc_skb+0x75/0x100
> Jun  4 17:13:30 localhost kernel: [ 3054.171342]  [<c0432f92>] ? get_parent_ip+0xb/0x31
> Jun  4 17:13:30 localhost kernel: [ 3054.171348]  [<c043de47>] ? __local_bh_disable+0x83/0x88
> Jun  4 17:13:30 localhost kernel: [ 3054.171359]  [<f835c90b>] rt2x00lib_rxdone+0x34e/0x392 [rt2x00lib]
> Jun  4 17:13:30 localhost kernel: [ 3054.171368]  [<f8d381e5>] rt2x00usb_work_rxdone+0x57/0x7f [rt2x00usb]
> Jun  4 17:13:30 localhost kernel: [ 3054.171376]  [<c044c43e>] process_one_work+0x1a6/0x2c8
> Jun  4 17:13:30 localhost kernel: [ 3054.171382]  [<f8d3818e>] ? rt2x00usb_work_txdone+0x7a/0x7a [rt2x00usb]
> Jun  4 17:13:30 localhost kernel: [ 3054.171389]  [<c044d547>] worker_thread+0xd3/0x14e
> Jun  4 17:13:30 localhost kernel: [ 3054.171395]  [<c044d474>] ? manage_workers.clone.11+0x14f/0x14f
> Jun  4 17:13:30 localhost kernel: [ 3054.171401]  [<c045048a>] kthread+0x72/0x77
> Jun  4 17:13:30 localhost kernel: [ 3054.171408]  [<c0450418>] ? __init_kthread_worker+0x47/0x47
> Jun  4 17:13:30 localhost kernel: [ 3054.171416]  [<c0761a42>] kernel_thread_helper+0x6/0x10
> Jun  4 17:13:30 localhost kernel: [ 3054.171421] FIX kmalloc-4096: Restoring 0xeeb4a032-0xeeb4a033=0xcc

I finally figured this out. Corruption happens not when module is
unloaded, but when is loaded. We get bad RX descriptors from hardware,
which may have random rxdesc.size and (dev_)flags. In consequence
rt2x00crypto_rx_insert_iv() may write to memory after allocated skb.

I will post 2 patches, first validate rxdesc.size, second reset
usb to prevent hardware undefined behaviour. However there
is still some problem here, device may stop to work after module
reload, probably some different kind of reset/initialization code
is also needed.

Stanislaw
