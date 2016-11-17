Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33013 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934176AbcKQRay (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:30:54 -0500
Received: by mail-wm0-f66.google.com with SMTP id u144so23298843wmu.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2016 09:30:53 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: Re: [RFC 04/12] ath10k: htc: refactorization
To: Michal Kazior <michal.kazior@tieto.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
 <1479141222-8493-5-git-send-email-erik.stromdahl@gmail.com>
 <CA+BoTQnTkwQjmNBdr8a+YauXffWGNBNyPTZ=RByoviTSp+1ZYQ@mail.gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Message-ID: <5b62d41b-7125-f1ce-b09f-29db7572a748@gmail.com> (sfid-20161117_183102_510839_5E3080F4)
Date: Thu, 17 Nov 2016 17:32:17 +0100
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnTkwQjmNBdr8a+YauXffWGNBNyPTZ=RByoviTSp+1ZYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/15/2016 11:19 AM, Michal Kazior wrote:
> On 14 November 2016 at 17:33, Erik Stromdahl <erik.stromdahl@gmail.com> wrote:
>> Code refactorization:
>>
>> Moved the code for ep 0 in ath10k_htc_rx_completion_handler
>> to ath10k_htc_control_rx_complete.
>>
>> This eases the implementation of SDIO/mbox significantly since
>> the ep_rx_complete cb is invoked directly from the SDIO/mbox
>> hif layer.
>>
>> Since the ath10k_htc_control_rx_complete already is present
>> (only containing a warning message) there is no reason for not
>> using it (instead of having a special case for ep 0 in
>> ath10k_htc_rx_completion_handler).
> 
> This should be squashed with Patch 3 since it's inseparable part of
> the same refactorization.
> 
> 
> Michał
> 


Hmm, I don't really see why this is an inseparable part of the previous
patch.

As far as I see this patch has nothing to do with patch 3, or am I
missing anything?

Are you really sure they should be squashed?

Erik
