Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38124 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712AbcDENep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 09:34:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 05 Apr 2016 19:04:43 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath10k: fix unconditional num_mpdus_ready subtraction
In-Reply-To: <87shz0b4s2.fsf@kamboji.qca.qualcomm.com>
References: <1459352551-11773-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1459352551-11773-3-git-send-email-rmanohar@qti.qualcomm.com>
 <87shz0b4s2.fsf@kamboji.qca.qualcomm.com>
Message-ID: <6a0952fb8bfc92769b93f602189ddeac@codeaurora.org> (sfid-20160405_153447_926808_52F751A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-04-05 18:18, Valo, Kalle wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
>> Decrement num_mpdus_ready only when rx amsdu is processed 
>> successfully.
>> Not doing so, will result in leak and impact stabilty under low memory
>> cases.
>> 
>> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/htt_rx.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c 
>> b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> index 96a7417..9696c2e 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> @@ -2412,14 +2412,12 @@ static void 
>> ath10k_htt_txrx_compl_task(unsigned long ptr)
>>  	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
>>  	struct ath10k *ar = htt->ar;
>>  	struct htt_tx_done tx_done = {};
>> -	struct sk_buff_head rx_q;
>>  	struct sk_buff_head rx_ind_q;
>>  	struct sk_buff_head tx_ind_q;
>>  	struct sk_buff *skb;
>>  	unsigned long flags;
>>  	int num_mpdus;
>> 
>> -	__skb_queue_head_init(&rx_q);
>>  	__skb_queue_head_init(&rx_ind_q);
>>  	__skb_queue_head_init(&tx_ind_q);
> 
> I guess you are removing the unused rx_q just as a cleanup? It's good
> practise to mention that in the commit log (or better yet in a separate
> patch).

update the commit log and send next version.

-Rajkumar
