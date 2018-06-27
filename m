Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45060 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbeF0P5H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 11:57:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmsmac: fix wrap around in conversion from constant to s16
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180617103407.27819-1-stefan@agner.ch>
References: <20180617103407.27819-1-stefan@agner.ch>
To: Stefan Agner <stefan@agner.ch>
Cc: Stefan Agner <stefan@agner.ch>,
        Tobias Regnery <tobias.regnery@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20180627155707.176F660714@smtp.codeaurora.org> (sfid-20180627_175728_177494_2C3E024B)
Date: Wed, 27 Jun 2018 15:57:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan Agner <stefan@agner.ch> wrote:

> The last value in the log_table wraps around to a negative value
> since s16 has a value range of -32768 to 32767. This is not what
> the table intends to represent. Use the closest positive value
> 32767.
> 
> This fixes a warning seen with clang:
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c:216:2: warning:
>       implicit conversion from 'int' to 's16' (aka 'short') changes
> value from 32768
>       to -32768 [-Wconstant-conversion]
>         32768
>         ^~~~~
> 1 warning generated.
> 
> Fixes: 4c0bfeaae9f9 ("brcmsmac: fix array out-of-bounds access in qm_log10")
> Cc: Tobias Regnery <tobias.regnery@gmail.com>
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Patch applied to wireless-drivers-next.git, thanks.

c9a61469fc97 brcmsmac: fix wrap around in conversion from constant to s16

-- 
https://patchwork.kernel.org/patch/10468755/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
