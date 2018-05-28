Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55758 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934008AbeE1KIL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 06:08:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 28 May 2018 13:08:04 +0300
From: merez@codeaurora.org
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Gidon Studinski <gidons@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 5/7] wil6210: add support for enhanced DMA RX data flows
In-Reply-To: <87efhzlxwe.fsf@purkki.adurom.net>
References: <1526227375-31881-1-git-send-email-merez@codeaurora.org>
 <1526227375-31881-6-git-send-email-merez@codeaurora.org>
 <87efhzlxwe.fsf@purkki.adurom.net>
Message-ID: <1acfc0dc335d86eadfdd8c009265957e@codeaurora.org> (sfid-20180528_120844_434151_1948D5CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-25 15:31, Kalle Valo wrote:
> Maya Erez <merez@codeaurora.org> writes:
> 
>> From: Gidon Studinski <gidons@codeaurora.org>
>> 
>> Enhanced DMA RX data path is handled using a single
>> RX descriptor ring for all VIFs.
>> Multiple RX status rings are supported, to allow RSS
>> and multi MSI support.
>> The driver gets the RX completions via the RX status rings.
>> The RX status message includes the completed RX buffer ID,
>> which points to the allocated SKB.
>> 
>> The enhanced DMA RX data flow supports RX chaining, where
>> multiple SKBs are merged into a single packet.
>> 
>> Enhanced DMA HW supports RX HW reorder offload, enabled by
>> default and can be disabled via module parameter.
>> 
>> Signed-off-by: Gidon Studinski <gidons@codeaurora.org>
>> Signed-off-by: Maya Erez <merez@codeaurora.org>
> 
> kbuild bot reported a warning but not sure if it's valid, please take a
> look:
> 
>    drivers/net/wireless/ath/wil6210/txrx_edma.c: In function
>    'wil_rx_handle_edma':
>>> drivers/net/wireless/ath/wil6210/txrx_edma.c:815:7: warning: 'stats'
>    may be used uninitialized in this function [-Wmaybe-uninitialized]
>      stats->rx_non_data_frame++;
>      ~~~~~^~~~~~~~~~~~~~~~~~~
>    drivers/net/wireless/ath/wil6210/txrx_edma.c:908:24: note: 'stats'
>    was declared here
>      struct wil_net_stats *stats;
>                            ^~~~~

This is false alarm but looking again on the code I think it is better 
to initialize stats.
I'll upload a fix.

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
