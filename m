Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:39118 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbZHGP7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 11:59:31 -0400
Received: by gxk9 with SMTP id 9so2185874gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 08:59:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <caf5d1ef0908062250k1b207abfk3af487bde38fd0d1@mail.gmail.com>
References: <caf5d1ef0908022128n373a24f1t994d6a41dd6f9962@mail.gmail.com>
	<caf5d1ef0908061406g73f8fc1cu12fed099dfeb329a@mail.gmail.com>
	<43e72e890908061429h56406fa7j271af9fcc7b29cbf@mail.gmail.com>
	<caf5d1ef0908062250k1b207abfk3af487bde38fd0d1@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 7 Aug 2009 08:59:09 -0700
Message-ID: <43e72e890908070859x4f0dbfc0wb0ac0826f43625e1@mail.gmail.com>
Subject: Re: [ath9k-devel] Kernel panic with ar5418 and compat-wireless
	2009-07-29
To: jords@shadowservices.biz
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 6, 2009 at 10:50 PM, Jordan Thoms<jords@shadowservices.biz> wrote:
> Hi,
> I have just tried wireless-testing and compiling a whole new kernel, and
> both times i received a oops error.

OK great, good to know it is not a compat specific bug and a real bug.

>  However, I think this could be a
> different issue, because it seemed to be triggered by periods of wireless
> inactivity. I watched a 40 minute TV episode over the wireless with no
> issue, but it then crashed approximately 20 mins after.
> The crash logs:
> Compat-wireless 2009-08-06
>  [ 1428.485778] BUG: unable to handle kernel NULL pointer dereference at
> 00000030
> [ 1428.486742] IP: [<f84a9ba1>] ieee80211_agg_splice_packets+0x37/0x9e
> [mac80211]

Please provide the output of:

gdb net/mac80211/mac80211.ko
l *(ieee80211_agg_splice_packets+0x37)

  Luis

> [ 1428.486742] *pde = 00000000
> [ 1428.486742] Thread overran stack, or stack corrupted
> [ 1428.486742] Oops: 0000 [#1] SMP
> [ 1428.486742] last sysfs file: /sys/devices/system/cpu/cpu1/online
> [ 1428.486742] Modules linked in: vboxnetadp vboxnetflt vboxdrv ath9k
> mac80211 ath cfg80211 rfkill_backport
> [ 1428.486742]
> [ 1428.486742] Pid: 0, comm: swapper Not tainted (2.6.30-gentoo-r4 #4)
> P5L-MX
> [ 1428.486742] EIP: 0060:[<f84a9ba1>] EFLAGS: 00010206 CPU: 0
> [ 1428.486742] EIP is at ieee80211_agg_splice_packets+0x37/0x9e [mac80211]
> [ 1428.486742] EAX: 00000030 EBX: 00000000 ECX: 00000003 EDX: f7076224
> [ 1428.486742] ESI: f54ac000 EDI: 00000002 EBP: c173fed8 ESP: c173fec0
> [ 1428.486742]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [ 1428.486742] Process swapper (pid: 0, ti=c173e000 task=c16bd300
> task.ti=c173e000)
> [ 1428.486742] Stack:
> [ 1428.486742]  f70761c0 c173fecc c102c788 00000000 f54ac000 f70761c0
> c173fef8 f84aa060
> [ 1428.486742]  f6a34ce0 f54ac020 f54ac12c f6a34cc0 f70761c0 00000001
> c173ff08 f84a6b13
> [ 1428.486742]  f7076280 00000000 c173ff18 c102cc9e 00000020 c17359d4
> c173ff3c c102c886
> [ 1428.486742] Call Trace:
> [ 1428.486742]  [<c102c788>] ? local_bh_disable+0xb/0xd
> [ 1428.486742]  [<f84aa060>] ? ieee80211_stop_tx_ba_cb+0x76/0xb4 [mac80211]
> [ 1428.486742]  [<f84a6b13>] ? ieee80211_tasklet_handler+0x5a/0xc3
> [mac80211]
> [ 1428.486742]  [<c102cc9e>] ? tasklet_action+0x57/0x9e
> [ 1428.486742]  [<c102c886>] ? __do_softirq+0x8e/0x132
> [ 1428.486742]  [<c102c950>] ? do_softirq+0x26/0x2b
> [ 1428.486742]  [<c102cb23>] ? irq_exit+0x29/0x5c
> [ 1428.486742]  [<c1004444>] ? do_IRQ+0x6d/0x83
> [ 1428.486742]  [<c1003129>] ? common_interrupt+0x29/0x30
> [ 1428.486742]  [<c100855d>] ? mwait_idle+0x66/0x79
> [ 1428.486742]  [<c1001d68>] ? cpu_idle+0x44/0x65
> [ 1428.486742]  [<c146adf7>] ? rest_init+0x53/0x55
> [ 1428.486742]  [<c17457fb>] ? start_kernel+0x2ac/0x2b1
> [ 1428.486742]  [<c174506a>] ? __init_begin+0x6a/0x6f
> [ 1428.486742] Code: ec 0c b9 03 00 00 00 89 45 e8 89 d8 83 e0 07 0f b7 3c
> 85 20 a2 4b f8 8b 45 e8 89 fa e8 0b db
> 00 00 8b 84 9e 3c 01 00 00 83 c0 30 <39> 00 74 5b 8b 45 e8 83 c0 64 89 45 ec
> e8 54 dc fd c8 89 45 f0
> [ 1428.486742] EIP: [<f84a9ba1>] ieee80211_agg_splice_packets+0x37/0x9e
> [mac80211] SS:ESP 0068:c173fec0
> [ 1428.486742] CR2: 0000000000000030
> [ 1429.140936] ---[ end trace 28eac1989c1512b0 ]---
> [ 1429.154801] Kernel panic - not syncing: Fatal exception in interrupt
> [ 1429.173894] Pid: 0, comm: swapper Tainted: G      D    2.6.30-gentoo-r4
> #4
> [ 1429.194534] Call Trace:
> [ 1429.201917]  [<c1028a0d>] panic+0x3f/0xdf
> [ 1429.213981]  [<c14881f9>] oops_end+0x8b/0x9a
> [ 1429.226827]  [<c1017745>] no_context+0x10c/0x116
> [ 1429.240715]  [<c10178d2>] __bad_area_nosemaphore+0xe0/0xe8
> [ 1429.257196]  [<c101793e>] bad_area_nosemaphore+0xd/0x10
> [ 1429.272898]  [<c1489187>] do_page_fault+0x102/0x207
> [ 1429.287564]  [<c1489085>] ? do_page_fault+0x0/0x207
> [ 1429.302228]  [<c148795d>] error_code+0x6d/0x74
> [ 1429.315603]  [<f84b007b>] ? ieee80211_open+0x486/0x4e3 [mac80211]
> [ 1429.333898]  [<c1489085>] ? do_page_fault+0x0/0x207
> [ 1429.348572]  [<f84a9ba1>] ? ieee80211_agg_splice_packets+0x37/0x9e
> [mac80211]
> [ 1429.369988]  [<c102c788>] ? local_bh_disable+0xb/0xd
> [ 1429.384921]  [<f84aa060>] ieee80211_stop_tx_ba_cb+0x76/0xb4 [mac80211]
> [ 1429.404525]  [<f84a6b13>] ieee80211_tasklet_handler+0x5a/0xc3 [mac80211]
> [ 1429.424641]  [<c102cc9e>] tasklet_action+0x57/0x9e
> [ 1429.439044]  [<c102c886>] __do_softirq+0x8e/0x132
> [ 1429.453188]  [<c102c950>] do_softirq+0x26/0x2b
> [ 1429.466551]  [<c102cb23>] irq_exit+0x29/0x5c
> [ 1429.479396]  [<c1004444>] do_IRQ+0x6d/0x83
> [ 1429.491721]  [<c1003129>] common_interrupt+0x29/0x30
> [ 1429.506643]  [<c100855d>] ? mwait_idle+0x66/0x79
> [ 1429.520528]  [<c1001d68>] cpu_idle+0x44/0x65
> [ 1429.533372]  [<c146adf7>] rest_init+0x53/0x55
> [ 1429.546476]  [<c17457fb>] start_kernel+0x2ac/0x2b1
> [ 1429.560880]  [<c174506a>] __init_begin+0x6a/0x6f
> Wireless-Testing:
> jords@bender ~ $ [ 3327.864925] BUG: unable to handle kernel NULL pointer
> dereference at 00000030
> [ 3327.865876] IP: [<f8407ba1>] ieee80211_agg_splice_packets+0x37/0x9e
> [mac80211]
> [ 3327.865876] *pde = 00000000
> [ 3327.865876] Thread overran stack, or stack corrupted
> [ 3327.865876] Oops: 0000 [#1] SMP
> [ 3327.865876] last sysfs file:
> /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
> [ 3327.865876] Modules linked in: ath9k mac80211 ath cfg80211
> [ 3327.865876]
> [ 3327.865876] Pid: 0, comm: swapper Not tainted (2.6.31-rc5-wl #1) P5L-MX
> [ 3327.865876] EIP: 0060:[<f8407ba1>] EFLAGS: 00010206 CPU: 0
> [ 3327.865876] EIP is at ieee80211_agg_splice_packets+0x37/0x9e [mac80211]
> [ 3327.865876] EAX: 00000030 EBX: 00000000 ECX: 00000003 EDX: f708a224
> [ 3327.865876] ESI: f5c44000 EDI: 00000002 EBP: c171ded4 ESP: c171debc
> [ 3327.865876]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [ 3327.865876] Process swapper (pid: 0, ti=c171c000 task=c1697160
> task.ti=c171c000)
> [ 3327.865876] Stack:
> [ 3327.865876]  f708a1c0 c171dec8 c102e3c6 00000000 f5c44000 f708a1c0
> c171def4 f8408060
> [ 3327.865876] <0> f6b11b60 f5c44020 f5c4412c f6b11b40 f708a1c0 c1713a14
> c171df04 f8404a46
> [ 3327.865876] <0> f708a280 00000000 c171df14 c102eb6e 00000020 00000005
> c171df3c c102e4db
> [ 3327.865876] Call Trace:
> [ 3327.865876]  [<c102e3c6>] ? local_bh_disable+0xb/0xd
> [ 3327.865876]  [<f8408060>] ? ieee80211_stop_tx_ba_cb+0x76/0xb4 [mac80211]
> [ 3327.865876]  [<f8404a46>] ? ieee80211_tasklet_handler+0x5a/0xc3
> [mac80211]
> [ 3327.865876]  [<c102eb6e>] ? tasklet_action+0x57/0x9e
> [ 3327.865876]  [<c102e4db>] ? __do_softirq+0xa5/0x145
> [ 3327.865876]  [<c102e5a1>] ? do_softirq+0x26/0x2b
> [ 3327.865876]  [<c102f11c>] ? irq_exit+0x29/0x5c
> [ 3327.865876]  [<c1004681>] ? do_IRQ+0x72/0x89
> [ 3327.865876]  [<c1003069>] ? common_interrupt+0x29/0x30
> [ 3327.865876]  [<c104007b>] ? __async_schedule+0x37/0x135
> [ 3327.865876]  [<c100883e>] ? mwait_idle+0x66/0x78
> [ 3327.865876]  [<c1001c77>] ? cpu_idle+0x44/0x65
> [ 3327.865876]  [<c1451e57>] ? rest_init+0x53/0x55
> [ 3327.865876]  [<c1723826>] ? start_kernel+0x2b1/0x2b6
> [ 3327.865876]  [<c172306a>] ? __init_begin+0x6a/0x6f
> [ 3327.865876] Code: ec 0c b9 03 00 00 00 89 45 e8 89 d8 83 e0 07 0f b7 3c
> 85 80 7b 41 f8 8b 45 e8 89 fa e8 f7 da
> 00 00 8b 84 9e 3c 01 00 00 83 c0 30 <39> 00 74 5b 8b 45 e8 83 c0 64 89 45 ec
> e8 9c 78 06 c9 89 45 f0
> [ 3327.865876] EIP: [<f8407ba1>] ieee80211_agg_splice_packets+0x37/0x9e
> [mac80211] SS:ESP 0068:c171debc
> [ 3327.865876] CR2: 0000000000000030
> [ 3328.528281] ---[ end trace 289a5951fbc06b5e ]---
> [ 3328.542165] Kernel panic - not syncing: Fatal exception in interrupt
> [ 3328.561251] Pid: 0, comm: swapper Tainted: G      D    2.6.31-rc5-wl #1
> [ 3328.581118] Call Trace:
> [ 3328.588496]  [<c102a3c9>] panic+0x3f/0xdf
> [ 3328.600561]  [<c146fe41>] oops_end+0x8b/0x9a
> [ 3328.613406]  [<c101977b>] no_context+0x10c/0x116
> [ 3328.627290]  [<c1019908>] __bad_area_nosemaphore+0xe0/0xe8
> [ 3328.643775]  [<c1019974>] bad_area_nosemaphore+0xd/0x10
> [ 3328.659478]  [<c1470dd8>] do_page_fault+0x102/0x20e
> [ 3328.674142]  [<c1470cd6>] ? do_page_fault+0x0/0x20e
> [ 3328.688809]  [<c146f59e>] error_code+0x66/0x6c
> [ 3328.702183]  [<f841007b>] ? ieee80211_get_key+0x25/0x160 [mac80211]
> [ 3328.720996]  [<c1470cd6>] ? do_page_fault+0x0/0x20e
> [ 3328.735668]  [<f8407ba1>] ? ieee80211_agg_splice_packets+0x37/0x9e
> [mac80211]
> [ 3328.757089]  [<c102e3c6>] ? local_bh_disable+0xb/0xd
> [ 3328.772023]  [<f8408060>] ieee80211_stop_tx_ba_cb+0x76/0xb4 [mac80211]
> [ 3328.791625]  [<f8404a46>] ieee80211_tasklet_handler+0x5a/0xc3 [mac80211]
> [ 3328.811739]  [<c102eb6e>] tasklet_action+0x57/0x9e
> [ 3328.826137]  [<c102e4db>] __do_softirq+0xa5/0x145
> [ 3328.840286]  [<c102e5a1>] do_softirq+0x26/0x2b
> [ 3328.853649]  [<c102f11c>] irq_exit+0x29/0x5c
> [ 3328.866491]  [<c1004681>] do_IRQ+0x72/0x89
> [ 3328.878814]  [<c1003069>] common_interrupt+0x29/0x30
> [ 3328.893740]  [<c104007b>] ? __async_schedule+0x37/0x135
> [ 3328.909444]  [<c100883e>] ? mwait_idle+0x66/0x78
> [ 3328.923327]  [<c1001c77>] cpu_idle+0x44/0x65
> [ 3328.936171]  [<c1451e57>] rest_init+0x53/0x55
> [ 3328.949275]  [<c1723826>] start_kernel+0x2b1/0x2b6
> [ 3328.963679]  [<c172306a>] __init_begin+0x6a/0x6f
>
> On Fri, Aug 7, 2009 at 9:29 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>
>> On Thu, Aug 6, 2009 at 2:06 PM, Jordan Thoms<jords@shadowservices.biz>
>> wrote:
>> > Any progress on this? Did my message get to the list?
>>
>> Please try today's compat-wireless tarball, just updated with the
>> latest patches merged onto wireless-testing. If you still seen an oops
>> it would be appreciated if you can instead just compile an entire
>> kernel using the wireless-testing git tree directly:
>>
>> http://wireless.kernel.org/en/developers/Documentation/git-guide
>>
>> I'm hoping the change is not backport related, and just want to verify.
>>
>>  Luis
>
>
