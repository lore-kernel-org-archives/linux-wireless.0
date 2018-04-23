Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36413 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755533AbeDWRWR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 13:22:17 -0400
Received: by mail-lf0-f46.google.com with SMTP id d20-v6so16159687lfe.3
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2018 10:22:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180420164507.GA22666@animalcreek.com>
References: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org>
 <1524045904-7005-3-git-send-email-amit.pundir@linaro.org> <1524227986.21176.467.camel@linux.intel.com>
 <20180420164507.GA22666@animalcreek.com>
From: Amit Pundir <amit.pundir@linaro.org>
Date: Mon, 23 Apr 2018 22:51:35 +0530
Message-ID: <CAMi1Hd36LbWSTsnxiLY0CAgW_CaAbTJNRrUQ07Qb4OiSmuC5sw@mail.gmail.com> (sfid-20180423_192232_843810_EC7830A4)
Subject: Re: [RESEND][PATCH 2/4] NFC: st21nfca: Fix memory OOB and leak issues
 in connectivity events handler
To: Mark Greer <mgreer@animalcreek.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
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

On 20 April 2018 at 22:15, Mark Greer <mgreer@animalcreek.com> wrote:
> On Fri, Apr 20, 2018 at 03:39:46PM +0300, Andy Shevchenko wrote:
>> On Wed, 2018-04-18 at 15:35 +0530, Amit Pundir wrote:
>>
>> >             if (skb->data[transaction->aid_len + 2] !=
>> > -               NFC_EVT_TRANSACTION_PARAMS_TAG)
>> > +               NFC_EVT_TRANSACTION_PARAMS_TAG ||
>> > +               skb->len < transaction->aid_len + transaction-
>> > >params_len + 4) {
>>
>> > +                   devm_kfree(dev, transaction);
>>
>> Oh, no.
>>
>> This is not memory leak per se, this is bad choice of devm_ API where it
>> should use plain kmalloc() / kfree().
>
> Also, there is no check to see if the allocation worked at all.

Ack. I'll add that in v2.
Thanks.

Regards,
Amit Pundir

>
> Mark
> --
