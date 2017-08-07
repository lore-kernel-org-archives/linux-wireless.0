Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:37930 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751506AbdHGRz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 13:55:27 -0400
Subject: Re: [PATCH 12/34] brcmfmac: Replace old IO functions with simpler
 ones.
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-13-ian@mnementh.co.uk> <59884E7F.3080607@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <4cbe4de3-a342-2cb7-d3d0-c40413381045@mnementh.co.uk> (sfid-20170807_195530_686050_A1811F78)
Date: Mon, 7 Aug 2017 18:55:23 +0100
MIME-Version: 1.0
In-Reply-To: <59884E7F.3080607@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/17 12:26, Arend van Spriel wrote:
> On 7/26/2017 10:25 PM, Ian Molton wrote:
>> Primarily this patch removes:
>>
>> brcmf_sdiod_f0_writeb()
>> brcmf_sdiod_reg_write()
>> brcmf_sdiod_reg_read()
> 
> Having [patch 30/34] "brcmfmac: Correctly handle accesses to SDIO func0"
> before this patch could make this look cleaner.

This is an artifact of how I came to the realisation the code was using
the obsoleted functions - it could be reordered, but it'd probably get
messy...

>> Since we no longer use the quirky method of deciding which function to
>> address via the address being accessed, take the opportunity to rename
>> some IO functions more in line with common kernel code.
> 
> As mentioned here this is more a rename than a replace so please use
> that in the subject as well.

Noted.

> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
>> ---
>>   .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 166
>> +++----------------
>>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 182
>> ++++++++++-----------
>>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  28 +++-
>>   3 files changed, 132 insertions(+), 244 deletions(-)
> 

-Ian
