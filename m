Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37100 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752643AbdIETbu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 15:31:50 -0400
Received: by mail-wm0-f42.google.com with SMTP id u26so23273232wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 Sep 2017 12:31:49 -0700 (PDT)
Subject: Re: [PATCH v5] brcmfmac: add CLM download support
To: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        kvalo@codeaurora.org, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, wright.feng@cypress.com
References: <1503987821-6132-1-git-send-email-wright.feng@cypress.com>
 <20170904113324.GA126340@aremote01.aus.cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e3162c6f-01ee-d46f-3745-03a5e2428bdb@broadcom.com> (sfid-20170905_213153_643653_38F4A909)
Date: Tue, 5 Sep 2017 21:31:46 +0200
MIME-Version: 1.0
In-Reply-To: <20170904113324.GA126340@aremote01.aus.cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04-09-17 13:33, Chung-Hsien Hsu wrote:
> On Tue, Aug 29, 2017 at 02:23:41PM +0800, Wright Feng wrote:
>> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
>>
>> The firmware for brcmfmac devices includes information regarding
>> regulatory constraints. For certain devices this information is kept
>> separately in a binary form that needs to be downloaded to the device.
>> This patch adds support to download this so-called CLM blob file. It
>> uses the same naming scheme as the other firmware files with extension
>> of .clm_blob.
>>
>> The CLM blob file is optional. If the file does not exist, the download
>> process will be bypassed. It will not affect the driver loading.
>>
>> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
>> ---
>> v2: Revise commit message to describe in more detail
>> v3: Add error handling in brcmf_c_get_clm_name function
>> v4: Correct the length of dload_buf in brcmf_c_download function
>> v5: Remove unnecessary cast and alignment
>> ---
>>   .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 ++
>>   .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 160 +++++++++++++++++++++
>>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
>>   .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
>>   .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  31 ++++
>>   .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  19 +++
>>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  19 +++
>>   .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  18 +++
>>   8 files changed, 261 insertions(+)
> 
> Hi Arend,
> 
> Do you think this patch is ready to be merged or is there something more
> to change?

Ultimately it is not my decision, but I will respond to it.

Regards,
Arend
