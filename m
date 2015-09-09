Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21391 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbbIIJfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 05:35:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix DMA alloc failure for target requested memory chunks
References: <1440762694-11578-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Wed, 9 Sep 2015 12:35:00 +0300
In-Reply-To: <1440762694-11578-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Fri, 28 Aug 2015 17:21:34
	+0530")
Message-ID: <8737yo9bqz.fsf@kamboji.qca.qualcomm.com> (sfid-20150909_113520_206783_9922B45B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> During long hours of stress testing like AP interface up/down along
> with continuous ping flood from a station doing connect/disconnect,
> it is observed that the system is not able to allocate DMA consistent
> memory of size > 512KB chunks as requested by firmware in WMI_SERVICE_EVENTID.
> With the system memory getting fragmented during the run based on the
> size of the memory requested, the failure to return physically continguous
> memory of high order can happen. Once the system gets to this situation,
> bringing up the wifi interface will fail and a system reboot may be needed
> to make it work again. This problem is obseved with QCA99X0.
>
> To fix this issue, allocate the DMA memory requested by firmware during
> device probe time and keep it during the life time of the device. WMI service
> ready event handler is changed to allocate the memory chunks if it is
> not already allocated or if the memory allocated for the previous ready
> event is not same as the current requested ones. After this patch the
> memory usage when wifi is inactive will be inceased by few 100KB to
> 3MB based on the target type.
>
> Failure happens with the following stack trace
>
> [29557.488773] kworker/u4:1: page allocation failure: order:8, mode:0xd0
> [29557.494297] CPU: 0 PID: 8402 Comm: kworker/u4:1 Not tainted 3.14.43 #7
> [29557.500793] Workqueue: ath10k_aux_wq ath10k_wmi_event_service_ready_work [ath10k_core]
> [29557.508602] [<c021e9b0>] (unwind_backtrace) from [<c021ba90>] (show_stack+0x10/0x14)
> [29557.516580] [<c021ba90>] (show_stack) from [<c03bdddc>] (dump_stack+0x88/0xcc)
> [29557.523612] [<c03bdddc>] (dump_stack) from [<c0290e34>] (warn_alloc_failed+0xdc/0x108)
> [29557.531515] [<c0290e34>] (warn_alloc_failed) from [<c0292d88>] (__alloc_pages_nodemask+0x4f0/0x654)
> [29557.540485] [<c0292d88>] (__alloc_pages_nodemask) from [<c0222b48>] (__dma_alloc_buffer.isra.20+0x2c/0x104)
> [29557.550260] [<c0222b48>] (__dma_alloc_buffer.isra.20) from [<c0222c34>] (__alloc_remap_buffer.isra.23+0x14/0xb8)
> [29557.560413] [<c0222c34>] (__alloc_remap_buffer.isra.23) from [<c022305c>] (__dma_alloc+0x224/0x2b8)
> [29557.569490] [<c022305c>] (__dma_alloc) from [<c0223208>] (arm_dma_alloc+0x84/0x90)
> [29557.577010] [<c0223208>] (arm_dma_alloc) from [<bf5159d0>] (ath10k_wmi_event_service_ready_work+0x2f8/0x420 [ath10k_core])
> [29557.588055] [<bf5159d0>] (ath10k_wmi_event_service_ready_work [ath10k_core]) from [<c024260c>] (process_one_work+0x20c/0x328)
> [29557.599305] [<c024260c>] (process_one_work) from [<c02432d0>] (worker_thread+0x228/0x360)
> [29557.607470] [<c02432d0>] (worker_thread) from [<c0247f88>] (kthread+0xd8/0xec)
> [29557.614750] [<c0247f88>] (kthread) from [<c0208d18>] (ret_from_fork+0x14/0x3c)
> [29557.712751] Normal: 696*4kB (UEMR) 512*8kB (UEMR) 367*16kB (UEMR) 404*32kB (UEMR) 455*64kB (UEMR) 424*128kB (UEMR) 379*256kB (UMR) 327*512kB (UMR) 1*1024kB (R) 0*2048kB 0*4096kB = 374544kB
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
