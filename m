Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52222 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753142AbdK0RPa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 12:15:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH for-4.15] brcmfmac: change driver unbind order of the sdio function devices
References: <1511642376-16279-1-git-send-email-arend.vanspriel@broadcom.com>
Date: Mon, 27 Nov 2017 19:15:24 +0200
In-Reply-To: <1511642376-16279-1-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Sat, 25 Nov 2017 21:39:25 +0100")
Message-ID: <87y3mr4p8z.fsf@kamboji.qca.qualcomm.com> (sfid-20171127_181534_435789_259E2EA0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> In the function brcmf_sdio_firmware_callback() the driver is
> unbound from the sdio function devices in the error path.
> However, the order in which it is done resulted in a use-after-free
> issue (see brcmf_ops_sdio_remove() in bcmsdh.c). Hence change
> the order and first unbind sdio function #2 device and then
> unbind sdio function #1 device.
>
> Cc: stable@vger.kernel.org # v4.12.x
> Fixes: 7a51461fc2da ("brcmfmac: unbind all devices upon failure in firmware callback")
> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

I'll queue this for v4.15.

-- 
Kalle Valo
