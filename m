Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51308 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753147AbdHNPq4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 11:46:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ian Molton <ian@mnementh.co.uk>,
        russianneuromancer <russianneuromancer@ya.ru>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [4.13 REGRESSION] Re: brcm43430 sdio wifi regression with 4.13-rc1
References: <d33144fc-c03e-0d71-41b2-e0cd235f5ffa@redhat.com>
        <03779c4f-b48b-444f-59c5-e10324dc77bd@mnementh.co.uk>
        <04f1050f-966e-b0c8-7714-ee5065ba69cf@mnementh.co.uk>
        <9e616361-da87-6f46-8ee3-4a4f673c3c80@broadcom.com>
        <d6c43415-186d-ea1d-c1da-f68020267508@redhat.com>
        <2323972d-280f-048f-31fb-1c31b0228b22@redhat.com>
Date: Mon, 14 Aug 2017 18:46:46 +0300
In-Reply-To: <2323972d-280f-048f-31fb-1c31b0228b22@redhat.com> (Hans de
        Goede's message of "Mon, 14 Aug 2017 17:20:38 +0200")
Message-ID: <87d17yb195.fsf@kamboji.qca.qualcomm.com> (sfid-20170814_174704_447821_CB6D9DAF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans de Goede <hdegoede@redhat.com> writes:

>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>>> index d21258d..def120c 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
>>> @@ -159,8 +159,9 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
>>>
>>>          brcmf_feat_firmware_capabilities(ifp);
>>>          memset(&gscan_cfg, 0, sizeof(gscan_cfg));
>>> -       brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN, "pfn_gscan_cfg",
>>> -                                 &gscan_cfg, sizeof(gscan_cfg));
>>> +       if (drvr->bus_if->chip != BRCM_CC_43430_CHIP_ID)
>>> +               brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN,
>>> "pfn_gscan_cfg",
>>> +                                         &gscan_cfg, sizeof(gscan_cfg));
>>>          brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_PNO, "pfn");
>>>          if (drvr->bus_if->wowl_supported)
>>>                  brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
>>>
>
> AFAICT this is still a problem with 4.13-rc5, can we at least get
> the above workaround merged for 4.13 ?

Just applied it few hours ago:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=e9bf53ab1ee34bb05c104bbfd2b77c844773f8e6

I'll try to get it to -rc6 but of course it depends on pull schedules if
it makes it or not.

-- 
Kalle Valo
