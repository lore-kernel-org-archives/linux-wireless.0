Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:41375 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3GSLIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 07:08:14 -0400
Received: by mail-bk0-f41.google.com with SMTP id jc3so1608985bkc.28
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jul 2013 04:08:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8761w64xr0.fsf@kamboji.qca.qualcomm.com>
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
	<1374129193-3533-2-git-send-email-michal.kazior@tieto.com>
	<8761w64xr0.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 19 Jul 2013 13:08:12 +0200
Message-ID: <CA+BoTQkD7U4KY5xq7YhTWz-qFP2f3NuQ=nHDZ2LgYaq+5M3pjg@mail.gmail.com> (sfid-20130719_130817_276636_B0187E44)
Subject: Re: [PATCH 1/3] ath10k: prevent HTC from being used after stopping
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 July 2013 13:04, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> It was possible to submit new HTC commands
>> after/while HTC stopped. This led to memory
>> corruption in some rare cases.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> @@ -957,7 +955,6 @@ void ath10k_htc_stop(struct ath10k_htc *htc)
>>       }
>>
>>       ath10k_hif_stop(htc->ar);
>> -     ath10k_htc_reset_endpoint_states(htc);
>>  }
>
> Is this on purpose? I can't fit it to the description.

You're right. I should've mentioned that in the commit message.

This line is simply unnecessary. Do you prefer fixing the commit
message accordingly or should I post it as a separate patch?


Pozdrawiam / Best regards,
Michał Kazior.
