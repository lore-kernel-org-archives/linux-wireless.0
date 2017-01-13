Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51723 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbdAMNe6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 08:34:58 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix wifi connectivity and warning in Rx with channel 169
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1484062318-13476-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1484062318-13476-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <49a03c9d4d4e46ddbd28d32342a089be@euamsexm01a.eu.qualcomm.com> (sfid-20170113_143507_221322_C81E362F)
Date: Fri, 13 Jan 2017 14:34:45 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> In countries where basic operation of channel 169 is allowed,
> this fixes the below WARN_ON_ONCE in Rx and fixes the station
> connectivity failure in channel 169 as the packet is dropped
> in the driver as the current check limits to channel 165. As of
> now all the packets beyond channel 165 is dropped, fix this
> by extending the range to channel 169.
> 
> Call trace:
> 
> drivers/net/wireless/ath/ath10k/wmi.c:1505
> ath10k_wmi_event_mgmt_rx+0x278/0x440 [ath10k_core]()
> Call Trace:
>  [<c158f812>] ? printk+0x2d/0x2f
>  [<c105a182>] warn_slowpath_common+0x72/0xa0
>  [<f8b67b58>] ? ath10k_wmi_event_mgmt_rx+0x278/0x440
> 
>  [<f8b67b58>] ? ath10k_wmi_event_mgmt_rx+0x278/0x440
> 
>  [<c105a1d2>] warn_slowpath_null+0x22/0x30
>  [<f8b67b58>] ath10k_wmi_event_mgmt_rx+0x278/0x440
> 
>  [<f8b0e72b>] ? ath10k_pci_sleep+0x8b/0xb0 [ath10k_pci]
>  [<f8b6ac63>] ath10k_wmi_10_2_op_rx+0xf3/0x3b0
> 
>  [<f8b6495e>] ath10k_wmi_process_rx+0x1e/0x60
> 
>  [<f8b5f077>] ath10k_htc_rx_completion_handler+0x347/0x4d0 [ath10k_core]
>  [<f8b11dc3>] ? ath10k_ce_completed_recv_next+0x53/0x70 [ath10k_pci]
>  [<f8b0f921>] ath10k_pci_ce_recv_data+0x171/0x1d0 [ath10k_pci]
>  [<f8b0ec69>] ? ath10k_pci_write32+0x39/0x80 [ath10k_pci]
>  [<f8b120bc>] ath10k_ce_per_engine_service+0x5c/0xa0 [ath10k_pci]
>  [<f8b1215f>] ath10k_ce_per_engine_service_any+0x5f/0x70 [ath10k_pci]
>  [<c1060dc0>] ? local_bh_enable_ip+0x90/0x90
>  [<f8b1048b>] ath10k_pci_tasklet+0x1b/0x50 [ath10k_pci]
> 
> Fixes: 34c30b0a5e97 ("ath10k: enable advertising support for channel 169, 5Ghz")
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

c486dc571a37 ath10k: fix wifi connectivity and warning in rx with channel 169

-- 
https://patchwork.kernel.org/patch/9508031/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
