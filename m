Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751235AbeEYMbc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 08:31:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <merez@codeaurora.org>
Cc: Gidon Studinski <gidons@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 5/7] wil6210: add support for enhanced DMA RX data flows
References: <1526227375-31881-1-git-send-email-merez@codeaurora.org>
        <1526227375-31881-6-git-send-email-merez@codeaurora.org>
Date: Fri, 25 May 2018 15:31:29 +0300
In-Reply-To: <1526227375-31881-6-git-send-email-merez@codeaurora.org> (Maya
        Erez's message of "Sun, 13 May 2018 19:02:53 +0300")
Message-ID: <87efhzlxwe.fsf@purkki.adurom.net> (sfid-20180525_143136_329037_E670CB28)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <merez@codeaurora.org> writes:

> From: Gidon Studinski <gidons@codeaurora.org>
>
> Enhanced DMA RX data path is handled using a single
> RX descriptor ring for all VIFs.
> Multiple RX status rings are supported, to allow RSS
> and multi MSI support.
> The driver gets the RX completions via the RX status rings.
> The RX status message includes the completed RX buffer ID,
> which points to the allocated SKB.
>
> The enhanced DMA RX data flow supports RX chaining, where
> multiple SKBs are merged into a single packet.
>
> Enhanced DMA HW supports RX HW reorder offload, enabled by
> default and can be disabled via module parameter.
>
> Signed-off-by: Gidon Studinski <gidons@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>

kbuild bot reported a warning but not sure if it's valid, please take a
look:

   drivers/net/wireless/ath/wil6210/txrx_edma.c: In function
   'wil_rx_handle_edma':
>> drivers/net/wireless/ath/wil6210/txrx_edma.c:815:7: warning: 'stats'
   may be used uninitialized in this function [-Wmaybe-uninitialized]
     stats->rx_non_data_frame++;
     ~~~~~^~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/ath/wil6210/txrx_edma.c:908:24: note: 'stats'
   was declared here
     struct wil_net_stats *stats;
                           ^~~~~
-- 
Kalle Valo
