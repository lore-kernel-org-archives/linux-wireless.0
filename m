Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47369 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbcDAUgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 16:36:10 -0400
Subject: Re: [PATCH 1/3] ath10k: Ensure txrx-compl-task is stopped when
 cleaning htt-tx.
To: Michal Kazior <michal.kazior@tieto.com>
References: <1459457986-29222-1-git-send-email-greearb@candelatech.com>
 <CA+BoTQnmMKoK9z2QnTgBeRkXR0GdR1WV0XpOzD7JZnJ6QbHQ1w@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56FEDBB8.2080404@candelatech.com> (sfid-20160401_223613_976960_EAC0AD45)
Date: Fri, 1 Apr 2016 13:36:08 -0700
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnmMKoK9z2QnTgBeRkXR0GdR1WV0XpOzD7JZnJ6QbHQ1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/31/2016 11:12 PM, Michal Kazior wrote:
> On 31 March 2016 at 22:59,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Otherwise, the txrx-compl-task may access some bad memory?
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/htt_tx.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
>> index 07b960e..58e88d3 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
>> @@ -376,6 +376,8 @@ void ath10k_htt_tx_free(struct ath10k_htt *htt)
>>   {
>>          int size;
>>
>> +       tasklet_kill(&htt->txrx_compl_task);
>> +
>
> I think, instead, the ordering of ath10k_htt_tx_free() and
> ath10k_htt_rx_free() should be reversed. It's already in the "correct"
> order in ath10k_core_stop() on error path.

That seems a bit too subtle for my taste, but either way
is fine with me.  You want to cook up a patch?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

