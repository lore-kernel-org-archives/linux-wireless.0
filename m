Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50249 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251Ab0KQWCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 17:02:16 -0500
Received: by vws13 with SMTP id 13so1390615vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 14:02:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101117211129.GA31776@kroah.com>
References: <20101116200438.GA10803@kroah.com>
	<1289980800-28743-1-git-send-email-mike.rapoport@gmail.com>
	<20101117211129.GA31776@kroah.com>
Date: Thu, 18 Nov 2010 00:02:15 +0200
Message-ID: <AANLkTikkVhc=3ismFX_5jWnzYHQiVXKbWQsFMPwTw6YZ@mail.gmail.com>
Subject: Re: [PATCH 4/4] staging: brcm80211: brcmfmac: cleanup bcmsdh_(un)register
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 11:11 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Nov 17, 2010 at 10:00:00AM +0200, Mike Rapoport wrote:
>> Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
>> ---
>>  drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |   13 +------------
>>  1 files changed, 1 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
>> index fd327e1..e3fb7ed 100644
>> --- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
>> +++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
>> @@ -285,28 +285,17 @@ extern int sdio_function_init(void);
>>
>>  int bcmsdh_register(bcmsdh_driver_t *driver)
>>  {
>> -     int error = 0;
>> -
>>       drvinfo = *driver;
>>
>> -#if defined(BCMPLATFORM_BUS)
>> -#if defined(BCMLXSDMMC)
>>       SDLX_MSG(("Linux Kernel SDIO/MMC Driver\n"));
>> -     error = sdio_function_init();
>
> Same question here, are you sure we can remove this code?

I'm not removing sdio_function_init here. I've only replaced
        error = sdio_function_init();
        return error;
with
        return sdio_function_init();

> just want to make sure.
>
> thanks,
>
> greg k-h
>



-- 
    Sincerely Yours,
        Mike.
