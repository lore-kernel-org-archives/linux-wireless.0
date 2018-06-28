Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35798 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935103AbeF1J3E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 05:29:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Remove Unicode Byte Order Mark from testcode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1528375527-22761-1-git-send-email-geert@linux-m68k.org>
References: <1528375527-22761-1-git-send-email-geert@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Eyal Ilsar <eilsar@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Message-Id: <20180628092904.63600608C8@smtp.codeaurora.org> (sfid-20180628_112921_354644_A52EB951)
Date: Thu, 28 Jun 2018 09:29:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Older gcc (< 4.4) doesn't like files starting with a Unicode BOM:
> 
>     drivers/net/wireless/ath/wcn36xx/testmode.c:1: error: stray ‘\357’ in program
>     drivers/net/wireless/ath/wcn36xx/testmode.c:1: error: stray ‘\273’ in program
>     drivers/net/wireless/ath/wcn36xx/testmode.c:1: error: stray ‘\277’ in program
> 
> Remove the BOM, the rest of the file is plain ASCII anyway.
> 
> Output of "file drivers/net/wireless/ath/wcn36xx/testmode.c" before:
> 
>     drivers/net/wireless/ath/wcn36xx/testmode.c: C source, UTF-8 Unicode (with BOM) text
> 
> and after:
> 
>     drivers/net/wireless/ath/wcn36xx/testmode.c: C source, ASCII text
> 
> Fixes: 87f825e6e246cee0 ("wcn36xx: Add support for Factory Test Mode (FTM)")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Ramon Fried <ramon.fried@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-current branch of ath.git, thanks.

371d5e9d99e1 wcn36xx: Remove Unicode Byte Order Mark from testcode

-- 
https://patchwork.kernel.org/patch/10451875/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
