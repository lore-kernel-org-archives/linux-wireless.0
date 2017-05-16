Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33074 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751997AbdEPKIT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 06:08:19 -0400
Received: by mail-qt0-f193.google.com with SMTP id a46so19920296qte.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 03:08:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bmqzs0m9.fsf@kamboji.qca.qualcomm.com>
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
 <1494336614-2107-8-git-send-email-amit.karwar@redpinesignals.com> <87bmqzs0m9.fsf@kamboji.qca.qualcomm.com>
From: amit karwar <amitkarwar@gmail.com>
Date: Tue, 16 May 2017 15:38:17 +0530
Message-ID: <CAEhWJFm+jYLwctwzEU4YwWBj+KhGKkjYzLMO6q=_NRCwFt0qEg@mail.gmail.com> (sfid-20170516_120845_766071_023AF81A)
Subject: Re: [v2 07/11] rsi: Add usb multi-byte read operation
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 12, 2017 at 12:05 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> USB multibyte read will be used in the new firmware loading method
>> for RS9113 chipset.
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> [...]
>
>> +static int rsi_usb_read_register_multiple(struct rsi_hw *adapter, u32 addr,
>> +                                       u8 *data, u16 count)
>> +{
>> +     struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
>> +     u8 *buf;
>> +     u16 transfer;
>> +     int status;
>> +
>> +     if (!addr)
>> +             return -EINVAL;
>> +
>> +     buf = kzalloc(4096, GFP_KERNEL);
>> +     if (!buf)
>> +             return -ENOMEM;
>> +
>> +     while (count) {
>> +             transfer = min_t(u16, count, 4096);
>
> A minor thing, no need to resend just because of this. But a define for
> 4096 would be nice.
>

I have defined a macro for 4096 in v3 series.

Regards,
Amitkumar Karwar
