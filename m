Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:38701 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753027AbdHGL0N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:26:13 -0400
Received: by mail-wr0-f180.google.com with SMTP id f21so569126wrf.5
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:26:13 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 08/34] brcmfmac: Fix uninitialised variable
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-9-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
Message-ID: <59884E53.2050209@broadcom.com> (sfid-20170807_132615_964970_42D0E017)
Date: Mon, 7 Aug 2017 13:26:11 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-9-ian@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/26/2017 10:25 PM, Ian Molton wrote:
> 	Unlikely to be a problem, but brcmf_sdiod_regrb() is
> not symmetric with brcmf_sdiod_regrl() in this regard.

You are pretty keen on symmetry, but you could also remove the 
initialization in brcmf_sdiod_regrl(). As long as no -Wunitialized pops 
up that would have my preference.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
