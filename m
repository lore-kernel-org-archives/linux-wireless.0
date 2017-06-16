Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:33930 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753296AbdFPKM6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 06:12:58 -0400
Received: by mail-wr0-f172.google.com with SMTP id 77so35824032wrb.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 03:12:58 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: fix uninitialized warning in
 brcmf_usb_probe_phase2()
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <1497602195-29895-1-git-send-email-arend.vanspriel@broadcom.com>
 <87shj0z5i1.fsf@kamboji.qca.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <17b4ddff-0f68-60d0-9f2c-cf5867cfba09@broadcom.com> (sfid-20170616_121302_754304_7962B662)
Date: Fri, 16 Jun 2017 12:12:56 +0200
MIME-Version: 1.0
In-Reply-To: <87shj0z5i1.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/16/2017 10:44 AM, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> 
>> This fixes the following warning:
>>
>>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c: In function
>>    'brcmf_usb_probe_phase2':
>>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:1198:2:
>>    warning: 'devinfo' may be used uninitialized in this function
>>    [-Wmaybe-uninitialized]
>>      mutex_unlock(&devinfo->dev_init_lock);
>>
>> Fixes: 6d0507a777fb ("brcmfmac: add parameter to pass error code in firmware callback")
>> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>> Reported-by: Kalle Valo <kvalo@codeaurora.org>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> ---
>> Hi Kalle,
>>
>> Here it is. Was indeed a valid warning.
> 
> Thanks for the quick fix.

Well, wanted to send it sooner, but ...

>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
>> @@ -1164,14 +1164,13 @@ static void brcmf_usb_probe_phase2(struct device *dev, int ret,
>>   				   void *nvram, u32 nvlen)
>>   {
>>   	struct brcmf_bus *bus = dev_get_drvdata(dev);
>> -	struct brcmf_usbdev_info *devinfo;
>> +	struct brcmf_usbdev_info *devinfo = bus->bus_priv.usb->devinfo;;
> 
> But an extra semicolon :) I'll try to edit it out during commit.

needed time for the extra semicolon :-p Thanks for being thorough.

Gr. AvS
