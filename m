Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52534 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751907AbeDQJ1h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 05:27:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 17 Apr 2018 14:57:36 +0530
From: pillair@codeaurora.org
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: ath10k: Enable hw checksum for wcn3990
In-Reply-To: <20180416131652.E274C606AC@smtp.codeaurora.org>
References: <1522993544-15279-1-git-send-email-pillair@codeaurora.org>
 <20180416131652.E274C606AC@smtp.codeaurora.org>
Message-ID: <b82378df7d86887170e650305c6f224b@codeaurora.org> (sfid-20180417_112741_243527_A240DCE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

The ath10k-check warning has been corrected and I have sent the v2 for 
the same.

Thanks,
Rakesh Pillai.

On 2018-04-16 18:46, Kalle Valo wrote:
> Rakesh Pillai <pillair@codeaurora.org> wrote:
> 
>> By default ath10k driver enables the support for HW_CHECKSUM
>> (NETIF_F_HW_CSUM). Since the TCP/UDP checksum calculation is not 
>> enabled
>> in the wcn3990 firmware the checksum is incorrect in the TCP/UDP 
>> packets
>> and all patckets are dropped. But due note that wcn3990 support in
>> ath10k is still incomplete so this isn't a critical fix (yet).
>> 
>> Enable hw checksum calculations in wcn3990 hardware by
>> setting the proper flags in msdu descriptor tso flags.
>> 
>> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> Introduces a new sparse warning:
> 
> potku:~/ath10k/src/ath$ ath10k-check
> drivers/net/wireless/ath/ath10k/htt_tx.c:1480:47: warning: invalid
> assignment: |=
> drivers/net/wireless/ath/ath10k/htt_tx.c:1480:47:    left side has
> type restricted __le32
> drivers/net/wireless/ath/ath10k/htt_tx.c:1480:47:    right side has
> type unsigned long
> 
> Patch set to Changes Requested.
