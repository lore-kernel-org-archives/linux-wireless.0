Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33853 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbcJEQkx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 12:40:53 -0400
Received: by mail-oi0-f49.google.com with SMTP id n132so215067723oih.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2016 09:40:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQkwSX954pPEh3oYzL62H9y4Y6UuPVLSxxxCkM5AznY7NA@mail.gmail.com>
References: <1473801118-103112-1-git-send-email-mfaltesek@google.com> <CA+BoTQkwSX954pPEh3oYzL62H9y4Y6UuPVLSxxxCkM5AznY7NA@mail.gmail.com>
From: Marty Faltesek <mfaltesek@google.com>
Date: Wed, 5 Oct 2016 12:40:52 -0400
Message-ID: <CAOiWkA9W6JSfPScK0PwffUnWuv4ZXQD4AF1s2FbMq0MmmasLrg@mail.gmail.com> (sfid-20161005_184057_427853_EF6620A0)
Subject: Re: [PATCH] ath10k: cache calibration data when the core is stopped.
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 3, 2016 at 4:02 AM, Michal Kazior <michal.kazior@tieto.com> wro=
te:
> On 13 September 2016 at 23:11, Marty Faltesek <mfaltesek@google.com> wrot=
e:
> [...]
>> +int
>> +ath10k_cal_data_alloc(struct ath10k *ar, void **buf)
>> +{
>> +       u32 hi_addr;
>> +       __le32 addr;
>> +       int ret;
>> +
>> +       vfree(*buf);
>> +       *buf =3D vmalloc(QCA988X_CAL_DATA_LEN);
>
> Shouldn't you use ar->hw_params to get hw-specific caldata length?

yup, it was because we were based on backports from earlier this year.

>
>
> [...]
>> @@ -1714,6 +1750,12 @@ int ath10k_core_start(struct ath10k *ar, enum ath=
10k_firmware_mode mode)
>>
>>         INIT_LIST_HEAD(&ar->arvifs);
>>
>> +       /*
>> +        * We are up now, so no need to cache calibration data.
>> +        */
>
> The comment style is:
>
>  /* comment */
>
> If it's multi-line it should be:
>
>  /* comment
>   * comment
>   */
>
> Ditto for other instances.

fixed, thanks.

>
>
> [...]
>> @@ -1757,6 +1799,11 @@ void ath10k_core_stop(struct ath10k *ar)
>>         lockdep_assert_held(&ar->conf_mutex);
>>         ath10k_debug_stop(ar);
>>
>> +       /*
>> +        * Cache caclibration data while stopped.
>
> typo. "calibration"
>
>
> Micha=C5=82

fixed thanks.
