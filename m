Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41506 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaHSMak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 08:30:40 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so5200752wiw.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2014 05:30:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87a977o450.fsf@kamboji.qca.qualcomm.com>
References: <1407402260-29854-1-git-send-email-michal.kazior@tieto.com>
	<1407402260-29854-5-git-send-email-michal.kazior@tieto.com>
	<87a977o450.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 19 Aug 2014 14:30:39 +0200
Message-ID: <CA+BoTQmgcBKfNKrAH5jKsehemx7rTxHHXMr8Qf+ctgfZpVj0Dg@mail.gmail.com> (sfid-20140819_143044_007243_F177B7F7)
Subject: Re: [PATCH 4/5] ath10k: split ce irq/handler setup
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 August 2014 10:40, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> It doesn't make much sense to overwrite send_cb
>> and recv_cb callbacks over and over again whenever
>> transport starts. Just make sure to unmask copy
>> engine interrupts when starting.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> The patch looks, just a followup question for the future:
>
>> @@ -1674,7 +1639,9 @@ static int ath10k_pci_ce_init(struct ath10k *ar)
>>               pipe_info->hif_ce_state = ar;
>>               attr = &host_ce_config_wlan[pipe_num];
>>
>> -             ret = ath10k_ce_init_pipe(ar, pipe_num, attr);
>> +             ret = ath10k_ce_init_pipe(ar, pipe_num, attr,
>> +                                       ath10k_pci_ce_send_done,
>> +                                       ath10k_pci_ce_recv_data);
>
> As we call ath10k_ce_init_pipe() only once and seem to have only one set
> of functions, why even bother bother with function pointers? What if we
> just call the functions directly?

Yeah, we can remove this abstraction later. I don't there's anything
depending on it anymore.


Michał
