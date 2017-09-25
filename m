Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44560 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932617AbdIYIXf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 04:23:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmsmac: make const array ucode_ofdm_rates static,
 reduces object code size
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170922140316.12768-1-colin.king@canonical.com>
References: <20170922140316.12768-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20170925082334.DB0A860618@smtp.codeaurora.org> (sfid-20170925_104608_896198_5F7071EB)
Date: Mon, 25 Sep 2017 08:23:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate const array ucode_ofdm_rates on the stack, instead make it
> static. Makes the object code smaller by 100 bytes:
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   39482	    564	      0	  40046	   9c6e	phy_cmn.o
> 
> After
>    text	   data	    bss	    dec	    hex	filename
>   39326	    620	      0	  39946	   9c0a	phy_cmn.o
> 
> (gcc 6.3.0, x86-64)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

d5633bb2c62a brcmsmac: make const array ucode_ofdm_rates static, reduces object code size

-- 
https://patchwork.kernel.org/patch/9966221/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
