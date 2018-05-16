Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33499 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbeEPSwx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 14:52:53 -0400
Received: by mail-qt0-f196.google.com with SMTP id e8-v6so2499766qth.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2018 11:52:53 -0700 (PDT)
Subject: Re: [PATCH V2 3/6] mwifiex: support sysfs initiated device coredump
To: Kalle Valo <kvalo@codeaurora.org>
References: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com>
 <1526472723-15758-4-git-send-email-arend.vanspriel@broadcom.com>
 <87h8n7lnfx.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AFC7E01.3070503@broadcom.com> (sfid-20180516_205257_659397_56F1EC2B)
Date: Wed, 16 May 2018 20:52:49 +0200
MIME-Version: 1.0
In-Reply-To: <87h8n7lnfx.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/16/2018 3:50 PM, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
>> it is possible to initiate a device coredump from user-space. This
>> patch adds support for it adding the .coredump() driver callback.
>> As there is no longer a need to initiate it through debugfs remove
>> that code.
>>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> ---
>>   V2:
>>    - export mwifiex_send_cmd() needed by mwifiex_usb.ko.
>> ---
>>   drivers/net/wireless/marvell/mwifiex/cmdevt.c  |  1 +
>>   drivers/net/wireless/marvell/mwifiex/debugfs.c | 31 +-------------------------
>>   drivers/net/wireless/marvell/mwifiex/pcie.c    | 18 +++++++++++++--
>>   drivers/net/wireless/marvell/mwifiex/sdio.c    | 12 ++++++++++
>>   drivers/net/wireless/marvell/mwifiex/usb.c     | 13 +++++++++++
>>   5 files changed, 43 insertions(+), 32 deletions(-)
>
> You forgot to CC mwifiex maintainers, doing it now. Full patch here:
>
> https://patchwork.kernel.org/patch/10403717/

Thanks, Kalle

You would almost think I am not used to submit patches for drivers I do 
not actively maintain ;-)

Gr. AvS
