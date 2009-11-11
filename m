Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758817AbZKKUoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 15:44:17 -0500
Date: Wed, 11 Nov 2009 15:44:20 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Aeolus Yang <Aeolus.Yang@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Oops on ath_txq_schedule() hit a BUG_ON()
Message-ID: <20091111204420.GA18071@bombadil.infradead.org>
References: <43e72e890911101606j46e1edfn64e331f3463d4da5@mail.gmail.com> <19194.14583.795686.199320@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19194.14583.795686.199320@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 11, 2009 at 09:39:27AM +0530, Sujith wrote:
> Luis R. Rodriguez wrote:
> > I managed to get an oops the 2.6.32-rc wireless bits on ath9k by using
> > linux-backports-modules package on Ubuntu 9.10 which is on 2.6.31. I'm
> > pretty sure this is a real oops which can be reproduced on 2.6.32-rc6
> > but I was unable to boot the same laptop on 2.6.32-rc6 [1] due to an
> > early oops on what seems to be i915.
> > 
> > The EIP is at ath_txq_schedule() but the oops happens due to a
> > BUG_ON() (used to be ASSERT()) on this piece of code:
> 
> I have seen this once, and I have a backtrace.

I got a full trace now, on Linus' tip.

Please excuse the double prints, I haven't figured out how to
cure that with netconsole yet [1]

[1] http://www.spinics.net/lists/netdev/msg111823.html

[ 1871.462097] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
[ 1871.462097] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
[ 1871.954504] wlan0: deauthenticating from 00:22:6b:56:fd:e8 by local choice (reason=3)
[ 1871.954504] wlan0: deauthenticating from 00:22:6b:56:fd:e8 by local choice (reason=3)
[ 1872.147005] wlan0: direct probe to AP 00:22:6b:56:fd:e8 (try 1)
[ 1872.147005] wlan0: direct probe to AP 00:22:6b:56:fd:e8 (try 1)
[ 1872.180982] wlan0: direct probe responded
[ 1872.181007] wlan0: authenticate with AP 00:22:6b:56:fd:e8 (try 1)
[ 1872.180982] wlan0: direct probe responded
[ 1872.181007] wlan0: authenticate with AP 00:22:6b:56:fd:e8 (try 1)
[ 1872.184759] wlan0: authenticated
[ 1872.184838] wlan0: associate with AP 00:22:6b:56:fd:e8 (try 1)
[ 1872.184759] wlan0: authenticated
[ 1872.184838] wlan0: associate with AP 00:22:6b:56:fd:e8 (try 1)
[ 1872.233087] wlan0: RX AssocResp from 00:22:6b:56:fd:e8 (capab=0x401 status=0 aid=1)
[ 1872.233112] wlan0: associated
[ 1872.233087] wlan0: RX AssocResp from 00:22:6b:56:fd:e8 (capab=0x401 status=0 aid=1)
[ 1872.233112] wlan0: associated
[ 1946.788260] ------------[ cut here ]------------
[ 1946.788284] kernel BUG at drivers/net/wireless/ath/ath9k/xmit.c:181!
[ 1946.788302] invalid opcode: 0000 [#1] SMP 
[ 1946.788331] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0c/PNP0C0A:00/power_supply/BAT1/energy_full
[ 1946.788349] Modules linked in: netconsole configfs binfmt_misc ppdev snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi arc4 snd_seq_midi_event ath9k snd_seq mac80211 bridge[ 1946.788260] ------------[ cut here ]------------
 snd_timer stp snd_seq_device ath iptable_filter joydev bnep snd cfg80211[ 1946.788284] kernel BUG at drivers/net/wireless/ath/ath9k/xmit.c:181!
 dell_laptop ip_tables psmouse soundcore btusb x_tables lp[ 1946.788302] invalid opcode: 0000 [#1]  dcdbas led_class snd_page_alloc serio_raw parport usbhid fbcon tileblitSMP  font bitblit softcursor i915 drm_kms_helper usb_storage drm r8169
 intel_agp mii agpgart i2c_algo_bit video output
[ 1946.788747] 
[ 1946.788761] Pid: 0, comm: swapper Not tainted (2.6.32-rc6 #3) Inspiron 1012
[ 1946.788775] EIP: 0060:[<f8e30872>] EFLAGS: 00010282 CPU: 1
[ 1946.788810] EIP is at ath_txq_schedule+0x5f2/0x600 [ath9k]
[ 1946.788823] EAX: 00000007 EBX: f6611ef0 ECX: 0000007d EDX: 00000081
[ 1946.788331] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0c/PNP0C0A:00/power_supply/BAT1/energy_full
[ 1946.788835] ESI: f5e1822c EDI: 00000000 EBP: f707ddd8 ESP: f707dd40
[ 1946.788848]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1946.788862] Process swapper (pid: 0, ti=f707c000 task=f705e580 task.ti=f707c000)
[ 1946.788349] Modules linked in:[ 1946.788872] Stack:
[ 1946.788880]  08000001 00000000 f707ddc4 f642ac28 f5e1a5bc netconsole f5e1a5b4 00000000 f5e1a5ac
[ 1946.789019] <0> f642ac00 0007001a configfs 00000000 f642ac00 00000000 00001a70 f5e18234 f5e18404
[ 1946.789066] <0> f642ac10 binfmt_misc 018bf000 00000000 f6611ef0 00000010 00001a70 f6611ef0 0000f000
 ppdev[ 1946.789118] Call Trace:
[ 1946.789157]  [<f8e30b77>] ? ath_tx_tasklet+0x2f7/0x3c0 [ath9k]
[ 1946.789192]  [<f8e2b99f>] ? ath9k_tasklet+0xcf/0x120 [ath9k]
[ 1946.789214]  [<c014ae72>] ? tasklet_action+0xa2/0xb0
[ 1946.789231]  [<c014c3b0>] ? __do_softirq+0x90/0x1a0
[ 1946.789249]  [<c0120786>] ? ack_apic_level+0x66/0x170
 snd_hda_codec_realtek[ 1946.789266]  [<c016e5d8>] ? tick_do_update_jiffies64+0x118/0x160
[ 1946.789283]  [<c014c4fd>] ? do_softirq+0x3d/0x40
[ 1946.789298]  [<c014c63d>] ? irq_exit+0x5d/0x70
[ 1946.789314]  [<c0104b40>] ? do_IRQ+0x50/0xc0
 snd_hda_intel[ 1946.789331]  [<c01656c4>] ? sched_clock_local+0xa4/0x180
[ 1946.789347]  [<c0103830>] ? common_interrupt+0x30/0x40
[ 1946.789364]  [<c016007b>] ? remove_wait_queue+0x1b/0x50
 snd_hda_codec[ 1946.789383]  [<c037547b>] ? acpi_idle_enter_bm+0x255/0x286
[ 1946.789400]  [<c047553e>] ? cpuidle_idle_call+0x6e/0xf0
[ 1946.789415]  [<c0101efc>] ? cpu_idle+0x8c/0xd0
[ 1946.789432]  [<c05619d7>] ? start_secondary+0x19e/0x1a4
 snd_pcm_oss snd_mixer_oss[ 1946.789443] Code: 08 8b 53 2c 89 4b  snd_seq_dummy2c 8b 9d 74 ff ff ff 89 50  snd_seq_oss0c 89 58 08 89 0a e9 f1  snd_seq_midifc ff ff 8d b4 26 00 00  arc400 00 bf 01 00 00 00 e9 26  ath9kfc ff ff <0f> 0b eb fe 8d  snd_seq76 00 8d bc 27 00 00 00 00  mac8021155 89 e5 57 56 53 83 
 bridge[ 1946.789907] EIP: [<f8e30872>] ath_txq_schedule+0x5f2/0x600 [ath9k] SS:ESP 0068:f707dd40
[ 1946.789962] ---[ end trace 95205084f510df62 ]---
[ 1946.789974] Kernel panic - not syncing: Fatal exception in interrupt
[ 1946.789989] Pid: 0, comm: swapper Tainted: G      D    2.6.32-rc6 #3
[ 1946.789999] Call Trace:
 stp[ 1946.790015]  [<c05644af>] ? printk+0x18/0x21
[ 1946.790030]  [<c05643ec>] panic+0x43/0xee
[ 1946.790133]  [<c0567c45>] oops_end+0xc5/0xd0
[ 1946.790151]  [<c01064bf>] die+0x4f/0x70
[ 1946.790166]  [<c0567386>] do_trap+0x96/0xc0
[ 1946.790181]  [<c01045e0>] ? do_invalid_op+0x0/0xa0
 snd_seq_device[ 1946.790196]  [<c0104666>] do_invalid_op+0x86/0xa0
[ 1946.790230]  [<f8e30872>] ? ath_txq_schedule+0x5f2/0x600 [ath9k]
[ 1946.790250]  [<c0492638>] ? __kfree_skb+0x38/0x90
[ 1946.790265]  [<c0492638>] ? __kfree_skb+0x38/0x90
 ath[ 1946.790280]  [<c04926ac>] ? consume_skb+0x1c/0x40
[ 1946.790313]  [<f8c8c84f>] ? ieee80211_tx_status+0x41f/0x450 [mac80211]
 joydev[ 1946.790331]  [<c04926ac>] ? consume_skb+0x1c/0x40
[ 1946.790350]  [<c0126d18>] ? default_spin_lock_flags+0x8/0x10
[ 1946.790367]  [<c0566d7a>] ? _spin_lock_irqsave+0x2a/0x40
[ 1946.790383]  [<c0567103>] error_code+0x73/0x80
 bnep[ 1946.790415]  [<f8e30872>] ? ath_txq_schedule+0x5f2/0x600 [ath9k]
[ 1946.790449]  [<f8e30b77>] ath_tx_tasklet+0x2f7/0x3c0 [ath9k]
 snd[ 1946.790483]  [<f8e2b99f>] ath9k_tasklet+0xcf/0x120 [ath9k]
[ 1946.790500]  [<c014ae72>] tasklet_action+0xa2/0xb0
[ 1946.790516]  [<c014c3b0>] __do_softirq+0x90/0x1a0
 dell_laptop[ 1946.790531]  [<c0120786>] ? ack_apic_level+0x66/0x170
[ 1946.790547]  [<c016e5d8>] ? tick_do_update_jiffies64+0x118/0x160
[ 1946.790563]  [<c014c4fd>] do_softirq+0x3d/0x40
[ 1946.790578]  [<c014c63d>] irq_exit+0x5d/0x70
[ 1946.790592]  [<c0104b40>] do_IRQ+0x50/0xc0
 ip_tables[ 1946.790608]  [<c01656c4>] ? sched_clock_local+0xa4/0x180
[ 1946.790623]  [<c0103830>] common_interrupt+0x30/0x40
[ 1946.790640]  [<c016007b>] ? remove_wait_queue+0x1b/0x50
[ 1946.790656]  [<c037547b>] ? acpi_idle_enter_bm+0x255/0x286
 psmouse[ 1946.790672]  [<c047553e>] cpuidle_idle_call+0x6e/0xf0
[ 1946.790687]  [<c0101efc>] cpu_idle+0x8c/0xd0
[ 1946.790702]  [<c05619d7>] start_secondary+0x19e/0x1a4
 btusb[ 1946.790734] [drm:drm_fb_helper_panic] *ERROR* panic occurred, switching back to text console
[ 1946.790767] [drm] Big FIFO is enabled
 x_tables lp led_class snd_page_alloc parport usbhid fbcon font bitblit softcursor drm_kms_helper usb_storage r8169 intel_agp mii agpgart video output
[ 1946.788761] Pid: 0, comm: swapper Not tainted (2.6.32-rc6 #3) Inspiron 1012
[ 1946.788775] EIP: 0060:[<f8e30872>] EFLAGS: 00010282 CPU: 1
[ 1946.788810] EIP is at ath_txq_schedule+0x5f2/0x600 [ath9k]
[ 1946.788823] EAX: 00000007 EBX: f6611ef0 ECX: 0000007d EDX: 00000081
[ 1946.788835] ESI: f5e1822c EDI: 00000000 EBP: f707ddd8 ESP: f707dd40
[ 1946.788848]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1946.788862] Process swapper (pid: 0, ti=f707c000 task=f705e580 task.ti=f707c000)
[ 1946.788872] Stack:
[ 1946.788880]  08000001 f707ddc4 f5e1a5bc f5e1a5b4 00000000 f5e1a5ac
[ 1946.789019] <0> f642ac00 0007001a 00000000 f642ac00 00000000 f5e18234 f5e18404
 f642ac10 018bf000 f6611ef0 00000010 00001a70 0000f000
[ 1946.789214]  [<c014ae72>] ? tasklet_action+0xa2/0xb0
[ 1946.789231]  [<c014c3b0>] ? __do_softirq+0x90/0x1a0
[ 1946.789249]  [<c0120786>] ? ack_apic_level+0x66/0x170
[ 1946.789266]  [<c016e5d8>] ? tick_do_update_jiffies64+0x118/0x160
[ 1946.789283]  [<c014c4fd>] ? do_softirq+0x3d/0x40
[ 1946.789298]  [<c014c63d>] ? irq_exit+0x5d/0x70
[ 1946.789314]  [<c0104b40>] ? do_IRQ+0x50/0xc0
[ 1946.789331]  [<c01656c4>] ? sched_clock_local+0xa4/0x180
[ 1946.789347]  [<c0103830>] ? common_interrupt+0x30/0x40
[ 1946.789364]  [<c016007b>] ? remove_wait_queue+0x1b/0x50
[ 1946.789383]  [<c037547b>] ? acpi_idle_enter_bm+0x255/0x286
[ 1946.789400]  [<c047553e>] ? cpuidle_idle_call+0x6e/0xf0
[ 1946.789415]  [<c0101efc>] ? cpu_idle+0x8c/0xd0
[ 1946.789432]  [<c05619d7>] ? start_secondary+0x19e/0x1a4
[ 1946.789443] Code: 08 8b 53 2c 89 4b 2c 8b 9d 74 ff ff 89 50 0c 58 08 89 e9 f1 fc ff 8d 26 00 00 00 bf 00 00 00 26 fc ff ff 0b eb fe 76 00 8d 27 00 00 00 55 89 57 56 83 
[ 1946.789974] Kernel panic - not syncing: Fatal exception in interrupt
[ 1946.789989] Pid: 0, comm: swapper Tainted: G      D    2.6.32-rc6 #3
[ 1946.789999] Call Trace:
[ 1946.790015]  [<c05644af>] ? printk+0x18/0x21
[ 1946.790030]  [<c05643ec>] panic+0x43/0xee
[ 1946.790133]  [<c0567c45>] oops_end+0xc5/0xd0
[ 1946.790151]  [<c01064bf>] die+0x4f/0x70
[ 1946.790166]  [<c0567386>] do_trap+0x96/0xc0
[ 1946.790181]  [<c01045e0>] ? do_invalid_op+0x0/0xa0
[ 1946.790196]  [<c0104666>] do_invalid_op+0x86/0xa0
[ 1946.790230]  [<f8e30872>] ? ath_txq_schedule+0x5f2/0x600 [ath9k]
[ 1946.790250]  [<c0492638>] ? __kfree_skb+0x38/0x90
[ 1946.790265]  [<c0492638>] ? __kfree_skb+0x38/0x90
[ 1946.790280]  [<c04926ac>] ? consume_skb+0x1c/0x40
[ 1946.790313]  [<f8c8c84f>] ? ieee80211_tx_status+0x41f/0x450 [mac80211]
[ 1946.790331]  [<c04926ac>] ? consume_skb+0x1c/0x40
[ 1946.790350]  [<c0126d18>] ? default_spin_lock_flags+0x8/0x10
[ 1946.790367]  [<c0566d7a>] ? _spin_lock_irqsave+0x2a/0x40
[ 1946.790383]  [<c0567103>] error_code+0x73/0x80
[ 1946.790415]  [<f8e30872>] ? ath_txq_schedule+0x5f2/0x600 [ath9k]
[ 1946.790449]  [<f8e30b77>] ath_tx_tasklet+0x2f7/0x3c0 [ath9k]
[ 1946.790483]  [<f8e2b99f>] ath9k_tasklet+0xcf/0x120 [ath9k]
[ 1946.790500]  [<c014ae72>] tasklet_action+0xa2/0xb0
[ 1946.790516]  [<c014c3b0>] __do_softirq+0x90/0x1a0
[ 1946.790531]  [<c0120786>] ? ack_apic_level+0x66/0x170
[ 1946.790547]  [<c016e5d8>] ? tick_do_update_jiffies64+0x118/0x160
[ 1946.790563]  [<c014c4fd>] do_softirq+0x3d/0x40
[ 1946.790578]  [<c014c63d>] irq_exit+0x5d/0x70
[ 1946.790592]  [<c0104b40>] do_IRQ+0x50/0xc0
[ 1946.790608]  [<c01656c4>] ? sched_clock_local+0xa4/0x180
[ 1946.790623]  [<c0103830>] common_interrupt+0x30/0x40
[ 1946.790640]  [<c016007b>] ? remove_wait_queue+0x1b/0x50
[ 1946.790656]  [<c037547b>] ? acpi_idle_enter_bm+0x255/0x286
[ 1946.790672]  [<c047553e>] cpuidle_idle_call+0x6e/0xf0
[ 1946.790687]  [<c0101efc>] cpu_idle+0x8c/0xd0
[ 1946.790702]  [<c05619d7>] start_secondary+0x19e/0x1a4
[ 1946.790734] [drm:drm_fb_helper_panic] *ERROR* panic occurred, switching back to text console
[ 1946.790767] [drm] Big FIFO is enabled
