Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:49154 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdKCJUM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2017 05:20:12 -0400
Received: by mail-qk0-f193.google.com with SMTP id q83so2413744qke.6
        for <linux-wireless@vger.kernel.org>; Fri, 03 Nov 2017 02:20:12 -0700 (PDT)
Subject: Re: [PATCH v6] brcmfmac: add CLM download support
To: Chung-Hsien Hsu <stanley.hsu@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
 <20171103082725.GB25372@aremote01.aus.cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9773ee9a-90d3-a303-54b0-9893503190f9@broadcom.com> (sfid-20171103_102016_658010_B9F39BB7)
Date: Fri, 3 Nov 2017 10:20:07 +0100
MIME-Version: 1.0
In-Reply-To: <20171103082725.GB25372@aremote01.aus.cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03-11-17 09:27, Chung-Hsien Hsu wrote:
> On Thu, Oct 05, 2017 at 03:31:18PM +0800, Wright Feng wrote:
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
>> v6: Add debug log for the case of no CLM file present
>> ---
>>   .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 ++
>>   .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 162 +++++++++++++++++++++
>>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
>>   .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
>>   .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  31 ++++
>>   .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  19 +++
>>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  19 +++
>>   .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  18 +++
>>   8 files changed, 263 insertions(+)
> 
> Any comments or feedback about this? I'm hoping to have it in v4.15.

Hi Chung-Hsien,

Sorry for not following up. The change log for v6 made me wonder if all 
my comments on v5 were addressed. I just checked and it looks fine to 
me. Kalle has set this patch to Deferred state in patchwork maybe 
awaiting my response. I already gave my "Reviewed-by:" on v5 so you may 
add that for v6, but I am sure Kalle can do that.

Regards,
Arend
