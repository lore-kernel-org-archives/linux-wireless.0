Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35088 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752242AbcLOUxm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 15:53:42 -0500
Received: by mail-wm0-f67.google.com with SMTP id a20so493200wme.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2016 12:52:18 -0800 (PST)
Subject: Re: [RFC v2 11/11] ath10k: Added sdio support
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
 <1479496971-19174-12-git-send-email-erik.stromdahl@gmail.com>
 <87oa0duow8.fsf@kamboji.qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <4d9b8000-47c1-3537-1e76-12c0dfa7d382@gmail.com> (sfid-20161215_215404_459357_38EEEAB3)
Date: Thu, 15 Dec 2016 21:52:16 +0100
MIME-Version: 1.0
In-Reply-To: <87oa0duow8.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/15/2016 05:40 PM, Valo, Kalle wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
> 
>> Initial HIF sdio/mailbox implementation.
>>
>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/Kconfig  |    6 +
>>  drivers/net/wireless/ath/ath10k/Makefile |    3 +
>>  drivers/net/wireless/ath/ath10k/sdio.c   | 1860 ++++++++++++++++++++++++++++++
>>  drivers/net/wireless/ath/ath10k/sdio.h   |  276 +++++
>>  4 files changed, 2145 insertions(+)
>>  create mode 100644 drivers/net/wireless/ath/ath10k/sdio.c
>>  create mode 100644 drivers/net/wireless/ath/ath10k/sdio.h
> 
> AFAIK the sdio firmware binary is different from pci and usb. And as all
> the firmware images need to coexist in the same repository I suspect we
> can't continue to use firmware-N.bin for both pcie and sdio (and in
> future usb). So should we somehow rename the sdio firmware filename to
> something else, like firmware-sdio-N.bin?
> 
I suppose you are right. I would be surprised if the firmware images
were the same for sdio, usb and pci. Hopefully all sdio chipsets sharing
the same device id and BMI version will use the same firmware image.
Currently, these two params are the only two that are used when
selecting firmware.

struct bmi_target_info also has a type parameter, but I can't see it
being used anywhere in the code.

If it turns out that several sdio chipsets uses the same BMI version and
device id, this parameter might be used (together with the other two) to
select hw params.
