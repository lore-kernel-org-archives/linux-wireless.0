Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36777 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbdLKJKz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 04:10:55 -0500
Received: by mail-qt0-f194.google.com with SMTP id a16so36737257qtj.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 Dec 2017 01:10:55 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: enlarge buffer size of caps to 512 bytes
To: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
References: <1512977901-12726-1-git-send-email-wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A2E4B9C.3060503@broadcom.com> (sfid-20171211_101059_798567_17EE9F67)
Date: Mon, 11 Dec 2017 10:10:52 +0100
MIME-Version: 1.0
In-Reply-To: <1512977901-12726-1-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/11/2017 8:38 AM, Wright Feng wrote:
> The buffer size of return of cap iovar is greater than 256 bytes in some
> firmwares. For instance, the return size of cap iovar is 271 bytes in 4373
> 13.10.246.79 firmare. It makes feature capability parsing failed because
> caps buffer is default value.
> So we enlarge caps buffer size to 512 bytes and add the error print for
> cap iovar error.

Looks fine to me. However, firmware side is also broken for some chips 
where released firmware uses 256 bytes (= WLC_IOCTL_SMLEN) but the 
capability tokens do no longer fit that size and we get a cut-off 
capability string.

Anyway...

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
