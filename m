Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:42109 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab3H1Fcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 01:32:51 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so1946621bkb.41
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 22:32:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87y57mjvwu.fsf@kamboji.qca.qualcomm.com>
References: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
	<1377601683-12072-1-git-send-email-michal.kazior@tieto.com>
	<1377601683-12072-2-git-send-email-michal.kazior@tieto.com>
	<87y57mjvwu.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 28 Aug 2013 07:32:50 +0200
Message-ID: <CA+BoTQ=mBeWQLvaLUL4gnTENRbGUK_fTkj9bP3HP-OSzBwG0Dg@mail.gmail.com> (sfid-20130828_073255_291210_E30F1109)
Subject: Re: [PATCH v2 1/6] ath10k: use inline ce_state structure
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 August 2013 06:12, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Simplifies memory managament of ce_state.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Sorry, I noticed this only in my second review round:
>
>> --- a/drivers/net/wireless/ath/ath10k/pci.h
>> +++ b/drivers/net/wireless/ath/ath10k/pci.h
>> @@ -233,7 +233,10 @@ struct ath10k_pci {
>>       spinlock_t ce_lock;
>>
>>       /* Map CE id to ce_state */
>> -     struct ce_state *ce_id_to_state[CE_COUNT_MAX];
>> +     struct ce_state ce_states[CE_COUNT_MAX];
>> +
>> +     /* makes sure that dummy reads are atomic */
>> +     spinlock_t hw_v1_workaround_lock;
>>  };
>
> That lock doesn't look right. Is it a leftover from a rebase?

Oh, good catch. I wonder how it got there..


Michał.
