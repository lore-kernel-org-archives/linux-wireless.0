Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35122 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932276AbeBVMR7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 07:17:59 -0500
Received: by mail-qk0-f194.google.com with SMTP id s188so6141117qkb.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Feb 2018 04:17:59 -0800 (PST)
Subject: Re: [PATCH 2/3] mwifiex: support sysfs initiated device coredump
To: Brian Norris <briannorris@chromium.org>
References: <1519210220-22437-1-git-send-email-arend.vanspriel@broadcom.com>
 <1519210220-22437-3-git-send-email-arend.vanspriel@broadcom.com>
 <20180221225903.GA42395@rodete-desktop-imager.corp.google.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A8EB4F4.2030103@broadcom.com> (sfid-20180222_131815_189394_D87B430B)
Date: Thu, 22 Feb 2018 13:17:56 +0100
MIME-Version: 1.0
In-Reply-To: <20180221225903.GA42395@rodete-desktop-imager.corp.google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/21/2018 11:59 PM, Brian Norris wrote:
> On Wed, Feb 21, 2018 at 11:50:19AM +0100, Arend van Spriel wrote:
>> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
>> it is possible to initiate a device coredump from user-space. This
>> patch adds support for it adding the .coredump() driver callback.
>> As there is no longer a need to initiate it through debugfs remove
>> that code.
>>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> ---
>>   drivers/net/wireless/marvell/mwifiex/debugfs.c | 31 +-------------------------
>>   drivers/net/wireless/marvell/mwifiex/pcie.c    | 19 ++++++++++++++--
>>   drivers/net/wireless/marvell/mwifiex/sdio.c    | 13 +++++++++++
>>   drivers/net/wireless/marvell/mwifiex/usb.c     | 14 ++++++++++++
>>   4 files changed, 45 insertions(+), 32 deletions(-)
>
> The documentation doesn't really say [1], but is the coredump supposed
> to happen synchronously? Because the mwifiex implementation is
> asynchronous, whereas it looks like the brcmfmac one is synchronous.

Well, that depends on the eye of the beholder I guess. From user-space 
perspective it is asynchronous regardless. A write access to the 
coredump sysfs file eventually results in a uevent when the devcoredump 
entry is created, ie. after driver has made a dev_coredump API call. 
Whether the driver does that synchronously or asynchronously is 
irrelevant as far as user-space is concerned.

> Brian
>
> [1] In fact, the ABI documentation really just describes kernel
> internals, rather than documenting any user-facing details, from what I
> can tell.

You are right. Clearly I did not reach the end my learning curve here. I 
assumed referring to the existing dev_coredump facility was sufficient, 
but maybe it is worth a patch to be more explicit and mention the uevent 
behavior. Also dev_coredump facility may be disabled upon which the 
trigger will have no effect in sysfs. In the kernel the data passed by 
the driver is simply freed by dev_coredump facility.

Regards,
Arend
