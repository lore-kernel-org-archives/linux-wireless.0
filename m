Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56012 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbaHLSfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 14:35:05 -0400
Message-ID: <53EA5E53.9010704@candelatech.com> (sfid-20140812_203510_487469_9D0A4419)
Date: Tue, 12 Aug 2014 11:34:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
References: <5338F1B8.5040305@candelatech.com> <1875618.ePecsgGYZf@blech> <53E3BB1D.10807@candelatech.com> <1518134.xFh23iA8q1@blech>
In-Reply-To: <1518134.xFh23iA8q1@blech>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/10/2014 06:44 AM, Christian Lamparter wrote:
> On Thursday, August 07, 2014 10:45:01 AM Ben Greear wrote:
>> On 08/07/2014 07:05 AM, Christian Lamparter wrote:
>>> Or: for every 16 Bytes of payload there is one fpu context save and
>>> restore... ouch!
>>
>> Any idea if it would work to put the fpu_begin/end a bit higher
>> and do all those 16 byte chunks in a batch without messing with
>> the FPU for each chunk?
> 
> It sort of works - see sample feature patch for aesni-intel-glue 
> (taken from 3.16-wl). Older kernels (like 3.15, 3.14) need:
> "crypto: allow blkcipher walks over AEAD data" [0] (and maybe more).
> 
> The FPU save/restore overhead should be gone. Also, if the aesni
> instructions can't be used, the implementation will fall back
> to the original ccm(aes) code. Calculating the MAC is still much
> more expensive than the payload encryption or decryption. However,
> I can't see a way of making this more efficient without rewriting
> and combining the parts I took from crypto/ccm.c into an several, 
> dedicated assembler functions.

I tried this patch on my i7 machine, on the 3.16+ kernel.  Without your
patch, I see about 260Mbps download.  With it, performance improves
to around 350Mbps - 375Mbps.

Without encryption, I see download rate of around 400 - 420Mbps.

So, your patch looks like a good improvement to me, and I'll be
happy to test further patches if you happen to do those assembler
optimizations you talk about above.

Let me know if you would like more/different performance
stats.


Here is perf top of open authentication, download, UDP:

Samples: 64K of event 'cycles', Event count (approx.): 8792558478
 30.78%  btserver                [.] 0x0000000000100501
  2.73%  [kernel]                [k] copy_user_generic_string
  2.02%  [kernel]                [k] swiotlb_tbl_unmap_single
  1.43%  [kernel]                [k] ioread32
  1.40%  [ath10k_core]           [k] ath10k_htt_txrx_compl_task
  1.38%  [kernel]                [k] csum_partial
  1.22%  [kernel]                [k] _raw_spin_lock_irqsave
  0.97%  [cfg80211]              [k] ftrace_define_fields_rdev_return_int_survey_info
  0.97%  [kernel]                [k] pskb_expand_head
  0.95%  [kernel]                [k] do_raw_spin_lock
  0.82%  [kernel]                [k] __slab_free
  0.78%  [kernel]                [k] __sk_run_filter
  0.71%  [kernel]                [k] __rcu_read_unlock
  0.67%  [kernel]                [k] __netif_receive_skb_core
  0.65%  [kernel]                [k] __rcu_read_lock
  0.62%  [kernel]                [k] build_skb
  0.59%  [mac80211]              [k] ieee80211_rx_handlers
  0.55%  [kernel]                [k] nf_iterate
  0.52%  [kernel]                [k] arch_local_irq_restore


Using WPA2, sw-crypt, download, UDP:


Samples: 52K of event 'cycles', Event count (approx.): 13162827574
 24.78%  btserver              [.] 0x00000000000c598c
 10.97%  [kernel]              [k] _aesni_enc1
  2.75%  [kernel]              [k] _aesni_enc4
  2.26%  [kernel]              [k] crypto_xor
  1.69%  [kernel]              [k] aesni_enc
  1.29%  [kernel]              [k] swiotlb_tbl_unmap_single
  1.21%  [kernel]              [k] copy_user_generic_string
  1.17%  [kernel]              [k] ioread32
  1.13%  [kernel]              [k] get_data_to_compute
  0.99%  [kernel]              [k] _raw_spin_lock_irqsave
  0.91%  [ath10k_core]         [k] ath10k_htt_txrx_compl_task
  0.70%  [kernel]              [k] __schedule
  0.70%  [kernel]              [k] native_write_msr_safe
  0.69%  [kernel]              [k] csum_partial
  0.62%  [kernel]              [k] pskb_expand_head
  0.62%  [kernel]              [k] __switch_to
  0.58%  [kernel]              [k] do_raw_spin_lock
  0.53%  [kernel]              [k] menu_select
  0.51%  [kernel]              [k] __rcu_read_unlock
  0.47%  [cfg80211]            [k] ftrace_define_fields_rdev_return_int_survey_info
  0.47%  [kernel]              [k] _aesni_inc
  0.47%  [kernel]              [k] __rcu_read_lock
  0.47%  [kernel]              [k] __sk_run_filter
  0.44%  [kernel]              [k] aesni_ctr_enc
  0.43%  [kernel]              [k] arch_local_irq_restore
  0.43%  [kernel]              [k] do_sys_poll
  0.42%  [kernel]              [k] __netif_receive_skb_core
  0.41%  [mac80211]            [k] ieee80211_rx_handlers
  0.38%  [kernel]              [k] update_cfs_shares


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

