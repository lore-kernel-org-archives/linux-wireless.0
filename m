Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:15502 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbYLVW3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 17:29:25 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1317996qwe.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 14:29:23 -0800 (PST)
Message-ID: <495014BF.1030602@cortland.com> (sfid-20081222_232930_966126_40018432)
Date: Mon, 22 Dec 2008 17:29:19 -0500
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
MIME-Version: 1.0
To: Bob Copeland <bcopeland@gmail.com>
CC: Keir <keirlawson@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, javier@cozybit.com
Subject: Re: Mesh now completely broken on ath5k, latest git
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>	 <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com>	 <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com>	 <40f31dec0812170906vd8e4445q9920c66905064df8@mail.gmail.com>	 <e27b78a40812171004r3a8d424dk7c390aaf7c757665@mail.gmail.com>	 <494A578A.7070803@cortland.com>	 <b6c5339f0812181138s1ba134a6qeff21eb063a87e08@mail.gmail.com>	 <494ABA6D.8070002@cortland.com>	 <b6c5339f0812181348x49e5c68bia827d9feb4ef0e6c@mail.gmail.com>	 <494C0181.8050008@cortland.com> <b6c5339f0812191241q3f2ff8aas5d538568552aca16@mail.gmail.com>
In-Reply-To: <b6c5339f0812191241q3f2ff8aas5d538568552aca16@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Fri, Dec 19, 2008 at 3:18 PM, Steve Brown <sbrown@cortland.com> wrote:
>   
>> If I revert this part of the pcu patch, the "queue 7" messages go away.
>> Beacons remain.
>>
>> -       ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
>> +       /* When in AP mode zero timer0 to start TSF */
>> +       if (ah->ah_op_mode == NL80211_IFTYPE_AP)
>> +               ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
>> +       else
>> +               ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
>>     
>
> So you're talking about AP mode and not mesh right (otherwise above code
> wouldn't make a difference)?  As in the HAL we do want to write 0 there.
> There's probably some other issue with setup of beacon timers.
>
>   
Yes, this was with AP mode. I agree that the current code conforms to 
the HAL. I'll keep looking.

I have also run some tests w/ mesh. After running (pings in both 
directions) for a half hour or so, I get a warning on one of the nodes. 
Most of the time, everything on that node freezes. When it doesn't, it 
is not possible to unload the ath5k driver on either node, even the one 
without the warning.

kernel:unregister_netdevice: waiting for mesh to become free. Usage 
count = 11

Should I submit a patch for the AR5K_CFG_ADHOC enable/disable bug? With 
it fixed, at least the ap and mesh problems are exposed. Maybe somebody 
can see what's wrong.

Steve
 
------------------------

Dec 19 15:56:07 ubuntu kernel: [10169.157843] ------------[ cut here 
]------------
Dec 19 15:56:07 ubuntu kernel: [10169.157848] WARNING: at 
net/mac80211/tx.c:569 invoke_tx_handlers+0xd77/0xde0 [mac80211]()
Dec 19 15:56:07 ubuntu kernel: [10169.157851] Modules linked in: ath5k 
af_packet i915 drm ppdev speedstep_lib cpufreq_conservative 
cpufreq_powersave cpufreq_userspace cpufreq_ondemand cpufreq_stats 
freq_table sco bridge rfcomm stp bnep l2cap bluetooth binfmt_misc ipv6 
battery sbs sbshc wmi video output container pci_slot snd_intel8x0 
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy 
snd_seq_oss snd_seq_midi arc4 ecb snd_rawmidi psmouse snd_seq_midi_event 
snd_seq serio_raw snd_timer snd_seq_device snd pcspkr soundcore 
snd_page_alloc iTCO_wdt iTCO_vendor_support rt73usb crc_itu_t rt2500usb 
rt2x00usb rt2x00lib rfkill evdev shpchp pci_hotplug led_class mac80211 
cfg80211 button intel_agp agpgart parport_pc lp parport ac 
iptable_filter ip_tables x_tables ext3 jbd mbcache sd_mod crc_t10dif 
usbhid hid sr_mod cdrom sg ata_piix pata_acpi ata_generic libata e100 
mii ehci_hcd scsi_mod uhci_hcd usbcore thermal processor fan fuse [last 
unloaded: ath5k]
Dec 19 15:56:07 ubuntu kernel: [10169.157995] Pid: 0, comm: swapper Not 
tainted 2.6.28-rc8-wl #9
Dec 19 15:56:07 ubuntu kernel: [10169.157998] Call Trace:
Dec 19 15:56:07 ubuntu kernel: [10169.158007]  [<c0377f35>] ? 
printk+0x18/0x1b
Dec 19 15:56:07 ubuntu kernel: [10169.158014]  [<c0133084>] 
warn_on_slowpath+0x54/0x80
Dec 19 15:56:07 ubuntu kernel: [10169.158038]  [<f8150249>] ? 
ieee80211_duration+0x189/0x220 [mac80211]
Dec 19 15:56:07 ubuntu kernel: [10169.158061]  [<f814a4ed>] ? 
rate_control_get_rate+0xbd/0xd0 [mac80211]
Dec 19 15:56:07 ubuntu kernel: [10169.158083]  [<f8151e77>] 
invoke_tx_handlers+0xd77/0xde0 [mac80211]
Dec 19 15:56:07 ubuntu kernel: [10169.158089]  [<c02e7678>] ? 
skb_release_data+0x68/0xa0
Dec 19 15:56:07 ubuntu kernel: [10169.158108]  [<f814fe4b>] ? 
__ieee80211_tx_prepare+0x17b/0x2f0 [mac80211]
Dec 19 15:56:07 ubuntu kernel: [10169.158127]  [<f81525d3>] 
ieee80211_master_start_xmit+0x1e3/0x4a0 [mac80211]
Dec 19 15:56:07 ubuntu kernel: [10169.158133]  [<c02ef83b>] 
dev_hard_start_xmit+0x23b/0x2d0
Dec 19 15:56:07 ubuntu kernel: [10169.158138]  [<c0301905>] 
__qdisc_run+0x1b5/0x220
Dec 19 15:56:07 ubuntu kernel: [10169.158153]  [<c02f1677>] 
dev_queue_xmit+0x337/0x570
Dec 19 15:56:07 ubuntu kernel: [10169.158172]  [<f8150cb6>] 
ieee80211_subif_start_xmit+0x366/0x7b0 [mac80211]
Dec 19 15:56:07 ubuntu kernel: [10169.158185]  [<f7d83376>] ? 
qh_urb_transaction+0xd6/0x3a0 [ehci_hcd]
Dec 19 15:56:07 ubuntu kernel: [10169.158190]  [<c02ef83b>] 
dev_hard_start_xmit+0x23b/0x2d0
Dec 19 15:56:07 ubuntu kernel: [10169.158194]  [<c0301905>] 
__qdisc_run+0x1b5/0x220
Dec 19 15:56:07 ubuntu kernel: [10169.158198]  [<c02f1677>] 
dev_queue_xmit+0x337/0x570
Dec 19 15:56:07 ubuntu kernel: [10169.158204]  [<c03173d5>] 
ip_finish_output+0x185/0x280
Dec 19 15:56:07 ubuntu kernel: [10169.158208]  [<c0314c90>] ? 
dst_output+0x0/0x10
Dec 19 15:56:07 ubuntu kernel: [10169.158212]  [<c0317520>] 
ip_output+0x50/0xa0
Dec 19 15:56:07 ubuntu kernel: [10169.158216]  [<c0314c90>] ? 
dst_output+0x0/0x10
Dec 19 15:56:07 ubuntu kernel: [10169.158220]  [<c03164e8>] 
ip_local_out+0x18/0x30
Dec 19 15:56:07 ubuntu kernel: [10169.158224]  [<c0316775>] 
ip_push_pending_frames+0x275/0x390
Dec 19 15:56:07 ubuntu kernel: [10169.158229]  [<c0338084>] 
icmp_push_reply+0x104/0x120
Dec 19 15:56:07 ubuntu kernel: [10169.158233]  [<c0338df6>] 
icmp_reply+0x116/0x1c0
Dec 19 15:56:07 ubuntu kernel: [10169.158237]  [<c0338fce>] 
icmp_echo+0x4e/0x50
Dec 19 15:56:07 ubuntu kernel: [10169.158242]  [<c02ea4eb>] ? 
__skb_checksum_complete_head+0x1b/0x70
Dec 19 15:56:07 ubuntu kernel: [10169.158246]  [<c02ea54b>] ? 
__skb_checksum_complete+0xb/0x10
Dec 19 15:56:07 ubuntu kernel: [10169.158250]  [<c03388cc>] 
icmp_rcv+0x21c/0x2a0
Dec 19 15:56:07 ubuntu kernel: [10169.158255]  [<c0312805>] 
ip_local_deliver_finish+0xa5/0x1c0
Dec 19 15:56:07 ubuntu kernel: [10169.158259]  [<c03129af>] 
ip_local_deliver+0x8f/0xa0
Dec 19 15:56:07 ubuntu kernel: [10169.158263]  [<c0312760>] ? 
ip_local_deliver_finish+0x0/0x1c0
Dec 19 15:56:07 ubuntu kernel: [10169.158267]  [<c03121ee>] 
ip_rcv_finish+0x14e/0x330
Dec 19 15:56:07 ubuntu kernel: [10169.158271]  [<c030c1af>] ? 
nf_hook_slow+0x9f/0xe0
Dec 19 15:56:07 ubuntu kernel: [10169.158275]  [<c03120a0>] ? 
ip_rcv_finish+0x0/0x330
Dec 19 15:56:07 ubuntu kernel: [10169.158279]  [<c0312607>] 
ip_rcv+0x237/0x280
Dec 19 15:56:07 ubuntu kernel: [10169.158283]  [<c03120a0>] ? 
ip_rcv_finish+0x0/0x330
Dec 19 15:56:07 ubuntu kernel: [10169.158287]  [<c02f0f94>] 
netif_receive_skb+0x284/0x550
Dec 19 15:56:07 ubuntu kernel: [10169.158291]  [<c02f12cb>] 
process_backlog+0x6b/0xe0
Dec 19 15:56:07 ubuntu kernel: [10169.158295]  [<c02f0a7d>] 
net_rx_action+0xed/0x220
Dec 19 15:56:07 ubuntu kernel: [10169.158300]  [<c01385b7>] 
__do_softirq+0x97/0x170
Dec 19 15:56:07 ubuntu kernel: [10169.158305]  [<c0115faf>] ? 
ack_apic_level+0x6f/0x290
Dec 19 15:56:07 ubuntu kernel: [10169.158309]  [<c01386ed>] 
do_softirq+0x5d/0x60
Dec 19 15:56:07 ubuntu kernel: [10169.158312]  [<c0138865>] 
irq_exit+0x55/0x90
Dec 19 15:56:07 ubuntu kernel: [10169.158318]  [<c0106703>] do_IRQ+0x83/0xa0
Dec 19 15:56:07 ubuntu kernel: [10169.158323]  [<c014bdfa>] ? 
hrtimer_start+0x1a/0x20
Dec 19 15:56:07 ubuntu kernel: [10169.158328]  [<c0105173>] 
common_interrupt+0x23/0x30
Dec 19 15:56:07 ubuntu kernel: [10169.158334]  [<c011be85>] ? 
native_safe_halt+0x5/0x10
Dec 19 15:56:07 ubuntu kernel: [10169.158339]  [<c010ac0d>] 
default_idle+0x5d/0x60
Dec 19 15:56:07 ubuntu kernel: [10169.158343]  [<c010285d>] 
cpu_idle+0x6d/0xd0
Dec 19 15:56:07 ubuntu kernel: [10169.158347]  [<c0369bde>] 
rest_init+0x4e/0x60
Dec 19 15:56:07 ubuntu kernel: [10169.158351] ---[ end trace 
16bfa1182f3e9a67 ]---


