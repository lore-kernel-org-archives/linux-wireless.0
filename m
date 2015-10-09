Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48174 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbbJIPeQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 11:34:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] ath10k: add copy engine fast path support
References: <1443164016-3612-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Fri, 9 Oct 2015 18:34:04 +0300
In-Reply-To: <1443164016-3612-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Fri, 25 Sep 2015 12:23:29 +0530")
Message-ID: <87612gqcnn.fsf@kamboji.qca.qualcomm.com> (sfid-20151009_173420_742944_5660F4C2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Below patchset adds fast path support for uplink traffic by bypassing
> HTC layer processing. This is enabled by making use of unused copy
> engine 5 to receive HTT messages directly from HIF layer. From initial
> validation in VHT80/5G mode TCP UL is improved to 900Mbps from ~840Mbps
> in conducted test.
>
> -Rajkumar
>
> Rajkumar Manoharan (7):
>   ath10k: export htc tx rx handlers
>   ath10k: register per copy engine send completion callbacks
>   ath10k: register per copy engine receive callbacks
>   ath10k: export htt tx rx handlers
>   ath10k: Configure copy engine 5 for HTT messages
>   ath10k: remove unused dl_is_polled
>   ath10k: remove htc polling for tx completion

With these patches I'm seeing a DMA warning every time with qca988x
during firmware boot (tested three out of three times, rebooted after
every test):

[   60.458260] ------------[ cut here ]------------
[   60.458374] WARNING: CPU: 1 PID: 0 at lib/dma-debug.c:1090 check_unmap+0x815/0x940()
[   60.458457] ath10k_pci 0000:02:00.0: DMA-API: device driver tries to free an invalid DMA memory address
[   60.458557] Modules linked in: ath10k_pci ath10k_core ath mac80211 cfg80211 [last unloaded: cfg80211]
[   60.458941] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.3.0-rc3-wl-ath+ #1082
[   60.458981] Hardware name: Hewlett-Packard HP ProBook 6540b/1722, BIOS 68CDD Ver. F.04 01/27/2010
[   60.459021]  00000000 00000000 f4ef3de4 c133dd94 00000000 f4ef3e14 c10562de c1b3e12c
[   60.459378]  f4ef3e40 00000000 c1b3d3b9 00000442 c13693c5 c13693c5 f435f840 f4ef3eb4
[   60.461026]  00000000 f4ef3e2c c10563c3 00000009 f4ef3e24 c1b3e12c f4ef3e40 f4ef3ea4
[   60.461528] Call Trace:
[   60.461592]  [<c133dd94>] dump_stack+0x48/0x64
[   60.461627] ath10k_pci 0000:02:00.0: qca988x hw2.0 (0x4100016c, 0x043202ff) fw 10.2.4.70.9-2 api 3 htt-ver 2.1 wmi-op 5 htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1 features no-p2p,raw-mode
[   60.461643] ath10k_pci 0000:02:00.0: debug 1 debugfs 1 tracing 1 dfs 1 testmode 1
[   60.461718]  [<c10562de>] warn_slowpath_common+0x8e/0xd0
[   60.461750]  [<c13693c5>] ? check_unmap+0x815/0x940
[   60.461781]  [<c13693c5>] ? check_unmap+0x815/0x940
[   60.461814]  [<c10563c3>] warn_slowpath_fmt+0x33/0x40
[   60.461844]  [<c13693c5>] check_unmap+0x815/0x940
[   60.461881]  [<c18c0c06>] ? _raw_spin_unlock_irqrestore+0x36/0x60
[   60.461915]  [<c10aac14>] ? trace_hardirqs_on_caller+0xa4/0x1c0
[   60.461954]  [<fa1cf15d>] ? ath10k_dbg+0x6d/0x140 [ath10k_core]
[   60.461989]  [<c1088e35>] ? local_clock+0x25/0x30
[   60.462020]  [<c136974c>] debug_dma_unmap_page+0x8c/0xa0
[   60.462053]  [<fa24dc2f>] ath10k_pci_htt_tx_cb+0x8f/0xb0 [ath10k_pci]
[   60.462085]  [<fa24dc70>] ath10k_pci_htt_rx_cb+0x20/0x30 [ath10k_pci]
[   60.462117]  [<fa2517fc>] ath10k_ce_per_engine_service+0x5c/0xa0 [ath10k_pci]
[   60.462162]  [<fa2518b7>] ath10k_ce_per_engine_service_any+0x77/0x90 [ath10k_pci]
[   60.462194]  [<fa24f85b>] ath10k_pci_tasklet+0x1b/0x50 [ath10k_pci]
[   60.462226]  [<c105bc4e>] tasklet_action+0x9e/0xb0
[   60.462257]  [<c105b17b>] __do_softirq+0xbb/0x3c0
[   60.462288]  [<c105b0c0>] ? trace_event_raw_event_irq_handler_entry+0xa0/0xa0
[   60.462321]  [<c10059b9>] do_softirq_own_stack+0x29/0x40
[   60.462353]  <IRQ>  [<c105b716>] irq_exit+0x86/0xb0
[   60.462427]  [<c18c2310>] do_IRQ+0x60/0x120
[   60.462493]  [<c10a4deb>] ? trace_hardirqs_off+0xb/0x10
[   60.462575]  [<c18c1931>] common_interrupt+0x31/0x38
[   60.462617]  [<c1694fa9>] ? cpuidle_enter_state+0xc9/0x350
[   60.462648]  [<c1696879>] ? menu_select+0x239/0x4b0
[   60.462682]  [<c1695264>] cpuidle_enter+0x14/0x20
[   60.462714]  [<c109becc>] call_cpuidle+0x3c/0x70
[   60.462757]  [<c109c0a9>] cpu_startup_entry+0x1a9/0x390
[   60.462789]  [<c1038b75>] start_secondary+0x105/0x150
[   60.462820] ---[ end trace 4bfd4799ecf8f81b ]---

-- 
Kalle Valo
