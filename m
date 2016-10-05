Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35736 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbcJEQjt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 12:39:49 -0400
Received: by mail-oi0-f48.google.com with SMTP id d132so77046909oib.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2016 09:39:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87fuodswlu.fsf@kamboji.qca.qualcomm.com>
References: <1473801118-103112-1-git-send-email-mfaltesek@google.com> <87fuodswlu.fsf@kamboji.qca.qualcomm.com>
From: Marty Faltesek <mfaltesek@google.com>
Date: Wed, 5 Oct 2016 12:39:48 -0400
Message-ID: <CAOiWkA_fuhzPeF7qPP0hLN3KTZUOi6_te5Zc3+vxKQ9GRj0VBw@mail.gmail.com> (sfid-20161005_183953_743310_CB8D6834)
Subject: Re: [PATCH] ath10k: cache calibration data when the core is stopped.
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 3, 2016 at 3:46 AM, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Marty Faltesek <mfaltesek@google.com> writes:
>
>> Caching calibration data allows it to be accessed when the
>> device is not active.
>>
>> Signed-off-by: Marty Faltesek <mfaltesek@google.com>
>
> No comma in the title, please.
>
> What tree did you use as the baseline? This doesn't seem to apply to
> ath.git:

We use backports 20160122 which has not been updated since earlier this year.
I can forward port it to your tree, and make sure
it builds but won't be able to test it. Will that be OK?

>
> Applying: ath10k: cache calibration data when the core is stopped.
> fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/core.c).
> Repository lacks necessary blobs to fall back on 3-way merge.
> Cannot fall back to three-way merge.
> Patch failed at 0001 ath10k: cache calibration data when the core is stopped.
>
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -1227,6 +1227,42 @@ success:
>>       return 0;
>>  }
>>
>> +int
>> +ath10k_cal_data_alloc(struct ath10k *ar, void **buf)
>> +{
>> +     u32 hi_addr;
>> +     __le32 addr;
>> +     int ret;
>
> I think this function should be in debug.c. That way the code is not
> wasting memory if DEBUGFS is disabled.

ok.

>
>> +     vfree(*buf);
>> +     *buf = vmalloc(QCA988X_CAL_DATA_LEN);
>> +     if (!*buf) {
>> +             return -EAGAIN;
>> +     }
>
> Is it really necessary to allocate memory every time? What if allocate
> it only once when module is loaded, just like with
> ar->debug.fw_crash_data?

yup, good suggestion.

>
> Also please note that this patch (which I'm queuing to 4.9) touches the
> same area:
>
> ath10k: fix debug cal data file
>
> https://patchwork.kernel.org/patch/9340953/

I've modified this too, and this won't be necessary, so can you drop
it? If not, let me know and I'll
pull it in and make sure I'm based off it too.
