Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:37406 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755663AbeDWRVB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 13:21:01 -0400
Received: by mail-lf0-f46.google.com with SMTP id b23-v6so16172796lfg.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2018 10:21:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1524227986.21176.467.camel@linux.intel.com>
References: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org>
 <1524045904-7005-3-git-send-email-amit.pundir@linaro.org> <1524227986.21176.467.camel@linux.intel.com>
From: Amit Pundir <amit.pundir@linaro.org>
Date: Mon, 23 Apr 2018 22:50:19 +0530
Message-ID: <CAMi1Hd1Hxgo=_1CMDJ8_mnzfcEm97=aiYoxgf42rK_oXp17arQ@mail.gmail.com> (sfid-20180423_192115_821943_A9F2C7B9)
Subject: Re: [RESEND][PATCH 2/4] NFC: st21nfca: Fix memory OOB and leak issues
 in connectivity events handler
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 April 2018 at 18:09, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Wed, 2018-04-18 at 15:35 +0530, Amit Pundir wrote:
>
>>               if (skb->data[transaction->aid_len + 2] !=
>> -                 NFC_EVT_TRANSACTION_PARAMS_TAG)
>> +                 NFC_EVT_TRANSACTION_PARAMS_TAG ||
>> +                 skb->len < transaction->aid_len + transaction-
>> >params_len + 4) {
>
>> +                     devm_kfree(dev, transaction);
>
> Oh, no.
>
> This is not memory leak per se, this is bad choice of devm_ API where it
> should use plain kmalloc() / kfree().
>

Hi, If I switch to kmalloc()/kfree() with allocation and may be
pre-usage checks along the way up to nfc_genl_se_transaction() would
that suffice? I believe, I still be needing the additional aid_len and
params_len checks regardless, right?

Regards,
Amit Pundir

>>                       return -EPROTO;
>> +             }
>
> --
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Intel Finland Oy
