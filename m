Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36723 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753195AbdFMLgP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 07:36:15 -0400
Received: by mail-wr0-f173.google.com with SMTP id 36so16890858wry.3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 04:36:09 -0700 (PDT)
Subject: Re: [for-4.12, 3/3] brcmfmac: unbind all devices upon failure in
 firmware callback
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
References: <1497268054-4507-4-git-send-email-arend.vanspriel@broadcom.com>
 <20170613061235.D11C6607CC@smtp.codeaurora.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <dba4a756-63de-1dd0-a245-3499b8038d29@broadcom.com> (sfid-20170613_133632_490949_9F674185)
Date: Tue, 13 Jun 2017 13:36:07 +0200
MIME-Version: 1.0
In-Reply-To: <20170613061235.D11C6607CC@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 13-06-17 08:12, Kalle Valo wrote:
> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> 
>> In brcmf_sdio_firmware_callback() we need to unbind the driver from
>> both sdio_func devices.
>>
>> Cc: stable@vger.kernel.org # 4.9.x-
>> Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
>> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
>> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> The commit log doesn't really describe the bug you are fixing (ie. doesn't
> answer "why?"). Can you give some more info, logs etc (as a reply to this mail)
> and I'll add it.

Merging with the commit message that Enric wrote:

"""
When request firmware fails, brcmf_ops_sdio_remove is being called and
brcmf_bus freed. In such circumstancies if you do a suspend/resume cycle
the kernel hangs on resume due a NULL pointer dereference in resume
function. So in brcmf_sdio_firmware_callback() we need to unbind the
driver from both sdio_func devices when firmware load failure is indicated.
"""

Regards,
Arend
