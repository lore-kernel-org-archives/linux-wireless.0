Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37390 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaHEXJp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 19:09:45 -0400
Message-ID: <53E16436.2020706@candelatech.com> (sfid-20140806_010948_702792_9C2DE64E)
Date: Tue, 05 Aug 2014 16:09:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
References: <5338F1B8.5040305@candelatech.com> <2968058.2zJHmYrLUV@debian64> <20140731200522.GA8868@w1.fi> <6460230.VGl66UFULp@debian64>
In-Reply-To: <6460230.VGl66UFULp@debian64>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2014 01:45 PM, Christian Lamparter wrote:
> On Thursday, July 31, 2014 11:05:22 PM Jouni Malinen wrote:
>> On Wed, Jul 30, 2014 at 08:59:33PM +0200, Christian Lamparter wrote:
>>> If you have disabled rx-decrypt logic of ath10k, then why isn't _aesni_dec1
>>> or aes_decrypt listed in the perf top result? I think they should be. Have you
>>> removed them from the "perf top results" or are they really absent 
>>> altogether? 
>>>
>>> Because, from this perf result, it looks like your CPU is not burden by the
>>> incoming RX at all?! Instead it is busy with the encryption of frames
>>> it will be transmitting (in case of tcp, this could be tcp acks).
>>
>> Keep in mind that this is CCMP, i.e., AES in CCM (Counter with CBC-MAC)
>> mode. The CCM mode uses only the block cipher encryption function, i.e.,
>> you won't be seeing aes_decrypt or _aesni_dec1 for this even on the RX
>> path (AES encryption operations are used to generate the key stream
>> blocks for CCM decryption).
> Yes, I remember this detail/the old days (before 3.12/3.13?). Back then
> ieee80211_aes_ccm_decrypt did exactly that. But these semantic pitfalls
> were taken care of by the following commit:
> 
> commit 7ec7c4a9a686c608315739ab6a2b0527a240883c (from wireless-testing.git)
> Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Date:   Thu Oct 10 09:55:20 2013 +0200

This patch is in my tree (I'm using 3.14.14 kernel currently).

Here is a perf top from a different machine, with single wlan interface
running UDP download (btserver is user-space app that is generating/receiving
the traffic).  I can do about 200Mbps download with WPA2 encryption enabled
on this machine, and ksoftirqd is using about 76% of a core according to top.

Samples: 154K of event 'cycles', Event count (approx.): 45228404083
  9.92%  [kernel]                 [k] __lock_acquire
  7.79%  btserver                 [.] 0x0000000000349d73
  6.44%  [kernel]                 [k] math_state_restore
  5.47%  [kernel]                 [k] _aesni_enc1
  4.36%  [kernel]                 [k] fpu_save_init
  2.88%  [kernel]                 [k] arch_local_save_flags
  2.68%  [kernel]                 [k] arch_local_irq_restore
  2.29%  [kernel]                 [k] lock_release
  1.80%  [kernel]                 [k] mark_lock
  1.58%  [kernel]                 [k] lock_acquire
  1.50%  [kernel]                 [k] irq_fpu_usable
  1.43%  [kernel]                 [k] crypto_xor
  1.35%  [kernel]                 [k] mark_held_locks
  1.30%  [kernel]                 [k] fib_rules_lookup
  1.25%  [kernel]                 [k] hlock_class
  1.20%  [kernel]                 [k] trace_hardirqs_on_caller
  0.99%  [kernel]                 [k] copy_user_generic_string
  0.92%  [kernel]                 [k] __netif_receive_skb_core
  0.88%  [kernel]                 [k] trace_hardirqs_off_caller
  0.87%  [kernel]                 [k] arch_local_irq_save
  0.85%  [kernel]                 [k] dev_queue_xmit_nit
  0.84%  [kernel]                 [k] aes_encrypt
  0.59%  [kernel]                 [k] do_raw_spin_lock
  0.55%  [kernel]                 [k] get_data_to_compute
  0.53%  [kernel]                 [k] __rcu_read_unlock
  0.52%  [kernel]                 [k] crypto_ctr_crypt

A second test where the station machine was not generating to itself
(ie, tx on Ethernet, to AP, receive back on wlan), but only
receiving traffic from the AP, shows this perf top:

Samples: 126K of event 'cycles', Event count (approx.): 29019221373
 10.74%  [kernel]                 [k] math_state_restore
 10.50%  btserver                 [.] 0x000000000033260d
  9.00%  [kernel]                 [k] _aesni_enc1
  7.33%  [kernel]                 [k] fpu_save_init
  6.70%  [kernel]                 [k] __lock_acquire
  2.46%  [kernel]                 [k] irq_fpu_usable
  2.34%  [kernel]                 [k] crypto_xor
  1.88%  [kernel]                 [k] arch_local_save_flags
  1.83%  [kernel]                 [k] arch_local_irq_restore
  1.58%  [kernel]                 [k] lock_release
  1.48%  [kernel]                 [k] aes_encrypt
  1.27%  [kernel]                 [k] mark_lock
  1.12%  [kernel]                 [k] lock_acquire
  1.02%  [kernel]                 [k] mark_held_locks
  0.96%  [kernel]                 [k] trace_hardirqs_on_caller
  0.93%  [kernel]                 [k] get_data_to_compute
  0.83%  [kernel]                 [k] hlock_class
  0.81%  [kernel]                 [k] __kernel_fpu_begin
  0.81%  [kernel]                 [k] crypto_ctr_crypt
  0.80%  [kernel]                 [k] crypto_inc


[greearb@ben-dt2 linux-3.14.x64]$ grep CCM .config
CONFIG_LIB80211_CRYPT_CCMP=m
# CONFIG_RTLLIB_CRYPTO_CCMP is not set
CONFIG_CRYPTO_CCM=y
[greearb@ben-dt2 linux-3.14.x64]$

[root@ct523-9292 lanforge]# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i7-2655LE CPU @ 2.20GHz
stepping	: 7
microcode	: 0x28
cpu MHz		: 2200.000
cache size	: 4096 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm
constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr
pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4390.31
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


Out of curiosity, might it help to prefetch the entire skb when
getting it from the NIC, since we are about to have to read it all
to do the decrypt?

Any idea how to prefetch the skb?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

