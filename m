Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1150 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab2BHKDF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 05:03:05 -0500
Message-ID: <4F32484B.7020409@broadcom.com> (sfid-20120208_110311_327197_D96A3E09)
Date: Wed, 8 Feb 2012 11:02:51 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: REGRESSION: crash in wireless-testing smoketest
References: <4F313815.3020107@broadcom.com> (
 sfid-20120207_154219_853529_011888C8)
 <4F313C53.2040604@sipsolutions.net> <4F315E7E.7040203@broadcom.com>
 <1328646776.4223.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1328646776.4223.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2012 09:32 PM, Johannes Berg wrote:
> On Tue, 2012-02-07 at 18:25 +0100, Arend van Spriel wrote:
> 
>>>> The brcmsmac driver does not provide a sta_remove callback. I suspect
>>>> that is causing the issue here. Can you confirm?
>>>
>>> I'm on a business trip right now, but I can take a look. Did it really 
>>> *crash*? You said so in the subject but have no crash data.
>>>
>>> johannes
>>>
>>
>> The logs did not catch it before the crash. I dug a bit deeper and it
>> does not seem the missing sta_remove is a problem as drv_sta_remove
>> checks the function pointer being non-NULL before using it.
>>
>> Can you recommend a kernel hacking option so the log may give a better clue?
> 
> Not really, I suppose this is automated and you don't capture the
> (serial) console?
> 
> johannes
> 
> 

I rerun the test on a kernel with some more lock checking and got lucky.

Feb  8 08:40:17 lb-bun-10 kernel: [  514.512283] wlan0: authenticate
with 98:fc:11:8e:94:57
Feb  8 08:40:17 lb-bun-10 kernel: [  514.512515] wlan0: send auth to
98:fc:11:8e:94:57 (try 1/3)
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514184] BUG: unable to handle
kernel NULL pointer dereference at 00000004
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514233] IP: [<f8648f08>]
minstrel_tx_status+0x48/0xe0 [mac80211]
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514285] *pde = 00000000
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514301] Oops: 0000 [#1] SMP
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514324] Modules linked in: arc4
brcmsmac(O) brcmutil(O) crc_ccitt bcma(O) mac80211(O) cfg80211(O)
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device nouveau snd ttm
drm_kms_helper drm soundcore mxm_wmi psmouse intel_agp intel_gtt
dell_laptop video serio_raw snd_page_alloc dell_wmi intel_ips
sparse_keymap dcdbas agpgart firewire_ohci sdhci_pci sdhci ahci
firewire_core crc_itu_t mmc_core libahci e1000e
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514653]
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514662] Pid: 909, comm:
NetworkManager Tainted: G           O
3.3.0-rc2-wl-testing-lockdep-00002-g2381b2c #1 Dell Inc. Latitude
E6410/07XJP9
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514722] EIP: 0060:[<f8648f08>]
EFLAGS: 00010246 CPU: 0
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514780] EIP is at
minstrel_tx_status+0x48/0xe0 [mac80211]
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514822] EAX: 00000000 EBX:
00000000 ECX: 00000000 EDX: 00000000
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514864] ESI: f8658680 EDI:
f373a860 EBP: f500de78 ESP: f500de64
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514906]  DS: 007b ES: 007b FS:
00d8 GS: 00e0 SS: 0068
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514942] Process NetworkManager
(pid: 909, ti=f500c000 task=e7252380 task.ti=e812e000)
Feb  8 08:40:17 lb-bun-10 kernel: [  514.514995] Stack:
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515010]  00000200 00000000
e9138000 f8658680 00000001 f500dee0 f864a9f6 e9138000
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515084]  f373a840 00000246
e629c520 e629c700 e90cc480 00000000 00000000 e629c520
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515157]  00000000 f500dee0
00000246 00000002 00000001 00000000 ec38f940 f373a858
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515230] Call Trace:
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515263]  [<f864a9f6>]
minstrel_ht_tx_status+0x336/0x870 [mac80211]
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515321]  [<f8603ea8>]
ieee80211_tx_status+0x228/0xc90 [mac80211]
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515377]  [<f8603cda>] ?
ieee80211_tx_status+0x5a/0xc90 [mac80211]
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515428]  [<c13e6d90>] ?
skb_dequeue+0x50/0x70
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515474]  [<f8602958>]
ieee80211_tasklet_handler+0x148/0x160 [mac80211]
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515525]  [<c108877b>] ?
trace_hardirqs_on+0xb/0x10
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515564]  [<c1039b81>] ?
local_bh_enable_ip+0x71/0xe0
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515601]  [<c103949e>]
tasklet_action+0xbe/0x110
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515636]  [<c1038dff>]
__do_softirq+0xaf/0x200
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515669]  [<c1038d50>] ?
irq_enter+0x70/0x70
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515700]  <IRQ>
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515719]  [<c1038bc5>] ?
irq_exit+0xb5/0xd0
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515753]  [<c14deadb>] ?
do_IRQ+0x4b/0xc0
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515785]  [<c10886e4>] ?
trace_hardirqs_on_caller+0xf4/0x180
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515826]  [<c14dea15>] ?
common_interrupt+0x35/0x3c
Feb  8 08:40:17 lb-bun-10 kernel: [  514.515861] Code: 00 00 00 00 25 00
02 00 00 89 45 ec 0f b6 1f 84 db 78 3c 8b 55 08 0f be db 8d 0c 9b c1 e1
04 8b 42 34 01 c8 31 d2 90 8d 74 26 00 <3b> 58 04 74 4b 83 c2 01 89 de
29 d6 83 e9 50 83 e8 50 83 fe ff
Feb  8 08:40:17 lb-bun-10 kernel: [  514.516246] EIP: [<f8648f08>]
minstrel_tx_status+0x48/0xe0 [mac80211] SS:ESP 0068:f500de64
Feb  8 08:40:17 lb-bun-10 kernel: [  514.521104] CR2: 0000000000000004
Feb  8 08:40:17 lb-bun-10 kernel: [  514.703921] ------------[ cut here
]------------
Feb  8 08:40:17 lb-bun-10 kernel: [  514.706344] WARNING: at
kernel/timer.c:1122 run_timer_softirq+0x33c/0x350()
Feb  8 08:40:17 lb-bun-10 kernel: [  514.708723] Hardware name: Latitude
E6410
Feb  8 08:40:17 lb-bun-10 kernel: [  514.709330] timer:
delayed_work_timer_fn+0x0/0x30 preempt leak: 10000104 -> 10000102
Feb  8 08:40:17 lb-bun-10 kernel: [  514.710070] Modules linked in: arc4
brcmsmac(O) brcmutil(O) crc_ccitt bcma(O) mac80211(O) cfg80211(O)
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec
Feb  8 08:40:17 lb-bun-10 kernel: [  514.710882] huh, entered softirq 7
SCHED c1069240 preempt_count 100001ed, exited with 100001ee?
Feb  8 08:40:17 lb-bun-10 kernel: [  514.716244] huh, entered softirq 9
RCU c10b5010 preempt_count 100001ed, exited with 100001ec?
Feb  8 08:40:17 lb-bun-10 kernel: [  514.718826] huh, entered softirq 9
RCU c10b5010 preempt_count 100001ec, exited with 100001eb?

Apparently, minstrel_ht expects some tx_status field filled in by
brcmsmac/mac80211. Have not found the problem yet.

Gr. AvS

