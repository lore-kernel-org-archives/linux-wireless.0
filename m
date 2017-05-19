Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63813 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752424AbdESJCT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 05:02:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Adrian Chadd <adrian@freebsd.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "simon.wunderlich@openmesh.com" <simon.wunderlich@openmesh.com>
Subject: Re: [PATCH] [ath10k] go back to using dma_alloc_coherent() for
 firmware scratch memory.
Date: Fri, 19 May 2017 09:02:08 +0000
Message-ID: <8760gxw776.fsf@kamboji.qca.qualcomm.com> (sfid-20170519_110242_113178_37685E15)
References: <20170501214327.5621-1-adrian@freebsd.org>
        <2107639.cIofNFgAHq@bentobox>
In-Reply-To: <2107639.cIofNFgAHq@bentobox> (Sven Eckelmann's message of "Wed,
        17 May 2017 12:06:01 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> writes:

> On Montag, 1. Mai 2017 14:43:27 CEST Adrian Chadd wrote:
>> This reverts b057886524be060021e3cfad0ba8458c850330cd in 2015
>> which converted this allocation from dma_map_coherent() to
>> kzalloc() / dma_map_single().
>>=20
>> The current problem manifests when using later model NICs with larger
>> (>700KiB) scratch spaces in memory.  Although the kzalloc call
>> succeeds, the software IOMMU TLB code (via dma_map_single()) panics
>> because it can't find 700KiB of linear physmem bounce buffers for DMA.
>> Now, this is a bit of a silly failure mode for the dma map API,
>> but it's what we currently have to play with.
> [....]
>>=20
>> Signed-off-by: Adrian Chadd <adrian@FreeBSD.org>
>> ---
>>  drivers/net/wireless/ath/ath10k/wmi.c | 35 ++++++++++------------------=
-------
>>  1 file changed, 10 insertions(+), 25 deletions(-)
>
> Thanks for investigating this. This partial revert fixes following crash =
for
> me with QCA99X0 on amd64 with SWIOMMU:
>
>     [    9.167281] DMA: Out of SW-IOMMU space for 689816 bytes at device =
0000:02:00.0
>     [    9.174719] Kernel panic - not syncing: DMA: Random memory could b=
e DMA read

I recently got a Compex WLE1216V5-20 board and this patch also fixed a
similar crash for me on my HP x86_64 test laptop:

[  840.491019] do_IRQ: 3.82 No irq handler for vector
[  840.965049] ath10k_pci 0000:02:00.0: pci irq msi oper_irq_mode 2 irq_mod=
e 0 reset_mode 0
[  841.094985] ath10k_pci 0000:02:00.0: qca9984/qca9994 hw1.0 target 0x0100=
0000 chip_id 0x00000000 sub 168c:cafe
[  841.095096] ath10k_pci 0000:02:00.0: kconfig debug 1 debugfs 1 tracing 1=
 dfs 1 testmode 1
[  841.095603] ath10k_pci 0000:02:00.0: firmware ver 10.4-3.4-00082 api 5 f=
eatures no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast crc32 f301=
de65
[  842.518071] ath10k_pci 0000:02:00.0: board_file api 2 bmi_id 0:1 crc32 7=
51efba1
[  845.220186] ath10k_pci 0000:02:00.0: swiotlb buffer is full (sz: 1172264=
 bytes)
[  845.220478] ath10k_pci 0000:02:00.0: DMA: Out of SW-IOMMU space for 1172=
264 bytes
[  845.220506] Kernel panic - not syncing: DMA: Random memory could be DMA =
accessed#012[  845.220506]=20
[  845.220532] CPU: 0 PID: 116 Comm: kworker/u16:4 Tainted: G            E =
  4.11.0-wt-ath+ #336
[  845.220554] Hardware name: Hewlett-Packard HP ProBook 6540b/1722, BIOS 6=
8CDD Ver. F.04 01/27/2010
[  845.220600] Workqueue: ath10k_aux_wq ath10k_wmi_event_service_ready_work=
 [ath10k_core]
[  845.220626] Call Trace:
[  845.220656]  dump_stack+0x85/0xc2
[  845.220684]  panic+0xda/0x228
[  845.220719]  swiotlb_full+0x88/0xa0
[  845.220746]  swiotlb_map_page+0x214/0x280
[  845.220785]  ath10k_wmi_event_service_ready_work+0x3f2/0x7d0 [ath10k_cor=
e]
[  845.220812]  ? swiotlb_map_sg_attrs+0x140/0x140
[  845.220858]  process_one_work+0x23b/0x7d0
[  845.221093]  worker_thread+0x4e/0x4a0
[  845.221126]  kthread+0x117/0x150
[  845.221149]  ? process_one_work+0x7d0/0x7d0
[  845.221175]  ? kthread_create_on_node+0x40/0x40
[  845.221205]  ret_from_fork+0x31/0x40
[  845.221314] Kernel Offset: 0xb000000 from 0xffffffff81000000 (relocation=
 range: 0xffffffff80000000-0xffffffffbfffffff)


--=20
Kalle Valo=
