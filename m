Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:55322 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbeCOHIL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 03:08:11 -0400
Received: by mail-wm0-f48.google.com with SMTP id q83so8414690wme.5
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2018 00:08:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ina00zwv.fsf@purkki.adurom.net>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
 <1520260620-4694-2-git-send-email-amitkarwar@gmail.com> <87ina00zwv.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 15 Mar 2018 12:38:08 +0530
Message-ID: <CAEhWJFk3CGJ9-QJZJt23-vvrwXgVq9GeY9AhXbPy2=FAUMUnOw@mail.gmail.com> (sfid-20180315_080833_187935_ACEE37F6)
Subject: Re: [PATCH 01/10] rsi: add support for hardware scan offload
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2018 at 8:46 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> With the current approach of scanning, roaming delays
>> are observed. Firmware has support for back ground scanning.
>> To get this advantage, mac80211 hardware scan is implemented.
>> In this method, foreground scan is performed in driver and
>> back ground scan is configured to firmware.
>
> To me doesn't like a good idea to duplicate scan functionality in the
> driver.

There is a limitation with our device. We need to configure background
scan parameters to firmware when device is connected. In non-connected
state, we can directly dump probe requests received from mac80211 as a
part of software scan.
Some synchronization issues are with existing software scan when
device is connected. This patch implements hw_scan where these issues
are no seen, as driver has more control on scan state machine

>
>> --- a/drivers/net/wireless/rsi/rsi_91x_main.c
>> +++ b/drivers/net/wireless/rsi/rsi_91x_main.c
>> @@ -324,6 +324,14 @@ struct rsi_hw *rsi_91x_init(u16 oper_mode)
>>       mutex_init(&common->rx_lock);
>>       mutex_init(&common->tx_bus_mutex);
>>
>> +     rsi_init_event(&common->chan_set_event);
>> +     rsi_init_event(&common->probe_cfm_event);
>> +     rsi_init_event(&common->chan_change_event);
>> +     rsi_init_event(&common->cancel_hw_scan_event);
>
> And I'm starting to dislike this rsi_init_event() even more (see my
> other mail). In upstream driver's custom abstractions are very much
> frowned upon, especially that it makes review harder.

Agreed. I will get rid of this in a separate cleanup patch series.

Regards,
Amitkumar Karwar
