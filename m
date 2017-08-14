Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752443AbdHNPUm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 11:20:42 -0400
Subject: [4.13 REGRESSION] Re: brcm43430 sdio wifi regression with 4.13-rc1
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ian Molton <ian@mnementh.co.uk>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: russianneuromancer <russianneuromancer@ya.ru>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
References: <d33144fc-c03e-0d71-41b2-e0cd235f5ffa@redhat.com>
 <03779c4f-b48b-444f-59c5-e10324dc77bd@mnementh.co.uk>
 <04f1050f-966e-b0c8-7714-ee5065ba69cf@mnementh.co.uk>
 <9e616361-da87-6f46-8ee3-4a4f673c3c80@broadcom.com>
 <d6c43415-186d-ea1d-c1da-f68020267508@redhat.com>
Message-ID: <2323972d-280f-048f-31fb-1c31b0228b22@redhat.com> (sfid-20170814_172046_163882_AB973ECF)
Date: Mon, 14 Aug 2017 17:20:38 +0200
MIME-Version: 1.0
In-Reply-To: <d6c43415-186d-ea1d-c1da-f68020267508@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 23-07-17 09:08, Hans de Goede wrote:
> Hi,
> 
> On 22-07-17 21:53, Arend van Spriel wrote:
>> On 22-07-17 21:19, Ian Molton wrote:
>>> On 22/07/17 20:18, Ian Molton wrote:
>>>> On 22/07/17 19:43, Hans de Goede wrote:
>>>>> Hi,
>>>>>
>>>>> When upgrading my devel environment to 4.13-rc1+ I noticed that
>>>>> the brcm43430 sdio wifi on a Chuwi Hi8 plus stopped working:
>>>>
>>>> There is a fix for this:
>>>>
>>>> https://patchwork.kernel.org/patch/9836383/
>>>
>>> Sorry, ignore me - this was a fix for the other 4.13-rc1 regression.
>>> Arend is looking into he other one. It affects me too.
>>>
>>> It appears to be the firmware going astray.
>>
>> It is still an enigma although admittedly I did not put much time in it
>> this week. The change below fixes it as the device goes haywire from
>> this command. At least this was reported by Stefan Wahren ("brcmfmac:
>> BCM43431 won't get probed on Raspberry Pi Zero W") on linux-wireless
>> mailing list. Still I can not explain it. Could be that there is not
>> enough free memory on the device.
> 
> As mentioned in my original mail, switching firmware version seems to
> fix this. linux-firmware has:
> 
> [hans@shalem ~]$ strings brcm-firmware/brcmfmac43430-sdio.bin.7.45.41.26.ucode1043.2060 | tail -n1
> 43430a1-roml/sdio-g-p2p-pool-pno-pktfilter-keepalive-aoe-mchan-tdls-proptxstatus-ampduhostreorder-lpc-sr-bcmcps Version: 7.45.41.26 CRC: a75d4f1b Date: Mon 2016-08-29 20:53:22 CEST Ucode Ver: 1043.2060 FWID: 01-4527cfab
> 
> Where as this one (from the android image on the tablet) does work:
> 
> [hans@shalem ~]$ strings brcm-firmware/brcmfmac43430-sdio.bin.7.45.77.0.ucode1043.2054 | tail -n1
> 43430a1-roml/sdio-g-pool-p2p-pno-pktfilter-keepalive-aoe-mchan-proptxstatus-ampduhostreorder-lpc-wl11u-rcc-fmc-wepso-okc-anqpo-11nprop-ndoe-tdls-hs20sta-clm_4335_ss-hwapwar-ivwar-srfast Version: 7.45.77.0 CRC: c1a399d4 Date: Wed 2016-03-30 11:31:45 CST Ucode Ver: 1043.2054 FWID: 01-ee8a6268
> 
> Here: https://www.spinics.net/lists/linux-wireless/msg164304.html
> you write that the firmware in linux-firmware does not have the
> gscan feature, the check for which is causing the issue, enabled,
> could it be the other firmware build does have it enabled? It does seem
> to have a bunch of extra things enabled. Maybe there simply is an error
> in the error-handling in the firmware when it is disabled ?
> 
> I've put all firmware versions I have here:
> 
> http://jwrdegoede.danny.cz/brcm-firmware/
> 
> Regards,
> 
> Hans
> 
> 
> 
>>
>> Regards,
>> Arend
>> ---
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> index d21258d..def120c 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>> @@ -159,8 +159,9 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
>>
>>          brcmf_feat_firmware_capabilities(ifp);
>>          memset(&gscan_cfg, 0, sizeof(gscan_cfg));
>> -       brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN, "pfn_gscan_cfg",
>> -                                 &gscan_cfg, sizeof(gscan_cfg));
>> +       if (drvr->bus_if->chip != BRCM_CC_43430_CHIP_ID)
>> +               brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN,
>> "pfn_gscan_cfg",
>> +                                         &gscan_cfg, sizeof(gscan_cfg));
>>          brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_PNO, "pfn");
>>          if (drvr->bus_if->wowl_supported)
>>                  brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
>>

AFAICT this is still a problem with 4.13-rc5, can we at least get
the above workaround merged for 4.13 ?

Regards,

Hans
