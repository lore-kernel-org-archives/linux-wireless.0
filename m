Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34962 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752277AbeGDPIf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 11:08:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: update STA info struct to the v5
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180628103623.29103-1-zajec5@gmail.com>
References: <20180628103623.29103-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20180704150835.7D3AD6031A@smtp.codeaurora.org> (sfid-20180704_170935_084964_E806FB7C)
Date: Wed,  4 Jul 2018 15:08:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> That struct is used when querying firmware for the STA. It seem is has
> been changing during the time. Luckily its format seems to be backward
> compatible starting with v2 (the only breakage was v1 -> v2).
> 
> The version that was supported by brcmfmac so far was v4. It was what
> 43602a1 and 4366b1 firmwares (7.35.177.56 and 10.10.69.3309 accordingly)
> were using. It also seems to be used by early 4366c0 firmwares
> (10.10.69.6908 and 10.10.69.69017).
> 
> The problem appears when switching to the 10.10.122.20 firmware. It uses
> v5 and instead of falling back to v4 when submitted buffer isn't big
> enough it fallbacks to the v3.
> 
> To receive all v4 specific info with the newest firmware we have to
> submit a struct (buffer) that matches v5.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

07b1ae468749 brcmfmac: update STA info struct to the v5

-- 
https://patchwork.kernel.org/patch/10493539/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
