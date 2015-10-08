Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48315 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbbJHRol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 13:44:41 -0400
Message-ID: <5616AB7D.9070803@codeaurora.org> (sfid-20151008_194446_035003_8811CDE0)
Date: Thu, 08 Oct 2015 10:44:29 -0700
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>,
	Peter Oh <poh@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: use pre-allocated DMA buffer in Tx
References: <1443117270-16790-1-git-send-email-poh@qca.qualcomm.com> <87fv1lvauk.fsf@kamboji.qca.qualcomm.com> <5616A511.5060705@codeaurora.org>
In-Reply-To: <5616A511.5060705@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I did quick glance on the warning.
The dma unmap warning is caused by dma_unmap_single called per every 
received packet in ath10k_pci_htt_tx_cb() <- ath10k_pci_htt_rx_cb().
The physical address is assigned by rx refill function for rx ring.
So it looks like copy engine patchset has a bug.
FYI, pre-allocated dma is coherent dma used in Tx only and only freed 
when ath10k driver stops.

On 10/08/2015 10:17 AM, Peter Oh wrote:
> Does it happen after you applied copy engine patchset or even without 
> the patchset?
> I saw ath10k_pci_htt_tx_cb in backtrace which is not merged to master 
> branch yet.
> If it only happens after the patchset, I'll apply them and look into 
> it if any possibilities are there.
>
> On 10/08/2015 04:49 AM, Kalle Valo wrote:
>> Peter Oh <poh@qca.qualcomm.com> writes:
>>
>>> ath10k driver is using dma_pool_alloc per packet and dma_pool_free
>>> in coresponding at Tx completion.
>>> Use of pre-allocated DMA buffer in Tx will improve saving CPU resource
>>> by 5% while it consumes about 56KB memory more as trade off.
>>>
>>> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
>> I see randomly the warning below with ath.git master branch commit
>> 2e88ba7ebe8d1. Can this patch cause that?
>>
>> [   53.637883] ------------[ cut here ]------------
>> [   53.637999] WARNING: CPU: 2 PID: 0 at lib/dma-debug.c:1090
>> check_unmap+0x815/0x940()
>> [   53.638070] ath10k_pci 0000:02:00.0: qca99x0 hw2.0 (0x01000000,
>> 0x003801ff bmi 1:1) fw 10.4.1.00007 fwapi 5 bdapi 2 htt-ver 2.2 wmi-op 6
>> htt-op 4 cal otp max-sta 512 raw 0 hwcrypto 1 features no-p2p
>> [   53.638077] ath10k_pci 0000:02:00.0: debug 1 debugfs 1 tracing 1 dfs
> 1
>> testmode 1
>> [   53.638205] ath10k_pci 0000:02:00.0: DMA-API: device driver tries to
>> free an invalid DMA memory address
>> [   53.638270] Modules linked in: ath10k_pci ath10k_core ath mac80211
>> cfg80211 [last unloaded: cfg80211]
>> [   53.638800] CPU: 2 PID: 0 Comm: swapper/2 Not tainted
> 4.3.0-rc3-wl-ath+
>> #1082
>> [   53.638880] Hardware name: Hewlett-Packard HP ProBook 6540b/1722,
> BIOS
>> 68CDD Ver. F.04 01/27/2010
>> [   53.638951]  00000000 00000000 f4445de4 c133dd94 00000000 f4445e14
>> c10562de c1b3e12c
>> [   53.639551]  f4445e40 00000000 c1b3d3b9 00000442 c13693c5 c13693c5
>> f422e840 f4445eb4
>> [   53.640169]  00000000 f4445e2c c10563c3 00000009 f4445e24 c1b3e12c
>> f4445e40 f4445ea4
>> [   53.640802] Call Trace:
>> [   53.640874]  [<c133dd94>] dump_stack+0x48/0x64
>> [   53.640953]  [<c10562de>] warn_slowpath_common+0x8e/0xd0
>> [   53.641031]  [<c13693c5>] ? check_unmap+0x815/0x940
>> [   53.641115]  [<c13693c5>] ? check_unmap+0x815/0x940
>> [   53.641201]  [<c10563c3>] warn_slowpath_fmt+0x33/0x40
>> [   53.641277]  [<c13693c5>] check_unmap+0x815/0x940
>> [   53.641356]  [<c1088e35>] ? local_clock+0x25/0x30
>> [   53.641432]  [<c136974c>] debug_dma_unmap_page+0x8c/0xa0
>> [   53.641511]  [<fa258aaf>] ath10k_pci_htt_tx_cb+0x8f/0xb0 [ath10k_pci]
>> [   53.641589]  [<fa258af0>] ath10k_pci_htt_rx_cb+0x20/0x30 [ath10k_pci]
>> [   53.641668]  [<fa25ca2c>] ath10k_ce_per_engine_service+0x5c/0xa0
>> [ath10k_pci]
>> [   53.641746]  [<fa25cae7>] ath10k_ce_per_engine_service_any+0x77/0x90
>> [ath10k_pci]
>> [   53.641825]  [<fa25aa4b>] ath10k_pci_tasklet+0x1b/0x50 [ath10k_pci]
>> [   53.642064]  [<c105bc4e>] tasklet_action+0x9e/0xb0
>> [   53.642142]  [<c105b17b>] __do_softirq+0xbb/0x3c0
>> [   53.642222]  [<c105b0c0>] ?
>> trace_event_raw_event_irq_handler_entry+0xa0/0xa0
>> [   53.642300]  [<c10059b9>] do_softirq_own_stack+0x29/0x40
>> [   53.642375]  <IRQ>  [<c105b716>] irq_exit+0x86/0xb0
>> [   53.642526]  [<c18c2310>] do_IRQ+0x60/0x120
>> [   53.642604]  [<c10a4deb>] ? trace_hardirqs_off+0xb/0x10
>> [   53.642680]  [<c18c1931>] common_interrupt+0x31/0x38
>> [   53.642760]  [<c1694fa9>] ? cpuidle_enter_state+0xc9/0x350
>> [   53.642835]  [<c1696879>] ? menu_select+0x239/0x4b0
>> [   53.642925]  [<c1695264>] cpuidle_enter+0x14/0x20
>> [   53.643063]  [<c109becc>] call_cpuidle+0x3c/0x70
>> [   53.643140]  [<c109c0a9>] cpu_startup_entry+0x1a9/0x390
>> [   53.643218]  [<c1038b75>] start_secondary+0x105/0x150
>> [   53.643294] ---[ end trace a5dc1d40148089eb ]---
>>
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k

