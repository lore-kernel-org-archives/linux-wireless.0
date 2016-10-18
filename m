Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40882 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbcJRFi7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 01:38:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 18 Oct 2016 11:08:58 +0530
From: akolli@codeaurora.org
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "Kolli, Anilkumar" <akolli@qti.qualcomm.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath10k: add per peer htt tx stats support for 10.4
In-Reply-To: <87vawygo2w.fsf@kamboji.qca.qualcomm.com>
References: <1475852332-18217-1-git-send-email-akolli@qti.qualcomm.com>
 <1475852332-18217-2-git-send-email-akolli@qti.qualcomm.com>
 <87vawygo2w.fsf@kamboji.qca.qualcomm.com>
Message-ID: <dde8d02e9ebf2eb9f37bb36c528548c2@codeaurora.org> (sfid-20161018_073926_395527_0C55FD37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2016-10-12 10:29, Valo, Kalle wrote:
> <akolli@qti.qualcomm.com> writes:
> 
>> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>> 
>> Per peer tx stats are part of 'HTT_10_4_T2H_MSG_TYPE_PEER_STATS'
>> event, Firmware sends one HTT event for every four PPDUs.
>> HTT payload has success pkts/bytes, failed pkts/bytes, retry
>> pkts/bytes and rate info per ppdu.
>> Peer stats are enabled through 'WMI_SERVICE_PEER_STATS',
>> which are nowadays enabled by default.
>> 
>> Parse peer stats and update the tx rate information per STA.
>> 
>> tx rate, Peer stats are tested on QCA4019 with Firmware version
>> 10.4-3.2.1-00028.
>> 
>> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
> 
> This and patch 2 add few new warnings:
> 
> drivers/net/wireless/ath/ath10k/htt_rx.c: In function
> 'ath10k_htt_fetch_peer_stats':
> drivers/net/wireless/ath/ath10k/htt_rx.c:2279:3: warning: too many
> arguments for format [-Wformat-extra-args]
> drivers/net/wireless/ath/ath10k/htt_rx.c:2285:17: warning: incorrect
> type in assignment (different base types)
> drivers/net/wireless/ath/ath10k/htt_rx.c:2285:17:    expected unsigned
> int [unsigned] [usertype] peer_id
> drivers/net/wireless/ath/ath10k/htt_rx.c:2285:17:    got restricted
> __le16 [usertype] peer_id
> drivers/net/wireless/ath/ath10k/debugfs_sta.c:84: space required
> before the open parenthesis '('

I will fix and send V2.

Thanks,
Anil.
