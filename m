Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64093 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZLUQlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 11:41:04 -0500
Received: by bwz27 with SMTP id 27so3587773bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 08:41:00 -0800 (PST)
Subject: Re: Panic in iwl3945 driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1259774227.26287.2.camel@maxim-laptop>
References: <1259167780.4072.2.camel@maxim-laptop>
	 <1259280022.3991.12.camel@maxim-laptop>
	 <1259596551.4090.0.camel@maxim-laptop>  <1259617333.4653.91.camel@rc-desk>
	 <1259620526.6559.34.camel@maxim-laptop> <1259659724.12157.110.camel@debian>
	 <1259732550.12157.130.camel@debian> <1259774227.26287.2.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 18:40:54 +0200
Message-ID: <1261413654.3556.6.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-12-02 at 19:17 +0200, Maxim Levitsky wrote: 
> On Wed, 2009-12-02 at 13:42 +0800, Zhu Yi wrote: 
> > On Tue, 2009-12-01 at 17:28 +0800, Zhu Yi wrote:
> > > On Tue, 2009-12-01 at 06:35 +0800, Maxim Levitsky wrote:
> > > > 0x000000000001668e <iwl3945_rx_reply_tx+302>:	lea    0x38(%r8),%rdi
> > > > 0x0000000000016692 <iwl3945_rx_reply_tx+306>:	lea    0x4f(%r8),%rax
> > > 
> > > When this happened, from your previous post, r8 is 0x0 and rdi is 0x38.
> > > Since "info" is %rdi (see below), this means
> > > txq->txb[txq->q.read_ptr].skb[0], aka. r8 is 0.
> > > 
> > > > 	rate_idx = iwl3945_hwrate_to_plcp_idx(tx_resp->rate);
> > > > 
> > > > 0x0000000000016696 <iwl3945_rx_reply_tx+310>:	movb   $0x0,0x9(%rdi)        <---------- RIP
> > > > 0x000000000001669a <iwl3945_rx_reply_tx+314>:	movb   $0x0,0xc(%rdi)
> > > > 0x000000000001669e <iwl3945_rx_reply_tx+318>:	movb   $0x0,0xf(%rdi)
> > > > 0x00000000000166a2 <iwl3945_rx_reply_tx+322>:	movb   $0x0,0x12(%rdi)
> > > > 0x00000000000166a6 <iwl3945_rx_reply_tx+326>:	movb   $0x0,0x15(%rdi)
> > > 
> > > This equals to below code in ieee80211_tx_info_clear_status(). "info" is
> > > %rdi, which is 0x38. That matches NULL pointer dereference at 0x41 in
> > > your oops header.
> > > 
> > > 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
> > >                 info->status.rates[i].count = 0;
> > > 
> > > I guess there is a race for txq->q.read_ptr somewhere. Haven't checked
> > > though.
> > 
> > OK. 3945 updated write_ptr without regard to read_ptr on the Tx path.
> > This messes up our TFD on high load. The patch should fix your problem.
> > 
> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > index 994db4a..b31b34c 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > @@ -548,6 +548,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
> >  	txq = &priv->txq[txq_id];
> >  	q = &txq->q;
> >  
> > +	if ((iwl_queue_space(q) < q->high_mark))
> > +		goto drop;
> > +
> >  	spin_lock_irqsave(&priv->lock, flags);
> >  
> >  	idx = get_cmd_index(q, q->write_ptr, 0);
> >  
> >
Few days ago, I had an idea to reply here that I am sure that this
problem disappeared with this patch.


Today I got same kernel panic _with_ the patch applied....



<1>[ 3075.773505] BUG: unable to handle kernel NULL pointer dereference at 0000000000000041
<1>[ 3075.773540] IP: [<ffffffffa0c175f6>] iwl3945_rx_reply_tx+0xc6/0x450 [iwl3945]
<4>[ 3075.773564] PGD 0 
<1>[ 3075.773570] Thread overran stack, or stack corrupted
<0>[ 3075.773579] Oops: 0002 [#1] PREEMPT SMP 
<0>[ 3075.773591] last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
<4>[ 3075.773604] CPU 0 
<4>[ 3075.773611] Modules linked in: af_packet nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc snd_hda_codec_realtek uvcvideo videodev iwl3945 cpufreq_powersave usb_storage v4l1_compat snd_hda_intel iwlcore cpufreq_conservative joydev usb_libusual v4l2_compat_ioctl32 snd_hda_codec cpufreq_userspace mac80211 acpi_cpufreq uhci_hcd coretemp snd_hwdep cfg80211 psmouse tg3 ohci1394 video ehci_hcd snd_pcm sbp2 ac battery output usbcore libphy snd_page_alloc lirc_ene0100 ieee1394 nvidia(P) serio_raw evdev rfkill fuse lzo lzo_decompress lzo_compress
<6>[ 3075.773757] Pid: 0, comm: swapper Tainted: P           2.6.32-wl #225 Aspire 5720     
<6>[ 3075.773772] RIP: 0010:[<ffffffffa0c175f6>]  [<ffffffffa0c175f6>] iwl3945_rx_reply_tx+0xc6/0x450 [iwl3945]
<6>[ 3075.773795] RSP: 0018:ffff880002203d20  EFLAGS: 00010246
<6>[ 3075.773806] RAX: 000000000000004f RBX: ffff880065121600 RCX: 00000000000000b0
<6>[ 3075.773820] RDX: ffffffffa0c1f220 RSI: ffff88004f42e008 RDI: 0000000000000038
<6>[ 3075.773834] RBP: ffff880002203d90 R08: 0000000000000000 R09: 0000000000000100
<6>[ 3075.773847] R10: 0000000000000001 R11: 0000000000000046 R12: 00000000000000a0
<6>[ 3075.773861] R13: 0000000000000002 R14: 00000000000000b0 R15: 0000000000020201
<6>[ 3075.773875] FS:  0000000000000000(0000) GS:ffff880002200000(0000) knlGS:0000000000000000
<6>[ 3075.773891] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
<6>[ 3075.773903] CR2: 0000000000000041 CR3: 0000000001001000 CR4: 00000000000006f0
<6>[ 3075.773917] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<6>[ 3075.773930] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>[ 3075.773945] Process swapper (pid: 0, threadinfo ffffffff815b8000, task ffffffff815bcb60)
<0>[ 3075.773959] Stack:
<4>[ 3075.773964]  ffff880065122070 0000000000000046 ffff880002203d40 0000000000000046
<4>[ 3075.773981] <0> 0000000000000282 0000000000000282 0000000000000282 ffff880065122010
<4>[ 3075.774000] <0> ffff880002203d70 ffff880065121600 ffff880065122eb0 ffff88004f42e000
<0>[ 3075.774020] Call Trace:
<0>[ 3075.774026]  <IRQ> 
<4>[ 3075.774037]  [<ffffffffa0c0acf7>] iwl3945_irq_tasklet+0x657/0x1740 [iwl3945]
<4>[ 3075.774060]  [<ffffffffa09b883e>] ? iwl_isr_legacy+0x3e/0x600 [iwlcore]
<4>[ 3075.774077]  [<ffffffff81053f86>] tasklet_action+0x106/0x110
<4>[ 3075.774090]  [<ffffffff810556a4>] __do_softirq+0x114/0x2c0
<4>[ 3075.774103]  [<ffffffff8109eb68>] ? handle_edge_irq+0x78/0x160
<4>[ 3075.774117]  [<ffffffff8100d25c>] call_softirq+0x1c/0x30
<4>[ 3075.774128]  [<ffffffff8100f1fd>] do_softirq+0x7d/0xb0
<4>[ 3075.774140]  [<ffffffff81055155>] irq_exit+0x95/0xa0
<4>[ 3075.774152]  [<ffffffff814031fc>] do_IRQ+0x7c/0xf0
<4>[ 3075.774165]  [<ffffffff8100ca13>] ret_from_intr+0x0/0xf
<0>[ 3075.774175]  <EOI> 
<4>[ 3075.774183]  [<ffffffff8129996a>] ? acpi_idle_enter_bm+0x275/0x2aa
<4>[ 3075.774196]  [<ffffffff81299974>] ? acpi_idle_enter_bm+0x27f/0x2aa
<4>[ 3075.774209]  [<ffffffff8129996a>] ? acpi_idle_enter_bm+0x275/0x2aa
<4>[ 3075.774224]  [<ffffffff8132996f>] ? cpuidle_idle_call+0x9f/0x160
<4>[ 3075.774237]  [<ffffffff8100b1df>] ? cpu_idle+0xaf/0x110
<4>[ 3075.774250]  [<ffffffff813eca3a>] ? rest_init+0x7a/0x80
<4>[ 3075.774264]  [<ffffffff8162dd01>] ? start_kernel+0x3ac/0x3b8
<4>[ 3075.774277]  [<ffffffff8162d315>] ? x86_64_start_reservations+0x125/0x129
<4>[ 3075.774291]  [<ffffffff8162d3fd>] ? x86_64_start_kernel+0xe4/0xeb
<0>[ 3075.774302] Code: 00 41 39 ce 0f 8d e3 01 00 00 48 8b 47 40 48 63 d2 48 69 d2 98 00 00 00 4c 8b 04 02 48 c7 c2 20 f2 c1 a0 49 8d 78 38 49 8d 40 4f <c6> 47 09 00 c6 47 0c 00 c6 47 0f 00 c6 47 12 00 c6 47 15 00 49 
<1>[ 3075.774394] RIP  [<ffffffffa0c175f6>] iwl3945_rx_reply_tx+0xc6/0x450 [iwl3945]
<4>[ 3075.774412]  RSP <ffff880002203d20>
<0>[ 3075.774420] CR2: 0000000000000041
<4>[ 3075.774429] ---[ end trace 7ea524291c193896 ]---
<0>[ 3075.774439] Kernel panic - not syncing: Fatal exception in interrupt
<4>[ 3075.774451] Pid: 0, comm: swapper Tainted: P      D    2.6.32-wl #225
<4>[ 3075.774463] Call Trace:
<4>[ 3075.774469]  <IRQ>  [<ffffffff813fe515>] panic+0x82/0x13f
<4>[ 3075.774486]  [<ffffffff81010a52>] oops_end+0xe2/0xf0
<4>[ 3075.774497]  [<ffffffff81031382>] no_context+0xf2/0x260
<4>[ 3075.774509]  [<ffffffff81031615>] __bad_area_nosemaphore+0x125/0x1e0
<4>[ 3075.774523]  [<ffffffff810316e3>] bad_area_nosemaphore+0x13/0x20
<4>[ 3075.774536]  [<ffffffff81031aca>] do_page_fault+0x26a/0x320
<4>[ 3075.774549]  [<ffffffff81402dcf>] page_fault+0x1f/0x30
<4>[ 3075.774564]  [<ffffffffa0c175f6>] ? iwl3945_rx_reply_tx+0xc6/0x450 [iwl3945]
<4>[ 3075.774581]  [<ffffffffa0c0acf7>] iwl3945_irq_tasklet+0x657/0x1740 [iwl3945]
<4>[ 3075.774602]  [<ffffffffa09b883e>] ? iwl_isr_legacy+0x3e/0x600 [iwlcore]
<4>[ 3075.774616]  [<ffffffff81053f86>] tasklet_action+0x106/0x110
<4>[ 3075.774628]  [<ffffffff810556a4>] __do_softirq+0x114/0x2c0
<4>[ 3075.774640]  [<ffffffff8109eb68>] ? handle_edge_irq+0x78/0x160
<4>[ 3075.774653]  [<ffffffff8100d25c>] call_softirq+0x1c/0x30
<4>[ 3075.774665]  [<ffffffff8100f1fd>] do_softirq+0x7d/0xb0
<4>[ 3075.774676]  [<ffffffff81055155>] irq_exit+0x95/0xa0
<4>[ 3075.774687]  [<ffffffff814031fc>] do_IRQ+0x7c/0xf0
<4>[ 3075.774698]  [<ffffffff8100ca13>] ret_from_intr+0x0/0xf
<4>[ 3075.774708]  <EOI>  [<ffffffff8129996a>] ? acpi_idle_enter_bm+0x275/0x2aa
<4>[ 3075.774726]  [<ffffffff81299974>] ? acpi_idle_enter_bm+0x27f/0x2aa
<4>[ 3075.774739]  [<ffffffff8129996a>] ? acpi_idle_enter_bm+0x275/0x2aa
<4>[ 3075.774752]  [<ffffffff8132996f>] ? cpuidle_idle_call+0x9f/0x160
<4>[ 3075.774765]  [<ffffffff8100b1df>] ? cpu_idle+0xaf/0x110
<4>[ 3075.774777]  [<ffffffff813eca3a>] ? rest_init+0x7a/0x80
<4>[ 3075.774789]  [<ffffffff8162dd01>] ? start_kernel+0x3ac/0x3b8
<4>[ 3075.774802]  [<ffffffff8162d315>] ? x86_64_start_reservations+0x125/0x129
<4>[ 3075.774816]  [<ffffffff8162d3fd>] ? x86_64_start_kernel+0xe4/0xeb
<0>[ 3075.774845] Rebooting in 10 seconds..



(gdb) info line *iwl3945_rx_reply_tx+0xc6
Line 483 of "/home/maxim/software/kernel/linux-2.6/include/net/mac80211.h"
   starts at address 0x16626 <iwl3945_rx_reply_tx+198> and ends at 0x1663a <iwl3945_rx_reply_tx+218>.


(gdb) list * 0x16626
0x16626 is in iwl3945_rx_reply_tx (/home/maxim/software/kernel/linux-2.6/include/net/mac80211.h:483).
478		BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) !=
479			     offsetof(struct ieee80211_tx_info, driver_rates));
480		BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) != 8);
481		/* clear the rate counts */
482		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
483			info->status.rates[i].count = 0;
484	
485		BUILD_BUG_ON(
486		    offsetof(struct ieee80211_tx_info, status.ampdu_ack_len) != 23);
487		memset(&info->status.ampdu_ack_len, 0,



Kernel is the dbb6e436ef8e1713258bf1218d09e927d8de3590
(wireless: update old static regulatory domain rules)

Plus few patches that only one that touches wireless is:


diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2a28a1f..a36de73 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -548,6 +548,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
        txq = &priv->txq[txq_id];
        q = &txq->q;
 
+       if ((iwl_queue_space(q) < q->high_mark))
+               goto drop;
+
        spin_lock_irqsave(&priv->lock, flags);
 
        idx = get_cmd_index(q, q->write_ptr, 0);



Best regards,
	Maxim Levitsky


