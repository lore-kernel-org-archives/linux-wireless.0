Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34547 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933825AbeBMKWc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 05:22:32 -0500
MIME-Version: 1.0
In-Reply-To: <87y3kdmcxe.fsf@purkki.adurom.net>
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
 <1513168977-2121-4-git-send-email-amitkarwar@gmail.com> <87y3kdmcxe.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Tue, 13 Feb 2018 15:52:30 +0530
Message-ID: <CAEhWJF=oMHU=9HkFJETVnC0bLozic7NTZ6qLP2hk3ezk5iKODg@mail.gmail.com> (sfid-20180213_112238_236730_25FB525C)
Subject: Re: [v5 3/8] rsi: add header file rsi_header
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 1, 2018 at 12:09 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> The common parameters used by wlan and bt modules are added
>> to a new header file "rsi_header.h" defined in '/include/linux'
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> [...]
>
>> diff --git a/include/linux/rsi_header.h b/include/linux/rsi_header.h
>> new file mode 100644
>> index 0000000..16a447b
>> --- /dev/null
>> +++ b/include/linux/rsi_header.h
>> @@ -0,0 +1,34 @@
>> +/**
>> + * Copyright (c) 2017 Redpine Signals Inc.
>> + *
>> + * Permission to use, copy, modify, and/or distribute this software for any
>> + * purpose with or without fee is hereby granted, provided that the above
>> + * copyright notice and this permission notice appear in all copies.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
>> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
>> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
>> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
>> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
>> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>> + */
>> +
>> +#ifndef __RSI_HEADER_H__
>> +#define __RSI_HEADER_H__
>> +
>> +/* HAL queue information */
>> +#define RSI_COEX_Q                   0x0
>> +#define RSI_BT_Q                     0x2
>> +#define RSI_WLAN_Q                      0x3
>> +#define RSI_WIFI_MGMT_Q                 0x4
>> +#define RSI_WIFI_DATA_Q                 0x5
>> +#define RSI_BT_MGMT_Q                        0x6
>> +#define RSI_BT_DATA_Q                        0x7
>> +
>> +enum rsi_host_intf {
>> +     RSI_HOST_INTF_SDIO = 0,
>> +     RSI_HOST_INTF_USB
>> +};
>> +
>> +#endif
>
> The name of the header "rsi_header.h" looks odd. The ".h" prefix already
> tells that it's a header file, no need to repeat that in the filename.
> But also calling it "rsi.h" feels a bit weird, it's not really very
> specific. Would "rsi_91x.h" (from rsi_91x.ko) be any better?

Sure. Using rsi_91x.h makes sense.

>
> Also I'm not sure about the location (include/linux), is that really the
> correct place to have a header file shared by a wireless and bluetooth
> driver? Anyone know? Or would include/net be better?
>

include/net looks more appropriate. I will use it.

Regards,
Amitkumar
