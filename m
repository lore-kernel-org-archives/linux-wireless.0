Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:56106
	"EHLO HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035Ab2FMMaL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 08:30:11 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] cfg80211/nl80211: Fix for wireless-testing kernel crash
Date: Wed, 13 Jun 2012 12:30:07 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A6C39@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120613_143016_947938_DB97FC76)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0A6BFE@mbx022-e1-nj-10.exch022.domain.local>,<1339586895.4519.33.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339586895.4519.33.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Wednesday, June 13, 2012 4:58 PM
To: Mahesh Palivela
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211/nl80211: Fix for wireless-testing kernel crash

On Wed, 2012-06-13 at 11:15 +0000, Mahesh Palivela wrote:
> I saw wireless-testing kernel crash at nl80211 survey_dump function. we can see this crash only when run wpa_supplicant of hostap dev branch. This patch is fix for it.

Please break long lines, include information about the crash and why
this fixes it, and don't reference wireless-testing ... it's not
specific in that particular tree

Thanks.
johannes

crash info:

Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.647231] BUG: unable to handle kernel NULL pointer dereference at 000000d4
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.655675] IP: [<f8fa5883>] nl80211_dump_survey+0x93/0x390 [cfg80211]
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.663504] *pdpt = 000000000ace0001 *pde = 0000000000000000 
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.670521] Oops: 0000 [#1] SMP 
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.675013] Modules linked in: arc4 pewlmac(O) mac80211 cfg80211 bnep rfcomm bluetooth binfmt_misc snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep i915 snd_pcm drm_kms_helper hid_generic snd_seq_midi snd_rawmidi usbhid drm hid snd_seq_midi_event snd_seq snd_timer snd_seq_device snd coretemp i2c_algo_bit kvm_intel mei ppdev lpc_ich video soundcore snd_page_alloc shpchp kvm microcode parport_pc lp parport e1000e ahci libahci
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.718508] 
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.721213] Pid: 3466, comm: wpa_supplicant Tainted: G           O 3.5.0-rc1-wl+ #5                  /DH61WW
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.732251] EIP: 0060:[<f8fa5883>] EFLAGS: 00010202 CPU: 2
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.738947] EIP is at nl80211_dump_survey+0x93/0x390 [cfg80211]
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.746054] EAX: 000000d0 EBX: f9f7afc0 ECX: cae8bbb8 EDX: 00000000
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.748205] Interrupt is not ours
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.757944] ESI: 00000001 EDI: caf6f9c0 EBP: cae8bc08 ESP: cae8bb9c
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.765348]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.771855] CR0: 8005003b CR2: 000000d4 CR3: 0ad36000 CR4: 000407f0
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.779239] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.786603] DR6: ffff0ff0 DR7: 00000400
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.791515] Process wpa_supplicant (pid: 3466, ti=cae8a000 task=cadda5e0 task.ti=cae8a000)
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.800848] Stack:
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.803912]  cae8bbb8 cae8bb9c cb9de084 eeda1000 00026d00 caca2ec0 00000000 000000d0
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.812692]  00001000 00026d01 caf6f9c0 000000d0 caf6f9c0 cae8bbf0 c1495d30 00000000
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.821451]  00001000 000000a4 f0127c00 00000f40 00000000 cae8bc08 cb9de000 f4ac3000
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.830206] Call Trace:
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.833685]  [<c1495d30>] ? __alloc_skb+0x60/0x200
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.839519]  [<c14c23aa>] netlink_dump+0x5a/0x1f0
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.845227]  [<c14c3256>] ? netlink_lookup+0x26/0xc0
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.851173]  [<c14c33a8>] netlink_dump_start+0xb8/0x150
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.857356]  [<f8fa57f0>] ? cfg80211_report_obss_beacon+0x1a0/0x1a0 [cfg80211]
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.865527]  [<c14c50fd>] genl_rcv_msg+0xed/0x260
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.871157]  [<c1157c10>] ? __pollwait+0xd0/0xd0
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.876695]  [<c1494bf5>] ? skb_free_head+0x45/0x50
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.882486]  [<f8fa57f0>] ? cfg80211_report_obss_beacon+0x1a0/0x1a0 [cfg80211]
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.890618]  [<c14c5010>] ? genl_rcv+0x30/0x30
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.895980]  [<c14c4a8e>] netlink_rcv_skb+0x8e/0xb0
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.901770]  [<c14c4ffc>] genl_rcv+0x1c/0x30
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.906958]  [<c14c44c4>] netlink_unicast+0x174/0x1f0
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.912923]  [<c14c4726>] netlink_sendmsg+0x1e6/0x310
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.918895]  [<c148d60f>] sock_sendmsg+0xff/0x120
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.924523]  [<c1071512>] ? check_preempt_curr+0x72/0x90
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.930772]  [<c1071558>] ? ttwu_do_wakeup+0x28/0x130
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.936761]  [<c12c77b2>] ? _copy_from_user+0x42/0x60
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.942753]  [<c1498e44>] ? verify_iovec+0x44/0xb0
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.948487]  [<c148e832>] __sys_sendmsg+0x262/0x270
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.954305]  [<c106bdc7>] ? __wake_up_common+0x47/0x70
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.960390]  [<c106d015>] ? __wake_up+0x45/0x60
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.965867]  [<c135cc69>] ? tty_wakeup+0x39/0x70
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.971418]  [<c1077f6d>] ? update_curr+0x17d/0x300
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.977219]  [<c1037d48>] ? default_spin_lock_flags+0x8/0x10
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.983800]  [<c158ca5d>] ? _raw_spin_lock_irqsave+0x2d/0x40
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.990379]  [<c101088d>] ? __switch_to+0xcd/0x2a0
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2016.996061]  [<c1070271>] ? finish_task_switch+0x41/0xc0
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2017.002243]  [<c148f9fb>] sys_sendmsg+0x3b/0x60
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2017.007617]  [<c14900a3>] sys_socketcall+0x283/0x2e0
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2017.013406]  [<c159375f>] sysenter_do_call+0x12/0x28
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2017.019204] Code: ac 8d 55 b0 8b 4d ac 89 14 24 8b 55 f0 ff d3 83 f8 fe 0f 84 85 01 00 00 85 c0 0f 85 f0 02 00 00 8b 45 b0 85 c0 0f 84 72 01 00 00 <0f> b7 50 04 8b 45 ec 05 00 01 00 00 e8 9c 28 ff ff 85 c0 74 a8 
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2017.039726] EIP: [<f8fa5883>] nl80211_dump_survey+0x93/0x390 [cfg80211] SS:ESP 0068:cae8bb9c
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2017.049008] CR2: 00000000000000d4
Jun 11 12:06:34 LAB-WLAN-STA-01 kernel: [ 2017.103589] ---[ end trace def0e7bb864be539 ]---

Reason for crash:

net/wireless/nl80211.c -> nl80211_dump_survey() survey_info structure is not being initialized. Without this dev->ops->dump_survey() return value is zero. But 'survey' argument passed to this function is untouched and we are trying to access the members of this structure and hitting crash. Hope this helps.

Thanks,
Mahesh