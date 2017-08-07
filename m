Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:38846 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752913AbdHGL05 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:26:57 -0400
Received: by mail-wr0-f181.google.com with SMTP id f21so575594wrf.5
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:26:57 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 12/34] brcmfmac: Replace old IO functions with simpler
 ones.
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-13-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
Message-ID: <59884E7F.3080607@broadcom.com> (sfid-20170807_133252_221685_A31C459F)
Date: Mon, 7 Aug 2017 13:26:55 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-13-ian@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/26/2017 10:25 PM, Ian Molton wrote:
> Primarily this patch removes:
>
> brcmf_sdiod_f0_writeb()
> brcmf_sdiod_reg_write()
> brcmf_sdiod_reg_read()

Having [patch 30/34] "brcmfmac: Correctly handle accesses to SDIO func0" 
before this patch could make this look cleaner.

> Since we no longer use the quirky method of deciding which function to
> address via the address being accessed, take the opportunity to rename
> some IO functions more in line with common kernel code.

As mentioned here this is more a rename than a replace so please use 
that in the subject as well.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 166 +++----------------
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 182 ++++++++++-----------
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  28 +++-
>   3 files changed, 132 insertions(+), 244 deletions(-)
