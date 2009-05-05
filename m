Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:46604 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbZEET1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 15:27:33 -0400
Received: by ewy24 with SMTP id 24so5306725ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2009 12:27:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1241509306.25337.4.camel@johannes.local>
References: <43e72e890905042005vb96f57aid70c476e38685dfe@mail.gmail.com>
	<1241509306.25337.4.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 5 May 2009 12:27:16 -0700
Message-ID: <43e72e890905051227n11b128bap4d250e66294a29ce@mail.gmail.com>
Subject: Re: oops during stress test - today's wl
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 5, 2009 at 12:41 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-05-04 at 20:05 -0700, Luis R. Rodriguez wrote:
>> mcgrof@pogo ~/wireless-testing (git::master)$ git-describe
>> v2.6.30-rc4-22720-gb2382a4
>>
>> While running iperf, after about 1 hour.
>>
>> http://bombadil.infradead.org/~mcgrof/oops-img/09-05/oops-01-v2.6.30-rc4-22720-gb2382a4.jpg
>>
>> Image probably doesn't help much.. but its what I got.. I'd look more
>> but its getting late here, so I'm out. I'll use netconsole tomorrow.
>
> Yeah, doesn't really help... I would suspect the driver to be honest,
> since the scan code is trying to TX a frame and it's already in
> ieee80211_tx() (and probably in __ieee80211_tx which gets inlined).

Right on --

[57158.757990] wlan1: no probe response from AP 00:03:7f:0c:c2:5d -
disassociating
[57559.563565] cfg80211: Found new beacon on frequency: 5200 MHz (Ch 40) on phy2
[57559.669684] cfg80211: Found new beacon on frequency: 5220 MHz (Ch 44) on phy2
[57563.415178] cfg80211: Found new beacon on frequency: 5745 MHz (Ch
149) on phy2
[57563.478395] cfg80211: Found new beacon on frequency: 5765 MHz (Ch
153) on phy2
[57563.737684] wlan1: authenticate with AP 00:03:7f:0c:c2:5d
[57563.754972] wlan1: authenticate with AP 00:03:7f:0c:c2:5d
[57563.763958] wlan1: authenticate with AP 00:03:7f:0c:c2:5d
[57563.765895] wlan1: authenticated
[57563.765930] wlan1: associate with AP 00:03:7f:0c:c2:5d
[57563.779535] wlan1: RX ReassocResp from 00:03:7f:0c:c2:5d
(capab=0x421 status=0 aid=1)
[57563.779595] wlan1: associated
[57633.747150] wlan1: deauthenticating by local choice (reason=3)
[57634.224023] wlan1: deauthenticating by local choice (reason=3)
[57654.246527] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[57659.942571] wlan1: authenticate with AP 00:03:7f:0c:c2:5d
[57659.945696] wlan1: authenticated
[57659.945735] wlan1: associate with AP 00:03:7f:0c:c2:5d
[57659.951992] wlan1: RX AssocResp from 00:03:7f:0c:c2:5d (capab=0x421
status=0 aid=1)
[57659.952054] wlan1: associated
[57659.962379] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[57670.356717] wlan1: no IPv6 routers present
[58264.676456] wlan1: deauthenticated (Reason: 2)
[58265.671832] wlan1: direct probe to AP 00:03:7f:0c:c2:5d try 1
[58265.671832] wlan1: direct probe to AP 00:03:7f:0c:c2:5d try 1
[58265.881845] wlan1: direct probe to AP 00:03:7f:0c:c2:5d try 2
[58265.881845] wlan1: direct probe to AP 00:03:7f:0c:c2:5d try 2
[58265.887928] wlan1 direct probe responded
[58265.887966] wlan1: authenticate with AP 00:03:7f:0c:c2:5d
[58265.887928] wlan1 direct probe responded
[58265.887966] wlan1: authenticate with AP 00:03:7f:0c:c2:5d
[58265.890837] wlan1: authenticated
[58265.890871] wlan1: associate with AP 00:03:7f:0c:c2:5d
[58265.890837] wlan1: authenticated
[58265.890871] wlan1: associate with AP 00:03:7f:0c:c2:5d
[58265.898987] wlan1: RX ReassocResp from 00:03:7f:0c:c2:5d
(capab=0x421 status=0 aid=1)
[58265.899041] wlan1: associated
[58265.898987] wlan1: RX ReassocResp from 00:03:7f:0c:c2:5d
(capab=0x421 status=0 aid=1)
[58265.899041] wlan1: associated
[58266.391122] ------------[ cut here ]------------
[58266.391166] kernel BUG at drivers/net/wireless/ath/ath9k/rc.c:746!
[58266.391202] invalid opcode: 0000 [#1] PREEMPT SMP
[58266.391253] last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[58266.391303] CPU 3
[58266.391333] Modules linked in: netconsole ath9k configfs ipv6
cpufreq_ondemand powernow_k8[58266.391122] ------------[ cut here
]------------
 freq_table binfmt_misc loop dm_multipath scsi_dh arc4 ecb mac80211
rfkill af_packet led_class ath sr_mod cfg80211 e1000 evdev shpchp
cdrom evbug[58266.391166] kernel BUG at
drivers/net/wireless/ath/ath9k/rc.c:746!
 usbhid[58266.391202] invalid opcode: 0000 [#1]  psmouse serio_raw
pcspkr i2c_nforce2 pci_hotplugPREEMPT  pata_amd hid sg i2c_core
processor wmi floppy thermal buttonSMP  dm_snapshot dm_zero dm_mirror
dm_region_hash dm_log dm_mod ahci ata_generic pata_acpi libata
 sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd
ehci_hcd usbcore [last unloaded: netconsole]
[58266.391841] Pid: 5111, comm: phy2 Not tainted 2.6.30-rc4-wl #27
System Product Name
[58266.391841] RIP: 0010:[<ffffffffa046c2c9>] [58266.391253] last
sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[58266.391303] CPU 3  [<ffffffffa046c2c9>] ath_get_rate+0x499/0x5e0 [ath9k]
[58266.391841] RSP: 0018:ffff88021d945a80  EFLAGS: 00010246

[58266.391333] Modules linked in:[58266.391841] RAX: 00000000000000fc
RBX: 000000000000001c RCX: 000000000000001c
 netconsole[58266.391841] RDX: 000000000000001c RSI: 0000000000000000
RDI: 0000000000000000
[58266.391841] RBP: ffff88021d945ae0 R08: 0000000000000000 R09: 000000000000002a
 ath9k[58266.391841] R10: 0000000000000000 R11: 0000000003746dde R12:
ffff88021e04a800
[58266.391841] R13: 0000000000000064 R14: ffff88021e06b738 R15: ffffffffa048b0c0
 configfs[58266.391841] FS:  00007f591775e6f0(0000)
GS:ffff88003658b000(0000) knlGS:0000000000000000
 ipv6[58266.391841] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[58266.391841] CR2: 00007fff5668a318 CR3: 000000021fc46000 CR4: 00000000000006a0
 cpufreq_ondemand[58266.391841] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
[58266.391841] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 powernow_k8[58266.391841] Process phy2 (pid: 5111, threadinfo
ffff88021d944000, task ffff88021fdf2280)
58266.391841] Stack:
[58266.391841]  ffff88021d945ab0 000000000000001c freq_table
ffff88021d945b70 ffff880213929780
[58266.391841]  binfmt_misc 000011481d945c10 ffff88021e06b700
ffff88021e048820 ffff88021e06b738
[58266.391841]  ffff8802186ff780 loop ffff88021d945c10
ffff88021e06b700 ffff88021e06b738
 dm_multipath[58266.391841] Call Trace:
[58266.391841]  scsi_dh [<ffffffffa02d608e>]
rate_control_get_rate+0xbe/0xd0 [mac80211]
[58266.391841]  arc4 [<ffffffffa02df4b3>]
invoke_tx_handlers+0x5d3/0xe40 [mac80211]
[58266.391841]  [<ffffffff8026b48d>] ? trace_hardirqs_on+0xd/0x10
 ecb[58266.391841]  mac80211 [<ffffffffa02dd90f>] ?
__ieee80211_tx_prepare+0x1af/0x3a0 [mac80211]
[58266.391841]  [<ffffffff802e303a>] ? kfree+0x12a/0x1a0
[58266.391841]  [<ffffffffa02dff76>] ieee80211_tx+0xd6/0x2a0 [mac80211]
[58266.391841]  rfkill af_packet [<ffffffffa02e0644>]
ieee80211_master_start_xmit+0x1e4/0x3c0 [mac80211]
[58266.391841]  led_class [<ffffffff804c9ccd>] dev_hard_start_xmit+0x25d/0x300
[58266.391841]  [<ffffffff804dd44e>] __qdisc_run+0x25e/0x2b0
 ath[58266.391841]  [<ffffffff804cbfb8>] dev_queue_xmit+0x2c8/0x4a0
[58266.391841]  sr_mod [<ffffffffa02e2367>] ieee80211_tx_skb+0x67/0x70
[mac80211]
[58266.391841]  cfg80211 [<ffffffffa02d146a>]
ieee80211_send_nullfunc+0xea/0x130 [mac80211]
[58266.391841]  e1000 [<ffffffffa02cca3c>]
__ieee80211_start_scan+0x2fc/0x450 [mac80211]
[58266.391841]  evdev [<ffffffffa02cd160>] ?
ieee80211_scan_work+0x0/0x250 [mac80211]
[58266.391841]  [<ffffffffa02cd28d>] ieee80211_scan_work+0x12d/0x250 [mac80211]
[58266.391841]  [<ffffffff80253569>] worker_thread+0x249/0x3c0
[58266.391841]  shpchp cdrom [<ffffffff80253513>] ? worker_thread+0x1f3/0x3c0
[58266.391841]  [<ffffffff802581f0>] ? autoremove_wake_function+0x0/0x40
 evbug[58266.391841]  [<ffffffff80253320>] ? worker_thread+0x0/0x3c0
[58266.391841]  usbhid [<ffffffff80253320>] ? worker_thread+0x0/0x3c0
[58266.391841]  [<ffffffff80257d06>] kthread+0x56/0x90
[58266.391841]  psmouse [<ffffffff8020d07a>] child_rip+0xa/0x20
[58266.391841]  [<ffffffff8020ca40>] ? restore_args+0x0/0x30
 serio_raw[58266.391841]  [<ffffffff80257cb0>] ? kthread+0x0/0x90
[58266.391841]  [<ffffffff8020d070>] ? child_rip+0x0/0x20
[58266.391841] Code: 0f b6 7c 87 1b 41 88 7e 17 e9 18 fc ff ff 48 8b
55 a8 48 8d 04 d2 41 8b 74 87 08 85 f6 74 0c 41 f6 44 24 54 01 0f 84
ba fd ff ff <0f> 0b eb fe 0f 1f 00 38 c2 66 0f 1f 44 00 00 7f 0b 89 c3
0f 1f
[58266.391841] RIP  [<ffffffffa046c2c9>] ath_get_rate+0x499/0x5e0 [ath9k]
[58266.391841]  RSP <ffff88021d945a80>
 pcspkr i2c_nforce2 pci_hotplug[58266.394869] ---[ end trace
42c6ceaa62c8df90 ]---
 hid[58266.394945] Kernel panic - not syncing: Fatal exception in interrupt
 sg[58266.395025] Pid: 5111, comm: phy2 Tainted: G      D    2.6.30-rc4-wl #27
 i2c_core[58266.395101] Call Trace:
 processor wmi[58266.395177]  [<ffffffff8055cb39>] panic+0xaa/0x17a
 floppy[58266.395255]  [<ffffffff8056019f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 thermal[58266.395333]  [<ffffffff8020ca40>] ? restore_args+0x0/0x30
 button[58266.395411]  [<ffffffff805621eb>] ? oops_end+0x6b/0xe0
 dm_snapshot[58266.395485]  [<ffffffff80562254>] oops_end+0xd4/0xe0
 dm_mirror[58266.395562]  [<ffffffff8020fd26>] die+0x56/0x90
 dm_region_hash[58266.395635]  [<ffffffff805619f6>] do_trap+0x146/0x170
 dm_log[58266.395709]  [<ffffffff8020dc00>] do_invalid_op+0x90/0xb0
 dm_mod ahci[58266.395797]  [<ffffffffa046c2c9>] ?
ath_get_rate+0x499/0x5e0 [ath9k]
 ata_generic[58266.395878]  [<ffffffff805601de>] ?
trace_hardirqs_off_thunk+0x3a/0x3c
 pata_acpi[58266.395958]  [<ffffffff8020ce15>] invalid_op+0x15/0x20
 libata sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
usbcore [last unloaded: netconsole]
[58266.391841] Pid: 5111, comm: phy2 Not tainted 2.6.30-rc4-wl #27
System Product Name
[58266.391841] RIP: 0010:[<ffffffffa046c2c9>]  [<ffffffffa046c2c9>]
ath_get_rate+0x499/0x5e0 [ath9k]
[58266.391841] RSP: 0018:ffff88021d945a80  EFLAGS: 00010246
[58266.391841] RAX: 00000000000000fc RBX: 000000000000001c RCX: 000000000000001c
[58266.391841] RDX: 000000000000001c RSI: 0000000000000000 RDI: 0000000000000000
[58266.391841] RBP: ffff88021d945ae0 R08: 0000000000000000 R09: 000000000000002a
[58266.396046]  [<ffffffffa046c2c9>] ? ath_get_rate+0x499/0x5e0 [ath9k]
[58266.397800]  [<ffffffffa02d608e>] rate_control_get_rate+0xbe/0xd0 [mac80211]
[58266.397897]  [<ffffffffa02df4b3>] invoke_tx_handlers+0x5d3/0xe40 [mac80211]
[58266.397978]  [<ffffffff8026b48d>] ? trace_hardirqs_on+0xd/0x10
[58266.398074]  [<ffffffffa02dd90f>] ?
__ieee80211_tx_prepare+0x1af/0x3a0 [mac80211]
[58266.391841] R10: 0000000000000000 R11: 0000000003746dde R12: ffff88021e04a800
[58266.398177]  [<ffffffff802e303a>] ? kfree+0x12a/0x1a0
[58266.391841] R13: 0000000000000064 R14: ffff88021e06b738 R15: ffffffffa048b0c0
[58266.391841] FS:  00007f591775e6f0(0000) GS:ffff88003658b000(0000)
knlGS:0000000000000000
[58266.398273]  [<ffffffffa02dff76>] ieee80211_tx+0xd6/0x2a0 [mac80211]
[58266.391841] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[58266.398374]  [<ffffffffa02e0644>]
ieee80211_master_start_xmit+0x1e4/0x3c0 [mac80211]
[58266.391841] CR2: 00007fff5668a318 CR3: 000000021fc46000 CR4: 00000000000006a0
[58266.398472]  [<ffffffff804c9ccd>] dev_hard_start_xmit+0x25d/0x300
[58266.391841] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[58266.398552]  [<ffffffff804dd44e>] __qdisc_run+0x25e/0x2b0
[58266.391841] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[58266.391841] Process phy2 (pid: 5111, threadinfo ffff88021d944000,
task ffff88021fdf2280)
[58266.398627]  [<ffffffff804cbfb8>] dev_queue_xmit+0x2c8/0x4a0
[58266.391841] Stack:
[58266.391841]  ffff88021d945ab0[58266.398724]  [<ffffffffa02e2367>]
ieee80211_tx_skb+0x67/0x70 [mac80211]
 000000000000001c ffff88021d945b70[58266.398823]  [<ffffffffa02d146a>]
ieee80211_send_nullfunc+0xea/0x130 [mac80211]
 ffff880213929780[58266.398938]  [<ffffffffa02cca3c>]
__ieee80211_start_scan+0x2fc/0x450 [mac80211]

[58266.399051]  [<ffffffffa02cd160>] ? ieee80211_scan_work+0x0/0x250 [mac80211]
[58266.391841]  000011481d945c10[58266.399146]  [<ffffffffa02cd28d>]
ieee80211_scan_work+0x12d/0x250 [mac80211]
 ffff88021e06b700[58266.399224]  [<ffffffff80253569>] worker_thread+0x249/0x3c0
 ffff88021e048820[58266.399302]  [<ffffffff80253513>] ?
worker_thread+0x1f3/0x3c0
 ffff88021e06b738
[58266.399378]  [<ffffffff802581f0>] ? autoremove_wake_function+0x0/0x40
[58266.391841] [58266.399457]  [<ffffffff80253320>] ? worker_thread+0x0/0x3c0
 ffff8802186ff780[58266.399534]  [<ffffffff80253320>] ? worker_thread+0x0/0x3c0
[58266.399614]  [<ffffffff80257d06>] kthread+0x56/0x90
 ffff88021d945c10 ffff88021e06b700[58266.399691]  [<ffffffff8020d07a>]
child_rip+0xa/0x20
 ffff88021e06b738[58266.399768]  [<ffffffff8020ca40>] ? restore_args+0x0/0x30

[58266.399847]  [<ffffffff80257cb0>] ? kthread+0x0/0x90
[58266.391841] Call Trace:
[58266.399921]  [<ffffffff8020d070>] ? child_rip+0x0/0x20
[58266.391841]  [<ffffffffa02d608e>] rate_control_get_rate+0xbe/0xd0 [mac80211]
[58266.391841]  [<ffffffffa02df4b3>] invoke_tx_handlers+0x5d3/0xe40 [mac80211]
[58266.391841]  [<ffffffff8026b48d>] ? trace_hardirqs_on+0xd/0x10
[58266.391841]  [<ffffffffa02dd90f>] ?
__ieee80211_tx_prepare+0x1af/0x3a0 [mac80211]
[58266.391841]  [<ffffffff802e303a>] ? kfree+0x12a/0x1a0
[58266.391841]  [<ffffffffa02dff76>] ieee80211_tx+0xd6/0x2a0 [mac80211]
[58266.391841]  [<ffffffffa02e0644>]
ieee80211_master_start_xmit+0x1e4/0x3c0 [mac80211]
[58266.391841]  [<ffffffff804c9ccd>] dev_hard_start_xmit+0x25d/0x300
[58266.391841]  [<ffffffff804dd44e>] __qdisc_run+0x25e/0x2b0
[58266.391841]  [<ffffffff804cbfb8>] dev_queue_xmit+0x2c8/0x4a0
[58266.391841]  [<ffffffffa02e2367>] ieee80211_tx_skb+0x67/0x70 [mac80211]
[58266.391841]  [<ffffffffa02d146a>]
ieee80211_send_nullfunc+0xea/0x130 [mac80211]
[58266.391841]  [<ffffffffa02cca3c>]
__ieee80211_start_scan+0x2fc/0x450 [mac80211]
[58266.391841]  [<ffffffffa02cd160>] ? ieee80211_scan_work+0x0/0x250 [mac80211]
[58266.391841]  [<ffffffffa02cd28d>] ieee80211_scan_work+0x12d/0x250 [mac80211]
[58266.391841]  [<ffffffff80253569>] worker_thread+0x249/0x3c0
[58266.391841]  [<ffffffff80253513>] ? worker_thread+0x1f3/0x3c0
[58266.391841]  [<ffffffff802581f0>] ? autoremove_wake_function+0x0/0x40
[58266.391841]  [<ffffffff80253320>] ? worker_thread+0x0/0x3c0
[58266.391841]  [<ffffffff80253320>] ? worker_thread+0x0/0x3c0
[58266.391841]  [<ffffffff80257d06>] kthread+0x56/0x90
[58266.391841]  [<ffffffff8020d07a>] child_rip+0xa/0x20
[58266.391841]  [<ffffffff8020ca40>] ? restore_args+0x0/0x30
[58266.391841]  [<ffffffff80257cb0>] ? kthread+0x0/0x90
[58266.391841]  [<ffffffff8020d070>] ? child_rip+0x0/0x20
[58266.391841] Code: 0f b6 7c 87 1b 41 88 7e 17 e9 18 ff ff 48 55 a8
48 04 d2 41 74 87 08 85 74 0c 41 44 24 54 0f 84 ba ff ff <0f> eb fe 0f
1f 38 c2 66 1f 44 00 7f 0b 89 0f 1f
 [<ffffffffa046c2c9>] ath_get_rate+0x499/0x5e0 [ath9k]
[58266.391841]  RSP <ffff88021d945a80>
[58266.394869] ---[ end trace 42c6ceaa62c8df90 ]---
[58266.394945] Kernel panic - not syncing: Fatal exception in interrupt
[58266.395025] Pid: 5111, comm: phy2 Tainted: G      D    2.6.30-rc4-wl #27
[58266.395101] Call Trace:
[58266.395177]  [<ffffffff8055cb39>] panic+0xaa/0x17a
[58266.395255]  [<ffffffff8056019f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[58266.395333]  [<ffffffff8020ca40>] ? restore_args+0x0/0x30
[58266.395411]  [<ffffffff805621eb>] ? oops_end+0x6b/0xe0
[58266.395485]  [<ffffffff80562254>] oops_end+0xd4/0xe0
[58266.395562]  [<ffffffff8020fd26>] die+0x56/0x90
[58266.395635]  [<ffffffff805619f6>] do_trap+0x146/0x170
[58266.395709]  [<ffffffff8020dc00>] do_invalid_op+0x90/0xb0
[58266.395797]  [<ffffffffa046c2c9>] ? ath_get_rate+0x499/0x5e0 [ath9k]
[58266.395878]  [<ffffffff805601de>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[58266.395958]  [<ffffffff8020ce15>] invalid_op+0x15/0x20
[58266.396046]  [<ffffffffa046c2c9>] ? ath_get_rate+0x499/0x5e0 [ath9k]
[58266.397800]  [<ffffffffa02d608e>] rate_control_get_rate+0xbe/0xd0 [mac80211]
[58266.397897]  [<ffffffffa02df4b3>] invoke_tx_handlers+0x5d3/0xe40 [mac80211]
[58266.397978]  [<ffffffff8026b48d>] ? trace_hardirqs_on+0xd/0x10
[58266.398074]  [<ffffffffa02dd90f>] ?
__ieee80211_tx_prepare+0x1af/0x3a0 [mac80211]
[58266.398177]  [<ffffffff802e303a>] ? kfree+0x12a/0x1a0
[58266.398273]  [<ffffffffa02dff76>] ieee80211_tx+0xd6/0x2a0 [mac80211]
[58266.398374]  [<ffffffffa02e0644>]
ieee80211_master_start_xmit+0x1e4/0x3c0 [mac80211]
[58266.398472]  [<ffffffff804c9ccd>] dev_hard_start_xmit+0x25d/0x300
[58266.398552]  [<ffffffff804dd44e>] __qdisc_run+0x25e/0x2b0
[58266.398627]  [<ffffffff804cbfb8>] dev_queue_xmit+0x2c8/0x4a0
[58266.398724]  [<ffffffffa02e2367>] ieee80211_tx_skb+0x67/0x70 [mac80211]
[58266.398823]  [<ffffffffa02d146a>]
ieee80211_send_nullfunc+0xea/0x130 [mac80211]
[58266.398938]  [<ffffffffa02cca3c>]
__ieee80211_start_scan+0x2fc/0x450 [mac80211]
[58266.399051]  [<ffffffffa02cd160>] ? ieee80211_scan_work+0x0/0x250 [mac80211]
[58266.399146]  [<ffffffffa02cd28d>] ieee80211_scan_work+0x12d/0x250 [mac80211]
[58266.399224]  [<ffffffff80253569>] worker_thread+0x249/0x3c0
[58266.399302]  [<ffffffff80253513>] ? worker_thread+0x1f3/0x3c0
[58266.399378]  [<ffffffff802581f0>] ? autoremove_wake_function+0x0/0x40
[58266.399457]  [<ffffffff80253320>] ? worker_thread+0x0/0x3c0
[58266.399534]  [<ffffffff80253320>] ? worker_thread+0x0/0x3c0
[58266.399614]  [<ffffffff80257d06>] kthread+0x56/0x90
[58266.399691]  [<ffffffff8020d07a>] child_rip+0xa/0x20
[58266.399768]  [<ffffffff8020ca40>] ? restore_args+0x0/0x30
[58266.399847]  [<ffffffff80257cb0>] ? kthread+0x0/0x90
[58266.399921]  [<ffffffff8020d070>] ? child_rip+0x0/0x20
