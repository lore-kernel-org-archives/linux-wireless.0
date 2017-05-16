Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:34369 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751212AbdEPKG5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 06:06:57 -0400
Received: by mail-qt0-f196.google.com with SMTP id l39so19912879qtb.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 03:06:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <72458624-9a4d-bb20-2bdb-1a8f4c53ca6e@broadcom.com>
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
 <1494336614-2107-6-git-send-email-amit.karwar@redpinesignals.com>
 <87fugbs0x5.fsf@kamboji.qca.qualcomm.com> <72458624-9a4d-bb20-2bdb-1a8f4c53ca6e@broadcom.com>
From: amit karwar <amitkarwar@gmail.com>
Date: Tue, 16 May 2017 15:36:56 +0530
Message-ID: <CAEhWJFmAStDyagTcq0=qa8RBu-pOZF50iviaWtxh-cv5koy5JQ@mail.gmail.com> (sfid-20170516_120712_842020_FD9B0EAD)
Subject: Re: [v2 05/11] rsi: Remove unnecessary buffer allocation
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 12, 2017 at 1:58 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 5/11/2017 8:28 PM, Kalle Valo wrote:
>>
>> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>>
>>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>>
>>> In functions usb read register and usb write register, dynamic allocation
>>> of 4 bytes is used. This is removed as it is unncessary for local
>>> variable
>>> and for such small data.
>>>
>>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>>> ---
>>>   drivers/net/wireless/rsi/rsi_91x_usb.c | 18 ++++--------------
>>>   1 file changed, 4 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c
>>> b/drivers/net/wireless/rsi/rsi_91x_usb.c
>>> index 73b01a8..8eb7407 100644
>>> --- a/drivers/net/wireless/rsi/rsi_91x_usb.c
>>> +++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
>>> @@ -157,12 +157,8 @@ static int rsi_usb_reg_read(struct usb_device
>>> *usbdev,
>>>                             u16 *value,
>>>                             u16 len)
>>>   {
>>> -       u8 *buf;
>>> -       int status = -ENOMEM;
>>> -
>>> -       buf  = kmalloc(0x04, GFP_KERNEL);
>>> -       if (!buf)
>>> -               return status;
>>> +       u8 buf[4];
>>> +       int status;
>>>         status = usb_control_msg(usbdev,
>>>                                  usb_rcvctrlpipe(usbdev, 0),
>>
>>
>> Recently I got a patch to orinoco_usb which did exactly the opposite
>> (unless I'm missing something):
>>
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=2f6ae79cb04bb7f9b4be3f1c32b6fda35bf976bc
>>
>> The documentation for usb_control_msg() does not mention anything if
>> it's possible to use stack memory, but AFAIU it's not possible to use
>> stack memory with DMA. Can anyone clarify?
>
>
> After private message I sent to Kalle here my public response :-p
> According to Greg this has been a USB core requirement for a long, long time
> (see below).
>

Thanks Arend.
I have dropped this patch in V3 series.

Regards,
Amitkumar Karwar
