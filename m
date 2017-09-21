Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34133 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751700AbdIUOdY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 10:33:24 -0400
Received: by mail-io0-f193.google.com with SMTP id g32so5566925ioj.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2017 07:33:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mv5qah2y.fsf@kamboji.qca.qualcomm.com>
References: <1504094535-6680-1-git-send-email-amitkarwar@gmail.com> <87mv5qah2y.fsf@kamboji.qca.qualcomm.com>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 21 Sep 2017 20:03:23 +0530
Message-ID: <CAEhWJFn9_gCNTT2AcN5+3TAzHYjfDOmhHC2YCurpJYhhAW4KMA@mail.gmail.com> (sfid-20170921_163328_845720_41332B01)
Subject: Re: [PATCH] rsi: add driver and firmware version info
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 19, 2017 at 8:09 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Pavani Muthyala <pavani.muthyala@redpinesignals.com>
>>
>> We will dump information about driver and firmware versions,
>> firmware file name and operating mode during initialization.
>>
>> Signed-off-by: Pavani Muthyala <pavani.muthyala@redpinesignals.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> [...]
>
>> +void rsi_print_version(struct rsi_common *common)
>> +{
>> +     memcpy(common->driver_ver, DRV_VER, ARRAY_SIZE(DRV_VER));
>> +     common->driver_ver[ARRAY_SIZE(DRV_VER)] = '\0';
>> +
>> +     rsi_dbg(ERR_ZONE, "================================================\n");
>> +     rsi_dbg(ERR_ZONE, "================ RSI Version Info ==============\n");
>> +     rsi_dbg(ERR_ZONE, "================================================\n");
>> +     rsi_dbg(ERR_ZONE, "FW Version\t: %d.%d.%d\n",
>> +             common->lmac_ver.major, common->lmac_ver.minor,
>> +             common->lmac_ver.release_num);
>> +     rsi_dbg(ERR_ZONE, "Driver Version\t: %s", common->driver_ver);
>> +     rsi_dbg(ERR_ZONE, "Operating mode\t: %d [%s]",
>> +             common->oper_mode, opmode_str(common->oper_mode));
>> +     rsi_dbg(ERR_ZONE, "Firmware file\t: %s", common->priv->fw_file_name);
>> +     rsi_dbg(ERR_ZONE, "================================================\n");
>> +}
>> +
>
> [...]
>
>> +#define DRV_VER                              "RS911X.NB0.NL.GNU.LNX.1.0"
>
> The concept of a driver version does not really work with upstream
> drivers. The history has shown multiple times that the driver version
> won't be updated for years and thus it won't have any meaning. So better
> remove driver_ver from the driver entirely.

I agree. Driver version has been removed in v2 patch.

Thanks,
Amitkumar Karwar
