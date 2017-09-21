Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35498 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbdIUOcF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 10:32:05 -0400
Received: by mail-io0-f196.google.com with SMTP id d16so5563675ioj.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2017 07:32:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFqt6zYY2WuwU+kQ=HmS5284CspyxF+EFm_jiysCQviSvegC1Q@mail.gmail.com>
References: <1505998288-2041-1-git-send-email-amitkarwar@gmail.com> <CAFqt6zYY2WuwU+kQ=HmS5284CspyxF+EFm_jiysCQviSvegC1Q@mail.gmail.com>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 21 Sep 2017 20:02:04 +0530
Message-ID: <CAEhWJF=eTwUA59VZBoPhxsBvpCm2eM_j1An--Ce_d0XLt8uVFw@mail.gmail.com> (sfid-20170921_163210_441930_375BD1E3)
Subject: Re: [v2] rsi: sdio suspend and resume support
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 21, 2017 at 7:08 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> On Thu, Sep 21, 2017 at 6:21 PM, Amitkumar Karwar <amitkarwar@gmail.com> wrote:
>> From: Karun Eagalapati <karun256@gmail.com>
>>
>> SDIO suspend and resume handlers are implemented and verified
>> that device works after suspend/resume cycle.
>>
>> Signed-off-by: Karun Eagalapati <karun256@gmail.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>> ---
>> v2: Replaced never ending while loop with 20msecs loop(Kalle Valo)
>> ---
>>  drivers/net/wireless/rsi/rsi_91x_sdio.c | 128 +++++++++++++++++++++++++++++++-
>>  drivers/net/wireless/rsi/rsi_sdio.h     |   2 +
>>  2 files changed, 126 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> index 8d3a483..b3f8006 100644
>> --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> @@ -1059,16 +1059,136 @@ static void rsi_disconnect(struct sdio_func *pfunction)
>>  }
>>
>>  #ifdef CONFIG_PM
>> +static int rsi_set_sdio_pm_caps(struct rsi_hw *adapter)
>> +{
>> +       struct rsi_91x_sdiodev *dev =
>> +               (struct rsi_91x_sdiodev *)adapter->rsi_dev;
>> +       struct sdio_func *func = dev->pfunction;
>> +       int ret;
>> +
>> +       ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
>> +       if (ret)
>> +               rsi_dbg(ERR_ZONE, "Set sdio keep pwr flag failed: %d\n", ret);
>> +
>> +       return ret;
>> +}
>> +
>> +static int rsi_sdio_disable_interrupts(struct sdio_func *pfunc)
>> +{
>> +       struct rsi_hw *adapter = sdio_get_drvdata(pfunc);
>> +       u8 isr_status = 0, data = 0;
>> +       int ret;
>> +       unsigned long t1;
>> +
>> +       rsi_dbg(INFO_ZONE, "Waiting for interrupts to be cleared..");
>> +       t1 = jiffies;
>> +       do {
>> +               rsi_sdio_read_register(adapter, RSI_FN1_INT_REGISTER,
>> +                                      &isr_status);
>> +               rsi_dbg(INFO_ZONE, ".");
>> +       } while ((isr_status) && (jiffies_to_msecs(jiffies - t1) < 20));
>> +       rsi_dbg(INFO_ZONE, "Interrupts cleared\n");
>> +
>> +       sdio_claim_host(pfunc);
>> +       ret = rsi_cmd52readbyte(pfunc->card, RSI_INT_ENABLE_REGISTER, &data);
>> +       if (ret < 0) {
>> +               rsi_dbg(ERR_ZONE,
>> +                       "%s: Failed to read int enable register\n",
>> +                       __func__);
>> +               goto done;
>> +       }
>> +
>> +       data &= RSI_INT_ENABLE_MASK;
>> +       ret = rsi_cmd52writebyte(pfunc->card, RSI_INT_ENABLE_REGISTER, data);
>> +       if (ret < 0) {
>> +               rsi_dbg(ERR_ZONE,
>> +                       "%s: Failed to write to int enable register\n",
>> +                       __func__);
>> +               goto done;
>> +       }
>> +       ret = rsi_cmd52readbyte(pfunc->card, RSI_INT_ENABLE_REGISTER, &data);
>> +       if (ret < 0) {
>> +               rsi_dbg(ERR_ZONE,
>> +                       "%s: Failed to read int enable register\n",
>> +                       __func__);
>> +               goto done;
>> +       }
>> +       rsi_dbg(INFO_ZONE, "int enable reg content = %x\n", data);
>> +
>> +done:
>> +       sdio_release_host(pfunc);
>> +       return ret;
>> +}
>> +
>> +static int rsi_sdio_enable_interrupts(struct sdio_func *pfunc)
>> +{
>> +       u8 data;
>> +       int ret;
>> +
>> +       sdio_claim_host(pfunc);
>> +       ret = rsi_cmd52readbyte(pfunc->card, RSI_INT_ENABLE_REGISTER, &data);
>> +       if (ret < 0) {
>> +               rsi_dbg(ERR_ZONE,
>> +                       "%s: Failed to read int enable register\n", __func__);
>> +               goto done;
>> +       }
>> +
>> +       data |= ~RSI_INT_ENABLE_MASK & 0xff;
>> +
>> +       ret = rsi_cmd52writebyte(pfunc->card, RSI_INT_ENABLE_REGISTER, data);
>> +       if (ret < 0) {
>> +               rsi_dbg(ERR_ZONE,
>> +                       "%s: Failed to write to int enable register\n",
>> +                       __func__);
>> +               goto done;
>> +       }
>> +
>> +       ret = rsi_cmd52readbyte(pfunc->card, RSI_INT_ENABLE_REGISTER, &data);
>> +       if (ret < 0) {
>> +               rsi_dbg(ERR_ZONE,
>> +                       "%s: Failed to read int enable register\n", __func__);
>> +               goto done;
>> +       }
>> +       rsi_dbg(INFO_ZONE, "int enable reg content = %x\n", data);
>> +
>> +done:
>> +       sdio_release_host(pfunc);
>> +       return ret;
>> +}
>> +
>>  static int rsi_suspend(struct device *dev)
>>  {
>> -       /* Not yet implemented */
>> -       return -ENOSYS;
>> +       int ret;
>> +       struct sdio_func *pfunction = dev_to_sdio_func(dev);
>> +       struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
>> +       struct rsi_common *common;
>> +
>> +       if (!adapter) {
>> +               rsi_dbg(ERR_ZONE, "Device is not ready\n");
>> +               return -ENODEV;
>> +       }
>> +       common = adapter->priv;
>> +       rsi_sdio_disable_interrupts(pfunction);
>> +
>> +       ret = rsi_set_sdio_pm_caps(adapter);
>> +       if (ret)
>> +               rsi_dbg(INFO_ZONE,
>> +                       "Setting power management caps failed\n");
>> +       common->fsm_state = FSM_CARD_NOT_READY;
>> +
>> +       return 0;
>
> I think it should be return ret if rsi_set_sdio_pm_caps() fails.

This is intentional. We don't want to return error and abort system
suspend operation due to this.

Regards,
Amitkumar Karwar
