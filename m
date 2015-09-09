Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23205 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbbIIH5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 03:57:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bob Copeland <me@bobcopeland.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
	<1440673024-13696-4-git-send-email-me@bobcopeland.com>
Date: Wed, 9 Sep 2015 10:57:30 +0300
In-Reply-To: <1440673024-13696-4-git-send-email-me@bobcopeland.com> (Bob
	Copeland's message of "Thu, 27 Aug 2015 06:57:04 -0400")
Message-ID: <87oahc9g9h.fsf@kamboji.qca.qualcomm.com> (sfid-20150909_095747_101599_2672ED41)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> Add support for mesh to ath10k.  We simply use an AP virtual interface
> in the firmware in order to enable beaconing without TSF adoption, and
> use the raw (802.11) transmit mode.
>
> Due to firmware limitations, the firmware must operate in raw
> (non-native 802.11) mode.  As this is configured at firmware init time,
> a new "rawmode" modparam is added, and mesh interfaces are available
> only if rawmode=true.  The firmware must advertise support for rawmode
> (tested successfully with firmware 10.2.4.70-2).
>
> When loaded with rawmode=1, ath10k can operate an open mesh STA via
> something like the following:
>
>     ip link set wlan0 down
>     iw dev wlan0 set type mp
>     ip link set wlan0 up
>     iw dev wlan0 set freq 5745 80 5775
>     iw dev wlan0 mesh join mesh-vht
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

I did a quick smoke test and saw the splat below. It's this warning from
cfg80211:

			/*
			 * Don't advertise an unsupported type
			 * in a combination.
			 */
			if (WARN_ON((wiphy->interface_modes & types) != types))
				return -EINVAL;

I didn't immeaditely figure out what's causing this, the interface types
looked correct to me. Unfortunately I don't have time to investigate
more at the moment, but will look later.

[  152.113232] ath10k_pci 0000:02:00.0: qca988x hw2.0 (0x4100016c, 0x043202ff) fw 10.2.4.70.6 api 3 htt-ver 2.1 wmi-op 5 htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1 features no-p2p
[  152.113448] ath10k_pci 0000:02:00.0: debug 1 debugfs 1 tracing 1 dfs 1 testmode 1
[  152.226213] ath: EEPROM regdomain: 0x0
[  152.226296] ath: EEPROM indicates default country code should be used
[  152.226365] ath: doing EEPROM country->regdmn map search
[  152.226434] ath: country maps to regdmn code: 0x3a
[  152.226504] ath: Country alpha2 being used: US
[  152.226573] ath: Regpair used: 0x3a
[  152.226677] ------------[ cut here ]------------
[  152.226785] WARNING: CPU: 0 PID: 1141 at net/wireless/core.c:530 wiphy_register+0x680/0x780 [cfg80211]()
[  152.226864] Modules linked in: ath10k_pci ath10k_core ath mac80211 cfg80211 [last unloaded: cfg80211]
[  152.227882] CPU: 0 PID: 1141 Comm: kworker/u16:5 Not tainted 4.2.0-wl-ath+ #1044
[  152.227972] Hardware name: Hewlett-Packard HP ProBook 6540b/1722, BIOS 68CDD Ver. F.04 01/27/2010
[  152.228068] Workqueue: ath10k_wq ath10k_core_register_work [ath10k_core]
[  152.228372]  00000000 00000000 f1c19d08 c18c0e4e 00000000 f1c19d38 c10578ce c1b0f660
[  152.229343]  00000000 00000475 fb37017a 00000212 fb317130 fb317130 00000088 efe48320
[  152.230500]  00000008 f1c19d48 c1057932 00000009 00000000 f1c19dac fb317130 f1c10008
[  152.231541] Call Trace:
[  152.231634]  [<c18c0e4e>] dump_stack+0x48/0x60
[  152.231824]  [<c10578ce>] warn_slowpath_common+0x8e/0xd0
[  152.232014]  [<fb317130>] ? wiphy_register+0x680/0x780 [cfg80211]
[  152.232232]  [<fb317130>] ? wiphy_register+0x680/0x780 [cfg80211]
[  152.232448]  [<c1057932>] warn_slowpath_null+0x22/0x30
[  152.232561]  [<fb317130>] wiphy_register+0x680/0x780 [cfg80211]
[  152.232657]  [<c11a3926>] ? __kmalloc+0x216/0x370
[  152.232749]  [<c10acd69>] ? mark_held_locks+0x59/0x80
[  152.232898]  [<fbfcb3d0>] ? ieee80211_register_hw+0x1f0/0x970 [mac80211]
[  152.233468]  [<fbfcb3d0>] ? ieee80211_register_hw+0x1f0/0x970 [mac80211]
[  152.233576]  [<fc22c7d0>] ? ath10k_hw_scan+0x210/0x210 [ath10k_core]
[  152.233679]  [<fc22c5c0>] ? ath10k_start_scan+0x140/0x140 [ath10k_core]
[  152.233794]  [<fbfcb541>] ieee80211_register_hw+0x361/0x970 [mac80211]
[  152.233889]  [<c1000f0c>] ? trace_hardirqs_on_thunk+0xc/0x10
[  152.233983]  [<c18caef5>] ? restore_all+0xf/0xf
[  152.234084]  [<fc22d973>] ath10k_mac_register+0x7c3/0x920 [ath10k_core]
[  152.234196]  [<c10a66bc>] ? __lock_is_held+0x3c/0x50
[  152.236050]  [<fc234e61>] ath10k_core_register_work+0x5d1/0x6d0 [ath10k_core]
[  152.236136]  [<c1070f00>] process_one_work+0x1d0/0x6c0
[  152.236204]  [<c1070e52>] ? process_one_work+0x122/0x6c0
[  152.236270]  [<c107150a>] worker_thread+0xea/0x3d0
[  152.236335]  [<c10acf5b>] ? trace_hardirqs_on+0xb/0x10
[  152.236399]  [<c1071420>] ? process_scheduled_works+0x30/0x30
[  152.236466]  [<c10773f5>] kthread+0xa5/0xc0
[  152.236531]  [<c18ca917>] ? _raw_spin_unlock_irq+0x27/0x40
[  152.236596]  [<c18cad01>] ret_from_kernel_thread+0x21/0x30
[  152.236664]  [<c1077350>] ? __init_kthread_worker+0x60/0x60
[  152.236731] ---[ end trace ce831788c6a79cf8 ]---
[  152.236813] ath10k_pci 0000:02:00.0: failed to register ieee80211: -22
[  152.236889] ath10k_pci 0000:02:00.0: could not register to mac80211 (-22)


-- 
Kalle Valo
