Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:36218 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdFMKXg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 06:23:36 -0400
MIME-Version: 1.0
In-Reply-To: <20170613055448.C0CD36075B@smtp.codeaurora.org>
References: <20170523180733.26276-1-enric.balletbo@collabora.com> <20170613055448.C0CD36075B@smtp.codeaurora.org>
From: Enric Balletbo Serra <eballetbo@gmail.com>
Date: Tue, 13 Jun 2017 12:23:35 +0200
Message-ID: <CAFqH_53v341QhUewFR5aQdZE1bPo5J5TY0G6zkXU9y0c5VEz1g@mail.gmail.com> (sfid-20170613_122407_393989_34BFA811)
Subject: Re: brcmfmac: Fix kernel oops on resume when request firmware fails.
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Christian Daudt <csd@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

2017-06-13 7:54 GMT+02:00 Kalle Valo <kvalo@codeaurora.org>:
> Enric Balletbo i Serra <enric.balletbo@collabora.com> wrote:
>
>> When request firmware fails, brcmf_ops_sdio_remove is being called and
>> brcmf_bus freed. In such circumstancies if you do a suspend/resume cycle
>> the kernel hangs on resume due a NULL pointer dereference in resume
>> function.
>>
>> Steps to reproduce the problem:
>>  - modprobe brcmfmac without the firmware
>>      brcmfmac mmc1:0001:1: Direct firmware load for brcm/brcmfmac4354-sdio.bin
>>      failed with error -2
>>  - do a suspend/resume cycle (echo mem > /sys/power/state)
>>
>> Protect against the NULL pointer derefence by checking if dev_get_drvdata
>> returned a valid pointer.
>>
>> Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
>
> My understanding is that there's a new version of this patch which fixes
> the issue. If not, let me know.
>
> Patch set to Superseded.
>

Yes there are these patch series [1] that fixes the issue, I guess
Arend is working on a v2 to fix a small issue we found.

[1] https://www.spinics.net/lists/linux-wireless/msg162762.html

> --
> https://patchwork.kernel.org/patch/9743159/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>

Regards,
 Enric
