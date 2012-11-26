Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44465 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2KZRqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 12:46:21 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id qAQHkJQ2023196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 09:46:20 -0800
Message-ID: <50B3AAEB.3070709@candelatech.com> (sfid-20121126_184631_765629_DC554BCF)
Date: Mon, 26 Nov 2012 09:46:19 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Kernel splat from 3.5.7+ (tainted)
References: <50B3A275.3010302@candelatech.com>
In-Reply-To: <50B3A275.3010302@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2012 09:10 AM, Ben Greear wrote:
> This looks like some sort of locking bug...the warning comes from the code
> in softirq.c (below). For what it's worth, the tainting module was not in active use.
>
> I should be able to get source code printout for the various addresses
> if there is anything of particular interest.

Here's some decoding below...it seems that the mac80211 code free's an SKB
with dev_kfree_skb(skb); while holding a spin_lock_irqsave(), and then
eventually we get the splat warning.

I'm not really sure what the problem is, however.

> static inline void _local_bh_enable_ip(unsigned long ip)
> {
>      WARN_ON_ONCE(in_irq() || irqs_disabled());
> #ifdef CONFIG_TRACE_IRQFLAGS
>      local_irq_disable();
> #endif
>
>
> Nov 21 19:33:17 localhost kernel: WARNING: at /home/greearb/git/linux-3.5.dev.y/kernel/softirq.c:159 _local_bh_enable_ip+0x41/0x9f()
> Nov 21 19:33:17 localhost kernel: Hardware name: To be filled by O.E.M.
> Nov 21 19:33:17 localhost kernel: Modules linked in: bnep bluetooth fuse 8021q garp stp llc macvlan wanlink(PO) pktgen lockd sunrpc gpio_ich ppdev coretemp
> hwmon kvm snd_hda_codec_realtek microcode serio_raw snd_hda_intel pcspkr snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm i2c_i801 lpc_ich mfd_core ath9k
> ath9k_common ath9k_hw ath mac80211 cfg80211 e1000e snd_page_alloc snd_timer snd soundcore parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper
> drm i2c_core [last unloaded: nf_nat]
> Nov 21 19:33:17 localhost kernel: Pid: 5905, comm: kworker/u:0 Tainted: P           O 3.5.7+ #27
> Nov 21 19:33:17 localhost kernel: Call Trace:
> Nov 21 19:33:17 localhost kernel: <IRQ>  [<ffffffff8105c5cc>] warn_slowpath_common+0x80/0x98
> Nov 21 19:33:17 localhost kernel: [<ffffffff8105c5f9>] warn_slowpath_null+0x15/0x17
> Nov 21 19:33:17 localhost kernel: [<ffffffff81062dfa>] _local_bh_enable_ip+0x41/0x9f

(gdb) l *( _local_bh_enable_ip+0x41)
0xffffffff81062dfa is in _local_bh_enable_ip (/home/greearb/git/linux-3.5.dev.y/kernel/softirq.c:159).
154	
155	EXPORT_SYMBOL(_local_bh_enable);
156	
157	static inline void _local_bh_enable_ip(unsigned long ip)
158	{
159		WARN_ON_ONCE(in_irq() || irqs_disabled());
160	#ifdef CONFIG_TRACE_IRQFLAGS
161		local_irq_disable();
162	#endif
163		/*
(gdb)


> Nov 21 19:33:17 localhost kernel: [<ffffffff81062e61>] local_bh_enable_ip+0x9/0xb

(gdb) l *(local_bh_enable_ip+0x9)
0xffffffff81062e61 is in local_bh_enable_ip (/home/greearb/git/linux-3.5.dev.y/kernel/softirq.c:193).
188	EXPORT_SYMBOL(local_bh_enable);
189	
190	void local_bh_enable_ip(unsigned long ip)
191	{
192		_local_bh_enable_ip(ip);
193	}
194	EXPORT_SYMBOL(local_bh_enable_ip);
195	
196	/*
197	 * We restart softirq processing MAX_SOFTIRQ_RESTART times,


> Nov 21 19:33:17 localhost kernel: [<ffffffff814e31a6>] _raw_spin_unlock_bh+0x1c/0x1e

(gdb) l *(_raw_spin_unlock_bh+0x1c)
0xffffffff814e31a6 is in _raw_spin_unlock_bh (/home/greearb/git/linux-3.5.dev.y/kernel/spinlock.c:194).
189	
190	#ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
191	void __lockfunc _raw_spin_unlock_bh(raw_spinlock_t *lock)
192	{
193		__raw_spin_unlock_bh(lock);
194	}
195	EXPORT_SYMBOL(_raw_spin_unlock_bh);
196	#endif
197	
198	#ifndef CONFIG_INLINE_READ_TRYLOCK
(gdb)


> Nov 21 19:33:17 localhost kernel: [<ffffffff8144fee4>] destroy_conntrack+0xbd/0xfc

0xffffffff8144fee4 is in destroy_conntrack (/home/greearb/git/linux-3.5.dev.y/net/netfilter/nf_conntrack_core.c:227).
222		}
223	
224		NF_CT_STAT_INC(net, delete);
225		spin_unlock_bh(&nf_conntrack_lock);
226	
227		if (ct->master)
228			nf_ct_put(ct->master);
229	
230		pr_debug("destroy_conntrack: returning ct=%p to slab\n", ct);
231		nf_conntrack_free(ct);


> Nov 21 19:33:17 localhost kernel: [<ffffffff8144da47>] nf_conntrack_destroy+0x27/0x2e

0xffffffff8144da47 is in nf_conntrack_destroy (/home/greearb/git/linux-3.5.dev.y/include/linux/rcupdate.h:754).
749	{
750		rcu_lockdep_assert(!rcu_is_cpu_idle(),
751				   "rcu_read_unlock() used illegally while idle");
752		rcu_lock_release(&rcu_lock_map);
753		__release(RCU);
754		__rcu_read_unlock();
755	}
756	
757	/**
758	 * rcu_read_lock_bh() - mark the beginning of an RCU-bh critical section
(gdb)


> Nov 21 19:33:17 localhost kernel: [<ffffffff81422934>] skb_release_head_state+0x9a/0xdc

0xffffffff81422934 is in skb_release_head_state (/home/greearb/git/linux-3.5.dev.y/net/core/skbuff.c:497).
492		}
493	#if IS_ENABLED(CONFIG_NF_CONNTRACK)
494		nf_conntrack_put(skb->nfct);
495	#endif
496	#ifdef NET_SKBUFF_NF_DEFRAG_NEEDED
497		nf_conntrack_put_reasm(skb->nfct_reasm);
498	#endif
499	#ifdef CONFIG_BRIDGE_NETFILTER
500		nf_bridge_put(skb->nf_bridge);
501	#endif
(gdb)

> Nov 21 19:33:17 localhost kernel: [<ffffffff81422b77>] __kfree_skb+0x11/0x7d

0xffffffff81422b77 is in __kfree_skb (/home/greearb/git/linux-3.5.dev.y/net/core/skbuff.c:515).
510	
511	/* Free everything but the sk_buff shell. */
512	static void skb_release_all(struct sk_buff *skb)
513	{
514		skb_release_head_state(skb);
515		skb_release_data(skb);
516	}
517	
518	/**
519	 *	__kfree_skb - private function

> Nov 21 19:33:17 localhost kernel: [<ffffffff81422c2c>] consume_skb+0x28/0x2a

0xffffffff81422c2c is in consume_skb (/home/greearb/git/linux-3.5.dev.y/net/core/skbuff.c:572).
567			smp_rmb();
568		else if (likely(!atomic_dec_and_test(&skb->users)))
569			return;
570		trace_consume_skb(skb);
571		__kfree_skb(skb);
572	}
573	EXPORT_SYMBOL(consume_skb);
574	
575	/**
576	 * 	skb_recycle - clean up an skb for reuse
(gdb)

> Nov 21 19:33:17 localhost kernel: [<ffffffffa01fa2f9>] __ieee80211_tx+0x1f9/0x31a [mac80211]

The line above is called with spin-lock held:


	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
...

0x182f9 is in __ieee80211_tx (/home/greearb/git/linux-3.5.dev.y/net/mac80211/tx.c:1256).
1251					skb_queue_splice_init(skbs, &local->pending[q]);
1252				} else {
1253					u32 len = skb_queue_len(&local->pending[q]);
1254					if (len >= max_pending_qsize) {
1255						__skb_unlink(skb, skbs);
1256						dev_kfree_skb(skb);
1257						/* TODO:  Add counter for this */
1258					} else {
1259						skb_queue_splice_tail_init(skbs,
1260									   &local->pending[q]);
(gdb)


> Nov 21 19:33:17 localhost kernel: [<ffffffff810247b2>] ? smp_apic_timer_interrupt+0x85/0x93
> Nov 21 19:33:17 localhost kernel: [<ffffffffa01fa4e0>] ieee80211_tx+0xc6/0xed [mac80211]
> Nov 21 19:33:17 localhost kernel: [<ffffffff81422c00>] ? kfree_skb_partial+0x1d/0x21
> Nov 21 19:33:17 localhost kernel: [<ffffffff81422d6b>] ? pskb_expand_head+0x13d/0x1eb
> Nov 21 19:33:17 localhost kernel: [<ffffffffa01fa95c>] ieee80211_xmit+0xbe/0xcc [mac80211]
> Nov 21 19:33:17 localhost kernel: [<ffffffffa01fb4ab>] ieee80211_subif_start_xmit+0xae2/0xb00 [mac80211]
> Nov 21 19:33:17 localhost kernel: [<ffffffff81084f17>] ? load_balance+0xc3/0x5ea
> Nov 21 19:33:17 localhost kernel: [<ffffffff8142c92e>] dev_hard_start_xmit+0x3e2/0x4d6
> Nov 21 19:33:17 localhost kernel: [<ffffffff814435ef>] sch_direct_xmit+0x6d/0x14d
> Nov 21 19:33:17 localhost kernel: [<ffffffff814437de>] __qdisc_run+0x10f/0x12b
> Nov 21 19:33:17 localhost kernel: [<ffffffff8142940b>] net_tx_action+0xe9/0x11e
> Nov 21 19:33:17 localhost kernel: [<ffffffff81062f55>] __do_softirq+0x86/0x12f
> Nov 21 19:33:17 localhost kernel: [<ffffffff814e955c>] call_softirq+0x1c/0x30
> Nov 21 19:33:17 localhost kernel: <EOI>  [<ffffffff8100bbd9>] do_softirq+0x41/0x7e
> Nov 21 19:33:17 localhost kernel: [<ffffffff81062e33>] _local_bh_enable_ip+0x7a/0x9f
> Nov 21 19:33:17 localhost kernel: [<ffffffff81062e70>] local_bh_enable+0xd/0xf
> Nov 21 19:33:17 localhost kernel: [<ffffffffa01fa9c7>] ieee80211_tx_skb_tid+0x5d/0x5f [mac80211]
> Nov 21 19:33:17 localhost kernel: [<ffffffffa0200a26>] ieee80211_send_nullfunc+0x5f/0x64 [mac80211]
> Nov 21 19:33:17 localhost kernel: [<ffffffffa01e8cba>] ieee80211_offchannel_return+0x9c/0x1d8 [mac80211]
> Nov 21 19:33:17 localhost kernel: [<ffffffffa01e84d5>] ? ieee80211_request_scan+0x4f/0x4f [mac80211]
> Nov 21 19:33:17 localhost kernel: [<ffffffffa01e794f>] __ieee80211_scan_completed+0x13e/0x179 [mac80211]
> Nov 21 19:33:17 localhost kernel: [<ffffffffa01e84d5>] ? ieee80211_request_scan+0x4f/0x4f [mac80211]
> Nov 21 19:33:17 localhost kernel: [<ffffffffa01e88ed>] ieee80211_scan_work+0x418/0x42f [mac80211]
> Nov 21 19:33:17 localhost kernel: [<ffffffff814e2495>] ? __schedule+0x51f/0x561
> Nov 21 19:33:17 localhost kernel: [<ffffffffa01e84d5>] ? ieee80211_request_scan+0x4f/0x4f [mac80211]
> Nov 21 19:33:17 localhost kernel: [<ffffffff8106fcc7>] process_one_work+0x1a6/0x278
> Nov 21 19:33:17 localhost kernel: [<ffffffff81071cd3>] worker_thread+0x136/0x255
> Nov 21 19:33:17 localhost kernel: [<ffffffff81071b9d>] ? manage_workers+0x191/0x191
> Nov 21 19:33:17 localhost kernel: [<ffffffff810755d7>] kthread+0x84/0x8c
> Nov 21 19:33:17 localhost kernel: [<ffffffff814e9464>] kernel_thread_helper+0x4/0x10
> Nov 21 19:33:17 localhost kernel: [<ffffffff81075553>] ? __init_kthread_worker+0x37/0x37
> Nov 21 19:33:17 localhost kernel: [<ffffffff814e9460>] ? gs_change+0x13/0x13
> Nov 21 19:33:17 localhost kernel: ---[ end trace f0563900e2e456dc ]---
> Nov 21 19:33:17 localhost kernel: IPv6: ADDRCONF(NETDEV_CHANGE): sta197: link becomes ready


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

