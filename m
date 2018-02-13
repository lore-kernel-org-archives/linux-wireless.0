Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:53525 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933931AbeBMKUq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 05:20:46 -0500
MIME-Version: 1.0
In-Reply-To: <87372lnrwu.fsf@purkki.adurom.net>
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
 <1513168977-2121-2-git-send-email-amitkarwar@gmail.com> <87372lnrwu.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Tue, 13 Feb 2018 15:50:44 +0530
Message-ID: <CAEhWJFkf-M3V-zP2it7qo5fD78ni1JmYh4nXuChWEadjgdMK3g@mail.gmail.com> (sfid-20180213_112051_103526_90D38680)
Subject: Re: [v5 1/8] rsi: add rx control block to handle rx packets in USB
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

On Thu, Feb 1, 2018 at 12:00 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> Rx bluetooth endpoint shall be added in further patches. Rx control
>> block is introduced here to handle Rx packets properly. Separate
>> function is written to initialize the RX control blocks.
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> [...]
>
>> +static int rsi_usb_init_rx(struct rsi_hw *adapter)
>> +{
>> +     struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
>> +     struct rx_usb_ctrl_block *rx_cb;
>> +     u8 idx;
>> +
>> +     for (idx = 0; idx < MAX_RX_URBS; idx++) {
>> +             rx_cb = &dev->rx_cb[idx];
>> +
>> +             rx_cb->rx_buffer = kzalloc(RSI_USB_BUF_SIZE * 2,
>> +                                        GFP_KERNEL | GFP_DMA);
>
> Do you really need GFP_DMA? From the documentation:
>
>  "GFP_DMA exists for historical reasons and should be avoided where
>   possible."

Thanks for review. I will get rid of this flag,

Regards,
Amitkumar
