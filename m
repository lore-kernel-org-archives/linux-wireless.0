Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47119 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaHSMhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 08:37:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] ath10k: split ce irq/handler setup
References: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
	<1407402260-29854-5-git-send-email-michal.kazior@tieto.com>
	<87a977o450.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmgcBKfNKrAH5jKsehemx7rTxHHXMr8Qf+ctgfZpVj0Dg@mail.gmail.com>
Date: Tue, 19 Aug 2014 15:37:23 +0300
In-Reply-To: <CA+BoTQmgcBKfNKrAH5jKsehemx7rTxHHXMr8Qf+ctgfZpVj0Dg@mail.gmail.com>
	(Michal Kazior's message of "Tue, 19 Aug 2014 14:30:39 +0200")
Message-ID: <87a970ac58.fsf@kamboji.qca.qualcomm.com> (sfid-20140819_143810_502552_63D0EB6D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 14 August 2014 10:40, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> It doesn't make much sense to overwrite send_cb
>>> and recv_cb callbacks over and over again whenever
>>> transport starts. Just make sure to unmask copy
>>> engine interrupts when starting.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> The patch looks, just a followup question for the future:
>>
>>> @@ -1674,7 +1639,9 @@ static int ath10k_pci_ce_init(struct ath10k *ar)
>>>               pipe_info->hif_ce_state = ar;
>>>               attr = &host_ce_config_wlan[pipe_num];
>>>
>>> -             ret = ath10k_ce_init_pipe(ar, pipe_num, attr);
>>> +             ret = ath10k_ce_init_pipe(ar, pipe_num, attr,
>>> +                                       ath10k_pci_ce_send_done,
>>> +                                       ath10k_pci_ce_recv_data);
>>
>> As we call ath10k_ce_init_pipe() only once and seem to have only one set
>> of functions, why even bother bother with function pointers? What if we
>> just call the functions directly?
>
> Yeah, we can remove this abstraction later. I don't there's anything
> depending on it anymore.

Good, again something for a rainy day :)

I added it to the TODO list (which we should cleanup as well):

http://wireless.kernel.org/en/users/Drivers/ath10k/todo

-- 
Kalle Valo
