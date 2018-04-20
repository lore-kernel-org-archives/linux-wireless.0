Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43922 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754761AbeDTMtb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 08:49:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2] ath10k: fix kernel panic while reading tpc_stats
References: <1521739904-17927-1-git-send-email-tamizhr@codeaurora.org>
        <87d0zqrg5c.fsf@kamboji.qca.qualcomm.com>
        <091e88a3479502f30683054f89c9da33@codeaurora.org>
Date: Fri, 20 Apr 2018 15:49:27 +0300
In-Reply-To: <091e88a3479502f30683054f89c9da33@codeaurora.org> (Tamizh
        chelvam's message of "Tue, 27 Mar 2018 12:09:54 +0530")
Message-ID: <87efjagi08.fsf@kamboji.qca.qualcomm.com> (sfid-20180420_144934_855424_83150C7B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tamizh chelvam <tamizhr@codeaurora.org> writes:

> On 2018-03-26 21:19, Kalle Valo wrote:
>> Tamizh chelvam <tamizhr@codeaurora.org> writes:
>>
>>> @@ -4455,6 +4461,8 @@ void ath10k_wmi_event_pdev_tpc_config(struct
>>> ath10k *ar, struct sk_buff *skb)
>>>  		   __le32_to_cpu(ev->twice_max_rd_power) / 2,
>>>  		   __le32_to_cpu(ev->num_tx_chain),
>>>  		   __le32_to_cpu(ev->rate_max));
>>> +exit:
>>> +	complete(&ar->debug.tpc_complete);
>>>  }
>>
>> And why do you need this anyway? The commit log doesn't explain that.
>
> Previously this complete call was not there in the error case and
> without this we will get "failed to request tpc config stats: -110"
> along with the error message and this is a timeout warning. I've added
> this since we have received the event and the warning message is
> incorrect. I'll remove this complete call here since it is a harmless
> message and send the next version of a patch.

Yeah, that's a good idea. If you want to add the complete it's better to
do that in it's own patch (and with a proper explanation in the commit
log).

-- 
Kalle Valo
