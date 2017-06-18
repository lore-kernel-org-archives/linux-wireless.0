Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34818 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752893AbdFRNBn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Jun 2017 09:01:43 -0400
Received: by mail-wm0-f53.google.com with SMTP id x70so58506154wme.0
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jun 2017 06:01:42 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: fix uninitialized warning in
 brcmf_usb_probe_phase2()
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <1497602195-29895-1-git-send-email-arend.vanspriel@broadcom.com>
 <CAGRGNgU8=i6Nox1k2c3RozPncm92Z9Gd85f=wgzwaSDmavbA4A@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <521530e3-63b0-0720-a290-e4a73bcdc65b@broadcom.com> (sfid-20170618_150147_250249_E9A8AF38)
Date: Sun, 18 Jun 2017 15:01:40 +0200
MIME-Version: 1.0
In-Reply-To: <CAGRGNgU8=i6Nox1k2c3RozPncm92Z9Gd85f=wgzwaSDmavbA4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-06-17 06:26, Julian Calaby wrote:
> Hi Arend,
> 
> On Fri, Jun 16, 2017 at 6:36 PM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> This fixes the following warning:
>>
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c: In function
>>   'brcmf_usb_probe_phase2':
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:1198:2:
>>   warning: 'devinfo' may be used uninitialized in this function
>>   [-Wmaybe-uninitialized]
>>     mutex_unlock(&devinfo->dev_init_lock);
>>
>> Fixes: 6d0507a777fb ("brcmfmac: add parameter to pass error code in firmware callback")
>> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>> Reported-by: Kalle Valo <kvalo@codeaurora.org>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
>> index 9ce3b55..8b16387 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
>> @@ -1164,14 +1164,13 @@ static void brcmf_usb_probe_phase2(struct device *dev, int ret,
>>                                    void *nvram, u32 nvlen)
>>  {
>>         struct brcmf_bus *bus = dev_get_drvdata(dev);
>> -       struct brcmf_usbdev_info *devinfo;
>> +       struct brcmf_usbdev_info *devinfo = bus->bus_priv.usb->devinfo;;
>>
>>         if (ret)
>>                 goto error;
> 
> Completely unrelated to this specific patch, I just want to point out
> that this construct looks _really_ weird.

Guess it might. This is a callback function in which the caller passes
the result. Could have chosen a better name than 'ret'. Other option
would have been a separate callback for the error handling, but I
decided that to be overkill.

Regards,
Arend
