Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:40694 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753576AbdKXMw2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Nov 2017 07:52:28 -0500
Received: by mail-wm0-f41.google.com with SMTP id b189so22353977wmd.5
        for <linux-wireless@vger.kernel.org>; Fri, 24 Nov 2017 04:52:27 -0800 (PST)
Subject: Re: brcmfmac: Unable to handle kernel paging request at virtual
 address 726f6674616cd8
To: Stefan Wahren <stefan.wahren@i2se.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <578431614.96494.1510505412682@email.1und1.de>
 <1906631797.229909.1511367617667@email.1und1.de>
 <08b0ba6f-d4e7-576e-18fe-98e8247d2d91@broadcom.com>
 <1736744183.124.1511378235966@email.1und1.de>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list@cypress.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A181609.40907@broadcom.com> (sfid-20171124_135245_286276_83E3FA0F)
Date: Fri, 24 Nov 2017 13:52:25 +0100
MIME-Version: 1.0
In-Reply-To: <1736744183.124.1511378235966@email.1und1.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/22/2017 8:17 PM, Stefan Wahren wrote:
> Hi Arend,
>
>> Arend van Spriel <arend.vanspriel@broadcom.com> hat am 22. November 2017 um 19:23 geschrieben:
>>
>>
>> On 22-11-17 17:20, Stefan Wahren wrote:
>>> Hi,
>>>
>>>> Stefan Wahren <stefan.wahren@i2se.com> hat am 12. November 2017 um 17:50 geschrieben:
>>>>
>>>>
>>>> Hi,
>>>> i discovered a random oops during probe of brcmfmac on Raspberry Pi 3 in yesterdays kernelci run for net-next [1]. I need to point out there is no DT entry for the wifi chip on Raspberry Pi 3 in the lack of a driver for the necessary GPIO expander. So the "HT Avail timeout" is expected.
>>>>
>>>> I was also able to trigger this oops by calling "modprobe brcmfmac" on my Raspberry Pi 3 with latest linux-next.
>>>>
>>>> Any help to fix this is appreciated.
>>>>
>>>> [1] - https://storage.kernelci.org/net-next/master/v4.14-rc8-2221-ga8a6f1e4ea78/arm64/defconfig+kselftest/lab-baylibre/boot-bcm2837-rpi-3-b.txt
>>>>
>>>
>>> the issue still persists in linux-next-20171122:
>>>
>> ...
>>
>> seems like a use-after-free. We do a device_release_driver() twice. Once
>> for sdio func #1 and for sdio func #2. This was introduced by:
>>
>> commit 7a51461fc2da82a6c565a3ee65c41c197f28225d
>> Author: Arend Van Spriel <arend.vanspriel@broadcom.com>
>> Date:   Mon Jun 12 12:47:34 2017 +0100
>>
>>       brcmfmac: unbind all devices upon failure in firmware callback
>>
>> What we do is:
>>
>>           device_release_driver(dev);
>>           device_release_driver(&sdiodev->func[2]->dev);
>>
>> with the assumption that dev == &sdiodev->func[1]->dev. I wonder if that
>> is always true. The error print did not make it in your log. Maybe we
>> should make it explicit here (see below).
>
> i tried it, but the issue still occurs.
>
> Maybe this is helpful but this issue doesn't happend everytime. Sometimes i need 2 attemps via unloading/loading.
>

I just realized the remove of sdio func #1 removes everything so we must 
first remove sdio func #2. Can you try the patch below.

Regards,
Arend
---
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c 
b/drivers/n
index b2256aa..58fa438 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4121,8 +4121,8 @@ static void brcmf_sdio_firmware_callback(struct 
device *de
         sdio_release_host(sdiodev->func[1]);
  fail:
         brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), err);
-       device_release_driver(dev);
         device_release_driver(&sdiodev->func[2]->dev);
+       device_release_driver(dev);
  }

  struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
