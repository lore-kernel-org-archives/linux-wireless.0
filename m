Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35211 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752842AbdHGLZe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:25:34 -0400
Received: by mail-wm0-f54.google.com with SMTP id m85so4683965wma.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:25:33 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 02/34] brcmfmac: Register sizes on hardware are not
 dependent on compiler types
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-3-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
Message-ID: <59884E2B.6060000@broadcom.com> (sfid-20170807_132537_085725_1BDF90B7)
Date: Mon, 7 Aug 2017 13:25:31 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-3-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 22:25, Ian Molton wrote:
> The 4 IO functions in this patch are incorrect as they use compiler types
> to determine how many bytes to send to the hardware.

I see no incorrectness here. It is validating the regsz value and those
compiler types are pretty well defined I would say. Anyway, I find the
use of sizeof() here pretty useless so thanks for the change.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
