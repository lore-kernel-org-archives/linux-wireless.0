Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37733 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbdH3Tmi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 15:42:38 -0400
Received: by mail-wm0-f48.google.com with SMTP id u26so16804877wma.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:42:37 -0700 (PDT)
Subject: Re: [PATCH 20/30] brcmfmac: Remove repeated calls to
 brcmf_chip_get_core()
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-21-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7d9713d2-09d5-240b-288a-99c41e42e6c1@broadcom.com> (sfid-20170830_214240_801924_181BE711)
Date: Wed, 30 Aug 2017 21:42:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-21-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> There is no need to repeatdly call brcmf_chip_get_core(), which
> traverses a list of cores every time its called (including during
> register access code!).
> 
> Call it once, and store a pointer to the core structure. The existing
> code does nto keep track of users of the cores anyway, and even so, this
> will allow for easier refcounting in future.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 25 +++++++++++++---------
>   1 file changed, 15 insertions(+), 10 deletions(-)
