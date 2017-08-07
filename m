Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:33397 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751493AbdHGQ6A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 12:58:00 -0400
Received: by mail-qt0-f175.google.com with SMTP id a18so6251616qta.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 09:58:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170807063127.GA2823@redhat.com>
References: <20170803153121.9046-1-mike@astro.ai> <20170807063127.GA2823@redhat.com>
From: Michael Skeffington <mike@hellotwist.com>
Date: Mon, 7 Aug 2017 12:57:59 -0400
Message-ID: <CAKXXJEwrgzFpUcFVnA4rw7N-9TKYXTBKRPOnLbFh3-SANPAHgA@mail.gmail.com> (sfid-20170807_185804_205907_935439DE)
Subject: Re: [PATCH v2] rt2x00: Fix MMIC Countermeasures.
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry about that, I work on other projects that use spaces and I must have
missed that when double checking the patch.  I sent out a new patch with
the correct line length, removal of trailing '.' and indentation fix.

On Mon, Aug 7, 2017 at 2:31 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Aug 03, 2017 at 11:31:21AM -0400, Michael Skeffingfon wrote:
>> @@ -136,10 +136,19 @@ void rt2800mmio_fill_rxdone(struct queue_entry *entry,
>>                */
>>               rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
>>
>> -             if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
>> +             if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS) {
>>                       rxdesc->flags |= RX_FLAG_DECRYPTED;
>> -             else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
>> +        } else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC) {
>
> Not sure why this happened, but here and on some other places below,
> tab was replaced by spaces resulting in wrong indent.
>
> Stanislaw
