Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:33172 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdFGIPT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Jun 2017 04:15:19 -0400
Received: by mail-qk0-f169.google.com with SMTP id r62so2900718qkf.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jun 2017 01:15:18 -0700 (PDT)
Subject: Re: [V4,1/3] brcmfmac: add support multi-scheduled scan
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
References: <1495180659-12406-1-git-send-email-arend.vanspriel@broadcom.com>
 <20170522151649.B5F1060AC8@smtp.codeaurora.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <621288e8-e950-5aea-7d27-c5cb802dd416@broadcom.com> (sfid-20170607_101525_254640_2DDF1092)
Date: Wed, 7 Jun 2017 10:15:15 +0200
MIME-Version: 1.0
In-Reply-To: <20170522151649.B5F1060AC8@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/22/2017 5:16 PM, Kalle Valo wrote:
> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>> From: Arend Van Spriel <arend.vanspriel@broadcom.com>
>>
>> This change adds support for multi-scheduled scan in the driver. It
>> currently relies on g-scan support in firmware and will set struct
>> wiphy::max_sched_scan_reqs accordingly. This is limited to 16 concurrent
>> requests.
>>
>> The firmware currently has a limit of 64 channels that can be configured
>> for all requests in total regardless whether there are duplicates. So if
>> a request uses 35 channels there are 29 channels left for another request.
>> When user-space does not specify any channels cfg80211 will add all
>> channels defined by the wiphy instance to the request, which makes
>> reaching the limit rather easy for dual-band devices.
>>
>> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
>> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> I see new warnings:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c: In function ‘brcmf_pno_config_sched_scans’:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c:166:6: warning: ‘mac_mask’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>    u8 *mac_mask;
>        ^
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c:183:2: warning: ‘mac_addr’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>    memcpy(pfn_mac.mac, mac_addr, ETH_ALEN);
>    ^
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c:165:6: note: ‘mac_addr’ was declared here
>    u8 *mac_addr;
>        ^
> 
> 3 patches set to Changes Requested.
> 
> 9736151 [V4,1/3] brcmfmac: add support multi-scheduled scan
> 9736147 [V4,2/3] brcmfmac: add mutex to protect pno requests
> 9736149 [V4,3/3] brcmfmac: add scheduled scan support for specified BSSIDs

Not seeing it here using gcc version 4.8.4 (Ubuntu 
4.8.4-2ubuntu1~14.04.3). Also tried using W=1 on the make command line. 
Getting a bunck of other warnings, but not the ones above. Do you want 
me to fix it?

Regards,
Arend
