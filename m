Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:35697 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750865AbdGVUa0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Jul 2017 16:30:26 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6MKUOYN009072
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jul 2017 21:30:25 +0100
Received: from mail-wr0-f197.google.com (mail-wr0-f197.google.com [209.85.128.197])
        by mx08-00252a01.pphosted.com with ESMTP id 2bv3f2r5nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jul 2017 21:30:24 +0100
Received: by mail-wr0-f197.google.com with SMTP id x43so20480115wrb.9
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jul 2017 13:30:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9e616361-da87-6f46-8ee3-4a4f673c3c80@broadcom.com>
References: <d33144fc-c03e-0d71-41b2-e0cd235f5ffa@redhat.com>
 <03779c4f-b48b-444f-59c5-e10324dc77bd@mnementh.co.uk> <04f1050f-966e-b0c8-7714-ee5065ba69cf@mnementh.co.uk>
 <9e616361-da87-6f46-8ee3-4a4f673c3c80@broadcom.com>
From: James Hughes <james.hughes@raspberrypi.org>
Date: Sat, 22 Jul 2017 21:30:22 +0100
Message-ID: <CAE_XsMJjTRpY4_F_GTUC86t-TWLhk-mfnMw=TFLvZ=v0-=fS0w@mail.gmail.com> (sfid-20170722_223031_739748_6701E231)
Subject: Re: brcm43430 sdio wifi regression with 4.13-rc1
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Ian Molton <ian@mnementh.co.uk>,
        Hans de Goede <hdegoede@redhat.com>,
        russianneuromancer <russianneuromancer@ya.ru>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 July 2017 at 20:53, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
> On 22-07-17 21:19, Ian Molton wrote:
>> On 22/07/17 20:18, Ian Molton wrote:
>>> On 22/07/17 19:43, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> When upgrading my devel environment to 4.13-rc1+ I noticed that
>>>> the brcm43430 sdio wifi on a Chuwi Hi8 plus stopped working:
>>>
>>> There is a fix for this:
>>>
>>> https://patchwork.kernel.org/patch/9836383/
>>
>> Sorry, ignore me - this was a fix for the other 4.13-rc1 regression.
>> Arend is looking into he other one. It affects me too.
>>
>> It appears to be the firmware going astray.
>
> It is still an enigma although admittedly I did not put much time in it
> this week. The change below fixes it as the device goes haywire from
> this command. At least this was reported by Stefan Wahren ("brcmfmac:
> BCM43431 won't get probed on Raspberry Pi Zero W") on linux-wireless
> mailing list. Still I can not explain it. Could be that there is not
> enough free memory on the device.
>
> Regards,
> Arend
> ---
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> index d21258d..def120c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> @@ -159,8 +159,9 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
>
>         brcmf_feat_firmware_capabilities(ifp);
>         memset(&gscan_cfg, 0, sizeof(gscan_cfg));
> -       brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN, "pfn_gscan_cfg",
> -                                 &gscan_cfg, sizeof(gscan_cfg));
> +       if (drvr->bus_if->chip != BRCM_CC_43430_CHIP_ID)
> +               brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN,
> "pfn_gscan_cfg",
> +                                         &gscan_cfg, sizeof(gscan_cfg));
>         brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_PNO, "pfn");
>         if (drvr->bus_if->wowl_supported)
>                 brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
>

Any movement on the mailbox issue would be good news for us, it's on
my list of things to investigate, and has been flagged up by Pi3/Pi0W
users as a possible cause/symptom of wireless issues. We have a
catchall thread for these issues here
https://github.com/raspberrypi/linux/issues/1342, with some extra
details but this particular mailbox error I've not been able to find a
way to reliably replicate so far. My Googling hadn't thrown up the
firmware version being relevant, which is a useful data point, along
with Arend's patch above. I should be able to take a bit more of a
look next week, so if anyone  has a way of replicating on a Pi3 I'd
like to here about it.

James, Raspberry Pi.
