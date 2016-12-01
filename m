Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61616 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755429AbcLALOn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 06:14:43 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix Tx DMA alloc failure during continuous wifi down/up
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1480499414-19543-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1480499414-19543-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <f867487151bf4e82a210dd1755cf4e43@euamsexm01a.eu.qualcomm.com> (sfid-20161201_121447_904390_38179CB3)
Date: Thu, 1 Dec 2016 12:14:23 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> With maximum number of vap's configured in a two radio supported
> systems of ~256 Mb RAM, doing a continuous wifi down/up and
> intermittent traffic streaming from the connected stations results
> in failure to allocate contiguous memory for tx buffers. This results
> in the disappearance of all VAP's and a manual reboot is needed as
> this is not a crash (or) OOM(for OOM killer to be invoked). To address
> this allocate contiguous memory for tx buffers one time and re-use them
> until the modules are unloaded but this results in a slight increase in
> memory footprint of ath10k when the wifi is down, but the modules are
> still loaded. Also as of now we use a separate bool 'tx_mem_allocated'
> to keep track of the one time memory allocation, as we cannot come up
> with something like 'ath10k_tx_{register,unregister}' before
> 'ath10k_probe_fw' is called as 'ath10k_htt_tx_alloc_cont_frag_desc'
> memory allocation is dependent on the hw_param 'continuous_frag_desc'
> 
> a) memory footprint of ath10k without the change
> 
> lsmod | grep ath10k
> ath10k_core           414498  1 ath10k_pci
> ath10k_pci             38236  0
> 
> b) memory footprint of ath10k with the change
> 
> ath10k_core           414980  1 ath10k_pci
> ath10k_pci             38236  0
> 
> Memory Failure Call trace:
> 
> hostapd: page allocation failure: order:6, mode:0xd0
>  [<c021f150>] (__dma_alloc_buffer.isra.23) from
> [<c021f23c>] (__alloc_remap_buffer.isra.26+0x14/0xb8)
> [<c021f23c>] (__alloc_remap_buffer.isra.26) from
> [<c021f664>] (__dma_alloc+0x224/0x2b8)
> [<c021f664>] (__dma_alloc) from [<c021f810>]
> (arm_dma_alloc+0x84/0x90)
> [<c021f810>] (arm_dma_alloc) from [<bf954764>]
> (ath10k_htt_tx_alloc+0xe0/0x2e4 [ath10k_core])
> [<bf954764>] (ath10k_htt_tx_alloc [ath10k_core]) from
> [<bf94e6ac>] (ath10k_core_start+0x538/0xcf8 [ath10k_core])
> [<bf94e6ac>] (ath10k_core_start [ath10k_core]) from
> [<bf947eec>] (ath10k_start+0xbc/0x56c [ath10k_core])
> [<bf947eec>] (ath10k_start [ath10k_core]) from
> [<bf8a7a04>] (drv_start+0x40/0x5c [mac80211])
> [<bf8a7a04>] (drv_start [mac80211]) from [<bf8b7cf8>]
> (ieee80211_do_open+0x170/0x82c [mac80211])
> [<bf8b7cf8>] (ieee80211_do_open [mac80211]) from
> [<c056afc8>] (__dev_open+0xa0/0xf4)
> [21053.491752] Normal: 641*4kB (UEMR) 505*8kB (UEMR) 330*16kB (UEMR)
> 126*32kB (UEMR) 762*64kB (UEMR) 237*128kB (UEMR) 1*256kB (M) 0*512kB
> 0*1024kB 0*2048kB 0*4096kB = 95276kB
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

9ec34a86195a ath10k: fix Tx DMA alloc failure during continuous wifi down/up

-- 
https://patchwork.kernel.org/patch/9453947/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
