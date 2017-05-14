Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34670 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdENIV7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 May 2017 04:21:59 -0400
Received: by mail-pf0-f176.google.com with SMTP id 9so8807416pfj.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 May 2017 01:21:59 -0700 (PDT)
Subject: Re: New brcmfmac errors in 4.12: brcmf_sdio_rxglom: sublen ... not
 multiple of 8
To: Hans de Goede <hdegoede@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <e8055bc7-eaf4-1ab6-31d1-130d83485980@redhat.com>
 <540e89cd-c222-e81a-5e34-600ae0aa052e@redhat.com>
 <701cc6a7-b66b-8a51-8755-13dd584cbebd@gmail.com>
 <cf896651-18a6-ee07-62a4-437c191ddde4@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a4cf8400-3b11-4d09-9b46-6d6382423ce7@broadcom.com> (sfid-20170514_102204_479226_7BB51211)
Date: Sun, 14 May 2017 10:21:50 +0200
MIME-Version: 1.0
In-Reply-To: <cf896651-18a6-ee07-62a4-437c191ddde4@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-5-2017 16:55, Hans de Goede wrote:
> Hi,
> 
> On 13-05-17 15:39, Heiner Kallweit wrote:
>> Am 13.05.2017 um 14:35 schrieb Hans de Goede:
>>> <resend with the author of the commit causing this added>
>>>
>>> Hi,
>>>
>>> On 13-05-17 14:19, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> I've just rebased my personal kernel tree to what will soon be 4.12-rc1
>>>> and I'm getting my dmesg log filled with the following errors:
>>>>
>>>> [   32.528271] brcmfmac: brcmf_sdio_rxglom: sublen 524 not multiple
>>>> of 8
>>>> [   32.528296] brcmfmac: brcmf_sdio_rxglom: sublen 84 not multiple of 8
>>>> [   33.063241] brcmfmac: brcmf_sdio_rxglom: sublen 1492 not multiple
>>>> of 8
>>>>
>> After a brief look at the code I'm not sure that the check actually
>> checks
>> for an error condition. Apart from the error messages:
>> Do you face issues with the functionality of the driver?
> 
> Yes after a while I get -ETIMEOUT errors for any sdio transfers
> to the device. But I'm not sure if this is caused by this commit,
> I think I've seen this once with 4.11 too.
> 
> I've reverted the commit for now, but I'm fine with instead of
> doing the revert dropping the error check if the brcmfmac developers
> think that is ok. Currently the ETIMEOUT seems to be gone, so
> if dropping the revert causes it to re-appear then we know more.

Instead of reverting please give this patch a try and let me know if it
works for you.

Regards,
Arend
---
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
b/drivers/n
index fc64b89..e034500 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3422,7 +3422,7 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
                /* otherwise, set txglomalign */
                value = sdiodev->settings->bus.sdio.sd_sgentry_align;
                /* SDIO ADMA requires at least 32 bit alignment */
-               value = max_t(u32, value, 4);
+               value = max_t(u32, value, ALIGNMENT);
                err = brcmf_iovar_data_set(dev, "bus:txglomalign", &value,
                                           sizeof(u32));
        }
