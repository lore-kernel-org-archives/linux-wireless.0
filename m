Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38342 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdGVTx7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Jul 2017 15:53:59 -0400
Received: by mail-wm0-f49.google.com with SMTP id w191so37343748wmw.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jul 2017 12:53:58 -0700 (PDT)
Subject: Re: brcm43430 sdio wifi regression with 4.13-rc1
To: Ian Molton <ian@mnementh.co.uk>,
        Hans de Goede <hdegoede@redhat.com>
Cc: russianneuromancer <russianneuromancer@ya.ru>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
References: <d33144fc-c03e-0d71-41b2-e0cd235f5ffa@redhat.com>
 <03779c4f-b48b-444f-59c5-e10324dc77bd@mnementh.co.uk>
 <04f1050f-966e-b0c8-7714-ee5065ba69cf@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9e616361-da87-6f46-8ee3-4a4f673c3c80@broadcom.com> (sfid-20170722_215403_767398_BD16EB0B)
Date: Sat, 22 Jul 2017 21:53:56 +0200
MIME-Version: 1.0
In-Reply-To: <04f1050f-966e-b0c8-7714-ee5065ba69cf@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-07-17 21:19, Ian Molton wrote:
> On 22/07/17 20:18, Ian Molton wrote:
>> On 22/07/17 19:43, Hans de Goede wrote:
>>> Hi,
>>>
>>> When upgrading my devel environment to 4.13-rc1+ I noticed that
>>> the brcm43430 sdio wifi on a Chuwi Hi8 plus stopped working:
>>
>> There is a fix for this:
>>
>> https://patchwork.kernel.org/patch/9836383/
> 
> Sorry, ignore me - this was a fix for the other 4.13-rc1 regression.
> Arend is looking into he other one. It affects me too.
> 
> It appears to be the firmware going astray.

It is still an enigma although admittedly I did not put much time in it
this week. The change below fixes it as the device goes haywire from
this command. At least this was reported by Stefan Wahren ("brcmfmac:
BCM43431 won't get probed on Raspberry Pi Zero W") on linux-wireless
mailing list. Still I can not explain it. Could be that there is not
enough free memory on the device.

Regards,
Arend
---
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index d21258d..def120c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -159,8 +159,9 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)

        brcmf_feat_firmware_capabilities(ifp);
        memset(&gscan_cfg, 0, sizeof(gscan_cfg));
-       brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN, "pfn_gscan_cfg",
-                                 &gscan_cfg, sizeof(gscan_cfg));
+       if (drvr->bus_if->chip != BRCM_CC_43430_CHIP_ID)
+               brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN,
"pfn_gscan_cfg",
+                                         &gscan_cfg, sizeof(gscan_cfg));
        brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_PNO, "pfn");
        if (drvr->bus_if->wowl_supported)
                brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
