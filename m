Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35599 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933865AbeBMKkt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 05:40:49 -0500
MIME-Version: 1.0
In-Reply-To: <87inbhmblb.fsf@purkki.adurom.net>
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
 <1513168977-2121-5-git-send-email-amitkarwar@gmail.com> <87inbhmblb.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Tue, 13 Feb 2018 16:10:47 +0530
Message-ID: <CAEhWJF=qx=M=mWr6csb=SOMu3pK6mGH4K6h6-idhc_HiAj2LHA@mail.gmail.com> (sfid-20180213_114054_625194_F3500F1B)
Subject: Re: [v5 4/8] rsi: add coex support
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

On Thu, Feb 1, 2018 at 12:38 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> With BT support, driver has to handle two streams of data
>> (i.e. wlan and BT). Actual coex implementation is in firmware.
>> Coex module just schedule the packets to firmware by taking them
>> from the corresponding paths.
>>
>> Structures for module and protocol operations are introduced for
>> this purpose. Protocol operations structure is global structure
>> which can be shared among different modules. Initialization of
>> coex and operating mode values is moved to rsi_91x_init().
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> [...]
>
>> +static void rsi_coex_sched_tx_pkts(struct rsi_coex_ctrl_block *coex_cb)
>> +{
>> +     enum rsi_coex_queues coex_q;
>> +     struct sk_buff *skb;
>> +
>> +     while (1) {
>> +             coex_q = rsi_coex_determine_coex_q(coex_cb);
>> +             rsi_dbg(INFO_ZONE, "queue = %d\n", coex_q);
>> +
>> +             if (coex_q == RSI_COEX_Q_INVALID) {
>> +                     rsi_dbg(DATA_TX_ZONE, "No more pkt\n");
>> +                     break;
>> +             }
>> +
>> +             if (coex_q == RSI_COEX_Q_BT)
>> +                     skb = skb_dequeue(&coex_cb->coex_tx_qs[RSI_COEX_Q_BT]);
>> +     }
>> +}
>
> Neverending loops are dangerous in kernel. Can you put a limit so that
> if there's a bug the loop will not run forever?

I will get rid of while(1) in v6 patch series.

Regards,
Amitkumar
