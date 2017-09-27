Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32774 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752334AbdI0NS1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Sep 2017 09:18:27 -0400
Received: by mail-oi0-f65.google.com with SMTP id z73so8724678oia.0
        for <linux-wireless@vger.kernel.org>; Wed, 27 Sep 2017 06:18:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87shf96aqt.fsf@kamboji.qca.qualcomm.com>
References: <1506345695-4654-1-git-send-email-amitkarwar@gmail.com> <87shf96aqt.fsf@kamboji.qca.qualcomm.com>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Wed, 27 Sep 2017 18:48:26 +0530
Message-ID: <CAEhWJFnKE7Jcss7k+886rCFCktfH_ajDwfXW_KcebSvdcju_qQ@mail.gmail.com> (sfid-20170927_151830_904724_F676A48E)
Subject: Re: [PATCH 1/3] rsi: sdio: add WOWLAN support for S3 suspend state
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 26, 2017 at 3:29 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Karun Eagalapati <karun256@gmail.com>
>>
>> WoWLAN is supported in RS9113 device through GPIO pin2.
>> wowlan config frame is internally sent to firmware in mac80211
>> suspend handler. Also beacon miss threshold and keep-alive time
>> values are increased to avoid un-necessary disconnection with AP.
>>
>> Signed-off-by: Karun Eagalapati <karun256@gmail.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>> ---
>>  drivers/net/wireless/rsi/Kconfig            |   7 ++
>>  drivers/net/wireless/rsi/rsi_91x_core.c     |   9 +-
>>  drivers/net/wireless/rsi/rsi_91x_mac80211.c | 125 ++++++++++++++++++++++++++++
>>  drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  66 +++++++++++++--
>>  drivers/net/wireless/rsi/rsi_91x_sdio.c     |  11 +++
>>  drivers/net/wireless/rsi/rsi_common.h       |   3 +
>>  drivers/net/wireless/rsi/rsi_main.h         |  12 ++-
>>  drivers/net/wireless/rsi/rsi_mgmt.h         |  37 +++++++-
>>  8 files changed, 258 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rsi/Kconfig b/drivers/net/wireless/rsi/Kconfig
>> index 7c5e4ca..0882b4e 100644
>> --- a/drivers/net/wireless/rsi/Kconfig
>> +++ b/drivers/net/wireless/rsi/Kconfig
>> @@ -42,4 +42,11 @@ config RSI_USB
>>         This option enables the USB bus support in rsi drivers.
>>         Select M (recommended), if you have a RSI 1x1 wireless module.
>>
>> +config RSI_WOW
>> +     bool "Redpine Signals WOWLAN support"
>> +     depends on RSI_SDIO && RSI_91X
>> +     default y
>> +     ---help---
>> +      Say Y, if you would like to enable wowlan support for RSI module.
>
> This adds a lot of ifdefs to the code. Is the Kconfig option really
> needed?

Thanks for the review.
Kconfig option can be removed. I will get rid of it.

Regards,
Amitkumar Karwar
