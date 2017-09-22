Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34709 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751928AbdIVLuJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Sep 2017 07:50:09 -0400
Received: by mail-io0-f193.google.com with SMTP id g32so320359ioj.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Sep 2017 04:50:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <59C4D1C6.1040601@broadcom.com>
References: <1505998288-2041-1-git-send-email-amitkarwar@gmail.com>
 <CAFqt6zYY2WuwU+kQ=HmS5284CspyxF+EFm_jiysCQviSvegC1Q@mail.gmail.com>
 <CAEhWJF=eTwUA59VZBoPhxsBvpCm2eM_j1An--Ce_d0XLt8uVFw@mail.gmail.com> <59C4D1C6.1040601@broadcom.com>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Fri, 22 Sep 2017 17:20:08 +0530
Message-ID: <CAEhWJFmWUqta-nVDOe7Es9QJibLq1=CH1-1bzR8dtgLbYWsRCg@mail.gmail.com> (sfid-20170922_135012_703912_26DEF042)
Subject: Re: [v2] rsi: sdio suspend and resume support
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 22, 2017 at 2:33 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 9/21/2017 4:32 PM, Amitkumar Karwar wrote:
>>
>> On Thu, Sep 21, 2017 at 7:08 PM, Souptick Joarder <jrdr.linux@gmail.com>
>> wrote:
>>>
>>> On Thu, Sep 21, 2017 at 6:21 PM, Amitkumar Karwar <amitkarwar@gmail.com>
>>> wrote:
>>>>
>>>> From: Karun Eagalapati <karun256@gmail.com>
>>>>
>>>> SDIO suspend and resume handlers are implemented and verified
>>>> that device works after suspend/resume cycle.
>>>>
>>>> Signed-off-by: Karun Eagalapati <karun256@gmail.com>
>>>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>>>> ---
>>>> v2: Replaced never ending while loop with 20msecs loop(Kalle Valo)
>>>> ---
>>>>   drivers/net/wireless/rsi/rsi_91x_sdio.c | 128
>>>> +++++++++++++++++++++++++++++++-
>>>>   drivers/net/wireless/rsi/rsi_sdio.h     |   2 +
>>>>   2 files changed, 126 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c
>>>> b/drivers/net/wireless/rsi/rsi_91x_sdio.c
>>>> index 8d3a483..b3f8006 100644
>>>> --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
>>>> +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
>>>> @@ -1059,16 +1059,136 @@ static void rsi_disconnect(struct sdio_func
>>>> *pfunction)
>
>
> [...]
>
>
>>>>   static int rsi_suspend(struct device *dev)
>>>>   {
>>>> -       /* Not yet implemented */
>>>> -       return -ENOSYS;
>>>> +       int ret;
>>>> +       struct sdio_func *pfunction = dev_to_sdio_func(dev);
>>>> +       struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
>>>> +       struct rsi_common *common;
>>>> +
>>>> +       if (!adapter) {
>>>> +               rsi_dbg(ERR_ZONE, "Device is not ready\n");
>>>> +               return -ENODEV;
>>>> +       }
>>>> +       common = adapter->priv;
>>>> +       rsi_sdio_disable_interrupts(pfunction);
>>>> +
>>>> +       ret = rsi_set_sdio_pm_caps(adapter);
>>>> +       if (ret)
>>>> +               rsi_dbg(INFO_ZONE,
>>>> +                       "Setting power management caps failed\n");
>>>> +       common->fsm_state = FSM_CARD_NOT_READY;
>>>> +
>>>> +       return 0;
>>>
>>>
>>> I think it should be return ret if rsi_set_sdio_pm_caps() fails.
>>
>>
>> This is intentional. We don't want to return error and abort system
>> suspend operation due to this.
>
>
> Has it been verified that powering down the SDIO bus during the suspend
> works for you device. In other words  does the claim in the commit message
> apply to a sdio host controller not supporting the KEEP_POWER flag as well?

Yes. It is verified. In this case, chip gets re enumerated and
firmware will be re-downloaded after resume.

Regards,
Amitkumar Karwar
